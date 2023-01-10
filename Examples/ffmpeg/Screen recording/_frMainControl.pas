unit _frMainControl;

interface

uses
  CoreBase,
  SwitchButton,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TfrMainControl = class(TFrame)
    btStartCaptrue: TButton;
    btResolution: TButton;
    procedure btStartCaptrueClick(Sender: TObject);
    procedure btResolutionClick(Sender: TObject);
  private
  public
    constructor Create(AOwner: TComponent); override;
  end;

implementation

uses
  Core;

{$R *.dfm}

procedure TfrMainControl.btResolutionClick(Sender: TObject);
var
  button : TSwitchButton absolute Sender;
begin
  if button.Checked then begin
    TCore.Obj.Video.SetOutputResolution(1920, 1080);
  end else begin
    TCore.Obj.Video.SetOutputResolution(1280,  720);
  end;
end;

procedure TfrMainControl.btStartCaptrueClick(Sender: TObject);
var
  button : TSwitchButton absolute Sender;
begin
  if button.Checked then begin
    TCore.Obj.StartRecording;
  end else begin
    TCore.Obj.StopRecording;
  end;
end;

constructor TfrMainControl.Create(AOwner: TComponent);
begin
  inherited;

  TCore.Obj.AddListener(Self);

  TSwitchButton.Create(btStartCaptrue, 'started', 'stoped', btStartCaptrueClick);
  TSwitchButton.Create(btResolution,   'FHD',     'HD',     btResolutionClick);
end;

end.
