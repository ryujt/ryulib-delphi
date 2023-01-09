unit _frControlBox;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, _frAudioControl,
  _frMainControl, _frVideoSource;

type
  TfrControlBox = class(TFrame)
    frAudioControl: TfrAudioControl;
    frMainControl1: TfrMainControl;
    frVideoSource1: TfrVideoSource;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

end.
