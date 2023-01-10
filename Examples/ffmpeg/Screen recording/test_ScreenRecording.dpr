program test_ScreenRecording;

uses
  Vcl.Forms,
  _fmMain in '_fmMain.pas' {fmMain},
  _frVideoPreview in '_frVideoPreview.pas' {frVideoPreview: TFrame},
  _frControlBox in '_frControlBox.pas' {frControlBox: TFrame},
  _fmScreenRegion in '_fmScreenRegion.pas' {fmScreenRegion},
  _frAudioControl in '_frAudioControl.pas' {frAudioControl: TFrame},
  SelectInputDeviceComboBox in 'SelectInputDeviceComboBox.pas',
  _frVideoSource in '_frVideoSource.pas' {frVideoSource: TFrame},
  _frMainControl in '_frMainControl.pas' {frMainControl: TFrame},
  Core in 'Core\Core.pas',
  CoreBase in 'Core\CoreBase.pas',
  Audio in 'Core\Audio.pas',
  Video in 'Core\Video.pas',
  ffmpeg in 'Core\ffmpeg.pas',
  _fmSelectWindow in '_fmSelectWindow.pas' {fmSelectWindow},
  ScreenUtils in 'Lib\ScreenUtils.pas',
  SwitchButton in 'SwitchButton.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfmScreenRegion, fmScreenRegion);
  Application.CreateForm(TfmMain, fmMain);
  Application.CreateForm(TfmSelectWindow, fmSelectWindow);
  Application.Run;
end.
