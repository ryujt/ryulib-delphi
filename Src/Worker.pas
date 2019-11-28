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
    FSimpleThread : TSimpleThread;
    procedure on_FSimpleThread_execute(ASimpleThread:TSimpleThread);
  private
    FOnTask: TWorkerEvent;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Add(ATask:integer); overload;
    procedure Add(AText:string); overload;
    procedure Add(ATask:integer; AText:string); overload;
    procedure Add(ATask:integer; AData:pointer); overload;
    procedure Add(ATask:integer; AText:string; AData:pointer; ASize,ATag:integer); overload;
  public
    property OnTask : TWorkerEvent read FOnTask write FOnTask;
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

constructor TWorker.Create;
begin
  inherited;

  FQueue := TSuspensionQueue<TTaskOfWorker>.Create;
  FSimpleThread := TSimpleThread.Create('Worker', on_FSimpleThread_execute);
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
end;

end.
