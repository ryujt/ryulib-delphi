unit _frAudioControl;

interface

uses
  StartCaptrueButton,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.jpeg,
  Vcl.ExtCtrls, Vcl.StdCtrls;

type
  TfrAudioControl = class(TFrame)
    btStartCaptrue: TButton;
    procedure btStartCaptrueClick(Sender: TObject);
  private
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
  if button.OnAir then ShowMessage('Let''s start broadcast!');
end;

constructor TfrAudioControl.Create(AOwner: TComponent);
begin
  inherited;

  TStartCaptrueButton.Create(btStartCaptrue, btStartCaptrueClick);
end;

end.
