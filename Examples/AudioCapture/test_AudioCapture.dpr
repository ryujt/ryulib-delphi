program test_AudioCapture;

uses
  Vcl.Forms,
  _fmMain in '_fmMain.pas' {fmMain},
  _frAudioControl in '_frAudioControl.pas' {frAudioControl: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfmMain, fmMain);
  Application.Run;
end.
