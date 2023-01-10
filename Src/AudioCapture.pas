unit AudioCapture;

interface

uses
  RyuLibBase,
  Classes, SysUtils;

type
  TCallBackData = procedure (AContext:pointer; AData:pointer; ASize:integer); cdecl;
  TCallBackError = procedure (AContext:pointer; ACode:integer); cdecl;

  TAudioCapture = class
  private
    FHandle : pointer;
    FOnData: TDataEvent;
    FOnError: TIntegerEvent;
    function Get_MicVolume: single;
    procedure Set_MicVolume(const Value: single);
    function GetSystemAudioVolume: single;
    procedure SetSystemAudioVolume(const Value: single);
    function GetMicMuted: boolean;
    function GetSystemAudioMuted: boolean;
    procedure SetMicMuted(const Value: boolean);
    procedure SetSystemAudioMuted(const Value: boolean);
  public
    constructor Create;
    destructor Destroy; override;

    {*
      Start capturing audio data.
      @param ADeviceID ID of the audio device to capture (-1 is the default device)
      @param AUseSystemAudio Decide whether to capture system audio.
    *}
    function Start(ADeviceID:integer; AUseSystemAudio:boolean=false):boolean;

    {*
      Stop capturing audio data.
    *}
    procedure Stop;
  public
    property MicMuted : boolean read GetMicMuted write SetMicMuted;
    property SystemAudioMuted : boolean read GetSystemAudioMuted write SetSystemAudioMuted;
    property MicVolume : single read Get_MicVolume write Set_MicVolume;
    property SystemAudioVolume : single read GetSystemAudioVolume write SetSystemAudioVolume;
    property OnData : TDataEvent read FOnData write FOnData;
    property OnEror : TIntegerEvent read FOnError write FOnError;
  end;

implementation

procedure initAudioCapture;
          cdecl; external 'AudioCapture.dll' delayed;

function  createAudioCapture(AContext:pointer; AOnData:TCallBackData; AOnError:TCallBackError):pointer;
          cdecl; external 'AudioCapture.dll' delayed;

function startAudioCapture(AHandle:pointer; ADeviceID:integer; AUseSystemAudio:boolean):boolean;
          cdecl; external 'AudioCapture.dll' delayed;

procedure stopAudioCapture(AHandle:pointer);
          cdecl; external 'AudioCapture.dll' delayed;

function  isMicMuted(AHandle:pointer):boolean;
          cdecl; external 'AudioCapture.dll' delayed;

function  isSystemMuted(AHandle:pointer):boolean;
          cdecl; external 'AudioCapture.dll' delayed;

function  getMicVolume(AHandle:pointer):Single;
          cdecl; external 'AudioCapture.dll' delayed;

function  getSystemVolume(AHandle:pointer):Single;
          cdecl; external 'AudioCapture.dll' delayed;

procedure setMicMute(AHandle:pointer; AValue:boolean);
          cdecl; external 'AudioCapture.dll' delayed;

procedure setSystemMute(AHandle:pointer; AValue:boolean);
          cdecl; external 'AudioCapture.dll' delayed;

procedure setMicVolume(AHandle:pointer; AVolume:Single);
          cdecl; external 'AudioCapture.dll' delayed;

procedure setSystemVolume(AHandle:pointer; AVolume:Single);
          cdecl; external 'AudioCapture.dll' delayed;

procedure releaseAudioCapture(AHandle:pointer);
          cdecl; external 'AudioCapture.dll' delayed;

{ TAudioCapture }

procedure on_AudioCapture_data(AContext:pointer; AData:pointer; ASize:integer); cdecl;
var
  audioCapture : TAudioCapture absolute AContext;
begin
  if Assigned(audioCapture.FOnData) then audioCapture.FOnData(AContext, AData, ASize);
end;

procedure on_AudioZip_error(AContext:pointer; ACode:integer); cdecl;
var
  audioCapture : TAudioCapture absolute AContext;
begin
  if Assigned(audioCapture.FOnError) then audioCapture.FOnError(AContext, ACode);
end;

constructor TAudioCapture.Create;
begin
  FHandle := createAudioCapture(Self, on_AudioCapture_data, on_AudioZip_error);
end;

destructor TAudioCapture.Destroy;
begin
  Stop;

  releaseAudioCapture(FHandle);

  inherited;
end;

function TAudioCapture.GetMicMuted: boolean;
begin
  Result := isMicMuted(FHandle);
end;

function TAudioCapture.GetSystemAudioMuted: boolean;
begin
  Result := isSystemMuted(FHandle);
end;

function TAudioCapture.Get_MicVolume: single;
begin
  Result := getMicVolume(FHandle);
end;

function TAudioCapture.GetSystemAudioVolume: single;
begin
  Result := getSystemVolume(FHandle);
end;

procedure TAudioCapture.SetMicMuted(const Value: boolean);
begin
  setMicMute(FHandle, Value);
end;

procedure TAudioCapture.SetSystemAudioMuted(const Value: boolean);
begin
  setSystemMute(FHandle, Value);
end;

procedure TAudioCapture.Set_MicVolume(const Value: single);
begin
  setMicVolume(FHandle, Value);
end;

procedure TAudioCapture.SetSystemAudioVolume(const Value: single);
begin
  setSystemVolume(FHandle, Value);
end;

function TAudioCapture.Start(ADeviceID:integer; AUseSystemAudio:boolean=false):boolean;
begin
  Result := startAudioCapture(FHandle, ADeviceID, AUseSystemAudio);
end;

procedure TAudioCapture.Stop;
begin
  stopAudioCapture(FHandle);
end;

initialization
  initAudioCapture;
end.
