unit AudioSender;

interface

uses
  AudioZip, UDPSocket,
  SysUtils, Classes;

type
  TAudioSender = class
  private
    FSocket : TUDPSocket;
    procedure onAuidoZipData(Sender:TObject; AData:pointer; ASize:integer);
  private
    FAudioZip : TAudioZip;
    function GetMicMuted: boolean;
    function GetMicVolume: single;
    function GetSystemAudioVolume: single;
    function GetSystemAudioMuted: boolean;
    procedure SetMicMuted(const Value: boolean);
    procedure SetMicVolume(const Value: single);
    procedure SetSystemAudioVolume(const Value: single);
    procedure SetSystemAudioMuted(const Value: boolean);
  public
    constructor Create;
    destructor Destroy; override;

    class function Obj:TAudioSender;

    procedure start(ADeviceID:integer; AUseSystemAudio:boolean);
    procedure stop;
  public
    property MicMuted : boolean read GetMicMuted write SetMicMuted;
    property SystemAudioMuted : boolean read GetSystemAudioMuted write SetSystemAudioMuted;
    property MicVolume : single read GetMicVolume write SetMicVolume;
    property SystemAudioVolume : single read GetSystemAudioVolume write SetSystemAudioVolume;
  end;

implementation

{ TAudioSender }

var
  MyObject : TAudioSender = nil;

class function TAudioSender.Obj: TAudioSender;
begin
  if MyObject = nil then MyObject := TAudioSender.Create;
  Result := MyObject;
end;

procedure TAudioSender.onAuidoZipData(Sender: TObject; AData: pointer;
  ASize: integer);
begin
  // TODO: Actual IP allocation is required.
  FSocket.SendTo('127.0.0.1', 1234, AData, ASize);
end;

procedure TAudioSender.SetMicMuted(const Value: boolean);
begin
  FAudioZip.MicMuted := Value;
end;

procedure TAudioSender.SetMicVolume(const Value: single);
begin
  FAudioZip.MicVolume := Value;
end;


procedure TAudioSender.SetSystemAudioMuted(const Value: boolean);
begin
  FAudioZip.SystemAudioMuted := Value;
end;

procedure TAudioSender.SetSystemAudioVolume(const Value: single);
begin
  FAudioZip.SystemAudioVolume := Value;
end;

procedure TAudioSender.start(ADeviceID:integer; AUseSystemAudio:boolean);
begin
  FAudioZip.Start(ADeviceID, AUseSystemAudio);
end;

procedure TAudioSender.stop;
begin
  FAudioZip.Stop;
end;

constructor TAudioSender.Create;
begin
  inherited;

  FSocket := TUDPSocket.Create(nil);
  FSocket.Start(false);

  FAudioZip := TAudioZip.Create;
  FAudioZip.OnEncode := onAuidoZipData;
end;

destructor TAudioSender.Destroy;
begin
  FAudioZip.Stop;

  FreeAndNil(FAudioZip);
  FreeAndNil(FSocket);

  inherited;
end;

function TAudioSender.GetMicMuted: boolean;
begin
  Result := FAudioZip.MicMuted;
end;

function TAudioSender.GetMicVolume: single;
begin
  Result := FAudioZip.MicVolume;
end;

function TAudioSender.GetSystemAudioMuted: boolean;
begin
  Result := FAudioZip.SystemAudioMuted;
end;

function TAudioSender.GetSystemAudioVolume: single;
begin
  Result := FAudioZip.SystemAudioVolume;
end;

initialization
  MyObject := TAudioSender.Create;
end.