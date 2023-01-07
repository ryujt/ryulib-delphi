# Hide UI detail codes

``` pas
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
```

``` pas
unit StartCaptrueButton;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.jpeg,
  Vcl.ExtCtrls, Vcl.StdCtrls;

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
```