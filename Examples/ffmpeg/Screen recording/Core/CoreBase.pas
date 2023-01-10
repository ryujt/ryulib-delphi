unit CoreBase;

interface

uses
  Types, SysUtils, Classes;

type
  TVideoSourceType = (vsRegion, vsWindow, vsMonitor);

  TNotifyProcedure = reference to procedure (AListener:TComponent);

  ICoreInternal = interface
    ['{90C4E956-D76A-4DF2-9D67-DB523AAF1C03}']
    procedure NotifyAll(ANotifyProcedure:TNotifyProcedure);
  end;

  IAudio = interface
    ['{6102301F-3259-4B76-9487-960CFBF6BBC6}']
    procedure SetDeviceID(AID:integer);
    procedure SetUseSystemAudio(AValue:boolean);
  end;

  IVideo = interface
    ['{E38F1280-9DB5-4C10-924B-F2B52054D2D4}']
    procedure SetVideoSource(AValue:TVideoSourceType);
    procedure SetTargetWindow(AValue:integer);
    procedure SetRegion(ARect:TRect);
    procedure SetOutputResolution(AWidth,AHeight:integer);
  end;

  Iffmpeg = interface
    ['{EB7FC1D6-9E0D-4B89-A3E8-45E595A10743}']
  end;

  IVideoSourceChanged = interface
    ['{5A4E49F9-4344-402C-8BD2-52335C94B2B1}']
    procedure onVideoSourceChanged(AValue:TVideoSourceType);
  end;

  ITargetWindowChanged = interface
    ['{017D1986-3049-4DDF-884E-67986C9EC42F}']
    procedure onTargetWindowChanged(AValue:integer; ACaption:string);
  end;

  IRecordingChanged = interface
    ['{A83694B2-D24D-4784-812B-90DF31E44FBD}']
    procedure onRecordingStatusChanged(AValue:boolean);
  end;

  TCoreBase = class (TComponent)
  protected
    FCore : ICoreInternal;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

{ TCoreBase }

constructor TCoreBase.Create(AOwner: TComponent);
begin
  inherited;

  FCore := AOwner as ICoreInternal;
end;

destructor TCoreBase.Destroy;
begin

  inherited;
end;

end.
