unit WebServerUnit;

interface

uses
  DebugTools, Disk, Strg,
  Web.WebReq, IdHTTPWebBrokerBridge,
  System.SysUtils, System.Classes, Web.HTTPApp;

type
  TWebServerModule = class(TWebModule)
    procedure WebServerModuleDefaultHandlerAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
  private
  public
  end;

procedure StartWebServer(APort:integer);
procedure StopWebServer;

implementation

var
  _WebServer : TIdHTTPWebBrokerBridge;

procedure StartWebServer(APort:integer);
begin
  _WebServer.Bindings.Clear;
  _WebServer.DefaultPort := APort;
  _WebServer.Active := True;
end;

procedure StopWebServer;
begin
  _WebServer.Active := False;
  _WebServer.Bindings.Clear;
end;

{$R *.dfm}

procedure TWebServerModule.WebServerModuleDefaultHandlerAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  filename, ext : string;
  fsData : TFileStream;
begin
  filename := GetExecPath + Request.PathInfo;
  filename := StringReplace(filename, '/', '\', [rfReplaceAll]);
  filename := StringReplace(filename, '\\', '\', [rfReplaceAll]);

  if not FileExists(filename) then SetLastChar(filename, '\');

  if not FileExists(filename) then begin
    if FileExists(filename + 'index.html') then filename := filename + 'index.html';
  end;

  ext := LowerCase( ExtractFileExt(filename) );

  if ext = '.js' then Response.ContentType := 'application/javascript; charset=UTF-8';
  if ext = '.css' then Response.ContentType := 'text/css; charset=UTF-8';

  fsData := TFileStream.Create(filename, fmOpenRead);
  Response.ContentStream  := fsData;

  Trace( Format('TWebServerModule - %s', [filename]) );
end;

initialization
  if WebRequestHandler <> nil then WebRequestHandler.WebModuleClass := TWebServerModule;
  _WebServer := TIdHTTPWebBrokerBridge.Create(nil);
finalization
  //
end.





Content-Type: image/png
