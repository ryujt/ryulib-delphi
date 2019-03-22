unit ShortcutLink;

interface

uses
  Disk,
  SysUtils, Classes, ShlObj, ActiveX, ComObj;

procedure CreateShortcutLink(const ALinkname,AFilename,AParams,AWorkingDir:string);

implementation

procedure CreateShortcutLink(const ALinkname,AFilename,AParams,AWorkingDir:string);
var
  MyObject: IUnknown;
  MySLink: IShellLink;
  MyPFile: IPersistFile;
begin
  MyObject:= CreateComObject(CLSID_ShellLink);
  MySLink:= MyObject as IShellLink;
  MyPFile:= MyObject as IPersistFile;

  with MySLink do begin
    SetArguments( PChar(AParams) );
    SetPath( PChar(AFilename) );
    SetWorkingDirectory( PChar(AWorkingDir) );
  end;

  MyPFile.Save( PChar(GetDesktopFolder + ALinkname), False);
end;

end.
