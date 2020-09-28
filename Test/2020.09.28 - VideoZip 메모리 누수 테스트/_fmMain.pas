unit _fmMain;

interface

uses
  DebugTools, VideoZip, Scheduler,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

const
  CAM_WIDTH  = 320;
  CAM_HEIGHT = 240;
  PACKET_SIZE = 1024 * 32;

type
  TForm1 = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FVideoZip : TVideoZip;
    procedure on_VideoZip_repeat(Sender:TObject);
  private
    FScheduler : TScheduler;
  public
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
  FVideoZip.Open(0, CAM_WIDTH, CAM_HEIGHT);
  FScheduler.Start;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FVideoZip := TVideoZip.Create;

  FScheduler := TScheduler.Create('');
  FScheduler.OnRepeat := on_VideoZip_repeat;
end;

procedure TForm1.on_VideoZip_repeat(Sender: TObject);
begin
  FVideoZip.Capture;
  FVideoZip.Execute;
  if FVideoZip.Size > 0 then begin
    {$IFDEF DEBUG}
    if FVideoZip.Size > PACKET_SIZE then Trace( Format('FVideoZip.Size > PACKET_SIZE - Size: %d', [FVideoZip.Size]) );
    {$ENDIF}

//    send_VideoPacket(FVideoZip.Data, FVideoZip.Size);
  end;

  FScheduler.Sleep(20);
end;

end.
