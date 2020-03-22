unit DeskZipUtils;

interface

uses
  Windows, Classes, SysUtils, Vcl.Graphics;

const
  PIXEL_FORMAT = pf32bit;
  PIXEL_SIZE = 4;
  CELL_SIZE = 32;
  LINE_SIZE = CELL_SIZE * PIXEL_SIZE;
  BOX_SIZE = CELL_SIZE * CELL_SIZE * PIXEL_SIZE;

  // 정상적인 압축
  SPEED_NORMAL = 0;

  // 원격제어에서 사용, KEY생성 하지 않고 PIXEL 방식 압축을 하지 않음
  SPEED_FAST = 1;

type
  TFrameType = (
    ftVideo320, ftVideo640, ftVideo800, ftVideo720p, ftVideo1080p,
    ftFrameStart, ftFrameEnd,
    ftBitmap, ftJpeg, ftPixel,
    ftNeedNext, ftAskDeskZip, ftEndOfDeskZip
  );

  TFrameBase = packed record
    Size : word;
    FrameType : TFrameType;
  end;
  PFrameBase = ^TFrameBase;

  TFrameStart = packed record
    Size : word;
    FrameType : TFrameType;
	  Width, Height : integer;

    function GetBitmapWidth:integer;
    function GetBitmapHeight:integer;

    /// 한 화면을 구성하는데 필요한 Frame 패킷 개수
    function GetScreenSize:integer;
  end;
  PFrameStart = ^TFrameStart;

  TFrameCell = packed record
    Size : word;

    FrameType : TFrameType;
  	Key : integer;
  	Index : integer;
	  Buffer : packed array [1..BOX_SIZE + 1024] of byte;

	  Width, Height : integer;

    function GetBufferSize:integer;
  end;
  PDeskFrame = ^TFrameCell;

function createDeskZip:pointer; cdecl;
procedure releaseDeskZip(AHandle:pointer); cdecl;
procedure setSpeed(AHandle:pointer; ASpeed:integer); cdecl;
procedure prepareDeskZip(AHandle:pointer; AWidth,AHeight:integer); cdecl;
procedure executeDeskZip(AHandle:pointer; ALeft,ATop:integer); cdecl;
function getDeskFrame(AHandle:pointer):pointer; cdecl;
procedure deleteDeskFrame(AFrame:pointer); cdecl;

function createDeskUnZip:pointer; cdecl;
procedure releaseDeskUnZip(AHandle:pointer); cdecl;
procedure executeDeskUnZip(AHandle:pointer; ADeskFrame:PDeskFrame); cdecl;
function getWidth(AHandle:pointer):integer; cdecl;
function getHeight(AHandle:pointer):integer; cdecl;
function getBitmapBuffer(AHandle:pointer):pointer; cdecl;

/// DeskZip은 CELL_SIZE로 나눠떨어지는 Bitmap을 사용한다.
function ToCellSize(ASize:integer):integer;

var
  FrameStart : TFrameStart;
  FrameEnd : TFrameBase;

  NeedNext : TFrameBase;
  EndOfDeskZip : TFrameBase;

  AskDeskZip : TFrameBase;

implementation

function createDeskZip:pointer; cdecl; external 'DeskZip.dll' delayed;
procedure releaseDeskZip(AHandle:pointer); cdecl; external 'DeskZip.dll' delayed;
procedure setSpeed(AHandle:pointer; ASpeed:integer); cdecl; external 'DeskZip.dll' delayed;
procedure prepareDeskZip(AHandle:pointer; AWidth,AHeight:integer); cdecl; external 'DeskZip.dll' delayed;
procedure executeDeskZip(AHandle:pointer; ALeft,ATop:integer); cdecl; external 'DeskZip.dll' delayed;
function getDeskFrame(AHandle:pointer):pointer; cdecl; external 'DeskZip.dll' delayed;
procedure deleteDeskFrame(AFrame:pointer); cdecl; external 'DeskZip.dll' delayed;

function createDeskUnZip:pointer; cdecl; external 'DeskZip.dll' delayed;
procedure releaseDeskUnZip(AHandle:pointer); cdecl; external 'DeskZip.dll' delayed;
procedure executeDeskUnZip(AHandle:pointer; ADeskFrame:PDeskFrame); cdecl; external 'DeskZip.dll' delayed;
function getWidth(AHandle:pointer):integer; cdecl; external 'DeskZip.dll' delayed;
function getHeight(AHandle:pointer):integer; cdecl; external 'DeskZip.dll' delayed;
function getBitmapBuffer(AHandle:pointer):pointer; cdecl; external 'DeskZip.dll' delayed;

function ToCellSize(ASize:integer):integer;
begin
  Result := ASize;
  if (Result mod CELL_SIZE) <> 0 then Result := Result + (CELL_SIZE - (Result mod CELL_SIZE));
end;

{ TDeskFrame }

function TFrameCell.GetBufferSize: integer;
begin
  Result :=  Size - (SizeOf(size) + SizeOf(FrameType) + SizeOf(Key) + SizeOf(Index));
end;

{ TFrameStartPacket }

function TFrameStart.GetBitmapHeight: integer;
begin
  Result := ToCellSize(Height);
end;

function TFrameStart.GetBitmapWidth: integer;
begin
  Result := ToCellSize(Width);
end;

function TFrameStart.GetScreenSize: integer;
begin
  Result := (GetBitmapWidth div CELL_SIZE) * (GetBitmapHeight div CELL_SIZE);
end;

initialization
  FrameStart.Size := 11;
  FrameStart.FrameType := ftFrameStart;

  FrameEnd.Size := 3;
  FrameEnd.FrameType := ftFrameEnd;

  NeedNext.Size := 3;
  NeedNext.FrameType := ftNeedNext;

  EndOfDeskZip.Size := 3;
  EndOfDeskZip.FrameType := ftEndOfDeskZip;

  AskDeskZip.Size := 3;
  AskDeskZip.FrameType := ftAskDeskZip;
end.
