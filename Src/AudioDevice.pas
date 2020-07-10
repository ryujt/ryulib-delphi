unit AudioDevice;

interface

uses
  Classes, SysUtils;

procedure LoadAudioDeviceList;
function GetAudioDeviceCount:integer;
function GetAudioDeviceName(index:integer):string;
function GetAudioDeviceInputChannels(index:integer):integer;
function GetAudioDeviceOutputChannels(index:integer):integer;

implementation

var
  List : TStringList;

function initAudioDevice:integer;
          cdecl; external 'AudioDevice.dll' delayed;

function getDeviceCount:integer;
          cdecl; external 'AudioDevice.dll' delayed;

procedure getDeviceName(AIndex:integer; AName:PAnsiChar; ASize:integer);
          cdecl; external 'AudioDevice.dll' delayed;

function getInputChannels(AIndex:integer):integer;
          cdecl; external 'AudioDevice.dll' delayed;

function getOutputChannels(AIndex:integer):integer;
          cdecl; external 'AudioDevice.dll' delayed;

procedure LoadAudioDeviceList;
begin
  initAudioDevice;
end;

function GetAudioDeviceCount:integer;
begin
  Result := getDeviceCount;
end;

function GetAudioDeviceName(index:integer):string;
var
  text : PAnsiChar;
  buffer : array [0..1024] of byte;
begin
  text := @Buffer;
  getDeviceName(index, text, SizeOf(buffer));
  Result := StrPas(text);
end;

function GetAudioDeviceInputChannels(index:integer):integer;
begin
  Result := getInputChannels(index);
end;

function GetAudioDeviceOutputChannels(index:integer):integer;
begin
  Result := getOutputChannels(index);
end;

initialization
  List := TStringList.Create;
end.
