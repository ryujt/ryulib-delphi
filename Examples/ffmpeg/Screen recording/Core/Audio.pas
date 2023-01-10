unit Audio;

interface

uses
  RyuLibBase,
  CoreBase, AudioCapture,
  SysUtils, Classes;

type
  TAudio = class (TCoreBase, IAudio)
  private
    FAudioCapture: TAudioCapture;
  private
    FDeviceID : integer;
    FUseSystemAudio : boolean;
    function GetOnData: TDataEvent;
    procedure SetOnData(const Value: TDataEvent);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Start;
    procedure Stop;

    procedure SetDeviceID(AID:integer);
    procedure SetUseSystemAudio(AValue:boolean);
  public
    property OnData : TDataEvent read GetOnData write SetOnData;
  end;

implementation

{ TAudio }

constructor TAudio.Create(AOwner: TComponent);
begin
  inherited;

  FDeviceID := -1;
  FUseSystemAudio := false;

  FAudioCapture := TAudioCapture.Create;
end;

destructor TAudio.Destroy;
begin
  FreeAndNil(FAudioCapture);

  inherited;
end;

function TAudio.GetOnData: TDataEvent;
begin
  Result := FAudioCapture.OnData;
end;

procedure TAudio.SetDeviceID(AID: integer);
begin
  FDeviceID := AID;
end;

procedure TAudio.SetOnData(const Value: TDataEvent);
begin
  FAudioCapture.OnData := Value;
end;

procedure TAudio.SetUseSystemAudio(AValue: boolean);
begin
  FUseSystemAudio := AValue;
end;

procedure TAudio.Start;
begin
  FAudioCapture.Start(FDeviceID, FUseSystemAudio);
end;

procedure TAudio.Stop;
begin
  FAudioCapture.Stop;
end;

end.
