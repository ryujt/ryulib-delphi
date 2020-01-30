unit _fmMain;

interface

uses
  VideoZip,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls;

const
  WIDTH = 320;
  HEIGHT = 240;

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
  Image.Picture.Bitmap.Width := WIDTH;
  Image.Picture.Bitmap.Height := -HEIGHT;

  FZip := createVideoZip;
  FUnZip := createVideoUnZip;

  openVideopZip(FZip, WIDTH, HEIGHT);
  openVideopUnZip(FUnZip, WIDTH, HEIGHT);
end;

procedure TfmMain.TimerTimer(Sender: TObject);
begin
  encode(FZip);

  Caption := Format('Encode size: %d', [getSize(FZip)]);

  decode(FUnZip, getData(FZip), getSize(FZip));
  SaveToBitmap(FUnZip, Image.Picture.Bitmap);
  Image.Invalidate;
end;

end.
