unit VideoZip;

interface

uses
  Classes, SysUtils, Graphics;

type
  TVideoZip = class
  private
    FHandle : pointer;
    FisActive: boolean;
    FWidth, FHeight : integer;
    function GetEncodedData: pointer;
    function GetEncodedSize: integer;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Open(AIndex,AWidth,AHeight:integer);
    procedure Close;
    procedure Execute;
    procedure GetBitmap(ABitmap:TBitmap);
  public
    property isActive : boolean read FisActive;
    property Data : pointer read GetEncodedData;
    property Size : integer read GetEncodedSize;
  end;

  TVideoUnZip = class
  private
    FHandle : pointer;
    FWidth, FHeight : integer;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Open(AWidth,AHeight:integer);
    procedure Execute(AData:pointer; ASize:integer);
    procedure GetBitmap(ABitmap:TBitmap);
  end;

function  getCameraCount:integer;
          cdecl; external 'VideoZip.dll' delayed;

function  getCameraName(AIndex:integer):PAnsiChar;
          cdecl; external 'VideoZip.dll' delayed;

function  getCameraNameString(AIndex:integer):string;

function  createVideoZip:pointer;
          cdecl; external 'VideoZip.dll' delayed;

procedure releaseVideoZip(AHandle:pointer);
          cdecl; external 'VideoZip.dll' delayed;

function openVideoZip(AHandle:pointer; AIndex,AWidth,AHeight:integer):boolean;
          cdecl; external 'VideoZip.dll' delayed;

procedure closeVideoZip(AHandle:pointer);
          cdecl; external 'VideoZip.dll' delayed;

procedure encodeVideoZip(AHandle:pointer);
          cdecl; external 'VideoZip.dll' delayed;

function getVideoZipBitmap(AHandle:pointer):pointer;
          cdecl; external 'VideoZip.dll' delayed;

function getVideoZipData(AHandle:pointer):pointer;
          cdecl; external 'VideoZip.dll' delayed;

function getVideoZipSize(AHandle:pointer):integer;
          cdecl; external 'VideoZip.dll' delayed;

function  createVideoUnZip:pointer;
          cdecl; external 'VideoZip.dll' delayed;

procedure releaseVideoUnZip(AHandle:pointer);
          cdecl; external 'VideoZip.dll' delayed;

procedure openVideoUnZip(AHandle:pointer; AWidth,AHeight:integer);
          cdecl; external 'VideoZip.dll' delayed;

procedure refreshVideoUnZip(AHandle:pointer);
          cdecl; external 'VideoZip.dll' delayed;

procedure decodeVideoUnZip(AHandle:pointer; AData:pointer; ASize:integer);
          cdecl; external 'VideoZip.dll' delayed;

function getVideoUnZipBitmap(AHandle:pointer):pointer;
          cdecl; external 'VideoZip.dll' delayed;

procedure SaveToBitmap(AHandle:pointer; ABitmap:TBitmap);

implementation

function getCameraNameString(AIndex:integer):string;
begin
  Result := StrPas( getCameraName(AIndex) );
end;

procedure SaveToBitmap(AHandle:pointer; ABitmap:TBitmap);
begin
  Move(getVideoUnZipBitmap(AHandle)^, ABitmap.ScanLine[ABitmap.Height-1]^, ABitmap.Width * ABitmap.Height * 4);
end;

{ TVideoZip }

procedure TVideoZip.Close;
begin
  FisActive := false;
  FWidth := 0;
  FHeight := 0;
  closeVideoZip(FHandle);
end;

constructor TVideoZip.Create;
begin
  FisActive := false;
  FWidth := 0;
  FHeight := 0;
  FHandle := createVideoZip;
end;

destructor TVideoZip.Destroy;
begin
  releaseVideoZip(FHandle);

  inherited;
end;

procedure TVideoZip.Execute;
begin
  encodeVideoZip(FHandle);
end;

procedure TVideoZip.GetBitmap(ABitmap: TBitmap);
var
  bitmap_ptr : pointer;
begin
  bitmap_ptr := getVideoZipBitmap(FHandle);
  if bitmap_ptr = nil then Exit;

  ABitmap.PixelFormat := pf24bit;
  ABitmap.Canvas.Brush.Color := clBlack;
  ABitmap.Width := FWidth;
  ABitmap.Height := -FHeight;
  Move(bitmap_ptr^, ABitmap.ScanLine[ABitmap.Height-1]^, FWidth * FHeight * 3);
end;

function TVideoZip.GetEncodedData: pointer;
begin
  Result := getVideoZipData(FHandle);
end;

function TVideoZip.GetEncodedSize: integer;
begin
  Result := getVideoZipSize(FHandle);
end;

procedure TVideoZip.Open(AIndex, AWidth, AHeight: integer);
begin
  if FisActive then Exit;

  FWidth := AWidth;
  FHeight := AHeight;
  FisActive := openVideoZip(FHandle, AIndex, AWidth, AHeight);
end;

{ TVideoUnZip }

constructor TVideoUnZip.Create;
begin
  FWidth := 0;
  FHeight := 0;
  FHandle := createVideoUnZip;
end;

destructor TVideoUnZip.Destroy;
begin
  releaseVideoUnZip(FHandle);

  inherited;
end;

procedure TVideoUnZip.Execute(AData:pointer; ASize:integer);
begin
  decodeVideoUnZip(FHandle, AData, ASize);
end;

procedure TVideoUnZip.Open(AWidth, AHeight: integer);
begin
  FWidth := AWidth;
  FHeight := AHeight;
  openVideoUnZip(FHandle, AWidth, AHeight);
end;

procedure TVideoUnZip.GetBitmap(ABitmap: TBitmap);
var
  bitmap_ptr : pointer;
begin
  bitmap_ptr := getVideoUnZipBitmap(FHandle);
  if bitmap_ptr = nil then Exit;

  ABitmap.PixelFormat := pf32bit;
  ABitmap.Canvas.Brush.Color := clBlack;
  ABitmap.Width := FWidth;
  ABitmap.Height := -FHeight;
  Move(bitmap_ptr^, ABitmap.ScanLine[ABitmap.Height-1]^, FWidth * FHeight * 4);
end;

end.
