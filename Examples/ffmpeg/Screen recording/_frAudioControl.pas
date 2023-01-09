unit _frAudioControl;

interface

uses
  MainControl,
  StartCaptrueButton, SelectInputDeviceComboBox,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.jpeg,
  Vcl.ExtCtrls, Vcl.StdCtrls;

type
  TfrAudioControl = class(TFrame, IOnAir)
    Shape1: TShape;
    Label1: TLabel;
    btStartCaptrue: TButton;
    cbSelectInputDevice: TComboBox;
    checkUseSystemAudio: TCheckBox;
    procedure btStartCaptrueClick(Sender: TObject);
  private
    procedure onAirStatusChanged(AIsOnAir:boolean);
  public
    constructor Create(AOwner: TComponent); override;
  end;

implementation

{$R *.dfm}

{ TfrAudioControl }

procedure TfrAudioControl.btStartCaptrueClick(Sender: TObject);
var
  button : TStartCaptrueButton absolute Sender;
begin
  if button.OnAir then begin
    TMainControl.Obj.StartRecording;
  end else begin
    TMainControl.Obj.StopRecording;
  end;

//  if button.OnAir then begin
//    TAudioSender.Obj.start(
//      GetSelectInputDeviceComboBox(cbSelectInputDevice).DeviceID,
//      checkUseSystemAudio.Checked
//    );
//  end else begin
//    TAudioSender.Obj.stop;
//  end;
end;

constructor TfrAudioControl.Create(AOwner: TComponent);
begin
  inherited;

  TMainControl.Obj.AddListener(Self);

  TStartCaptrueButton.Create(btStartCaptrue, btStartCaptrueClick);
  TSelectInputDeviceComboBox.Create(cbSelectInputDevice);
end;

procedure TfrAudioControl.onAirStatusChanged(AIsOnAir: boolean);
begin
  cbSelectInputDevice.Enabled := not AIsOnAir;
  checkUseSystemAudio.Enabled := not AIsOnAir;
end;

end.
