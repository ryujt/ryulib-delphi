unit Video;

interface

uses
  CoreBase,
  SysUtils, Classes;

type
  TVideo = class (TCoreBase)
  private
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Start;
    procedure Stop;
  end;

implementation

{ TVideo }

constructor TVideo.Create(AOwner: TComponent);
begin
  inherited;

end;

destructor TVideo.Destroy;
begin

  inherited;
end;

procedure TVideo.Start;
begin

end;

procedure TVideo.Stop;
begin

end;

end.
