unit _fmMain;

interface

uses
  TokenReplace,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TfmMain = class(TForm)
    Memo1: TMemo;
    Memo2: TMemo;
    btExecute: TButton;
    Panel1: TPanel;
    Splitter1: TSplitter;
    procedure FormCreate(Sender: TObject);
    procedure btExecuteClick(Sender: TObject);
  private
    FTokenReplace : TTokenReplace;
  public
  end;

var
  fmMain: TfmMain;

implementation

{$R *.dfm}

procedure TfmMain.btExecuteClick(Sender: TObject);
begin
  FTokenReplace.Input := Memo1.Text;
  FTokenReplace.Replace('begin', '����');
  FTokenReplace.Replace('end', '��');
  FTokenReplace.Replace(':Time', '@�ð�');
  FTokenReplace.Replace(':TimeLimit', '@�ð�����');
  FTokenReplace.Execute;
  Memo2.Text := FTokenReplace.Output;
end;

procedure TfmMain.FormCreate(Sender: TObject);
begin
  FTokenReplace := TTokenReplace.Create(Self);
  FTokenReplace.WhiteSpace := '~!#$%^&*()_+`-={}|[]\";''<>?,./ '#13#10#0;
end;

end.

