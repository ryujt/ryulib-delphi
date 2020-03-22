unit DeskUnZip;

interface

uses
  DeskZipUtils,
  DebugTools,
  SysUtils, Classes, Graphics;

type
  TDeskUnZip = class
  private
    FHandle : pointer;
    function GetHeight: integer;
    function GetWidth: integer;
    function GetBitmapHeight: integer;
    function getBitmapWidth: integer;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Execute(ADeskFrame:PDeskFrame);

    function GetBitmapBuffer:pointer;
    procedure GetBitmap(ABitmap:TBitmap);
  public
    property Width : integer read GetWidth;
    property Height : integer read GetHeight;

    property BitmapWidth : integer read getBitmapWidth;
    property BitmapHeight : integer read GetBitmapHeight;
  end;

implementation

{ TDeskUnZip }

constructor TDeskUnZip.Create;
begin
  inherited;

  FHandle := createDeskUnZip;
end;

destructor TDeskUnZip.Destroy;
begin
  releaseDeskUnZip(FHandle);

  inherited;
end;

procedure TDeskUnZip.Execute(ADeskFrame: PDeskFrame);
begin
  executeDeskUnZip(FHandle, ADeskFrame);
end;

procedure TDeskUnZip.GetBitmap(ABitmap: TBitmap);
var
  pixels : integer;
begin
  if (ABitmap.Width <> BitmapWidth) or (ABitmap.Height <> BitmapWidth) then begin
    ABitmap.PixelFormat := pf32bit;
    ABitmap.Canvas.Brush.Color := clBlack;
    ABitmap.Width  := ToCellSize(Width);
    ABitmap.Height := -ToCellSize(Height);
  end;

  pixels := ABitmap.Width * ABitmap.Height;
  if pixels = 0 then Exit;

  Move(GetBitmapBuffer^, ABitmap.ScanLine[ABitmap.Height-1]^, pixels * PIXEL_SIZE);
end;

function TDeskUnZip.GetBitmapBuffer: pointer;
begin
  Result := DeskZipUtils.getBitmapBuffer(FHandle);
end;

function TDeskUnZip.GetBitmapHeight: integer;
begin
  Result := Height;
  if (Result mod CELL_SIZE) <> 0 then Result := Result + (CELL_SIZE - (Result mod CELL_SIZE));
end;

function TDeskUnZip.getBitmapWidth: integer;
begin
  Result := Width;
  if (Result mod CELL_SIZE) <> 0 then Result := Result + (CELL_SIZE - (Result mod CELL_SIZE));
end;

function TDeskUnZip.GetHeight: integer;
begin
  Result := DeskZipUtils.GetHeight(FHandle);
end;

function TDeskUnZip.GetWidth: integer;
begin
  Result := DeskZipUtils.GetWidth(FHandle);
end;

end.
