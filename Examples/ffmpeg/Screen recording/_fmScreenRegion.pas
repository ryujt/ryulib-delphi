unit _fmScreenRegion;

interface

uses
  CoreBase,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, BitmapWindow;

type
  TfmScreenRegion = class(TForm, IVideoSourceChanged, IRecordingChanged)
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
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    // IVideoSourceChanged
    procedure onVideoSourceChanged(AValue:TVideoSourceType);

    // IRecordingChanged
    procedure onRecordingStatusChanged(AValue:boolean);
  private
    procedure create_hole;
  private
    FRecording: boolean;
    procedure SetRecording(const Value: boolean);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure SetSize(AWidth,AHeight:integer);
  public
    property Recording : boolean read FRecording write SetRecording;
  end;

var
  fmScreenRegion: TfmScreenRegion;

implementation

uses
  Core;

{$R *.dfm}

constructor TfmScreenRegion.Create(AOwner: TComponent);
begin
  inherited;

  FRecording := false;

  Left := 0;
  Top  := 0;

  create_hole;

  TCore.Obj.AddListener(Self);
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

procedure TfmScreenRegion.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  TCore.Obj.Terminate;
end;

procedure TfmScreenRegion.FormResize(Sender: TObject);
begin
  create_hole;
end;

procedure TfmScreenRegion.FormShow(Sender: TObject);
begin
  SetWindowPos(Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOSIZE or SWP_NOMOVE);
end;

procedure TfmScreenRegion.onRecordingStatusChanged(AValue: boolean);
begin
  plInfo.Visible := not AValue;
  create_hole;
  tmBlink.Enabled := AValue;

  if AValue = false then begin
    BitmapWindow.Visible := true;
    Exit;
  end;

  if Visible then
  // TODO:
//    TOptions.Obj.ScreenOption.SetScreenRegion(
//      Left + plClient.Left,
//      Top  + plClient.Top,
//      plClient.Width,
//      plClient.Height
//    );
end;

procedure TfmScreenRegion.onVideoSourceChanged(AValue: TVideoSourceType);
begin
  if AValue = vsRegion then Show
  else Hide;
end;

procedure TfmScreenRegion.plInfoMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  ReleaseCapture;
  Perform(WM_SysCommand, $F012, 0);
end;

procedure TfmScreenRegion.SetRecording(const Value: boolean);
begin
  FRecording := Value;
end;

procedure TfmScreenRegion.SetSize(AWidth, AHeight: integer);
begin
  Width  := AWidth  + 13;
  Height := AHeight + 13;
end;

procedure TfmScreenRegion.tmBlinkTimer(Sender: TObject);
begin
  BitmapWindow.Visible := not BitmapWindow.Visible;
end;

procedure TfmScreenRegion.tmInfoTimer(Sender: TObject);
begin
  plInfo.Caption := Format('(%d, %d) - %d X %d', [Left + plClient.Left, Top + plClient.Top, plClient.Width, plClient.Height]);
//  TCore.Obj.Video.SetRegion(
//    Rect(
//      Left + plClient.Left, Top + plClient.Top,
//      Left + plClient.Left + Top + plClient.Top + plClient.Width, plClient.Height
//    )
//  );
end;

end.


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


