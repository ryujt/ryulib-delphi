unit _fmMain;

interface

uses
  Disk, WebServerUnit,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Samples.Spin;

type
  TfmMain = class(TForm)
    Panel1: TPanel;
    SpinEdit: TSpinEdit;
    btStart: TButton;
    Button2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btStartClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FWebServerModule : TWebServerModule;
  public
    procedure Start;
    procedure Stop;
  end;

var
  fmMain: TfmMain;

implementation

{$R *.dfm}

procedure TfmMain.btStartClick(Sender: TObject);
begin
  if SpinEdit.Enabled then Start
  else Stop;
end;

procedure TfmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  StopWebServer;
end;

procedure TfmMain.FormCreate(Sender: TObject);
begin
  Start;
end;

procedure TfmMain.Start;
begin
  btStart.Caption := 'Stop';
  SpinEdit.Enabled := false;

  try
    StartWebServer(SpinEdit.Value);
    ShellExecuteFile(Format('http://127.0.0.1:%d/', [SpinEdit.Value]), '', '');
  except
    Stop;
    MessageDlg('포트가 이미 사용중입니다. 다른 포트를 사용하세요.', mtError, [mbOK], 0)
  end;
end;

procedure TfmMain.Stop;
begin
  StopWebServer;

  btStart.Caption := 'Start';
  SpinEdit.Enabled := true;
end;

end.
