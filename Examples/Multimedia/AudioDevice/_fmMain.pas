unit _fmMain;

interface

uses
  AudioDevice,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TfmMain = class(TForm)
    ListBox: TListBox;
    procedure FormCreate(Sender: TObject);
  private
    FAudioDeviceList : TAudioDeviceList;
  public
  end;

var
  fmMain: TfmMain;

implementation

{$R *.dfm}

procedure TfmMain.FormCreate(Sender: TObject);
var
  i: Integer;
  audioDevice : TAudioDevice;
begin
  FAudioDeviceList := TAudioDeviceList.Create;

  for i := 0 to FAudioDeviceList.Count-1 do begin
    audioDevice := FAudioDeviceList.Devices[i];
    ListBox.Items.Add(Format('Name: %s, InputChannels: %d, OutputChannels: %d', [audioDevice.Name, audioDevice.InputChannels, audioDevice.OutputChannels]));
  end;
end;

end.
