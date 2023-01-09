unit SelectInputDeviceComboBox;

interface

uses
  AudioDevice,
  Generics.Collections,
  Winapi.Windows, System.SysUtils, System.Variants, System.Classes, Vcl.StdCtrls;

type
  TSelectInputDeviceComboBox = class (TComponent)
  private
    FAudioDeviceList : TAudioDeviceList;
    procedure onKeyPress(Sender: TObject; var Key: Char);
    procedure onDropDown(Sender: TObject);
  private
    FTarget : TComboBox;
    function GetDeviceID: integer;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Target : TComboBox read FTarget;
    property DeviceID : integer read GetDeviceID;
  end;

function GetSelectInputDeviceComboBox(Aarget:TComboBox):TSelectInputDeviceComboBox;

implementation

var
  comboBoxMap : TDictionary<TComboBox, TSelectInputDeviceComboBox>;

function GetSelectInputDeviceComboBox(Aarget:TComboBox):TSelectInputDeviceComboBox;
begin
  Result := nil;
  comboBoxMap.TryGetValue(Aarget, Result);
end;

{ TSelectInputDeviceComboBox }

constructor TSelectInputDeviceComboBox.Create(AOwner: TComponent);
var
  comboBox : TComboBox absolute AOwner;
begin
  inherited;

  FAudioDeviceList := TAudioDeviceList.Create;

  comboBox.OnKeyPress := onKeyPress;
  comboBox.OnDropDown := onDropDown;

  FTarget := comboBox;

  comboBoxMap.Add(FTarget, Self);
end;

destructor TSelectInputDeviceComboBox.Destroy;
begin
  FreeAndNil(FAudioDeviceList);

  comboBoxMap.Remove(FTarget);

  inherited;
end;

function TSelectInputDeviceComboBox.GetDeviceID: integer;
begin
  if FTarget.ItemIndex < 0 then begin
    Result := -1;
    Exit;
  end;

  Result := FAudioDeviceList.InputDevices[FTarget.ItemIndex].No;
end;

procedure TSelectInputDeviceComboBox.onDropDown(Sender: TObject);
var
  i: Integer;
begin
  FTarget.Items.Clear;
  FTarget.ItemIndex := -1;
  FTarget.Text := 'default audio input device';

  FAudioDeviceList.Refresh;
  for i := 0 to FAudioDeviceList.InputCount-1 do
    FTarget.Items.Add(FAudioDeviceList.InputDevices[i].Name);
end;

procedure TSelectInputDeviceComboBox.onKeyPress(Sender: TObject; var Key: Char);
begin
  Key := #0;
end;

initialization
  comboBoxMap := TDictionary<TComboBox, TSelectInputDeviceComboBox>.Create;
end.
