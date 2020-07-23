unit Worker;

interface

uses
  DebugTools, RyuLibBase, SuspensionQueue, SimpleThread,
  Windows, SysUtils, Classes, SyncObjs;

type
  TWorkerEvent = procedure (Sender:TObject; ATask:integer; AText:string; AData:pointer; ASize:integer; ATag:integer) of object;

  TTaskOfWorker = class
  private
    FTask : integer;
    FText : string;
    FData : pointer;
    FSize : integer;
    FTag : integer;
  public
    constructor Create(ATask:integer; AText:string; AData:pointer; ASize,ATag:integer); reintroduce;
  end;

  TWorker = class
  private
    FQueue : TSuspensionQueue<TTaskOfWorker>;
  private
    FSimpleThread : TSimpleThread;
    procedure on_FSimpleThread_execute(ASimpleThread:TSimpleThread);
  private
    FOnTask: TWorkerEvent;
    FOnTerminated: TNotifyEvent;
  public
    constructor Create(ATag:string='Woker'); reintroduce;
    destructor Destroy; override;

    procedure TerminateNow;
    procedure Terminate;
    procedure TerminateAndWait;

    procedure Add(ATask:integer); overload;
    procedure Add(AText:string); overload;
    procedure Add(ATask:integer; AText:string); overload;
    procedure Add(ATask:integer; AData:pointer); overload;
    procedure Add(ATask:integer; AText:string; AData:pointer; ASize,ATag:integer); overload;
  public
    property OnTask : TWorkerEvent read FOnTask write FOnTask;
    property OnTerminated : TNotifyEvent read FOnTerminated write FOnTerminated;
  end;

implementation

{ TTaskOfWorker }

constructor TTaskOfWorker.Create(ATask: integer; AText: string; AData: pointer;
  ASize, ATag: integer);
begin
  FTask := ATask;
  FText := AText;
  FData := AData;
  FSize := ASize;
  FTag := ATag;
end;

{ TWorker }

procedure TWorker.Add(ATask:integer; AText: string);
begin
  FQueue.Push(TTaskOfWorker.Create(ATask, AText, nil, 0, 0));
end;

procedure TWorker.Add(ATask: integer);
begin
  FQueue.Push(TTaskOfWorker.Create(ATask, '', nil, 0, 0));
end;

procedure TWorker.Add(ATask: integer; AText: string; AData: pointer; ASize,
  ATag: integer);
begin
  FQueue.Push(TTaskOfWorker.Create(ATask, AText, AData, ASize, ATag));
end;

procedure TWorker.Add(AText: string);
begin
  FQueue.Push(TTaskOfWorker.Create(0, AText, nil, 0, 0));
end;

procedure TWorker.Add(ATask: integer; AData: pointer);
begin
  FQueue.Push(TTaskOfWorker.Create(ATask, '', AData, 0, 0));
end;

constructor TWorker.Create(ATag:string='Woker');
begin
  inherited Create;

  FQueue := TSuspensionQueue<TTaskOfWorker>.Create;
  FSimpleThread := TSimpleThread.Create(ATag, on_FSimpleThread_execute);
  FSimpleThread.FreeOnTerminate := false;
end;

destructor TWorker.Destroy;
begin
  FSimpleThread.TerminateNow;
  FreeAndNil(FQueue);
  FreeAndNil(FSimpleThread);

  inherited;
end;

procedure TWorker.on_FSimpleThread_execute(ASimpleThread: TSimpleThread);
var
  task : TTaskOfWorker;
begin
  while ASimpleThread.Terminated = false do begin
    task := FQueue.Pop;
    if Assigned(FOnTask) then FOnTask(Self, task.FTask, task.FText, task.FData, task.FSize, task.FTag);
  end;

  if Assigned(FOnTerminated) then FOnTerminated(Self);
end;

procedure TWorker.Terminate;
begin
  FSimpleThread.Terminate;
end;

procedure TWorker.TerminateAndWait;
begin
  FSimpleThread.Terminate(INFINITE);
end;

procedure TWorker.TerminateNow;
begin
  FSimpleThread.TerminateNow;
  if Assigned(FOnTerminated) then FOnTerminated(Self);
end;

end.
