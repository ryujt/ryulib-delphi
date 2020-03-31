unit NamedShareMemory;

interface

uses
  DebugTools,
  Windows, SysUtils, Classes;

const
  BUFFER_SIZE = 32 * 1024;

type
  TNamedShareMemory = class
  private
  public
    class function Read(const AName:string):string;
    class function Write(const AName,AMsg:string):boolean;
  end;

implementation

{ TNamedShareMemory }

class function TNamedShareMemory.Read(const AName: string): string;
var
  pBuf: PChar;
  hMapFile: THandle;
begin
  Result := '';

  hMapFile := OpenFileMapping(FILE_MAP_ALL_ACCESS, False, PWideChar(AName));
    try
      if hMapFile = 0 then begin
        Trace( Format('[ERROR] OpenFileMapping = %d', [GetLastError]) );
        Exit;
      end;

      pBuf := MapViewOfFile(hMapFile, FILE_MAP_ALL_ACCESS, 0, 0, BUFFER_SIZE);
      try
        if pBuf = nil then begin
          Trace( Format('[ERROR] MapViewOfFile = %d', [GetLastError]) );
          CloseHandle(hMapFile);
          Exit;
        end;

        Result := pBuf;
    finally
      UnmapViewOfFile(pBuf);
    end;
  finally
    CloseHandle(hMapFile);
  end;
end;

class function TNamedShareMemory.Write(const AName, AMsg: string): boolean;
var
  pBuf: PChar;
  hMapFile: THandle;
begin
  Result := False;

  hMapFile := OpenFileMapping(FILE_MAP_ALL_ACCESS, False, PWideChar(AName));
  try
    if hMapFile = 0 then begin
      hMapFile := CreateFileMapping(INVALID_HANDLE_VALUE, nil, PAGE_READWRITE, 0, BUFFER_SIZE, PWideChar(AName));
      if hMapFile = 0 then begin
        Trace( Format('[ERROR] CreateFileMapping = %d', [GetLastError]) );
        Exit;
      end;
    end;

    pBuf := MapViewOfFile(hMapFile, FILE_MAP_ALL_ACCESS, 0, 0, BUFFER_SIZE);
    if pBuf = nil then begin
      Trace( Format('[ERROR] MapViewOfFile = %d', [GetLastError]) );
      Exit;
    end;

    CopyMemory(pBuf, PChar(AMsg), Length(AMsg) * SizeOf(Char));
  finally
    UnmapViewOfFile(pBuf);
  end;

  Result := True;
end;

end.
