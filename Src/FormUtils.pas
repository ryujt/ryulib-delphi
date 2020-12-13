unit FormUtils;

interface

uses
  Disk, Strg, RyuGraphics,
  SysUtils, Classes, Graphics, Controls, Forms;

procedure SaveFormInfo(const APath:string; const AForm:TForm);
procedure LoadFormInfo(const APath:string; const AForm:TForm; ADefaultWidth,ADefaultHeight:integer);

implementation

procedure SaveFormInfo(const APath:string; const AForm:TForm);
var
  filename : string;
begin
  ForceDirectories(APath);

  if APath = '' then
    filename := DeleteRight(ParamStr(0), '.') + 'ini'
  else
    filename := APath + DeleteRight( ExtractFileName(ParamStr(0)), '.') + 'ini';

  if AForm.WindowState = wsMaximized then begin
    WriteIniInt(filename, AForm.Name, 'Maximized', 1);
  end else begin
    WriteIniInt(filename, AForm.Name, 'Maximized', 0);
    WriteIniInt(filename, AForm.Name, 'Left',   AForm.Left);
    WriteIniInt(filename, AForm.Name, 'Top',    AForm.Top);
    WriteIniInt(filename, AForm.Name, 'Width',  AForm.Width);
    WriteIniInt(filename, AForm.Name, 'Height', AForm.Height);
  end;
end;

procedure LoadFormInfo(const APath:string; const AForm:TForm; ADefaultWidth,ADefaultHeight:integer);
var
  filename : string;
begin
  if APath = '' then
    filename := DeleteRight(ParamStr(0), '.') + 'ini'
  else
    filename := APath + DeleteRight( ExtractFileName(ParamStr(0)), '.') + 'ini';

  AForm.Left   := IniInteger(filename, AForm.Name, 'Left',   0);
  AForm.Top    := IniInteger(filename, AForm.Name, 'Top',    0);
  AForm.Width  := IniInteger(filename, AForm.Name, 'Width',  ADefaultWidth);
  AForm.Height := IniInteger(filename, AForm.Name, 'Height', ADefaultHeight);

  if IniInteger(filename, AForm.Name, 'Maximized',  0) = 1 then begin
    AForm.WindowState := wsMaximized;
  end;

  if not IsWindowInMonitorAreas(AForm.Left, AForm.Top) then begin
    AForm.Left   := 0;
    AForm.Top    := 0;
    AForm.Width  := ADefaultWidth;
    AForm.Height := ADefaultWidth;
  end;
end;

end.
