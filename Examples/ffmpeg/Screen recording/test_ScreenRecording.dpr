program test_ScreenRecording;

uses
  Vcl.Forms,
  _fmMain in '_fmMain.pas' {fmMain},
  _frVideoPreview in '_frVideoPreview.pas' {frVideoPreview: TFrame},
  _frControlBox in '_frControlBox.pas' {frControlBox: TFrame},
  _fmScreenRegion in '_fmScreenRegion.pas' {fmScreenRegion},
  _frAudioControl in '_frAudioControl.pas' {frAudioControl: TFrame},
  AudioSender in 'AudioSender.pas',
  SelectInputDeviceComboBox in 'SelectInputDeviceComboBox.pas',
  StartCaptrueButton in 'StartCaptrueButton.pas',
  _frVideoSource in '_frVideoSource.pas' {frVideoSource: TFrame},
  _frMainControl in '_frMainControl.pas' {frMainControl: TFrame},
  Core in 'Core\Core.pas',
  MainControl in 'Core\MainControl.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfmMain, fmMain);
  Application.CreateForm(TfmScreenRegion, fmScreenRegion);
  Application.Run;
end.
