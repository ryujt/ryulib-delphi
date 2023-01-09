unit _fmMain;

interface

uses
  FastStrings, Strg,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TfmMain = class(TForm)
    moMsg: TMemo;
    btReplace: TButton;
    Panel1: TPanel;
    Splitter1: TSplitter;
    moResult: TMemo;
    procedure btReplaceClick(Sender: TObject);
  private
  public
  end;

var
  fmMain: TfmMain;

implementation

uses
  CompareBytes;

function StrReplace(Org,Src,Dst:string):string;
var
  iOrgIndex, iOrgLength, iResultIndex, iResultLength, iSrcSize, iDstSize, iResultSize : integer;
begin
  iOrgLength := Length(Org);

  // �˳��� �޸� ���� Ȯ��
  iResultSize := iOrgLength;
  iResultLength := iResultSize + 1024*10;
  SetLength(Result, iResultLength);

  iSrcSize := Length(Src);
  iDstSize := Length(Dst);

  iOrgIndex := 1;
  iResultIndex := 1;
  while iOrgIndex <= (iOrgLength-iSrcSize+1) do begin
    if CompareFastBytes(@Org[iOrgIndex], @Src[1], iSrcSize) then begin
      Move(Dst[1], Result[iResultIndex], iDstSize);
      Inc(iResultIndex, iDstSize);
      Inc(iOrgIndex, iSrcSize);
      Inc(iResultSize, iDstSize - iSrcSize);

      // ġȯ ���� ���ڿ� ���̰� iResultLength ���� Ŀ���� ��
      if iResultSize >= (iResultLength-iDstSize) then begin
        iResultLength := iResultLength + 1024*10;
        SetLength(Result, iResultLength);
      end;
    end else begin
      Result[iResultIndex] := Org[iOrgIndex];
      Inc(iResultIndex);
      Inc(iOrgIndex);
    end;
  end;

  // �ߺ��ڵ尡 ������, �Լ� ȣ�� � ���� �ӵ��� �����ϱ� ���� ��ġ�ߴ�.
  // if ���� ���� �ɷ����� �͵� ����������.
  while iOrgIndex <= iOrgLength do begin
      Result[iResultIndex] := Org[iOrgIndex];
      Inc(iResultIndex);
      Inc(iOrgIndex);
  end;

  SetLength(Result, iResultSize);
end;

{$R *.dfm}

procedure TfmMain.btReplaceClick(Sender: TObject);
var
  Text, Src, Dst : string;
  Loop: Integer;
  Tick : Cardinal;
begin
  Src := '<';
  Dst := '****';

  Tick := GetTickCount;
  for Loop := 1 to 100 do begin
    Text := moMsg.Text;
    Text := FastReplace(Text, Src, Dst, true);
  end;
  moResult.Lines.Add(Format('FastReplace: %d', [GetTickCount-Tick]));

  Tick := GetTickCount;
  for Loop := 1 to 100 do begin
    Text := moMsg.Text;
    Text := StrReplace(Text, Src, Dst);
  end;
  moResult.Lines.Add(Format('StrReplace: %d', [GetTickCount-Tick]));

  Tick := GetTickCount;
  for Loop := 1 to 100 do begin
    Text := moMsg.Text;
    Text := StringReplace(Text, Src, Dst, [rfReplaceAll]);
  end;
  moResult.Lines.Add(Format('StringReplace: %d', [GetTickCount-Tick]));

  moMsg.Text := Text;
end;

end.
