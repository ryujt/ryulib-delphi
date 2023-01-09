unit CoreBase;

interface

uses
  SysUtils, Classes;

type
  TNotifyProcedure = reference to procedure (AListener:TComponent);

  ICoreInternal = interface
    ['{90C4E956-D76A-4DF2-9D67-DB523AAF1C03}']
    procedure NotifyAll(ANotifyProcedure:TNotifyProcedure);
  end;

  IAudio = interface
    ['{6102301F-3259-4B76-9487-960CFBF6BBC6}']
  end;

  IVideo = interface
    ['{E38F1280-9DB5-4C10-924B-F2B52054D2D4}']
  end;

  Iffmpeg = interface
    ['{EB7FC1D6-9E0D-4B89-A3E8-45E595A10743}']
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
