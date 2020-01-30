unit AudioZip;

interface

uses
  Classes, SysUtils;

type
  TCallBackData = procedure (AContext:pointer; AData:pointer; ASize:integer); cdecl;
  TCallBackError = procedure (AContext:pointer; ACode:integer); cdecl;

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

initialization
  initAudioZip;
end.
