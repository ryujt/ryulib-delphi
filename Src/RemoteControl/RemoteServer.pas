unit RemoteServer;

interface

uses
  RemoteControlUtils,
  DeskZipUtils, DeskZipUnit,
  RyuLibBase, DebugTools, SuperSocketUtils, SuperSocketClient, AsyncTasks,
  Windows, SysUtils, Classes, TypInfo;

type
  TRemoteServer = class
  private
    FSocket: TSuperSocketClient;
    procedure on_FSocket_error(Sender:TObject; AErrorCode:integer; const AMsg:string);
    procedure on_FSocket_connected(ASender: TObject);
    procedure on_FSocket_disconnected(ASender: TObject);
    procedure on_FSocket_Received(ASender: TObject; APacket: PPacket);
  private
    procedure rp_ConnectionID(APacket:PConnectionIDPacket);
  private
    FDeskZip: TDeskZipUnit;
    procedure on_FDeskZip_data(Sender:TObject; AData:pointer);
  private
    procedure do_deskzip_packet(APacket: PPacket);
    procedure do_remote_control_packet(APacket: PPacket);
  private
    FConnectionID: integer;
    FOnConnectError: TNotifyEvent;
    FOnConnectionID: TIntegerEvent;
    FOnConnected: TNotifyEvent;
    FOnDisconnected: TNotifyEvent;
    FOnPeerConnectError: TNotifyEvent;
    FOnPeerConnected: TNotifyEvent;
    FOnPeerDisconnected: TNotifyEvent;
    function GetConnected: boolean;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Terminate;

    procedure Connect(const AHost:string; APort:integer);
    procedure Discoonect;
  public
    property Connected: boolean read GetConnected;
    property ConnectionID : integer read FConnectionID;
    property OnConnectError : TNotifyEvent read FOnConnectError write FOnConnectError;
    property OnConnected : TNotifyEvent read FOnConnected write FOnConnected;
    property OnDisconnected : TNotifyEvent read FOnDisconnected write FOnDisconnected;
    property OnConnectionID : TIntegerEvent read FOnConnectionID write FOnConnectionID;
    property OnPeerConnectError : TNotifyEvent read FOnPeerConnectError write FOnPeerConnectError;
    property OnPeerConnected : TNotifyEvent read FOnPeerConnected write FOnPeerConnected;
    property OnPeerDisconnected : TNotifyEvent read FOnPeerDisconnected write FOnPeerDisconnected;
  end;

implementation

{ TRemoteServer }

procedure TRemoteServer.Connect(const AHost:string; APort:integer);
begin
  FSocket.Connect(AHost, APort);
end;

constructor TRemoteServer.Create;
begin
  inherited;

  FConnectionID := -1;

  FSocket := TSuperSocketClient.Create(true);
  FSocket.UseNagel := false;
  FSocket.OnError := on_FSocket_error;
  FSocket.OnConnected := on_FSocket_connected;
  FSocket.OnDisconnected := on_FSocket_disconnected;
  FSocket.OnReceived := on_FSocket_Received;

  FDeskZip := TDeskZipUnit.Create;
  FDeskZip.OnData := on_FDeskZip_data;
end;

destructor TRemoteServer.Destroy;
begin

  inherited;
end;

procedure TRemoteServer.Discoonect;
begin
  FSocket.Disconnect;
end;

procedure TRemoteServer.do_deskzip_packet(APacket: PPacket);
begin
  case TFrameType(APacket^.PacketType) of
    ftNeedNext: ;
    ftAskDeskZip: FDeskZip.Execute;
    ftEndOfDeskZip: ;
  end;
end;

procedure TRemoteServer.do_remote_control_packet(APacket: PPacket);
const
  KEYEVENTF_KEYDOWN = 0;
var
  packet: PRemoteControlPacket absolute APacket;
begin
  case TPacketType(APacket^.PacketType) of
    ptConnectionID: rp_ConnectionID( Pointer(APacket) );

    ptErPeerConnected:
      AsyncTask(
        procedure (AUserData:pointer) begin
          if Assigned(FOnPeerConnectError) then FOnPeerConnectError(Self);
        end
      );

    ptPeerConnected: begin
      AsyncTask(
        procedure (AUserData:pointer) begin
          if Assigned(FOnPeerConnected) then FOnPeerConnected(Self);
        end
      );
      FDeskZip.Prepare(0);
    end;

    ptPeerDisconnected:
      AsyncTask(
        procedure (AUserData:pointer) begin
          if Assigned(FOnPeerDisconnected) then FOnPeerDisconnected(Self);
        end
      );

    ptMouseMove: SetCursorPos(packet^.X, packet^.Y);
    ptMouseDown, ptMouseUp: Mouse_Event(packet^.Key, packet^.X, packet^.Y, 0, 0);

    ptKeyDown: Keybd_Event(packet^.Key, MapVirtualKey(packet^.Key, 0), KEYEVENTF_KEYDOWN, 0);
    ptKeyUp: Keybd_Event(packet^.Key, MapVirtualKey(packet^.Key, 0), KEYEVENTF_KEYUP, 0);
  end;
end;

function TRemoteServer.GetConnected: boolean;
begin
  Result := FSocket.Connected;
end;

procedure TRemoteServer.on_FDeskZip_data(Sender: TObject; AData: pointer);
begin
  FSocket.Send(AData);
end;

procedure TRemoteServer.on_FSocket_connected(ASender: TObject);
begin
  AsyncTask(
    procedure (AUserData:pointer) begin
      if Assigned(FOnConnected) then FOnConnected(Self);
    end
  );
end;

procedure TRemoteServer.on_FSocket_disconnected(ASender: TObject);
begin
  AsyncTask(
    procedure (AUserData:pointer) begin
      if Assigned(FOnDisconnected) then FOnDisconnected(Self);
    end
  );
end;

procedure TRemoteServer.on_FSocket_error(Sender: TObject; AErrorCode: integer;
  const AMsg: string);
begin
  AsyncTask(
    procedure (AUserData:pointer) begin
      // TODO: 다른 에러 메시지도 처리
      if (AErrorCode = -1) and Assigned(FOnConnectError) then FOnConnectError(Self);
    end
  );
end;

procedure TRemoteServer.on_FSocket_Received(ASender: TObject; APacket: PPacket);
begin
  if APacket^.PacketType < 100 then begin
    do_deskzip_packet(APacket);
  end else begin
    {$IFDEF DEBUG}
    Trace( Format('TRemoteServer.on_FSocket_Received - %d', [APacket^.PacketType]) );
    {$ENDIF}

    do_remote_control_packet(APacket);
  end;
end;

procedure TRemoteServer.rp_ConnectionID(APacket: PConnectionIDPacket);
begin
  FConnectionID := APacket^.ID;
  AsyncTask(
    procedure (AUserData:pointer) begin
      if Assigned(FOnConnectionID) then FOnConnectionID(Self, APacket^.ID);
    end
  );
end;

procedure TRemoteServer.Terminate;
begin
  FSocket.Terminate;
  FDeskZip.Terminate;
end;

end.
