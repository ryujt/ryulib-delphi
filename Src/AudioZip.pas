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
    FOnData: TDataEvent;
    FOnEror: TIntegerEvent;
    function GetVolume: single;
    procedure SetVolume(const Value: single);
  public
    constructor Create;
    destructor Destroy; override;

    procedure Start;
    procedure Stop;
  public
    property Volume : single read GetVolume write SetVolume;
    property OnData : TDataEvent read FOnData write FOnData;
    property OnEror : TIntegerEvent read FOnEror write FOnEror;
  end;

  TAudioUnZip = class
  private
    FHandle : pointer;
    FOnEror: TIntegerEvent;
    function GetAudioUnZipDelayCount: integer;
    function GetVolume: single;
    procedure SetVolume(const Value: single);
  public
    constructor Create;
    destructor Destroy; override;

    procedure Play(AData:pointer; ASize:integer);
    procedure Skip(ACount:integer);
  public
    property DelayCount : integer read GetAudioUnZipDelayCount;
    property Volume : single read GetVolume write SetVolume;
    property OnEror : TIntegerEvent read FOnEror write FOnEror;
  end;

procedure initAudioZip;
          cdecl; external 'AudioZip.dll' delayed;

function  createAudioZip(AContext:pointer; AOnData:TCallBackData; AOnError:TCallBackError):pointer;
          cdecl; external 'AudioZip.dll' delayed;

procedure startAudioZip(AHandle:pointer);
          cdecl; external 'AudioZip.dll' delayed;

procedure stopAudioZip(AHandle:pointer);
          cdecl; external 'AudioZip.dll' delayed;

function  getMicVolume(AHandle:pointer):Single;
          cdecl; external 'AudioZip.dll' delayed;

procedure  setMicVolume(AHandle:pointer; AVolume:Single);
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

procedure  setSpeakerVolume(AHandle:pointer; AVolume:Single);
          cdecl; external 'AudioZip.dll' delayed;

procedure releaseAudioUnZip(AHandle:pointer);
          cdecl; external 'AudioZip.dll' delayed;


implementation

{ TAudioZip }

procedure on_AudioZip_data(AContext:pointer; AData:pointer; ASize:integer); cdecl;
var
  AudioZip : TAudioZip absolute AContext;
begin
  if Assigned(AudioZip.FOnData) then AudioZip.FOnData(AContext, AData, ASize);
end;

procedure on_AudioZip_error(AContext:pointer; ACode:integer); cdecl;
var
  AudioZip : TAudioZip absolute AContext;
begin
  if Assigned(AudioZip.FOnEror) then AudioZip.FOnEror(AContext, ACode);
end;

constructor TAudioZip.Create;
begin
  FHandle := createAudioZip(Self, on_AudioZip_data, on_AudioZip_error);
end;

destructor TAudioZip.Destroy;
begin
  Stop;

  releaseAudioZip(FHandle);

  inherited;
end;

function TAudioZip.GetVolume: single;
begin
  Result := getMicVolume(FHandle);
end;

procedure TAudioZip.SetVolume(const Value: single);
begin
  setMicVolume(FHandle, Value);
end;

procedure TAudioZip.Start;
begin
  startAudioZip(FHandle);
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
