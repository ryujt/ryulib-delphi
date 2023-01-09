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
  CoreBase in 'Core\CoreBase.pas',
  Audio in 'Core\Audio.pas',
  Video in 'Core\Video.pas',
  ffmpeg in 'Core\ffmpeg.pas',
  _fmSelectWindow in '_fmSelectWindow.pas' {fmSelectWindow};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfmMain, fmMain);
  Application.CreateForm(TfmScreenRegion, fmScreenRegion);
  Application.CreateForm(TfmSelectWindow, fmSelectWindow);
  Application.Run;
end.
