unit AudioZip;

interface

uses
  RyuLibBase,
  Classes, SysUtils;

type
  TCallBackData = procedure (AContext:pointer; AData:pointer; ASize:integer); cdecl;
  TCallBackError = procedure (AContext:pointer; ACode:integer); cdecl;

  TAudioZip = class
  private
    FHandle : pointer;
    FOnSouce: TDataEvent;
    FOnEncode: TDataEvent;
    FOnEror: TIntegerEvent;
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
      Start capturing and compressing audio data.
      @param ADeviceID ID of the audio device to capture (-1 is the default device)
      @param AUseSystemAudio Decide whether to capture system audio.
    *}
    function Start(ADeviceID:integer; AUseSystemAudio:boolean=false):boolean;

    {*
      Stop capturing and compressing audio data.
    *}
    procedure Stop;
  public
    property MicMuted : boolean read GetMicMuted write SetMicMuted;
    property SystemAudioMuted : boolean read GetSystemAudioMuted write SetSystemAudioMuted;
    property MicVolume : single read Get_MicVolume write Set_MicVolume;
    property SystemAudioVolume : single read GetSystemAudioVolume write SetSystemAudioVolume;
    property OnSouce : TDataEvent read FOnSouce write FOnSouce;
    property OnEncode : TDataEvent read FOnEncode write FOnEncode;
    property OnEror : TIntegerEvent read FOnEror write FOnEror;
  end;

  TAudioUnZip = class
  private
    FHandle : pointer;
    FOnEror: TIntegerEvent;
    FMuted: boolean;
    function GetAudioUnZipDelayCount: integer;
    function GetVolume: single;
    procedure SetVolume(const Value: single);
  public
    constructor Create;
    destructor Destroy; override;

    {*
      Decompresse auido data and paly it.
      @parm AData Address of compressed audio data.
      @param ASize Size of the compressed audio data.
    *}
    procedure Play(AData:pointer; ASize:integer);

    {*
      Drop audio packets at the front of the buffer by a given number.
      This method will remove delays caused by voice transmission and reception.
      @param ACount Number of audio data to skip
    *}
    procedure Skip(ACount:integer);
  public
    property DelayCount : integer read GetAudioUnZipDelayCount;
    property Muted : boolean read FMuted write FMuted;
    property Volume : single read GetVolume write SetVolume;
    property OnEror : TIntegerEvent read FOnEror write FOnEror;
  end;

implementation

procedure initAudioZip;
          cdecl; external 'AudioZip.dll' delayed;

function  createAudioZip(AContext:pointer; AOnSouce:TCallBackData; AOnEncode:TCallBackData; AOnError:TCallBackError):pointer;
          cdecl; external 'AudioZip.dll' delayed;

function startAudioZip(AHandle:pointer; ADeviceID:integer; AUseSystemAudio:boolean):boolean;
          cdecl; external 'AudioZip.dll' delayed;

procedure stopAudioZip(AHandle:pointer);
          cdecl; external 'AudioZip.dll' delayed;

function  isMicMuted(AHandle:pointer):boolean;
          cdecl; external 'AudioZip.dll' delayed;

function  isSystemMuted(AHandle:pointer):boolean;
          cdecl; external 'AudioZip.dll' delayed;

function  getMicVolume(AHandle:pointer):Single;
          cdecl; external 'AudioZip.dll' delayed;

function  getSystemVolume(AHandle:pointer):Single;
          cdecl; external 'AudioZip.dll' delayed;

procedure setMicMute(AHandle:pointer; AValue:boolean);
          cdecl; external 'AudioZip.dll' delayed;

procedure setSystemMute(AHandle:pointer; AValue:boolean);
          cdecl; external 'AudioZip.dll' delayed;

procedure setMicVolume(AHandle:pointer; AVolume:Single);
          cdecl; external 'AudioZip.dll' delayed;

procedure setSystemVolume(AHandle:pointer; AVolume:Single);
          cdecl; external 'AudioZip.dll' delayed;

procedure releaseAudioZip(AHandle:pointer);
          cdecl; external 'AudioZip.dll' delayed;

function  createAudioUnZip(AContext:pointer; AOnError:TCallBackError):pointer;
          cdecl; external 'AudioZip.dll' delayed;

procedure playAudio(AHandle:pointer; AData:pointer; ASize:integer);
          cdecl; external 'AudioZip.dll' delayed;

procedure skipAudio(AHandle:pointer; Count:integer);
          cdecl; external 'AudioZip.dll' delayed;

function  getDelayCount(AHandle:pointer):integer;
          cdecl; external 'AudioZip.dll' delayed;

function  getSpeakerVolume(AHandle:pointer):Single;
          cdecl; external 'AudioZip.dll' delayed;

procedure setSpeakerVolume(AHandle:pointer; AVolume:Single);
          cdecl; external 'AudioZip.dll' delayed;

procedure releaseAudioUnZip(AHandle:pointer);
          cdecl; external 'AudioZip.dll' delayed;

{ TAudioZip }

procedure on_AudioZip_source(AContext:pointer; AData:pointer; ASize:integer); cdecl;
var
  AudioZip : TAudioZip absolute AContext;
begin
  if Assigned(AudioZip.FOnSouce) then AudioZip.FOnSouce(AContext, AData, ASize);
end;

procedure on_AudioZip_encode(AContext:pointer; AData:pointer; ASize:integer); cdecl;
var
  AudioZip : TAudioZip absolute AContext;
begin
  if Assigned(AudioZip.FOnEncode) then AudioZip.FOnEncode(AContext, AData, ASize);
end;

procedure on_AudioZip_error(AContext:pointer; ACode:integer); cdecl;
var
  AudioZip : TAudioZip absolute AContext;
begin
  if Assigned(AudioZip.FOnEror) then AudioZip.FOnEror(AContext, ACode);
end;

constructor TAudioZip.Create;
begin
  FHandle := createAudioZip(Self, on_AudioZip_source, on_AudioZip_encode, on_AudioZip_error);
end;

destructor TAudioZip.Destroy;
begin
  Stop;

  releaseAudioZip(FHandle);

  inherited;
end;

function TAudioZip.GetMicMuted: boolean;
begin
  Result := isMicMuted(FHandle);
end;

function TAudioZip.GetSystemAudioMuted: boolean;
begin
  Result := isSystemMuted(FHandle);
end;

function TAudioZip.Get_MicVolume: single;
begin
  Result := getMicVolume(FHandle);
end;

function TAudioZip.GetSystemAudioVolume: single;
begin
  Result := getSystemVolume(FHandle);
end;

procedure TAudioZip.SetMicMuted(const Value: boolean);
begin
  setMicMute(FHandle, Value);
end;

procedure TAudioZip.SetSystemAudioMuted(const Value: boolean);
begin
  setSystemMute(FHandle, Value);
end;

procedure TAudioZip.Set_MicVolume(const Value: single);
begin
  setMicVolume(FHandle, Value);
end;

procedure TAudioZip.SetSystemAudioVolume(const Value: single);
begin
  setSystemVolume(FHandle, Value);
end;

function TAudioZip.Start(ADeviceID:integer; AUseSystemAudio:boolean=false):boolean;
begin
  Result := startAudioZip(FHandle, ADeviceID, AUseSystemAudio);
end;

procedure TAudioZip.Stop;
begin
  stopAudioZip(FHandle);
end;

{ TAudioUnZip }

procedure on_AudioUnZip_error(AContext:pointer; ACode:integer); cdecl;
var
  AudioZip : TAudioZip absolute AContext;
begin
  if Assigned(AudioZip.FOnEror) then AudioZip.FOnEror(AContext, ACode);
end;

constructor TAudioUnZip.Create;
begin
  FMuted := false;
  FHandle := createAudioUnZip(Self, on_AudioUnZip_error);
end;

destructor TAudioUnZip.Destroy;
begin
  releaseAudioUnZip(FHandle);

  inherited;
end;

function TAudioUnZip.GetAudioUnZipDelayCount: integer;
begin
  Result := getDelayCount(FHandle)
end;

function TAudioUnZip.GetVolume: single;
begin
  Result := getSpeakerVolume(FHandle)
end;

procedure TAudioUnZip.Play(AData: pointer; ASize: integer);
begin
  playAudio(FHandle, AData, ASize);
end;

procedure TAudioUnZip.SetVolume(const Value: single);
begin
  setSpeakerVolume(FHandle, Value);
end;

procedure TAudioUnZip.Skip(ACount: integer);
begin
  skipAudio(FHandle, ACount);
end;

initialization
  initAudioZip;
end.
