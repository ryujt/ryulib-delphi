unit _fmMain;

interface

uses
  AudioZip,
  DebugTools,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TfmMain = class(TForm)
    btCreate: TButton;
    btStart: TButton;
    btRelease: TButton;
    btStop: TButton;
    procedure btCreateClick(Sender: TObject);
    procedure btStartClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btReleaseClick(Sender: TObject);
    procedure btStopClick(Sender: TObject);
  private
  public
  end;

var
  fmMain: TfmMain;
  HandleZip : pointer;
  HandleUnZip : pointer;

implementation

{$R *.dfm}

procedure on_data(AContext:pointer; AData:pointer; ASize:integer); cdecl;
begin
  Trace( Format('on_data: %d', [ASize]) );
  playAudio(HandleUnZip, AData, ASize);
end;

procedure on_error(AContext:pointer; ACode:integer); cdecl;
begin
  Trace( Format('on_error: %d', [ACode]) );
end;

procedure TfmMain.btCreateClick(Sender: TObject);
begin
  HandleZip := createAudioZip(Self, on_data, on_error);
  HandleUnZip := createAudioUnZip(Self, on_error);
end;

procedure TfmMain.btReleaseClick(Sender: TObject);
begin
  releaseAudioZip(HandleZip);
  releaseAudioUnZip(HandleUnZip);
end;

procedure TfmMain.btStartClick(Sender: TObject);
begin
  startAudioZip(HandleZip);
end;

procedure TfmMain.btStopClick(Sender: TObject);
begin
  stopAudioZip(HandleZip);
end;

procedure TfmMain.FormCreate(Sender: TObject);
begin
  initAudioZip;
end;

end.
