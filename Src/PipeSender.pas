unit PipeSender;

interface

uses
  AudioZip,
  Classes, SysUtils;

type
  TCallBackNotify = procedure (AContext:pointer); cdecl;

  TPipeSender = class
  private
    FHanlde : pointer;
    FOnConnected: TNotifyEvent;
  public
    constructor Create;
    destructor Destroy; override;

    function Open(AName:AnsiString):boolean;
    procedure Close;
    procedure Send(const AData:pointer; ASize:integer);
  public
    property OnConnected : TNotifyEvent read FOnConnected write FOnConnected;
  end;

function  create_PipeSender_object(AContext:pointer):pointer;
          cdecl; external 'PipeSender.dll' delayed;

procedure destroy_PipeSender_object(AHandle:pointer);
          cdecl; external 'PipeSender.dll' delayed;

procedure PipeSender_setOnConnected(AHandle:pointer; AEvent:TCallBackNotify);
          cdecl; external 'PipeSender.dll' delayed;

function  PipeSender_open(AHandle:pointer; AName:PAnsiChar):boolean;
          cdecl; external 'PipeSender.dll' delayed;

procedure PipeSender_close(AHandle:pointer);
          cdecl; external 'PipeSender.dll' delayed;

procedure PipeSender_send(AHandle:pointer; AData:pointer; ASize:integer);
          cdecl; external 'PipeSender.dll' delayed;

implementation

procedure on_connected(AContext:pointer); cdecl;
var
  context : TPipeSender absolute AContext;
begin
  if Assigned(context.FOnConnected) then context.FOnConnected(context);  
end;

{ TPipeSender }

procedure TPipeSender.Close;
begin
  PipeSender_close(FHanlde);
end;

constructor TPipeSender.Create;
begin
  FHanlde := create_PipeSender_object(Self);
  PipeSender_setOnConnected(FHanlde, on_connected);
end;

destructor TPipeSender.Destroy;
begin
  destroy_PipeSender_object(FHanlde);

  inherited;
end;

function TPipeSender.Open(AName: AnsiString): boolean;
begin
  Result := PipeSender_open(FHanlde, PAnsiChar(AName));
end;

procedure TPipeSender.Send(const AData: pointer; ASize: integer);
begin
  PipeSender_send(FHanlde, AData, ASize);
end;

end.
