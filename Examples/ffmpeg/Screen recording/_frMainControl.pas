unit _frMainControl;

interface

uses
  CoreBase,
  StartCaptrueButton,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TfrMainControl = class(TFrame)
    btStartCaptrue: TButton;
    procedure btStartCaptrueClick(Sender: TObject);
  private
  public
    constructor Create(AOwner: TComponent); override;
  end;

implementation

uses
  Core;

{$R *.dfm}

procedure TfrMainControl.btStartCaptrueClick(Sender: TObject);
var
  button : TStartCaptrueButton absolute Sender;
begin
  if button.OnAir then begin
//      GetSelectInputDeviceComboBox(cbSelectInputDevice).DeviceID,
//      checkUseSystemAudio.Checked
    TCore.Obj.StartRecording;
  end else begin
    TCore.Obj.StopRecording;
  end;
end;

constructor TfrMainControl.Create(AOwner: TComponent);
begin
  inherited;

  TCore.Obj.AddListener(Self);

  TStartCaptrueButton.Create(btStartCaptrue, btStartCaptrueClick);
end;

end.
