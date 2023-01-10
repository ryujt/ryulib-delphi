unit ScreenUtils;

interface

uses
  Types, SysUtils, Classes, StdCtrls, Forms;

procedure LoadMonitorList(AComboBox:TComboBox);
function GetMonitorRect(AIndex:integer):TRect;

implementation

procedure LoadMonitorList(AComboBox:TComboBox);
var
  i: Integer;
begin
  AComboBox.Items.Clear;
  for i := 0 to Screen.MonitorCount-1 do
    AComboBox.Items.Add(Format('%d: (%d, %d) - %d x %d', [i+1, Screen.Monitors[i].Left, Screen.Monitors[i].Top, Screen.Monitors[i].Width, Screen.Monitors[i].Height]));
  if AComboBox.Items.Count > 0 then AComboBox.ItemIndex := 0;
  if Assigned(AComboBox.OnChange) then AComboBox.OnChange(AComboBox);
end;

function GetMonitorRect(AIndex:integer):TRect;
begin
  try
    Result := Screen.Monitors[AIndex].BoundsRect;
  except
    Result := Rect(0, 0, 0, 0);
  end;
end;

end.
