unit StartCaptrueButton;

interface

uses
  Winapi.Windows, System.SysUtils, System.Variants, System.Classes, Vcl.StdCtrls;

type
  TStartCaptrueButton = class (TButton)
  private
    FTargetButton : TButton;
    FTargetOnClick : TNotifyEvent;
    procedure onClick(Sender: TObject);
  private
    FOnAir : boolean;
    FOnClick : TNotifyEvent;
  public
    constructor Create(AOwner:TComponent; AOnClick:TNotifyEvent); reintroduce;
    destructor Destroy; override;
  published
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
  FTargetButton := button;
end;

destructor TStartCaptrueButton.Destroy;
begin

  inherited;
end;

procedure TStartCaptrueButton.onClick(Sender: TObject);
begin
  FOnAir := not FOnAir;
  if FOnAir then FTargetButton.Caption := 'On Air'
  else FTargetButton.Caption := 'off the air';

  if Assigned(FOnClick) then FOnClick(Self);
end;

end.
