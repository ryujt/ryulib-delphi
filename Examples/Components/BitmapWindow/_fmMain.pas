unit _fmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BitmapWindow, Vcl.ExtCtrls, SwitchButton, BitmapButton, Vcl.StdCtrls;

type
  TfmMain = class(TForm)
    BitmapWindow: TBitmapWindow;
    imgLine_End: TImage;
    lbTitle: TLabel;
    plClient: TPanel;
    btClose: TBitmapButton;
    btFullScreen: TBitmapButton;
    btMinimize: TBitmapButton;
    btStayOnTop: TSwitchButton;
    procedure btCloseClick(Sender: TObject);
  private
    FBitmapWindow: TBitmapWindow;
  public
  end;

var
  fmMain: TfmMain;

implementation

{$R *.dfm}

procedure TfmMain.btCloseClick(Sender: TObject);
begin
  Close;
end;

end.
