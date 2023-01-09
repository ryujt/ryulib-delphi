unit _frAudioControl;

interface

uses
  StartCaptrueButton, SelectInputDeviceComboBox,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.jpeg,
  Vcl.ExtCtrls, Vcl.StdCtrls;

type
  TfrAudioControl = class(TFrame)
    Shape1: TShape;
    Label1: TLabel;
    btStartCaptrue: TButton;
    cbSelectInputDevice: TComboBox;
    checkUseSystemAudio: TCheckBox;
    procedure btStartCaptrueClick(Sender: TObject);
  private
  public
    constructor Create(AOwner: TComponent); override;
  end;

implementation

uses
  AudioSender;

{$R *.dfm}

{ TfrAudioControl }

procedure TfrAudioControl.btStartCaptrueClick(Sender: TObject);
var
  button : TStartCaptrueButton absolute Sender;
begin
  cbSelectInputDevice.Enabled := not button.OnAir;
  checkUseSystemAudio.Enabled := not button.OnAir;

  if button.OnAir then begin
    TAudioSender.Obj.start(
      GetSelectInputDeviceComboBox(cbSelectInputDevice).DeviceID,
      checkUseSystemAudio.Checked
    );
  end else begin
    TAudioSender.Obj.stop;
  end;
end;

constructor TfrAudioControl.Create(AOwner: TComponent);
begin
  inherited;

  TStartCaptrueButton.Create(btStartCaptrue, btStartCaptrueClick);
  TSelectInputDeviceComboBox.Create(cbSelectInputDevice);
end;

end.
