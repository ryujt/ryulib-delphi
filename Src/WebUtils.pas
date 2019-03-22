unit WebUtils;

interface

uses
  JsonData,
  WinInet,
  Windows, SysUtils, Classes,
  System.Net.URLClient, System.Net.HttpClient, System.Net.HttpClientComponent,
  System.Net.Mime;

function GetHTTP(const AURL:string):string;
function GetHTTP_JSON_Value(const AURL,AName:string):string;

function PostHTTP(const AURL:string; AValues:TStringList):string;

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

function PostHTTP(const AURL:string; AValues:TStringList):string;
var
  ResultStream : TStringStream;
  Client: TNetHTTPClient;
  Request: TNetHTTPRequest;
begin
  Result := '';

  ResultStream := TStringStream.Create;
  Client:= TNetHTTPClient.Create(nil);
  Request:= TNetHTTPRequest.Create(nil);

  try
    Request.Client := Client;
    Request.Post(AURL, AValues, ResultStream, nil);
    Result := ResultStream.DataString;
  finally
    Request.Free;
    Client.Free;
    ResultStream.Free;
  end;
end;

end.
