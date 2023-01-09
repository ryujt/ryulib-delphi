unit _fmScreenRegion;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, BitmapWindow;

type
  TfmScreenRegion = class(TForm)
    BitmapWindow: TBitmapWindow;
    plClient: TPanel;
    plInfo: TPanel;
    tmInfo: TTimer;
    tmBlink: TTimer;
    procedure FormResize(Sender: TObject);
    procedure plInfoMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure tmInfoTimer(Sender: TObject);
    procedure tmBlinkTimer(Sender: TObject);
  private
    procedure create_hole;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

var
  fmScreenRegion: TfmScreenRegion;

implementation

{$R *.dfm}

constructor TfmScreenRegion.Create(AOwner: TComponent);
begin
  inherited;

  create_hole;
end;

procedure TfmScreenRegion.create_hole;
var
  hRect, hDelete, hInfo, hResult: THandle;
begin
  plInfo.Caption := Format('(%d, %d) - %d X %d', [Left + plClient.Left, Top + plClient.Top, plClient.Width, plClient.Height]);

  plInfo.Left := (Width  - plInfo.Width)  div 2;
  plInfo.Top  := (Height - plInfo.Height) div 2;

  hResult := CreateRectRgn(0, 0, Width, Height);
  hRect := CreateRectRgn(0, 0, Width, Height);

  hDelete := CreateRectRgn(
    plClient.Left, plClient.Top,
    plClient.Left + plClient.Width,
    plClient.Top  + plClient.Height
  );

  hInfo := CreateRectRgn(
    plInfo.Left, plInfo.Top,
    plInfo.Left + plInfo.Width,
    plInfo.Top  + plInfo.Height
  );

  if plInfo.Visible then CombineRgn(hDelete, hDelete, hInfo, RGN_XOR);
  CombineRgn(hResult, hRect, hDelete, RGN_XOR);
  SetWindowRgn(Handle, hResult, True);
end;

destructor TfmScreenRegion.Destroy;
begin

  inherited;
end;

procedure TfmScreenRegion.FormResize(Sender: TObject);
begin
  create_hole;
end;

procedure TfmScreenRegion.plInfoMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  ReleaseCapture;
  Perform(WM_SysCommand, $F012, 0);
end;

procedure TfmScreenRegion.tmBlinkTimer(Sender: TObject);
begin
  BitmapWindow.Visible := not BitmapWindow.Visible;
end;

procedure TfmScreenRegion.tmInfoTimer(Sender: TObject);
begin
  plInfo.Caption := Format('(%d, %d) - %d X %d', [Left + plClient.Left, Top + plClient.Top, plClient.Width, plClient.Height]);
end;

end.

procedure TfmSelectRegion.rp_OnAir(AParams: TJsonData);
begin
  plInfo.Visible := not AParams.Booleans['IsOnAir'];
  create_hole;
  tmBlink.Enabled := AParams.Booleans['IsOnAir'];

  if AParams.Booleans['IsOnAir'] then begin
    if Visible then
      TOptions.Obj.ScreenOption.SetScreenRegion(
        Left + plClient.Left,
        Top  + plClient.Top,
        plClient.Width,
        plClient.Height
      );
  end else begin
    BitmapWindow.Visible := true;
  end;
end;

procedure TfmSelectRegion.rp_SetSelectRegionVisible(AParams: TJsonData);
begin
  Visible := AParams.Booleans['Visible'];
  if Visible then begin
    TOptions.Obj.ScreenOption.SetScreenRegion(
      Left + plClient.Left,
      Top  + plClient.Top,
      plClient.Width,
      plClient.Height
    );
  end;
end;

procedure TfmSelectRegion.rp_ShowOptionControl(AParams: TJsonData);
begin
  if Visible and (AParams.Values['Target'] = '') then begin
    TOptions.Obj.ScreenOption.SetScreenRegion(
      Left + plClient.Left,
      Top  + plClient.Top,
      plClient.Width,
      plClient.Height
    );
  end;
end;


