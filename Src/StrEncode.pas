unit StrEncode;

interface

uses
  Classes, SysUtils;

/// ChangeCharset('euc-kr', 'utf-8', AText)
function ChangeCharset(const csFrom,csTo,AText:AnsiString):string;

implementation

function change_charset(szSrcCharset,szDstCharset:PAnsiChar; szSrc:PAnsiChar; SrcLength:integer; szDst:PAnsiChar; DstLength:integer):boolean;
          cdecl; external 'StrEncode.dll' delayed;

function ChangeCharset(const csFrom,csTo,AText:AnsiString):string;
var
  buffer : PAnsiChar;
  buffer_size : integer;
begin
  Result := '';

  // 충분한 여유 공간 확보
  buffer_size := Length(AText) * 4;
  GetMem(buffer, buffer_size);

  if change_charset(PAnsiChar(csFrom), PAnsiChar(csTo), PAnsiChar(AText), Length(AText), buffer, buffer_size) then Result := AnsiString(buffer);
end;

end.

