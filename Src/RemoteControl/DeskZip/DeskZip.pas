unit DeskZip;

interface

uses
  DeskZipUtils,
  SysUtils, Classes;

type
  TDeskZip = class
  private
    FHandle : pointer;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Prepare(AWidth,AHeight:integer);
    procedure Execute(ALeft,ATop:integer);
    function GetDeskFrame:PFrameBase;

    procedure setSpeed(ASpeed:integer);
  end;

implementation

{ TDeskZip }

constructor TDeskZip.Create;
begin
  inherited;

  FHandle := createDeskZip;
end;

destructor TDeskZip.Destroy;
begin
  releaseDeskZip(FHandle);

  inherited;
end;

procedure TDeskZip.Execute(ALeft,ATop:integer);
begin
  executeDeskZip(FHandle, ALeft, ATop);
end;

function TDeskZip.GetDeskFrame: PFrameBase;
begin
  Result := DeskZipUtils.getDeskFrame(FHandle);
end;

procedure TDeskZip.Prepare(AWidth, AHeight: integer);
begin
  prepareDeskZip(FHandle, AWidth, AHeight);
end;

procedure TDeskZip.setSpeed(ASpeed: integer);
begin
  DeskZipUtils.setSpeed(FHandle, ASpeed);
end;

end.
