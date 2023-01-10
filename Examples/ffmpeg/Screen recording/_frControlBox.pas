unit _frControlBox;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, _frAudioControl,
  _frMainControl, _frVideoSource;

type
  TfrControlBox = class(TFrame)
    frMainControl: TfrMainControl;
    frAudioControl: TfrAudioControl;
    frVideoSource: TfrVideoSource;
  private
  public
  end;

implementation

{$R *.dfm}

end.
