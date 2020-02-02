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
  public
    constructor Create;
    destructor Destroy; override;

    procedure Start;
    procedure Stop;
  public
    property OnData : TDataEvent read FOnData write FOnData;
    property OnEror : TIntegerEvent read FOnEror write FOnEror;
  end;

  TAudioUnZip = class
  private
    FHandle : pointer;
    FOnEror: TIntegerEvent;
    function GetAudioUnZipDelayCount: integer;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Play(AData:pointer; ASize:integer);
    procedure Skip(ACount:integer);
  public
    property DelayCount : integer read GetAudioUnZipDelayCount;
    property OnEror : TIntegerEvent read FOnEror write FOnEror;
  end;

procedure initAudioZip;
          cdecl; external 'AudioZip.dll';

function  createAudioZip(AContext:pointer; AOnData:TCallBackData; AOnError:TCallBackError):pointer;
          cdecl; external 'AudioZip.dll';

procedure startAudioZip(AHandle:pointer);
          cdecl; external 'AudioZip.dll';

procedure stopAudioZip(AHandle:pointer);
          cdecl; external 'AudioZip.dll';

procedure releaseAudioZip(AHandle:pointer);
          cdecl; external 'AudioZip.dll';

function  createAudioUnZip(AContext:pointer; AOnError:TCallBackError):pointer;
          cdecl; external 'AudioZip.dll';

procedure playAudio(AHandle:pointer; AData:pointer; ASize:integer);
          cdecl; external 'AudioZip.dll';

procedure skipAudio(AHandle:pointer; Count:integer);
          cdecl; external 'AudioZip.dll';

function  getDelayCount(AHandle:pointer):integer;
          cdecl; external 'AudioZip.dll';

procedure releaseAudioUnZip(AHandle:pointer);
          cdecl; external 'AudioZip.dll';

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

procedure TAudioUnZip.Play(AData: pointer; ASize: integer);
begin
  playAudio(FHandle, AData, ASize);
end;

procedure TAudioUnZip.Skip(ACount: integer);
begin
  skipAudio(FHandle, ACount);
end;

initialization
  initAudioZip;
end.
