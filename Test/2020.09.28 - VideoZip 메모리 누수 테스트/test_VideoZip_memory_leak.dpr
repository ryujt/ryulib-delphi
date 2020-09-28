program test_VideoZip_memory_leak;

uses
  Vcl.Forms,
  _fmMain in '_fmMain.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
