unit _fmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, _frAudioControl;

type
  TfmMain = class(TForm)
    frAudioControl: TfrAudioControl;
  private
  public
  end;

var
  fmMain: TfmMain;

implementation

{$R *.dfm}

end.
