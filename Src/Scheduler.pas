unit Scheduler;

interface

uses
  DebugTools, RyuLibBase, ThreadQueue, SimpleThread,
  Windows, SysUtils, Classes, SyncObjs;

type
  TWorkerEvent = procedure (Sender:TObject; ATask:integer; AText:string; AData:pointer; ASize:integer; ATag:integer) of object;

  TTaskOfScheduler = class
  private
    FTask : integer;
    FText : string;
    FData : pointer;
    FSize : integer;
    FTag : integer;
  public
    constructor Create(ATask:integer; AText:string; AData:pointer; ASize,ATag:integer); reintroduce;
  end;

  TScheduler = class
  private
    FIsStarted : boolean;
    FQueue : TThreadQueue<TTaskOfScheduler>;
    procedure do_clear;
  private
    FSimpleThread : TSimpleThread;
    procedure on_FSimpleThread_execute(ASimpleThread:TSimpleThread);
  private
    FOnTask: TWorkerEvent;
    FOnRepeat: TNotifyEvent;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Terminate;
    procedure TerminateNow;
    procedure TerminateAndWait;

    procedure Sleep(ATimeOut:DWORD);

    procedure Start;
    procedure Stop;

    procedure Add(ATask:integer); overload;
    procedure Add(AText:string); overload;
    procedure Add(ATask:integer; AText:string); overload;
    procedure Add(ATask:integer; AData:pointer); overload;
    procedure Add(ATask:integer; AText:string; AData:pointer; ASize,ATag:integer); overload;
  public
    property OnTask : TWorkerEvent read FOnTask write FOnTask;
    property OnRepeat : TNotifyEvent read FOnRepeat write FOnRepeat;
  end;

implementation

{ TTaskOfScheduler }

constructor TTaskOfScheduler.Create(ATask: integer; AText: string; AData: pointer;
  ASize, ATag: integer);
begin
  FTask := ATask;
  FText := AText;
  FData := AData;
  FSize := ASize;
  FTag := ATag;
end;

{ TScheduler }

procedure TScheduler.Add(ATask:integer; AText: string);
begin
  FQueue.Push(TTaskOfScheduler.Create(ATask, AText, nil, 0, 0));
  FSimpleThread.WakeUp;
end;

procedure TScheduler.Add(ATask: integer);
begin
  FQueue.Push(TTaskOfScheduler.Create(ATask, '', nil, 0, 0));
  FSimpleThread.WakeUp;
end;

procedure TScheduler.Add(ATask: integer; AText: string; AData: pointer; ASize,
  ATag: integer);
begin
  FQueue.Push(TTaskOfScheduler.Create(ATask, AText, AData, ASize, ATag));
  FSimpleThread.WakeUp;
end;

procedure TScheduler.Add(AText: string);
begin
  FQueue.Push(TTaskOfScheduler.Create(0, AText, nil, 0, 0));
  FSimpleThread.WakeUp;
end;

procedure TScheduler.Add(ATask: integer; AData: pointer);
begin
  FQueue.Push(TTaskOfScheduler.Create(ATask, '', AData, 0, 0));
  FSimpleThread.WakeUp;
end;

constructor TScheduler.Create;
begin
  inherited;

  FIsStarted := false;

  FQueue := TThreadQueue<TTaskOfScheduler>.Create;
  FSimpleThread := TSimpleThread.Create('Scheduler', on_FSimpleThread_execute);
  FSimpleThread.FreeOnTerminate := false;
end;

destructor TScheduler.Destroy;
begin
  TerminateNow;

  inherited;
end;

procedure TScheduler.do_clear;
var
  task : TTaskOfScheduler;
begin
  while FQueue.Pop(task) do task.Free;  
end;

procedure TScheduler.on_FSimpleThread_execute(ASimpleThread: TSimpleThread);
var
  task : TTaskOfScheduler;
begin
  while ASimpleThread.Terminated = false do begin
    if FQueue.Pop(task) then begin
      try
        if Assigned(FOnTask) then FOnTask(Self, task.FTask, task.FText, task.FData, task.FSize, task.FTag);
      finally
        task.Free;
      end;
    end;

    if FIsStarted then begin
      if Assigned(FOnRepeat) then FOnRepeat(Self)
      else ASimpleThread.Sleep(1);
    end else begin
      ASimpleThread.Sleep(1);
    end;
  end;

  FreeAndNil(FQueue);
  FreeAndNil(FSimpleThread);
end;

procedure TScheduler.Sleep(ATimeOut: DWORD);
begin
  FSimpleThread.Sleep(ATimeOut);
end;

procedure TScheduler.Start;
begin
  FIsStarted := true;
end;

procedure TScheduler.Stop;
begin
  FIsStarted := false;
end;

procedure TScheduler.Terminate;
begin
  FSimpleThread.Terminate;
end;

procedure TScheduler.TerminateAndWait;
begin
  FSimpleThread.TerminateAndWait;
end;

procedure TScheduler.TerminateNow;
begin
  FSimpleThread.TerminateNow;
end;

end.
