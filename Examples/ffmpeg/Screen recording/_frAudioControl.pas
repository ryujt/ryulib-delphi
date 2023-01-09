unit _frAudioControl;

interface

uses
  CoreBase,
  SelectInputDeviceComboBox,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.jpeg,
  Vcl.ExtCtrls, Vcl.StdCtrls;

type
  TfrAudioControl = class(TFrame, IRecordingChanged)
    Shape1: TShape;
    Label1: TLabel;
    cbSelectInputDevice: TComboBox;
    checkUseSystemAudio: TCheckBox;
  private // IRecordingChanged
    procedure onRecordingStatusChanged(AValue:boolean);
  public
    constructor Create(AOwner: TComponent); override;
  end;

implementation

uses
  Core;

{$R *.dfm}

{ TfrAudioControl }

constructor TfrAudioControl.Create(AOwner: TComponent);
begin
  inherited;

  TCore.Obj.AddListener(Self);

  TSelectInputDeviceComboBox.Create(cbSelectInputDevice);
end;

procedure TfrAudioControl.onRecordingStatusChanged(AValue: boolean);
begin
  cbSelectInputDevice.Enabled := not AValue;
  checkUseSystemAudio.Enabled := not AValue;
end;

end.
