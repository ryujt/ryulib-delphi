unit _fmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, _frControlBox, _frVideoPreview;

type
  TfmMain = class(TForm)
    frVideoPreview: TfrVideoPreview;
    frControlBox: TfrControlBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    constructor Create(AOwner: TComponent); override;
    procedure CreateParams(var Params:TCreateParams); override;
  public
  end;

var
  fmMain: TfmMain;

implementation

{$R *.dfm}

{ TfmMain }

constructor TfmMain.Create(AOwner: TComponent);
begin
  inherited;

  Left := Application.MainForm.Width + 1;
  Top  := Application.MainForm.Top   + 1;
  Show;
end;

procedure TfmMain.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);

  with Params do begin
    exStyle := exStyle or WS_EX_APPWINDOW;
    WndParent := Winapi.Windows.GetDesktopWindow;
  end;
end;

procedure TfmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Application.MainForm.Close;
end;

end.
