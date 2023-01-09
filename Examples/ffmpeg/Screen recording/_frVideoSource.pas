unit _frVideoSource;

interface

uses
  CoreBase,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Buttons;

type
  TfrVideoSource = class(TFrame, IRecordingChanged, ITargetWindowChanged)
    Shape1: TShape;
    Label1: TLabel;
    cbVideoSource: TComboBox;
    plWindow: TPanel;
    edWindow: TEdit;
    SpeedButton1: TSpeedButton;
    procedure cbVideoSourceKeyPress(Sender: TObject; var Key: Char);
    procedure cbVideoSourceChange(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    // IRecordingChanged
    procedure onRecordingStatusChanged(AValue:boolean);

    // ITargetWindowChanged
    procedure onTargetWindowChanged(AValue:integer; ACaption:string);
  public
    constructor Create(AOwner: TComponent); override;
  end;

implementation

uses
  Core,
  _fmSelectWindow;

{$R *.dfm}

procedure TfrVideoSource.cbVideoSourceChange(Sender: TObject);
begin
  TCore.Obj.Video.SetVideoSource(TVideoSourceType(cbVideoSource.ItemIndex));
  plWindow.Visible := TVideoSourceType(cbVideoSource.ItemIndex) = vsWindow;
end;

procedure TfrVideoSource.cbVideoSourceKeyPress(Sender: TObject;
  var Key: Char);
begin
  Key := #0;
end;

constructor TfrVideoSource.Create(AOwner: TComponent);
begin
  inherited;

  TCore.Obj.AddListener(Self);
end;

procedure TfrVideoSource.onRecordingStatusChanged(AValue: boolean);
begin
  cbVideoSource.Enabled := not AValue;
  plWindow.Enabled := not AValue;
end;

procedure TfrVideoSource.onTargetWindowChanged(AValue: integer; ACaption:string);
begin
  edWindow.Text := ACaption;
end;

procedure TfrVideoSource.SpeedButton1Click(Sender: TObject);
begin
  fmSelectWindow.Show;
end;

end.
