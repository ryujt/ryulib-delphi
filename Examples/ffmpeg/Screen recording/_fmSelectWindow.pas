unit _fmSelectWindow;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TfmSelectWindow = class(TForm)
    plClient: TPanel;
    Timer: TTimer;
    procedure TimerTimer(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    procedure create_hole;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

var
  fmSelectWindow: TfmSelectWindow;

implementation

uses
  Core;

{$R *.dfm}

constructor TfmSelectWindow.Create(AOwner: TComponent);
begin
  inherited;

  create_hole;

  TCore.Obj.AddListener(Self);
end;

procedure TfmSelectWindow.create_hole;
var
  hRect, hDelete, hResult: THandle;
begin
  hResult := CreateRectRgn(0, 0, Width, Height);
  hRect := CreateRectRgn(0, 0, Width, Height);

  hDelete := CreateRectRgn(
    plClient.Left, plClient.Top,
    plClient.Left + plClient.Width,
    plClient.Top  + plClient.Height
  );

  if CombineRgn(hResult, hRect, hDelete, RGN_XOR) = ERROR then Exit;

  SetWindowRgn(Handle, hResult, True);
end;

destructor TfmSelectWindow.Destroy;
begin
  TCore.Obj.RemoveListener(Self);

  inherited;
end;

procedure TfmSelectWindow.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Timer.Enabled := false;
end;

procedure TfmSelectWindow.FormDeactivate(Sender: TObject);
begin
  Timer.Enabled := false;
  Close;
end;

procedure TfmSelectWindow.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then Close;
end;

procedure TfmSelectWindow.FormShow(Sender: TObject);
begin
  TCore.Obj.Video.SetTargetWindow(-1);
  Timer.Enabled := true;
end;

procedure TfmSelectWindow.TimerTimer(Sender: TObject);
var
  c_pos : TPoint;
  target_window : THandle;
  WindowRect : TRect;
begin
  if Visible = false then Exit;

  GetCursorPos(c_pos);
  target_window := WindowFromPoint(c_pos);
  if target_window = 0 then Exit;

  GetWindowRect(target_window, WindowRect);

  Left := WindowRect.Left;
  Top  := WindowRect.Top;

  Width  := WindowRect.Width;
  Height := WindowRect.Height;

  create_hole;

  if GetActiveWindow = 0 then begin
    Timer.Enabled := false;
    Close;
    TCore.Obj.Video.SetTargetWindow(target_window);
  end;
end;

end.
