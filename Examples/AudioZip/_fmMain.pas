unit _fmMain;

interface

uses
  AudioZip,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TfmMain = class(TForm)
    moMsg: TMemo;
    Panel1: TPanel;
    btStart: TButton;
    btStop: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btStartClick(Sender: TObject);
    procedure btStopClick(Sender: TObject);
  private
    FAudioZip : TAudioZip;
    procedure on_data(Sender:TObject; AData:pointer; ASize:integer);
    procedure on_FAudioZip_error(Sender:TObject; AValue:Integer);
  private
    FAudioUnZip : TAudioUnZip;
    procedure on_FAudioUnZip_error(Sender:TObject; AValue:Integer);
  public
  end;

var
  fmMain: TfmMain;

implementation

{$R *.dfm}

procedure TfmMain.btStartClick(Sender: TObject);
begin
  moMsg.Lines.Add('AudioZip Start');
  FAudioZip.Start(-1);
end;

procedure TfmMain.btStopClick(Sender: TObject);
begin
  FAudioZip.Stop;
  moMsg.Lines.Add('AudioZip Stop');

  Caption := 'Exapmle of AudioZip';
end;

procedure TfmMain.FormCreate(Sender: TObject);
begin
  FAudioZip := TAudioZip.Create;
  FAudioZip.OnData := on_data;
  FAudioZip.OnEror := on_FAudioZip_error;

  FAudioUnZip := TAudioUnZip.Create;
  FAudioUnZip.OnEror := on_FAudioUnZip_error;
end;

procedure TfmMain.on_data(Sender: TObject; AData: pointer; ASize: integer);
begin
  FAudioUnZip.Play(AData, ASize);
  Caption := Format('AudioZip Size: %d, AudioUnZip Delay: %d', [ASize, FAudioUnZip.DelayCount]);
end;

procedure TfmMain.on_FAudioUnZip_error(Sender: TObject; AValue: Integer);
begin
  moMsg.Lines.Add( Format('AudioUnZip Error: %d', [AValue]) );
end;

procedure TfmMain.on_FAudioZip_error(Sender: TObject; AValue: Integer);
begin
  moMsg.Lines.Add( Format('AudioZip Error: %d', [AValue]) );
end;

end.
