unit ImageResize;

interface

uses
  AsyncTasks,
  Classes, SysUtils, Graphics;

type
  TImageResizeCompletedProcedure = reference to procedure(ABimap:pointer; AWidth,AHeight:integer);

  /// Resize 32bit bitmap image
  TImageResize = class
  private
    FHandle : pointer;
    FSrcWidth, FSrcHeight : integer;
    FDstWidth, FDstHeight : integer;
    FSource : pointer;
    FResized : pointer;
    FTargetBitmap : TBitmap;
  public
    constructor Create;
    destructor Destroy; override;

    procedure SetSource(ABitmap:pointer; AWidth,AHeight:integer);
    procedure SetTarget(AWidth,AHeight:integer);
    procedure Resize(AProcedure:TImageResizeCompletedProcedure);
  end;

function createImageResize:pointer;
          cdecl; external 'ImageResize.dll' delayed;

procedure releaseImageResize(AHandle:pointer);
          cdecl; external 'ImageResize.dll' delayed;

procedure readBitmap32(AHandle,ABitmap:pointer; width,height:integer);
          cdecl; external 'ImageResize.dll' delayed;

function resizeBitmap32(AHandle:pointer; width,height:integer):pointer;
          cdecl; external 'ImageResize.dll' delayed;

implementation

{ TImageResize }

constructor TImageResize.Create;
begin
  FHandle := createImageResize;
end;

destructor TImageResize.Destroy;
begin
  releaseImageResize(FHandle);

  inherited;
end;

procedure TImageResize.Resize(AProcedure:TImageResizeCompletedProcedure);
begin
  AsyncTask(
    procedure (AUserData:pointer) begin
      readBitmap32(FHandle, FSource, FSrcWidth, FSrcHeight);
      FResized := resizeBitmap32(FHandle, FDstWidth, FDstHeight);
    end,

    procedure (AUserData:pointer) begin
      if FResized <> nil then AProcedure(FResized, FDstWidth, FDstHeight);
    end,

    Self
  );
end;

procedure TImageResize.SetSource(ABitmap: pointer; AWidth, AHeight: integer);
begin
  FSource := ABitmap;
  FSrcWidth := AWidth;
  FSrcHeight := AHeight;
end;

procedure TImageResize.SetTarget(AWidth,AHeight:integer);
begin
  FDstWidth := AWidth;
  FDstHeight := AHeight;
end;

end.
