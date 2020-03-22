unit RemoteControlUtils;

interface

uses
  SuperSocketUtils,
  Classes, SysUtils;

type
  TPacketType = (
    ptNone=100,

    ptConnectionID,

    ptSetConnectionID,  // 클라이언트 쪽에서 서버(화면공유자)의 ID를 이용해서 서로의 ID를 교환하여 연결한다.
    ptErPeerConnected,  // 잘못된 서버(화면공유자)의 ID로 연결 시도 하였다.
    ptPeerConnected,    // 서버(화면공유자)와 클라이언트(원격조정자)가 연결되었다.
    ptPeerDisconnected, // 상대방의 접속이 끊어졌다.

    ptKeyDown, ptKeyUp,
    ptMouseDown, ptMouseMove, ptMouseUp
  );

  TConnectionIDPacket = packed record
    PacketSize : word;
    PacketType : TPacketType;
    ID : integer;
  end;
  PConnectionIDPacket = ^TConnectionIDPacket;

  TRemoteControlPacket = packed record
    PacketSize : word;
    PacketType : TPacketType;
    Key : word;
    X, Y : integer;
  end;
  PRemoteControlPacket = ^TRemoteControlPacket;

implementation

end.
