unit Video;

interface

uses
  CoreBase,
  Windows, SysUtils, Classes;

type
  TVideo = class (TCoreBase, IVideo)
  private
    FVideoSource : TVideoSourceType;
    FTargetWindow : integer;
    function GetWindowTitle(AHandle:integer):string;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Start;
    procedure Stop;

    procedure SetVideoSource(AValue:TVideoSourceType);
    procedure SetTargetWindow(AValue:integer);
  end;

implementation

{ TVideo }

constructor TVideo.Create(AOwner: TComponent);
begin
  inherited;

  FVideoSource := vsRegion;
  FTargetWindow := -1;
end;

destructor TVideo.Destroy;
begin

  inherited;
end;

function TVideo.GetWindowTitle(AHandle: integer): string;
var
  len: integer;
begin
  Result := 'The target window is not selected.';
  if AHandle = -1 then Exit;

  len := GetWindowTextLength(AHandle) + 1;
  SetLength(Result, len);
  GetWindowText(AHandle, PChar(Result), len);

  if Trim(Result) = '' then Result := IntToStr(AHandle);
end;

procedure TVideo.SetTargetWindow(AValue: integer);
var
  caption : string;
begin
  FTargetWindow := AValue;
  caption := GetWindowTitle(AValue);

  FCore.NotifyAll(
    procedure (AListener:TComponent)
    begin
      if Supports(AListener, ITargetWindowChanged) then (AListener as ITargetWindowChanged).onTargetWindowChanged(AValue, caption);
    end
  );
end;

procedure TVideo.SetVideoSource(AValue: TVideoSourceType);
begin
  FVideoSource := AValue;
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
