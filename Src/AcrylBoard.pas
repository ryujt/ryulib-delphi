unit AcrylBoard;

interface

uses
  RyuLibBase,
  Windows, Messages, SysUtils, Classes, Graphics, Controls, ExtCtrls;

type
  // TODO: implement dsLine, dsRectangle, dsEllipse
  TDrawStyle = (dsEraser, dsPen, dsLine, dsRectangle, dsEllipse);

  TAcrylBoard = class (TCustomControl)
  protected
    procedure Paint; override;
    procedure Resize; override;
    procedure MouseDown(Button:TMouseButton; Shift:TShiftState; X,Y:Integer); override;
    procedure MouseMove(Shift:TShiftState; X,Y:Integer); override;
    procedure MouseUp(Button:TMouseButton; Shift:TShiftState; X,Y:Integer); override;
  private
    FMouseDown : TPoint;
    FOldWindowSize : TSize;
  private
    FBitmap : TBitmap;
    procedure on_Bitmap_Change(Sender:TObject);
  private
    FBitmapLayer : TBitmap;
    procedure do_ResizeBitmapLayer;
  private
    FAutoSize: boolean;
    FCanDraw: boolean;
    FDrawStyle: TDrawStyle;
    function GetPenColor: TColor;
    function GetTransparentColor: TColor;
    procedure SetPenColor(const Value: TColor);
    procedure SetTransparentColor(const Value: TColor);
    procedure SetAutoSize(const Value: boolean);
    function GetPenWidth: TColor;
    procedure SetPenWidth(const Value: TColor);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Clear;
  published
    property OnClick;
    property OnDblClick;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseEnter;
    property OnMouseLeave;
  published
    property CanDraw : boolean read FCanDraw write FCanDraw;
    property DrawStyle : TDrawStyle read FDrawStyle write FDrawStyle;
    property AutoSize : boolean read FAutoSize write SetAutoSize;
    property PenColor : TColor read GetPenColor write SetPenColor;
    property PenWidth : TColor read GetPenWidth write SetPenWidth;
    property TransparentColor : TColor read GetTransparentColor write SetTransparentColor;
    property Bitmap : TBitmap read FBitmap;
    property BitmapLayer : TBitmap read FBitmapLayer;
  end;

implementation

{ TAcrylBoard }

procedure TAcrylBoard.Clear;
begin
  FBitmapLayer.Canvas.FillRect( Rect(0, 0, Width, Height) );
  Invalidate;
end;

constructor TAcrylBoard.Create(AOwner: TComponent);
const
  DEFAULT_PEN_COLOR = clRed;
  DEFAULT_TRANSPARENT_COLOR = $578390;
begin
  inherited;

  FDrawStyle := dsPen;
  FCanDraw := false;

  DoubleBuffered := true;
  ControlStyle := ControlStyle + [csOpaque];

  FBitmap := TBitmap.Create;
  FBitmap.OnChange := on_Bitmap_Change;

  FBitmapLayer := TBitmap.Create;
  FBitmapLayer.PixelFormat := pf32bit;
  FBitmapLayer.Canvas.Pen.Color := DEFAULT_PEN_COLOR;
  FBitmapLayer.Canvas.Pen.Width := 3;
  FBitmapLayer.Canvas.Brush.Color := DEFAULT_TRANSPARENT_COLOR;
  FBitmapLayer.TransparentColor := DEFAULT_TRANSPARENT_COLOR;
  FBitmapLayer.Transparent := true;

  do_ResizeBitmapLayer;
end;

destructor TAcrylBoard.Destroy;
begin
  FreeAndNil(FBitmap);
  FreeAndNil(FBitmapLayer);

  inherited;
end;

procedure TAcrylBoard.do_ResizeBitmapLayer;
begin
  if (FBitmapLayer.Width <> Width) or (FBitmapLayer.Height <> Height) then begin
    FBitmapLayer.Width  := Width;
    FBitmapLayer.Height := Height;
  end;
end;

function TAcrylBoard.GetPenColor: TColor;
begin
  Result := FBitmapLayer.Canvas.Pen.Color;
end;

function TAcrylBoard.GetPenWidth: TColor;
begin
  Result := FBitmapLayer.Canvas.Pen.Width;
end;

function TAcrylBoard.GetTransparentColor: TColor;
begin
  Result := FBitmapLayer.TransparentColor;
end;

procedure TAcrylBoard.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;

  if not FCanDraw then Exit;

  FMouseDown := Point( X, Y);

  FOldWindowSize.cx := Width;
  FOldWindowSize.cy := Height;

  FBitmapLayer.Canvas.MoveTo( X, Y );
end;

procedure TAcrylBoard.MouseMove(Shift: TShiftState; X,Y: Integer);
begin
  inherited;

  if not FCanDraw then Exit;

  if Shift = [ssLeft] then begin
    case FDrawStyle of
      dsEraser: FBitmapLayer.Canvas.FillRect( Rect(X, Y, X+32, Y+32) );
      dsPen: FBitmapLayer.Canvas.LineTo( X, Y );
    end;

    Invalidate;
  end;
end;

function PointDistance(A,B:TPoint):integer;
begin
  Result := Round( SQRT (SQR(A.X-B.X) + SQR(A.Y-B.Y)) );
end;

procedure TAcrylBoard.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  inherited;

end;

procedure TAcrylBoard.on_Bitmap_Change(Sender: TObject);
begin
  if not FAutoSize then Exit;

  if (FBitmap.Width <> Width) or (FBitmap.Height <> Height) then begin
    Width  := FBitmap.Width;
    Height := FBitmap.Height;
  end;
end;

procedure TAcrylBoard.Paint;
begin
  inherited;

  Canvas.Brush.Style := bsSolid;
  Canvas.Draw( 0, 0, FBitmap );
  Canvas.Draw( 0, 0, FBitmapLayer );
end;

procedure TAcrylBoard.Resize;
begin
  inherited;

  do_ResizeBitmapLayer;
end;

procedure TAcrylBoard.SetAutoSize(const Value: boolean);
begin
  FAutoSize := Value;
  on_Bitmap_Change( FBitmap );
end;

procedure TAcrylBoard.SetPenColor(const Value: TColor);
begin
  FBitmapLayer.Canvas.Pen.Color := Value;
end;

procedure TAcrylBoard.SetPenWidth(const Value: TColor);
begin
  FBitmapLayer.Canvas.Pen.Width := Value;
end;

procedure TAcrylBoard.SetTransparentColor(const Value: TColor);
begin
  FBitmapLayer.TransparentColor := Value;
end;

end.

