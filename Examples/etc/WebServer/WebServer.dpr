program WebServer;

uses
  Vcl.Forms,
  _fmMain in '_fmMain.pas' {fmMain},
  WebServerUnit in '..\..\Src\WebServerUnit.pas' {WebServerModule: TWebModule},
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Aqua Graphite');
  Application.CreateForm(TfmMain, fmMain);
  Application.Run;
end.
