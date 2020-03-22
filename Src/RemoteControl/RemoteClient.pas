unit RemoteClient;

interface

uses
  RemoteControlUtils,
  DeskZipUtils, DeskUnZipUnit,
  RyuLibBase, DebugTools, SuperSocketUtils, SuperSocketClient, AsyncTasks,
  Windows, SysUtils, Classes, TypInfo, Graphics;

type
  TRemoteClient = class
  private
    // 지금 처음 화면 전송을 시작하는가?
    FIsFirstScreen: boolean;

    FDeskUnZip: TDeskUnZipUnit;
  private
    FSocket: TSuperSocketClient;
    procedure on_FSocket_error(Sender:TObject; AErrorCode:integer; const AMsg:string);
    procedure on_FSocket_connected(ASender: TObject);
    procedure on_FSocket_disconnected(ASender: TObject);
    procedure on_FSocket_Received(ASender: TObject; APacket: PPacket);
  private
    procedure rp_ConnectionID(APacket:PConnectionIDPacket);
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
    function GetBitmapHeight: integer;
    function getBitmapWidth: integer;
    function GetHeight: integer;
    function GetWidth: integer;
    function GetOnDeskScreenIsReady: TNotifyEvent;
    procedure SetOnDeskScreenIsReady(const Value: TNotifyEvent);
  public
    constructor Create;
    destructor Destroy; override;

    class function Obj:TRemoteClient;

    procedure Terminate;

    procedure Connect(const AHost:string; APort:integer);
    procedure Discoonect;
  public
    procedure sp_SetConnectionID(AID: integer);
    procedure sp_AskDeskZip;

    procedure sp_MouseDown(AMode, AX, AY: integer);
    procedure sp_MouseMove(AX, AY: integer);
    procedure sp_MouseUp(AMode, AX, AY: integer);

    procedure sp_KeyDown(AKey: integer);
    procedure sp_KeyUp(AKey: integer);

    procedure GetBitmap(ABitmap: TBitmap);
  public
    property Connected: boolean read GetConnected;
    property ConnectionID: integer read FConnectionID;

    property Width: integer read GetWidth;
    property Height: integer read GetHeight;

    property BitmapWidth: integer read getBitmapWidth;
    property BitmapHeight: integer read GetBitmapHeight;

    property OnConnectError : TNotifyEvent read FOnConnectError write FOnConnectError;
    property OnConnected : TNotifyEvent read FOnConnected write FOnConnected;
    property OnDisconnected : TNotifyEvent read FOnDisconnected write FOnDisconnected;
    property OnConnectionID : TIntegerEvent read FOnConnectionID write FOnConnectionID;
    property OnPeerConnectError : TNotifyEvent read FOnPeerConnectError write FOnPeerConnectError;
    property OnPeerConnected : TNotifyEvent read FOnPeerConnected write FOnPeerConnected;
    property OnPeerDisconnected : TNotifyEvent read FOnPeerDisconnected write FOnPeerDisconnected;
    property OnDeskScreenIsReady : TNotifyEvent read GetOnDeskScreenIsReady write SetOnDeskScreenIsReady;
  end;

implementation

{ TRemoteClient }

var
  MyObject : TRemoteClient = nil;

class function TRemoteClient.Obj: TRemoteClient;
begin
  if MyObject = nil then MyObject := TRemoteClient.Create;
  Result := MyObject;
end;

procedure TRemoteClient.Connect(const AHost:string; APort:integer);
begin
  FSocket.Connect(AHost, APort);
end;

constructor TRemoteClient.Create;
begin
  inherited;

  FConnectionID := -1;

  FSocket := TSuperSocketClient.Create(true);
  FSocket.UseNagel := false;
  FSocket.OnError := on_FSocket_error;
  FSocket.OnConnected := on_FSocket_connected;
  FSocket.OnDisconnected := on_FSocket_disconnected;
  FSocket.OnReceived := on_FSocket_Received;

  FDeskUnZip := TDeskUnZipUnit.Create;
end;

destructor TRemoteClient.Destroy;
begin
  FreeAndNil(FSocket);
  FreeAndNil(FDeskUnZip);

  inherited;
end;

procedure TRemoteClient.Discoonect;
begin
  FSocket.Disconnect;
end;

procedure TRemoteClient.do_deskzip_packet(APacket: PPacket);
begin
  case TFrameType(APacket^.PacketType) of
    ftNeedNext: ;
    ftEndOfDeskZip: ;
    ftFrameStart, ftBitmap, ftJpeg, ftPixel: FDeskUnZip.Execute(APacket);

    ftFrameEnd: begin
      FDeskUnZip.Execute(APacket);
      sp_AskDeskZip;
    end;
  end;
end;

procedure TRemoteClient.do_remote_control_packet(APacket: PPacket);
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

    ptPeerConnected:
      AsyncTask(
        procedure (AUserData:pointer) begin
          if Assigned(FOnPeerConnected) then FOnPeerConnected(Self);
        end
      );

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

procedure TRemoteClient.GetBitmap(ABitmap: TBitmap);
begin
  FDeskUnZip.GetBitmap(ABitmap);
end;

function TRemoteClient.GetBitmapHeight: integer;
begin
  Result := FDeskUnZip.BitmapHeight;
end;

function TRemoteClient.getBitmapWidth: integer;
begin
  Result := FDeskUnZip.BitmapWidth;
end;

function TRemoteClient.GetConnected: boolean;
begin
  Result := FSocket.Connected;
end;

function TRemoteClient.GetHeight: integer;
begin
  Result := FDeskUnZip.Height;
end;

function TRemoteClient.GetOnDeskScreenIsReady: TNotifyEvent;
begin
  Result := FDeskUnZip.OnDeskScreenIsReady;
end;

function TRemoteClient.GetWidth: integer;
begin
  Result := FDeskUnZip.Width;
end;

procedure TRemoteClient.on_FSocket_connected(ASender: TObject);
begin
  AsyncTask(
    procedure (AUserData:pointer) begin
      if Assigned(FOnConnected) then FOnConnected(Self);
    end
  );
end;

procedure TRemoteClient.on_FSocket_disconnected(ASender: TObject);
begin
  AsyncTask(
    procedure (AUserData:pointer) begin
      if Assigned(FOnDisconnected) then FOnDisconnected(Self);
    end
  );
end;

procedure TRemoteClient.on_FSocket_error(Sender: TObject; AErrorCode: integer;
  const AMsg: string);
begin
  AsyncTask(
    procedure (AUserData:pointer) begin
      // TODO: 다른 에러 메시지도 처리
      if (AErrorCode = -1) and Assigned(FOnConnectError) then FOnConnectError(Self);
    end
  );
end;

procedure TRemoteClient.on_FSocket_Received(ASender: TObject; APacket: PPacket);
begin
  if APacket^.PacketType < 100 then begin
    do_deskzip_packet(APacket);
  end else begin
    {$IFDEF DEBUG}
    Trace( Format('TRemoteClient.on_FSocket_Received - %d', [APacket^.PacketType]) );
    {$ENDIF}

    do_remote_control_packet(APacket);
  end;
end;

procedure TRemoteClient.rp_ConnectionID(APacket: PConnectionIDPacket);
begin
  FConnectionID := APacket^.ID;

  AsyncTask(
    procedure (AUserData:pointer) begin
      if Assigned(FOnConnectionID) then FOnConnectionID(Self, APacket^.ID);
    end
  );
end;

procedure TRemoteClient.SetOnDeskScreenIsReady(const Value: TNotifyEvent);
begin
  FDeskUnZip.OnDeskScreenIsReady := Value;
end;

procedure TRemoteClient.sp_AskDeskZip;
var
  packet: TPacket;
begin
  packet.PacketSize := 3;
  packet.PacketType := Byte(ftAskDeskZip);
  FSocket.Send(@packet);
end;

procedure TRemoteClient.sp_KeyDown(AKey: integer);
var
  packet: TRemoteControlPacket;
begin
  packet.PacketSize := SizeOf(TRemoteControlPacket);
  packet.PacketType := ptKeyDown;
  packet.Key := AKey;
  FSocket.Send(@packet);
end;

procedure TRemoteClient.sp_KeyUp(AKey: integer);
var
  packet: TRemoteControlPacket;
begin
  packet.PacketSize := SizeOf(TRemoteControlPacket);
  packet.PacketType := ptKeyUp;
  packet.Key := AKey;
  FSocket.Send(@packet);
end;

procedure TRemoteClient.sp_MouseDown(AMode, AX, AY: integer);
var
  packet: TRemoteControlPacket;
begin
  packet.PacketSize := SizeOf(TRemoteControlPacket);
  packet.PacketType := ptMouseDown;
  packet.Key := AMode;
  packet.X := AX;
  packet.Y := AY;
  FSocket.Send(@packet);
end;

procedure TRemoteClient.sp_MouseMove(AX, AY: integer);
var
  packet: TRemoteControlPacket;
begin
  packet.PacketSize := SizeOf(TRemoteControlPacket);
  packet.PacketType := ptMouseMove;
  packet.X := AX;
  packet.Y := AY;
  FSocket.Send(@packet);
end;

procedure TRemoteClient.sp_MouseUp(AMode, AX, AY: integer);
var
  packet: TRemoteControlPacket;
begin
  packet.PacketSize := SizeOf(TRemoteControlPacket);
  packet.PacketType := ptMouseUp;
  packet.Key := AMode;
  packet.X := AX;
  packet.Y := AY;
  FSocket.Send(@packet);
end;

procedure TRemoteClient.sp_SetConnectionID(AID: integer);
var
  packet: TConnectionIDPacket;
begin
  packet.PacketSize := SizeOf(TConnectionIDPacket);
  packet.PacketType := ptSetConnectionID;
  packet.id := AID;
  FSocket.Send(@packet);

  sp_AskDeskZip;
end;

procedure TRemoteClient.Terminate;
begin
  FSocket.Terminate;
  FDeskUnZip.Terminate;
end;

end.
