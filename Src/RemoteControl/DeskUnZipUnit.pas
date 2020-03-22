unit DeskUnZipUnit;

interface

uses
  DeskZipUtils, DeskUnZip,
  DebugTools, RyuLibBase, SuperSocketUtils, Scheduler, AsyncTasks,
  Windows, SysUtils, Classes, Graphics;

const
  TASK_DESKZIP = 1;

type
  TDeskUnZipUnit = class
  private
    FDeskUnZip: TDeskUnZip;
  private
    FScheduler: TScheduler;
    procedure on_DeskZip_task(Sender: TObject; ATask: integer; AText: string;
      AData: pointer; ASize: integer; ATag: integer);

    procedure do_execute(APacket: PPacket);
  private
    FOnDeskScreenIsReady: TNotifyEvent;
    function GetBitmapHeight: integer;
    function getBitmapWidth: integer;
    function GetHeight: integer;
    function GetWidth: integer;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Terminate;

    procedure Execute(APacket: PPacket);

    procedure GetBitmap(ABitmap: TBitmap);
  public
    property Width: integer read GetWidth;
    property Height: integer read GetHeight;

    property BitmapWidth: integer read getBitmapWidth;
    property BitmapHeight: integer read GetBitmapHeight;

    property OnDeskScreenIsReady : TNotifyEvent read FOnDeskScreenIsReady write FOnDeskScreenIsReady;
  end;

implementation

{ TDeskUnZipUnit }

constructor TDeskUnZipUnit.Create;
begin
  inherited;

  FDeskUnZip := TDeskUnZip.Create;

  FScheduler := TScheduler.Create;
  FScheduler.OnTask := on_DeskZip_task;
end;

destructor TDeskUnZipUnit.Destroy;
begin
  FreeAndNil(FDeskUnZip);
  FreeAndNil(FScheduler);

  inherited;
end;

procedure TDeskUnZipUnit.do_execute(APacket: PPacket);
begin
  try
    FDeskUnZip.Execute(pointer(APacket));
    if APacket^.PacketType = Byte(ftFrameEnd) then
      AsyncTask(
        procedure (AUserData:pointer) begin
          if Assigned(FOnDeskScreenIsReady) then FOnDeskScreenIsReady(Self);
        end
      );
  finally
    FreeMem(APacket);
  end;
end;

procedure TDeskUnZipUnit.Execute(APacket: PPacket);
begin
  FScheduler.Add(TASK_DESKZIP, APacket^.Clone);
end;

procedure TDeskUnZipUnit.GetBitmap(ABitmap: TBitmap);
begin
  FDeskUnZip.GetBitmap(ABitmap);
end;

function TDeskUnZipUnit.GetBitmapHeight: integer;
begin
  Result := FDeskUnZip.BitmapHeight;
end;

function TDeskUnZipUnit.getBitmapWidth: integer;
begin
  Result := FDeskUnZip.BitmapWidth;
end;

function TDeskUnZipUnit.GetHeight: integer;
begin
  Result := FDeskUnZip.Height;
end;

function TDeskUnZipUnit.GetWidth: integer;
begin
  Result := FDeskUnZip.Width;
end;

procedure TDeskUnZipUnit.on_DeskZip_task(Sender: TObject; ATask: integer;
  AText: string; AData: pointer; ASize, ATag: integer);
begin
  case ATask of
    TASK_DESKZIP: do_execute(AData);
  end;
end;

procedure TDeskUnZipUnit.Terminate;
begin
  FScheduler.TerminateNow;
end;

end.
