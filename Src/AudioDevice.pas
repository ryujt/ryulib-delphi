unit AudioDevice;

interface

uses
  Generics.Collections,
  Classes, SysUtils;

type
  TAudioDevice = class
  private
    FNo: integer;
    FName : string;
    FInputChannels: integer;
    FOutputChannels : integer;
  public
    constructor Create(ANo:integer; AName:string; AInputChannels,AOutputChannels:integer); reintroduce;

    property No : integer read FNo;
    property Name : string read FName;
    property InputChannels : integer read FInputChannels;
    property OutputChannels : integer read FOutputChannels;
  end;

  TAudioDeviceList = class
  private
    FDeviceList : TList<TAudioDevice>;
    FInputDeviceList : TList<TAudioDevice>;
    FOutputDeviceList : TList<TAudioDevice>;
    function GetCount: integer;
    function GetInputCount: integer;
    function GetOutputCount: integer;
    function GetDevices(index: integer): TAudioDevice;
    function GetInputDevices(index: integer): TAudioDevice;
    function GetOutputDevices(index: integer): TAudioDevice;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Refresh;

    property Count : integer read GetCount;
    property InputCount : integer read GetInputCount;
    property OutputCount : integer read GetOutputCount;

    property Devices[index:integer] : TAudioDevice read GetDevices;
    property InputDevices[index:integer] : TAudioDevice read GetInputDevices;
    property OutputDevices[index:integer] : TAudioDevice read GetOutputDevices;
  end;

procedure LoadAudioDeviceList;
function GetAudioDeviceCount:integer;
function GetAudioDeviceName(index:integer):string;
function GetAudioDeviceInputChannels(index:integer):integer;
function GetAudioDeviceOutputChannels(index:integer):integer;

implementation

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

{ TAudioDevice }

constructor TAudioDevice.Create(ANo:integer; AName: string; AInputChannels,
  AOutputChannels: integer);
begin
  FNo := ANo;
  FName := AName;
  FInputChannels := AInputChannels;
  FOutputChannels := AOutputChannels;
end;

{ TAudioDeviceList }

constructor TAudioDeviceList.Create;
begin
  inherited;

  FDeviceList       := TList<TAudioDevice>.Create;
  FInputDeviceList  := TList<TAudioDevice>.Create;
  FOutputDeviceList := TList<TAudioDevice>.Create;

  Refresh;
end;

destructor TAudioDeviceList.Destroy;
begin
  FreeAndNil(FDeviceList);
  FreeAndNil(FInputDeviceList);
  FreeAndNil(FOutputDeviceList);

  inherited;
end;

function TAudioDeviceList.GetCount: integer;
begin
  Result := FDeviceList.Count;
end;

function TAudioDeviceList.GetDevices(index: integer): TAudioDevice;
begin
  Result := FDeviceList[index];
end;

function TAudioDeviceList.GetInputCount: integer;
begin
  Result := FInputDeviceList.Count;
end;

function TAudioDeviceList.GetInputDevices(index: integer): TAudioDevice;
begin
  Result := FInputDeviceList[index];
end;

function TAudioDeviceList.GetOutputCount: integer;
begin
  Result := FOutputDeviceList.Count;
end;

function TAudioDeviceList.GetOutputDevices(index: integer): TAudioDevice;
begin
  Result := FOutputDeviceList[index];
end;

function delete_whitespace(const text:string):string;
var
  i: Integer;
begin
  Result := '';
  for i := 1 to Length(text) do
    if text[i] <> ' ' then Result := Result + text[i];
end;

function is_device_in_the_list(list:TStrings; name:string):boolean;
var
  i: Integer;
begin
  Result := false;

  name := delete_whitespace(name);
  for i := 0 to list.Count-1 do
    if name = delete_whitespace(list[i]) then begin
      Result := true;
      Exit;
    end;
end;

procedure TAudioDeviceList.Refresh;
var
  audioDeviceInfo : TAudioDevice;
  i, inputChannels, outputChannels : integer;
  deviceName : string;
  deviceNames : TStringList;
begin
  FDeviceList.Clear;
  FInputDeviceList.Clear;
  FOutputDeviceList.Clear;

  LoadAudioDeviceList;

  deviceNames := TStringList.Create;
  try
    for i := 0 to GetAudioDeviceCount-1 do begin
      deviceName := Trim(GetAudioDeviceName(i));

      if is_device_in_the_list(deviceNames, deviceName) then Continue;
      if Pos('@', deviceName) > 0 then Continue;

      deviceNames.Add(deviceName);

      inputChannels   := GetAudioDeviceInputChannels(i);
      outputChannels  := GetAudioDeviceOutputChannels(i);
      audioDeviceInfo := TAudioDevice.Create(i, deviceName, inputChannels, outputChannels);

      FDeviceList.Add(audioDeviceInfo);
      if inputChannels  > 0 then FInputDeviceList.Add(audioDeviceInfo);
      if outputChannels > 0 then FOutputDeviceList.Add(audioDeviceInfo);
    end;
  finally
    deviceNames.Free;
  end;
end;

end.
