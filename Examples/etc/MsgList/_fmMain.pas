unit _fmMain;

interface

uses
  MsgList,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls;

type
  TfmMain = class(TForm)
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    Panel2: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    FMsgList : TMsgList;
  public
  end;

var
  fmMain: TfmMain;

implementation

{$R *.dfm}

procedure TfmMain.Button1Click(Sender: TObject);
begin
  FMsgList.Add('TestjY sdafasd sadfasd ���ƾƾƾƾƾƾ� �����ٶ󸶹ٻ������īŸ sdfs - ' + IntToStr(Tag));
  Tag := Tag + 1;
end;

procedure TfmMain.FormCreate(Sender: TObject);
begin
  FMsgList := TMsgList.Create(Self);
  FMsgList.Parent := Panel1;
  FMsgList.Align := alClient;
end;

end.
