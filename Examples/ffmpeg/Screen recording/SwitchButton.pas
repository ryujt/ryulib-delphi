unit SwitchButton;

interface

uses
  Winapi.Windows, System.SysUtils, System.Variants, System.Classes, Vcl.StdCtrls;

type
  TSwitchButton = class (TComponent)
  private
    FTargetOnClick : TNotifyEvent;
    procedure onClick(Sender: TObject);
  private
    FLabelOn : string;
    FLabelOff : string;
    FTarget : TButton;
    FChecked : boolean;
    FOnClick : TNotifyEvent;
  public
    constructor Create(AOwner:TComponent; ALabelOn,ALabelOff:string; AOnClick:TNotifyEvent); reintroduce;
  published
    property Target : TButton read FTarget;
    property Checked : boolean read FChecked;
  end;

implementation

{ TSwitchButton }

constructor TSwitchButton.Create(AOwner:TComponent; ALabelOn,ALabelOff:string; AOnClick:TNotifyEvent);
var
  button : TButton absolute AOwner;
begin
  inherited Create(AOwner);

  FLabelOn := ALabelOn;
  FLabelOff := ALabelOff;
  FChecked := false;
  FOnClick := AOnClick;

  FTargetOnClick := button.OnClick;
  button.OnClick := onClick;
  FTarget := button;
end;

procedure TSwitchButton.onClick(Sender: TObject);
begin
  FChecked := not FChecked;
  if FChecked then FTarget.Caption := FLabelOn
  else FTarget.Caption := FLabelOff;

  if Assigned(FOnClick) then FOnClick(Self);
end;

end.
