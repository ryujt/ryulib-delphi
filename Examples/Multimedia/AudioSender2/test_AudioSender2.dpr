program test_AudioSender2;

uses
  Vcl.Forms,
  _fmMain in '_fmMain.pas' {fmMain},
  _frAudioControl in '_frAudioControl.pas' {frAudioControl: TFrame},
  AudioSender in 'AudioSender.pas',
  StartCaptrueButton in 'StartCaptrueButton.pas',
  SelectInputDeviceComboBox in 'SelectInputDeviceComboBox.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfmMain, fmMain);
  Application.Run;
end.