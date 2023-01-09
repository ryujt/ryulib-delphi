unit ffmpeg;

interface

uses
  CoreBase,
  SysUtils, Classes;

type
  Tffmpeg = class (TCoreBase)
  private
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Start;
    procedure Stop;
  end;

implementation

{ Tffmpeg }

constructor Tffmpeg.Create(AOwner: TComponent);
begin
  inherited;

end;

destructor Tffmpeg.Destroy;
begin

  inherited;
end;

procedure Tffmpeg.Start;
begin

end;

procedure Tffmpeg.Stop;
begin

end;

end.
