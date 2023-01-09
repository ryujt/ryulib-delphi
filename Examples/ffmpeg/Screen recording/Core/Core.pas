unit Core;

interface

uses
  Generics.Collections,
  SysUtils, Classes;

type
  TNotifyProcedure = reference to procedure (AListener:TComponent);

  TCore = class
  private
    FListener : TList<TComponent>;
  public
    constructor Create;
    destructor Destroy; override;

    procedure AddListener(AListener:TComponent);
    procedure RemoveListener(AListener:TComponent);
    procedure NotifyAll(ANotifyProcedure:TNotifyProcedure);
  end;

implementation

{ TCore }

procedure TCore.AddListener(AListener: TComponent);
begin
  FListener.Add(AListener);
end;

constructor TCore.Create;
begin
  inherited;

  FListener := TList<TComponent>.Create;
end;

destructor TCore.Destroy;
begin
  FreeAndNil(FListener);

  inherited;
end;

procedure TCore.NotifyAll(ANotifyProcedure: TNotifyProcedure);
var
  i: Integer;
begin
  for i := 0 to FListener.Count-1 do ANotifyProcedure(FListener[i]);
end;

procedure TCore.RemoveListener(AListener: TComponent);
begin
  FListener.Remove(AListener);
end;

end.
