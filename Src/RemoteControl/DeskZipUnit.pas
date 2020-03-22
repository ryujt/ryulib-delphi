unit DeskZipUnit;

interface

uses
  Config,
  DeskZipUtils, DeskZip,
  DebugTools, Scheduler,
  Windows, SysUtils, Classes, Graphics, Forms;

const
  TASK_PREPARE = 1;
  TASK_EXECUTE = 2;

type
  TDataEvent = procedure (Sender:TObject; AData:pointer) of object;

  TDeskZipUnit = class
  private
    FDeskZip: TDeskZip;
  private
    FScheduler: TScheduler;
    procedure on_DeskZip_repeat(Sender: TObject);
    procedure on_DeskZip_task(Sender: TObject; ATask: integer; AText: string;
      AData: pointer; ASize: integer; ATag: integer);

    procedure do_prepare(AMonitorIndex: integer);
    procedure do_execute;
  private
    FOnData: TDataEvent;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Terminate;

    procedure Prepare(AMonitorIndex: integer);
    procedure Execute;
  public
    property OnData : TDataEvent read FOnData write FOnData;
  end;

implementation

{ TDeskZipUnit }

constructor TDeskZipUnit.Create;
begin
  inherited;

  FDeskZip := nil;

  FScheduler := TScheduler.Create;
  FScheduler.OnRepeat := on_DeskZip_repeat;
  FScheduler.OnTask := on_DeskZip_task;
end;

destructor TDeskZipUnit.Destroy;
begin
  if FDeskZip <> nil then FDeskZip.Free;

  FreeAndNil(FScheduler);

  inherited;
end;

procedure TDeskZipUnit.do_execute;
var
  frame: PFrameBase;
begin
  if FDeskZip = nil then Exit;

  FDeskZip.Execute(0, 0);
  frame := FDeskZip.GetDeskFrame;
  while frame <> nil do begin
    if Assigned(FOnData) then FOnData(Self, pointer(frame));
    frame := FDeskZip.GetDeskFrame;
  end;
end;

procedure TDeskZipUnit.do_prepare(AMonitorIndex: integer);
begin
  if FDeskZip <> nil then FDeskZip.Free;

  FDeskZip := TDeskZip.Create;
  FDeskZip.setSpeed(SPEED_FAST);
  FDeskZip.Prepare(Screen.Monitors[AMonitorIndex].Width, Screen.Monitors[AMonitorIndex].Height);
end;

procedure TDeskZipUnit.Execute;
begin
  FScheduler.Add(TASK_EXECUTE);
end;

procedure TDeskZipUnit.on_DeskZip_repeat(Sender: TObject);
begin
  //
end;

procedure TDeskZipUnit.on_DeskZip_task(Sender: TObject; ATask: integer;
  AText: string; AData: pointer; ASize, ATag: integer);
begin
  try
    case ATask of
      TASK_PREPARE: do_prepare(ATag);
      TASK_EXECUTE: do_execute;
    end;
  except
    // TODO: 에러 처리
    on E : Exception do Trace('TDeskZipUnit.do_execute');
  end;
end;

procedure TDeskZipUnit.Prepare(AMonitorIndex: integer);
begin
  FScheduler.Add(TASK_PREPARE, '', nil, 0, AMonitorIndex);
end;

procedure TDeskZipUnit.Terminate;
begin
  FScheduler.TerminateNow;
end;

end.
