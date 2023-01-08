unit UDPSocket;

interface

uses
  RyuLibBase, SimpleThread, DynamicQueue, SuspensionQueue, ThreadUtils,
  Windows, Classes, SysUtils, WinSock;

type
  TPacketUDP = class
    Host : AnsiString;
    Port : integer;
    Memory : TMemory;
    constructor Create(const AHost:string; APort:integer; AData:pointer; ASize:integer); reintroduce;
    destructor Destroy; override;
  end;

  TUDPReceivedEvent = procedure(const APeerIP:string; APeerPort:integer; AData:pointer; ASize:integer) of object;

  TUDPSocket = class(TComponent)
  private
    FSocket : TSocket;
    FSendQueue : TDynamicQueue;
    FRecvQueue : TSuspensionQueue<TPacketUDP>;
    FBuffer : Pointer;
    function do_Bind:boolean;
    procedure do_Send;
    procedure do_Receive;
  private
    FMainThread : TSimpleThread;
    procedure on_FMainThread_Execute(ASimpleThread:TSimpleThread);
  private
    FRecvThread : TSimpleThread;
    procedure on_FRecvThread_Execute(ASimpleThread:TSimpleThread);
  private
    FBufferSize : integer;
    FPort: integer;
    FActive: boolean;
    FOnReceived: TUDPReceivedEvent;
    FTimeOutRead: integer;
    FTimeOutWrite: integer;
    FIsServer: boolean;
    procedure SetPort(const Value: integer);
    procedure SetBufferSize(const Value: integer);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    {*
      Start UDP socket.
      @param ANeedBinding If ANeedBinding is true, it becomes a server socket.
    *}
    procedure Start(ANeedBinding:boolean=true);

    {*
      Stop UDP socket.
    *}
    procedure Stop;

    {*
      Send binary data to the APort of an AHost.
    *}
    procedure SendTo(const AHost:string; APort:integer; AData:pointer; ASize:integer); overload;

    {*
      Send text data to the APort of an AHost.
    *}
    procedure SendTo(const AHost:string; APort:integer; AText:string); overload;
  published
    property Active : boolean read FActive;
    property Port : integer read FPort write SetPort;
    property IsServer : boolean read FIsServer;
    property BufferSize : integer read FBufferSize write SetBufferSize;
    property TimeOutRead : integer read FTimeOutRead write FTimeOutRead;
    property TimeOutWrite : integer read FTimeOutWrite write FTimeOutWrite;
    property OnReceived : TUDPReceivedEvent read FOnReceived write FOnReceived;
  end;

var
  WSAData : TWSAData;

implementation

{ TPacketUDP }

constructor TPacketUDP.Create(const AHost:string; APort:integer; AData:pointer; ASize:integer);
begin
  inherited Create;

  Host := AnsiString(AHost);
  Port := APort;
  Memory := TMemory.Create(AData, ASize);
end;

destructor TPacketUDP.Destroy;
begin
  if Memory <> nil then FreeAndNil(Memory);

  inherited;
end;

{ TUDPSocket }

constructor TUDPSocket.Create(AOwner: TComponent);
begin
  inherited;

  FSocket := -1;
  FActive := false;
  FIsServer := false;
  FBufferSize := 1024 * 1024;
  FTimeOutRead := 1;
  FTimeOutWrite := 5;

  GetMem(FBuffer, FBufferSize);

  FSendQueue := TDynamicQueue.Create(true);
  FRecvQueue := TSuspensionQueue<TPacketUDP>.Create;

  FMainThread := TSimpleThread.Create('TUDPSocket.FMainThread', on_FMainThread_Execute);
  FRecvThread := TSimpleThread.Create('TUDPSocket.FRecvThread', on_FRecvThread_Execute);

  RemoveThreadObject(FMainThread.Handle);
  SetThreadPriority(FMainThread.Handle, THREAD_PRIORITY_TIME_CRITICAL);
end;

destructor TUDPSocket.Destroy;
begin
  Stop;

  FMainThread.TerminateNow;

  FreeMem(FBuffer);

//  FreeAndNil(FSimpleThread);
//  FreeAndNil(FSendQueue);
//  FreeAndNil(FRecvQueue);

  inherited;
end;

function TUDPSocket.do_Bind: boolean;
var
  SockAddr : TSockAddr;
begin
  FillChar(SockAddr, SizeOf(TSockAddr), 0);
  SockAddr.sin_family := AF_INET;
  SockAddr.sin_port := htons(FPort);
  SockAddr.sin_addr.s_addr := htonl(INADDR_ANY);

  Result := bind(FSocket, SockAddr, sizeof(SockAddr)) > -1;
end;

procedure TUDPSocket.do_Receive;
var
  iBytes, iSizeOfAddr : integer;
  SockAddr : TSockAddr;
begin
  iSizeOfAddr := SizeOf(SockAddr);
  iBytes := recvfrom(FSocket, FBuffer^, FBufferSize, 0, SockAddr, iSizeOfAddr);

  if iBytes > 0 then
    FRecvQueue.Push(
      TPacketUDP.Create(String(inet_ntoa(SockAddr.sin_addr)), ntohs(SockAddr.sin_port), FBuffer, iBytes)
    );
end;

procedure TUDPSocket.do_Send;
var
  SockAddr : TSockAddr;
  PacketUDP : TPacketUDP;
begin
  if FSendQueue.Pop( Pointer(PacketUDP) ) = false then Exit;

  try
    FillChar(SockAddr, SizeOf(SockAddr), 0);

    SockAddr.sin_family := AF_INET;
    SockAddr.sin_port := htons(PacketUDP.Port);
    SockAddr.sin_addr.S_addr := inet_addr(PAnsiChar(PacketUDP.Host));

    if FSocket <> -1 then
      WinSock.SendTo(FSocket, PacketUDP.Memory.Data^, PacketUDP.Memory.Size, 0, SockAddr, SizeOf(TSockAddr));
  finally
    PacketUDP.Free;
  end;
end;

procedure TUDPSocket.on_FMainThread_Execute(ASimpleThread: TSimpleThread);
begin
  while ASimpleThread.Terminated = false do begin
    if FSocket = -1 then begin
      ASimpleThread.Sleep(5);
      Continue;
    end;

    try
      while FSendQueue.IsEmpty = false do do_Send;
      if FIsServer then do_Receive;
    except
      ASimpleThread.Sleep(5);
    end;
  end;
end;

procedure TUDPSocket.on_FRecvThread_Execute(ASimpleThread: TSimpleThread);
var
  PacketUDP : TPacketUDP;
begin
  while ASimpleThread.Terminated = false do begin
    PacketUDP := FRecvQueue.Pop;
    try
      if Assigned(FOnReceived) then
        FOnReceived(String(PacketUDP.Host), PacketUDP.Port, PacketUDP.Memory.Data, PacketUDP.Memory.Size);
    finally
      PacketUDP.Free;
    end;
  end;
end;

procedure TUDPSocket.SendTo(const AHost: string; APort: integer; AText: string);
var
  ssData : TStringStream;
begin
  ssData := TStringStream.Create;
  try
    ssData.WriteString(AText);
    SendTo(AHost, APort, ssData.Memory, ssData.Size);
  finally
    ssData.Free;
  end;
end;

procedure TUDPSocket.SendTo(const AHost: string; APort: integer; AData: pointer;
  ASize: integer);
begin
  if FSocket <> -1 then FSendQueue.Push( Pointer(TPacketUDP.Create(AHost, APort, AData, ASize)) );
end;

procedure TUDPSocket.SetBufferSize(const Value: integer);
begin
  if FSocket <> -1 then
    raise Exception.Create('Socket has opened.  Close it before you change this property.');

  FBufferSize := Value;

  FreeMem(FBuffer);
  GetMem(FBuffer, Value);
end;

procedure TUDPSocket.SetPort(const Value: integer);
begin
  if FSocket <> -1 then
    raise Exception.Create('Socket has opened.  Close it before you change this property.');

  FPort := Value;
end;

procedure TUDPSocket.Start(ANeedBinding:boolean);
var
  iBufferSize : integer;
  iTimeOutRead, iTimeOutWrite : Integer;
begin
  Stop;

  FIsServer := ANeedBinding;

  FSocket := socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP);
  if FSocket = -1 then
    raise Exception.Create('Can''t open Socket');

  iBufferSize := FBufferSize;
  setsockopt(FSocket, SOL_SOCKET, SO_SNDBUF, @iBufferSize, SizeOf(iBufferSize));
  setsockopt(FSocket, SOL_SOCKET, SO_RCVBUF, @iBufferSize, SizeOf(iBufferSize));

  iTimeOutRead := FTimeOutRead;
  setsockopt(FSocket, SOL_SOCKET, SO_RCVTIMEO, @iTimeOutRead, SizeOf(iTimeOutRead));

  iTimeOutWrite := FTimeOutWrite;
  setsockopt(FSocket, SOL_SOCKET, SO_SNDTIMEO, @iTimeOutWrite, SizeOf(iTimeOutWrite));

  if ANeedBinding then begin
    if FPort = 0 then begin
      FPort := $FFFF;
      while (FActive = false) and (FPort > 0) do begin
        FPort := FPort - 1;
        FActive := do_Bind;
      end;
    end else begin
      FActive := do_Bind;
    end;

    if not FActive then
      raise Exception.Create('The port is already using.');
  end;
end;

procedure TUDPSocket.Stop;
begin
  FActive := false;
  FIsServer := false;

  if FSocket <> -1 then begin
    closesocket(FSocket);
    FSocket := -1;
  end;
end;

initialization
  if WSAStartup($0202, WSAData) <> 0 then
    raise Exception.Create(SysErrorMessage(GetLastError));
finalization
  WSACleanup;
end.
