unit _frVideoSource;

interface

uses
  CoreBase,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TfrVideoSource = class(TFrame, IRecordingChanged)
    Shape1: TShape;
    Label1: TLabel;
    cbVideoSource: TComboBox;
    procedure cbVideoSourceKeyPress(Sender: TObject; var Key: Char);
    procedure cbVideoSourceChange(Sender: TObject);
  private // IRecordingChanged
    procedure onRecordingStatusChanged(AValue:boolean);
  public
    constructor Create(AOwner: TComponent); override;
  end;

implementation

uses
  Core;

{$R *.dfm}

procedure TfrVideoSource.cbVideoSourceChange(Sender: TObject);
begin
  TCore.Obj.Video.SetVideoSource(TVideoSourceType(cbVideoSource.ItemIndex));
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
end;

end.
