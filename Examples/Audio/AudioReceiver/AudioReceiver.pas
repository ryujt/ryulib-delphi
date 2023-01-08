unit AudioReceiver;

interface

uses
  AudioZip, UDPSocket,
  SysUtils, Classes;

type
  TAudioReceiver = class
  private
    FSocket : TUDPSocket;
    procedure onSocketReceived(const APeerIP:string; APeerPort:integer; AData:pointer; ASize:integer);
  private
    FAudioUnZip : TAudioUnZip;
  public
    constructor Create;
    destructor Destroy; override;

    class function Obj:TAudioReceiver;

    procedure Start;
    procedure Stop;
  end;

implementation

{ TAudioReceiver }

var
  MyObject : TAudioReceiver = nil;

class function TAudioReceiver.Obj: TAudioReceiver;
begin
  if MyObject = nil then MyObject := TAudioReceiver.Create;
  Result := MyObject;
end;

procedure TAudioReceiver.onSocketReceived(const APeerIP: string;
  APeerPort: integer; AData: pointer; ASize: integer);
begin
  FAudioUnZip.Play(AData, ASize);
end;

procedure TAudioReceiver.Start;
begin
  FSocket.Start(true);
end;

procedure TAudioReceiver.Stop;
begin
  FSocket.Stop;
end;

constructor TAudioReceiver.Create;
begin
  inherited;

  FSocket := TUDPSocket.Create(nil);
  FSocket.OnReceived := onSocketReceived;
  FSocket.Port := 1234;

  FAudioUnZip := TAudioUnZip.Create;
end;

destructor TAudioReceiver.Destroy;
begin
  FreeAndNil(FSocket);
  FreeAndNil(FAudioUnZip);

  inherited;
end;

initialization
  MyObject := TAudioReceiver.Create;
end.