unit Video;

interface

uses
  CoreBase,
  SysUtils, Classes;

type
  TVideo = class (TCoreBase, IVideo)
  private
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Start;
    procedure Stop;

    procedure SetVideoSource(AValue:TVideoSourceType);
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

procedure TVideo.SetVideoSource(AValue: TVideoSourceType);
begin
  FCore.NotifyAll(
    procedure (AListener:TComponent)
    begin
      if Supports(AListener, IVideoSourceChanged) then (AListener as IVideoSourceChanged).onVideoSourceChanged(AValue);
    end
  );
end;

procedure TVideo.Start;
begin

end;

procedure TVideo.Stop;
begin

end;

end.
