program example_AudioDevice;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  AudioDevice,
  System.SysUtils;

var
  i, input, output : integer;
  device_name : string;
begin
  LoadAudioDeviceList;
  for i := 0 to GetAudioDeviceCount-1 do begin
    device_name := Trim(GetAudioDeviceName(i));
    input       := GetAudioDeviceInputChannels(i);
    output      := GetAudioDeviceOutputChannels(i);

    WriteLn(i, ': ', device_name, ', ', input, ', ', output);
  end;

  ReadLn;
end.
