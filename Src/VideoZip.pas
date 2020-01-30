unit VideoZip;

interface

uses
  Classes, SysUtils, Graphics;

function  getCameraCount:integer;
          cdecl; external 'VideoZip.dll';

function  getCameraName(AIndex:integer):PAnsiChar;
          cdecl; external 'VideoZip.dll';

function  getCameraNameString(AIndex:integer):string;

function  createVideoZip:pointer;
          cdecl; external 'VideoZip.dll';

procedure releaseVideoZip(AHandle:pointer);
          cdecl; external 'VideoZip.dll';

function openVideopZip(AHandle:pointer; AWidth,AHeight:integer):boolean;
          cdecl; external 'VideoZip.dll';

procedure closeVideopZip(AHandle:pointer);
          cdecl; external 'VideoZip.dll';

procedure encode(AHandle:pointer);
          cdecl; external 'VideoZip.dll';

function getData(AHandle:pointer):pointer;
          cdecl; external 'VideoZip.dll';

function getSize(AHandle:pointer):integer;
          cdecl; external 'VideoZip.dll';

function  createVideoUnZip:pointer;
          cdecl; external 'VideoZip.dll';

procedure releaseVideoUnZip(AHandle:pointer);
          cdecl; external 'VideoZip.dll';

procedure openVideopUnZip(AHandle:pointer; AWidth,AHeight:integer);
          cdecl; external 'VideoZip.dll';

procedure refresh(AHandle:pointer);
          cdecl; external 'VideoZip.dll';

procedure decode(AHandle:pointer; AData:pointer; ASize:integer);
          cdecl; external 'VideoZip.dll';

function getBitmap(AHandle:pointer):pointer;
          cdecl; external 'VideoZip.dll';

procedure SaveToBitmap(AHandle:pointer; ABitmap:TBitmap);

implementation

function getCameraNameString(AIndex:integer):string;
begin
  Result := StrPas( getCameraName(AIndex) );
end;

procedure SaveToBitmap(AHandle:pointer; ABitmap:TBitmap);
begin
  Move(getBitmap(AHandle)^, ABitmap.ScanLine[ABitmap.Height-1]^, ABitmap.Width * ABitmap.Height * 4);
end;

end.
