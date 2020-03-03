unit WebFile;

interface

uses
  DebugTools, RyuLibBase, Disk,
  Windows, SysUtils, Classes, Wininet;

type
  TDownloadingEvent = procedure (Sender:TObject; AFileSize,ACurrent:integer) of object;

  TWebFile = class (TComponent)
  private
    FStoped : boolean;
    procedure do_Download(const AURL,AFileName:string);
  private
    FCurrentSize: integer;
    FFileSize: integer;
    FOnDownloadBegin: TNotifyEvent;
    FOnDownloading: TDownloadingEvent;
    FOnDownloadEnd: TNotifyEvent;
    FOnError: TStringEvent;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Download(const AURL,AFileName:string);
    procedure Stop;
  published
    property CurrentSize : integer read FCurrentSize;
    property FileSize : integer read FFileSize;
    property OnError : TStringEvent read FOnError write FOnError;
    property OnDownloadBegin : TNotifyEvent read FOnDownloadBegin write FOnDownloadBegin;
    property OnDownloading : TDownloadingEvent read FOnDownloading write FOnDownloading;
    property OnDownloadEnd : TNotifyEvent read FOnDownloadEnd write FOnDownloadEnd;
  end;

function GetRemoteFilesize(const Url:string):integer;
function DownloadFromURL(const AURL,ADst:string):boolean;

implementation

const
  sUserAgent = 'Mozilla/5.001 (windows; U; NT4.0; en-US; rv:1.0) Gecko/25250101';

function GetWinInetError(ErrorCode:Cardinal): string;
const
   winetdll = 'wininet.dll';
var
  Len: Integer;
  Buffer: PChar;
begin
  Len := FormatMessage(
  FORMAT_MESSAGE_FROM_HMODULE or FORMAT_MESSAGE_FROM_SYSTEM or
  FORMAT_MESSAGE_ALLOCATE_BUFFER or FORMAT_MESSAGE_IGNORE_INSERTS or  FORMAT_MESSAGE_ARGUMENT_ARRAY,
  Pointer(GetModuleHandle(winetdll)), ErrorCode, 0, @Buffer, SizeOf(Buffer), nil);
  try
    while (Len > 0) and {$IFDEF UNICODE}(CharInSet(Buffer[Len - 1], [#0..#32, '.'])) {$ELSE}(Buffer[Len - 1] in [#0..#32, '.']) {$ENDIF} do Dec(Len);
    SetString(Result, Buffer, Len);
  finally
    LocalFree(HLOCAL(Buffer));
  end;
end;

procedure ParseURL(const lpszUrl: string; var Host, Resource: string);
var
  lpszScheme      : array[0..INTERNET_MAX_SCHEME_LENGTH - 1] of Char;
  lpszHostName    : array[0..INTERNET_MAX_HOST_NAME_LENGTH - 1] of Char;
  lpszUserName    : array[0..INTERNET_MAX_USER_NAME_LENGTH - 1] of Char;
  lpszPassword    : array[0..INTERNET_MAX_PASSWORD_LENGTH - 1] of Char;
  lpszUrlPath     : array[0..INTERNET_MAX_PATH_LENGTH - 1] of Char;
  lpszExtraInfo   : array[0..1024 - 1] of Char;
  lpUrlComponents : TURLComponents;
begin
  ZeroMemory(@lpszScheme, SizeOf(lpszScheme));
  ZeroMemory(@lpszHostName, SizeOf(lpszHostName));
  ZeroMemory(@lpszUserName, SizeOf(lpszUserName));
  ZeroMemory(@lpszPassword, SizeOf(lpszPassword));
  ZeroMemory(@lpszUrlPath, SizeOf(lpszUrlPath));
  ZeroMemory(@lpszExtraInfo, SizeOf(lpszExtraInfo));
  ZeroMemory(@lpUrlComponents, SizeOf(TURLComponents));

  lpUrlComponents.dwStructSize      := SizeOf(TURLComponents);
  lpUrlComponents.lpszScheme        := lpszScheme;
  lpUrlComponents.dwSchemeLength    := SizeOf(lpszScheme);
  lpUrlComponents.lpszHostName      := lpszHostName;
  lpUrlComponents.dwHostNameLength  := SizeOf(lpszHostName);
  lpUrlComponents.lpszUserName      := lpszUserName;
  lpUrlComponents.dwUserNameLength  := SizeOf(lpszUserName);
  lpUrlComponents.lpszPassword      := lpszPassword;
  lpUrlComponents.dwPasswordLength  := SizeOf(lpszPassword);
  lpUrlComponents.lpszUrlPath       := lpszUrlPath;
  lpUrlComponents.dwUrlPathLength   := SizeOf(lpszUrlPath);
  lpUrlComponents.lpszExtraInfo     := lpszExtraInfo;
  lpUrlComponents.dwExtraInfoLength := SizeOf(lpszExtraInfo);

  InternetCrackUrl(PChar(lpszUrl), Length(lpszUrl), ICU_DECODE or ICU_ESCAPE, lpUrlComponents);

  Host := lpszHostName;
  Resource := lpszUrlPath;
end;

function GetRemoteFilesize(const Url:string):integer;
var
  hInet    : HINTERNET;
  hConnect : HINTERNET;
  hRequest : HINTERNET;
  lpdwBufferLength: DWORD;
  lpdwReserved    : DWORD;
  ServerName: string;
  Resource: string;
  ErrorCode : Cardinal;
begin
  ParseURL(Url,ServerName,Resource);
  Result:=0;

  hInet := InternetOpen(PChar(sUserAgent), INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, 0);
  if hInet=nil then begin
    ErrorCode:=GetLastError;
    raise Exception.Create(Format('InternetOpen Error %d Description %s',[ErrorCode,GetWinInetError(ErrorCode)]));
  end;

  try
    hConnect := InternetConnect(hInet, PChar(ServerName), INTERNET_DEFAULT_HTTP_PORT, nil, nil, INTERNET_SERVICE_HTTP, 0, 0);
    if hConnect=nil then begin
      ErrorCode:=GetLastError;
      raise Exception.Create(Format('InternetConnect Error %d Description %s',[ErrorCode,GetWinInetError(ErrorCode)]));
    end;

    try
      hRequest := HttpOpenRequest(hConnect, PChar('HEAD'), PChar(Resource), nil, nil, nil, 0, 0);
        if hRequest<>nil then begin
          try
            lpdwBufferLength:=SizeOf(Result);
            lpdwReserved    :=0;
            if not HttpSendRequest(hRequest, nil, 0, nil, 0) then begin
              ErrorCode:=GetLastError;
              raise Exception.Create(Format('HttpOpenRequest Error %d Description %s',[ErrorCode,GetWinInetError(ErrorCode)]));
            end;

             if not HttpQueryInfo(hRequest, HTTP_QUERY_CONTENT_LENGTH or HTTP_QUERY_FLAG_NUMBER, @Result, lpdwBufferLength, lpdwReserved) then begin
              Result:=0;
              ErrorCode:=GetLastError;
              raise Exception.Create(Format('HttpQueryInfo Error %d Description %s',[ErrorCode,GetWinInetError(ErrorCode)]));
             end;
          finally
            InternetCloseHandle(hRequest);
          end;
        end else begin
          ErrorCode:=GetLastError;
          raise Exception.Create(Format('HttpOpenRequest Error %d Description %s',[ErrorCode,GetWinInetError(ErrorCode)]));
        end;
    finally
      InternetCloseHandle(hConnect);
    end;
  finally
    InternetCloseHandle(hInet);
  end;
end;

function DownloadFromURL(const AURL,ADst:string):boolean;
var
  hSession: HINTERNET;
  hService: HINTERNET;
  Buffer: array[0..4096] of Char;
  dwBytesRead: DWORD;
  fsData : TFileStream;
begin
  Result := False;

  hSession := InternetOpen(PChar(sUserAgent), INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, 0);
  if not Assigned(hSession) then Exit;

  try
    hService := InternetOpenUrl(hSession, PChar(aUrl), nil, 0, INTERNET_FLAG_RELOAD, 0);
    if not Assigned(hService) then Exit;

    fsData := TFileStream.Create(ADst, fmCreate);
    try
      while True do begin
        dwBytesRead := 4096;
        InternetReadFile(hService, @Buffer, 4096, dwBytesRead);
        if dwBytesRead = 0 then break;

        fsData.Write(Buffer, dwBytesRead);
      end;

      Result := True;
    finally
      InternetCloseHandle(hService);
      fsData.Free;
    end;
  finally
    InternetCloseHandle(hSession);
  end;
end;

{ TWebFile }

constructor TWebFile.Create(AOwner: TComponent);
begin
  inherited;

end;

destructor TWebFile.Destroy;
begin

  inherited;
end;

procedure TWebFile.Download(const AURL,AFileName: string);
begin
  FStoped := false;

  if Assigned(FOnDownloadBegin) then FOnDownloadBegin(Self);

  try
    do_Download(AURL, AFileName);
  except
    On E : Exception do begin
      FStoped := true;
      if Assigned(FOnError) then FOnError(Self, E.Message);
      Trace( Format('TWebFile.Download - %s', [E.Message]) );
    end;
  end;

  if (FStoped = false) and Assigned(FOnDownloadEnd) then FOnDownloadEnd(Self);
end;

procedure TWebFile.do_Download(const AURL, AFileName: string);
var
  hSession: HINTERNET;
  hService: HINTERNET;
  Buffer: array[0..4096] of Char;
  dwBytesRead: DWORD;
  fsData : TFileStream;
begin
  FFileSize := GetRemoteFilesize(AURL);
  FCurrentSize := 0;

  hSession := InternetOpen(PChar(sUserAgent), INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, 0);
  if not Assigned(hSession) then Exit;

  try
    hService := InternetOpenUrl(hSession, PChar(aUrl), nil, 0, INTERNET_FLAG_RELOAD, 0);
    if not Assigned(hService) then Exit;

    fsData := TFileStream.Create(AFileName, fmCreate);
    try
      while True do begin
        dwBytesRead := 4096;
        InternetReadFile(hService, @Buffer, 4096, dwBytesRead);
        if dwBytesRead = 0 then break;
        if FStoped then break;

        fsData.Write(Buffer, dwBytesRead);

        FCurrentSize := FCurrentSize + dwBytesRead;
        if Assigned(FOnDownloading) then FOnDownloading(Self, FFileSize, FCurrentSize);
      end;
    finally
      InternetCloseHandle(hService);
      fsData.Free;
    end;
  finally
    InternetCloseHandle(hSession);
  end;
end;

procedure TWebFile.Stop;
begin
  FStoped := true;
end;

end.
