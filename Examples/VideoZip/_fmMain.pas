unit _fmMain;

interface

uses
  VideoZip,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls;

const
  CAM_WIDTH = 320;
  CAM_HEIGHT = 240;

type
  TfmMain = class(TForm)
    Timer: TTimer;
    Image: TImage;
    procedure FormCreate(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
  private
    FZip : pointer;
    FUnZip : pointer;
  public
  end;

var
  fmMain: TfmMain;

implementation

{$R *.dfm}

procedure TfmMain.FormCreate(Sender: TObject);
begin
  Image.Picture.Bitmap.PixelFormat := pf32bit;
  Image.Picture.Bitmap.Canvas.Brush.Color := clBlack;
  Image.Picture.Bitmap.Width := CAM_WIDTH;
  Image.Picture.Bitmap.Height := -CAM_HEIGHT;

  FZip := createVideoZip;
  FUnZip := createVideoUnZip;

  if openVideoZip(FZip, 0, CAM_WIDTH, CAM_HEIGHT) = false then
    raise Exception.Create('Error - openVideopZip');

  openVideoUnZip(FUnZip, CAM_WIDTH, CAM_HEIGHT);
end;

procedure TfmMain.TimerTimer(Sender: TObject);
begin
  encodeVideoZip(FZip);

  Caption := Format('Encode size: %d', [getVideoZipSize(FZip)]);

  if getVideoZipSize(FZip) > 0 then begin
    decodeVideoUnZip(FUnZip, getVideoZipData(FZip), getVideoZipSize(FZip));
    SaveToBitmap(FUnZip, Image.Picture.Bitmap);
    Image.Invalidate;
  end;
end;

end.
