unit WebUtils;

interface

uses
  JsonData,
  WinInet, idHTTP,
  Windows, SysUtils, Classes;

function GetHTTP(const AURL:string):string;
function GetHTTP_UTF8(const AURL:string):string;
function GetHTTP_JSON_Value(const AURL,AName:string):string;

implementation

function GetHTTP(const AURL:string):string;
var
  NetHandle : HINTERNET;
  UrlHandle : HINTERNET;
  BytesRead : DWord;
  Buffer : array[0..1024] of AnsiChar;
  ResultLine : AnsiString;
begin
  Result := '';

  NetHandle := InternetOpen('Delphi', INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, 0);
  if not Assigned(NetHandle) then Exit;

  try
    UrlHandle := InternetOpenUrl(NetHandle, PChar(AURL), nil, 0, INTERNET_FLAG_RELOAD, 0);
    if not Assigned(UrlHandle) then Exit;

    try
      FillChar(Buffer, SizeOf(Buffer), 0);
      repeat
        ResultLine := ResultLine + Buffer;
        FillChar(Buffer, SizeOf(Buffer), 0);
        InternetReadFile(UrlHandle, @Buffer, SizeOf(Buffer), BytesRead);
      until BytesRead = 0;
    finally
      InternetCloseHandle(UrlHandle);
    end;
  finally
    InternetCloseHandle(NetHandle);
  end;

  Result := ResultLine;
end;

function GetHTTP_UTF8(const AURL:string):string;
var
  rbstr: RawByteString;
  IdHTTP : TIdHTTP;
  MemoryStream: TMemoryStream;
begin
  Result := '';

  IdHTTP := TIdHTTP.Create(nil);
  MemoryStream := TMemoryStream.Create;
  try
    IdHTTP.Get(AURL, MemoryStream);
    rbstr := PAnsiChar(MemoryStream.Memory);
    Result := UTF8Decode(rbstr);
  finally
    IdHTTP.Free;
    MemoryStream.Free;
  end;
end;

function GetHTTP_JSON_Value(const AURL,AName:string):string;
var
  JsonData : TJsonData;
begin
  Result := '';

  JsonData := TJsonData.Create;
  try
    JsonData.Text := GetHTTP(AURL);
    Result := JsonData.Values[AName];
  finally
    JsonData.Free;
  end;
end;

end.

