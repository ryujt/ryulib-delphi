unit TaskQueue;

interface

uses
  DebugTools, RyuLibBase, SimpleThread, SuspensionQueue,
  SysUtils, Classes;

type
  TTaskEnvet = procedure (ASender:Tobject; const AData:pointer) of object;

  {*
    처리해야 할 작업을 큐에 넣고 차례로 실행한다.
    작업의 실행은 내부의 스레드를 이용해서 비동기로 실행한다.
    작업 요청이 다양한 스레드에서 진행되는데, 순차적인 동작이 필요 할 때 사용한다.
  }
  TTaskQueue = class
  private
    FQueue : TSuspensionQueue<pointer>;
  private
    FSimpleThread : TSimpleThread;
    procedure on_FSimpleThread_Execute(ASimpleThread:TSimpleThread);
  private
    FOnTask: TTaskEnvet;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Add(AData:pointer);
  public
    property OnTask : TTaskEnvet read FOnTask write FOnTask;
  end;

implementation

procedure TTaskQueue.Add(AData:pointer);
begin
  FQueue.Push(Adata);
end;

constructor TTaskQueue.Create;
begin
  inherited;

  FQueue := TSuspensionQueue<pointer>.Create;
  FSimpleThread := TSimpleThread.Create('TTaskQueue', on_FSimpleThread_Execute);
end;

destructor TTaskQueue.Destroy;
begin
  FSimpleThread.Terminate;
  FSimpleThread.WakeUp;

  inherited;
end;

procedure TTaskQueue.on_FSimpleThread_Execute(ASimpleThread: TSimpleThread);
var
  item : pointer;
begin
  while ASimpleThread.Terminated = false do begin
    item := FQueue.Pop;
    try
      if Assigned(FOnTask) then FOnTask(Self, item);
    except
      on E: Exception do Trace('TTaskQueue.on_FSimpleThread_Execute - ' + E.Message);
    end;
  end;

  FreeAndNil(FQueue);
  FreeAndNil(FSimpleThread);
end;

end.



