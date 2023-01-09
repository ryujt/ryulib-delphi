unit MainControl;

interface

uses
  Core,
  SysUtils, Classes;

type
  IOnAir = interface
    ['{A83694B2-D24D-4784-812B-90DF31E44FBD}']
    procedure onAirStatusChanged(AIsOnAir:boolean);
  end;

  TMainControl = class(TCore)
  private
  public
    constructor Create;
    destructor Destroy; override;

    class function Obj:TMainControl;

    procedure StartRecording;
    procedure StopRecording;
  end;

implementation

{ TMainControl }

var
  MyObject : TMainControl = nil;

class function TMainControl.Obj: TMainControl;
begin
  if MyObject = nil then MyObject := TMainControl.Create;
  Result := MyObject;
end;

procedure TMainControl.StartRecording;
begin
  NotifyAll(
    procedure (AListener:TComponent)
    begin
      if Supports(AListener, IOnAir) then (AListener as IOnAir).onAirStatusChanged(true);
    end
  );
end;

procedure TMainControl.StopRecording;
begin
  NotifyAll(
    procedure (AListener:TComponent)
    begin
      if Supports(AListener, IOnAir) then (AListener as IOnAir).onAirStatusChanged(false);
    end
  );
end;

constructor TMainControl.Create;
begin
  inherited;

end;

destructor TMainControl.Destroy;
begin

  inherited;
end;

initialization
  MyObject := TMainControl.Create;
end.