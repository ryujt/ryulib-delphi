unit Core;

interface

uses
  CoreBase, Audio, Video, ffmpeg,
  Generics.Collections,
  SysUtils, Classes;

type
  TCore = class (TComponent, ICoreInternal)
  private
    FAudio : TAudio;
    procedure onAudioData(Sender:TObject; AData:pointer; ASize:integer);
  private
    FVideo : TVideo;
    Fffmpeg : Tffmpeg;
    procedure set_RecordingStatus(AValue:boolean);
  private
    FListener : TList<TComponent>;
    function Get_ffmpeg: Iffmpeg;
    function GetAudio: IAudio;
    function GetVideo: IVideo;
  private // ICoreInternal
    procedure NotifyAll(ANotifyProcedure:TNotifyProcedure);
  public
    constructor Create;
    destructor Destroy; override;

    class function Obj:TCore;

    {*
       Termination processing of core objects is required when the application is terminating.
       You should run this method on MainForm.OnClose.
    *}
    procedure Terminate;

    procedure AddListener(AListener:TComponent);
    procedure RemoveListener(AListener:TComponent);

    procedure StartRecording;
    procedure StopRecording;
  public
    property Audio : IAudio read GetAudio;
    property Video : IVideo read GetVideo;
    property ffmpeg : Iffmpeg read Get_ffmpeg;
  end;

implementation

var
  MyObject : TCore = nil;

{ TCore }

class function TCore.Obj: TCore;
begin
  if MyObject = nil then MyObject := TCore.Create;
  Result := MyObject;
end;

procedure TCore.onAudioData(Sender: TObject; AData: pointer; ASize: integer);
begin
  Fffmpeg.WriteAudio(AData, ASize);
end;

procedure TCore.AddListener(AListener: TComponent);
begin
  FListener.Add(AListener);
end;

constructor TCore.Create;
begin
  inherited Create(nil);

  FListener := TList<TComponent>.Create;

  FAudio := TAudio.Create(Self);
  FAudio.OnData := onAudioData;

  FVideo := TVideo.Create(Self);
  Fffmpeg := Tffmpeg.Create(Self);
end;

destructor TCore.Destroy;
begin
  FreeAndNil(FListener);
  FreeAndNil(FAudio);
  FreeAndNil(FVideo);
  FreeAndNil(Fffmpeg);

  inherited;
end;

function TCore.GetAudio: IAudio;
begin
  Result := FAudio as IAudio;
end;

function TCore.GetVideo: IVideo;
begin
  Result := FVideo as IVideo;
end;

function TCore.Get_ffmpeg: Iffmpeg;
begin
  Result := Fffmpeg as Iffmpeg;
end;

procedure TCore.NotifyAll(ANotifyProcedure: TNotifyProcedure);
var
  i: Integer;
begin
  for i := 0 to FListener.Count-1 do ANotifyProcedure(FListener[i]);
end;

procedure TCore.RemoveListener(AListener: TComponent);
begin
  FListener.Remove(AListener);
end;

procedure TCore.set_RecordingStatus(AValue: boolean);
begin
  NotifyAll(
    procedure (AListener:TComponent)
    begin
      if Supports(AListener, IRecordingChanged) then (AListener as IRecordingChanged).onRecordingStatusChanged(AValue);
    end
  );
end;

procedure TCore.StartRecording;
begin
  try
    FAudio.Start;
    FVideo.Start;
    Fffmpeg.Start;
    set_RecordingStatus(true);
  except
    // TODO:
  end;
end;

procedure TCore.StopRecording;
begin
  try
    FAudio.Stop;
    FVideo.Stop;
    Fffmpeg.Stop;
  except
    // TODO:
  end;

  set_RecordingStatus(false);
end;

procedure TCore.Terminate;
begin
    FAudio.Terminate;
    FVideo.Terminate;
    Fffmpeg.Terminate;
end;

end.
