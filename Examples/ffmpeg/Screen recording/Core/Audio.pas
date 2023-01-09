unit Audio;

interface

uses
  CoreBase,
  SysUtils, Classes;

type
  TAudio = class (TCoreBase, IAudio)
  private
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Start;
    procedure Stop;
  end;

implementation

{ TAudio }

constructor TAudio.Create(AOwner: TComponent);
begin
  inherited;

end;

destructor TAudio.Destroy;
begin

  inherited;
end;

procedure TAudio.Start;
begin

end;

procedure TAudio.Stop;
begin

end;

end.
