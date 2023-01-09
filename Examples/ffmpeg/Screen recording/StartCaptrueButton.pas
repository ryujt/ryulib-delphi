unit StartCaptrueButton;

interface

uses
  Winapi.Windows, System.SysUtils, System.Variants, System.Classes, Vcl.StdCtrls;

type
  TStartCaptrueButton = class (TComponent)
  private
    FTargetOnClick : TNotifyEvent;
    procedure onClick(Sender: TObject);
  private
    FTarget : TButton;
    FOnAir : boolean;
    FOnClick : TNotifyEvent;
  public
    constructor Create(AOwner:TComponent; AOnClick:TNotifyEvent); reintroduce;
  published
    property Target : TButton read FTarget;
    property OnAir : boolean read FOnAir;
  end;

implementation

{ TStartCaptrueButton }

constructor TStartCaptrueButton.Create(AOwner:TComponent; AOnClick:TNotifyEvent);
var
  button : TButton absolute AOwner;
begin
  inherited Create(AOwner);

  FOnAir := false;
  FOnClick := AOnClick;

  FTargetOnClick := button.OnClick;
  button.OnClick := onClick;
  FTarget := button;
end;

procedure TStartCaptrueButton.onClick(Sender: TObject);
begin
  FOnAir := not FOnAir;
  if FOnAir then FTarget.Caption := 'started'
  else FTarget.Caption := 'stoped';

  if Assigned(FOnClick) then FOnClick(Self);
end;

end.
