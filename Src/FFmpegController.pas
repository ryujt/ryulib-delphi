unit FFmpegController;

interface

uses
  Classes, SysUtils;

function open_ffmpeg(const json:AnsiString):boolean;
procedure close_ffmpeg();

implementation

function create_ffmpeg_controller():pointer;
         cdecl; external 'ffmpeg_controller.dll' delayed;

procedure destory_ffmpeg_controller(handle:pointer);
         cdecl; external 'ffmpeg_controller.dll' delayed;

function open_ffmpeg_controller(handle:pointer; json:PAnsiChar):boolean;
         cdecl; external 'ffmpeg_controller.dll' delayed;

procedure close_ffmpeg_controller(handle:pointer);
          cdecl; external 'ffmpeg_controller.dll' delayed;

var
  handle : pointer;

function open_ffmpeg(const json:AnsiString):boolean;
begin
  Result := open_ffmpeg_controller(handle, PAnsiChar(json));
end;

procedure close_ffmpeg();
begin
  close_ffmpeg_controller(handle);
end;

initialization
  handle := create_ffmpeg_controller;
end.
