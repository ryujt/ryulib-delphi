unit _fmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, _frControlBox, _frVideoPreview;

type
  TfmMain = class(TForm)
    frVideoPreview: TfrVideoPreview;
    frControlBox: TfrControlBox;
  private
  public
  end;

var
  fmMain: TfmMain;

implementation

{$R *.dfm}

end.
