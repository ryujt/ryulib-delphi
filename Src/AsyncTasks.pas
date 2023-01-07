unit AsyncTasks;

interface

uses
  DebugTools,
  HandleComponent, ThreadPool,
  Windows, Messages, Classes, SysUtils;

type
  {*
    @param AUserData 사용자 정의 데이터 (외부에서 공유하는 포인터)
    @param ALocalData AsyncTask 내부의 전역변수처럼 사용한다. AProcedure,ACallBack 끼리 공유할 데이터가 있을 때 사용한다.
  *}
  TAsyncTaskProcedure = reference to procedure (AUserData:pointer; var ALocalData:pointer);

{* 스레드를 이용해서 AProcedure를 실행하고 완료하면 ACallBack을 메인 스레드에서 실행한다.
  @param AProcedure 내부 스레드를 이용해서 실행할 함수
  @param ACallBack AProcedure 처리가 완료되면 메인 스레드에서 실행되는 함수
  @param AUserData 사용자 정의 데이터
}
procedure AsyncTask(AProcedure,ACallBack:TAsyncTaskProcedure; AUserData:pointer=nil); overload;

{* 스레드에서 GUI 등을 접근하면 안되기 때문에 윈도우 메시지를 이용하여 ACallBack을 메인 스레드에서 실행한다.
}
procedure AsyncTask(ACallBack:TAsyncTaskProcedure; AUserData:pointer=nil); overload;

implementation

type
  TAsyncTaskData = class
  private
  public
    AsyncTaskProcedure : TAsyncTaskProcedure;
    CallBack : TAsyncTaskProcedure;
    LocalData : pointer;
    UserData : pointer;
  end;

  TAsyncTaskHandler = class (THandleComponent)
  private
    procedure do_WM_Handled(var AMsg:TMessage); message WM_USER;
  public
  end;

var
  AsyncTaskHandler : TAsyncTaskHandler = nil;

function InternalThreadFunction(lpThreadParameter: Pointer): Integer; stdcall;
var
  AsyncTaskData : TAsyncTaskData absolute lpThreadParameter;
begin
  Result := 0;
  try
    AsyncTaskData.AsyncTaskProcedure(AsyncTaskData.UserData, AsyncTaskData.LocalData);
    PostMessage(AsyncTaskHandler.Handle, WM_USER, Integer(AsyncTaskData), 0);
  except
    on E : Exception do Trace('AsyncTasks.AsyncTask() - ' + E.Message);
  end;
end;

procedure AsyncTask(AProcedure,ACallBack:TAsyncTaskProcedure; AUserData:pointer=nil);
var
  AsyncTaskData : TAsyncTaskData;
begin
  AsyncTaskData := TAsyncTaskData.Create;
  AsyncTaskData.AsyncTaskProcedure := AProcedure;
  AsyncTaskData.CallBack := ACallBack;
  AsyncTaskData.UserData := AUserData;
  QueueIOWorkItem(InternalThreadFunction, Pointer(AsyncTaskData));
end;

procedure AsyncTask(ACallBack:TAsyncTaskProcedure; AUserData:pointer=nil);
var
  AsyncTaskData : TAsyncTaskData;
begin
  AsyncTaskData := TAsyncTaskData.Create;
  AsyncTaskData.CallBack := ACallBack;
  AsyncTaskData.UserData := AUserData;
  PostMessage(AsyncTaskHandler.Handle, WM_USER, Integer(AsyncTaskData), 0);
end;

{ TAsyncTaskHandler }

procedure TAsyncTaskHandler.do_WM_Handled(var AMsg: TMessage);
var
  AsyncTaskData : TAsyncTaskData;
begin
  AsyncTaskData := Pointer(AMsg.WParam);
  try
    AsyncTaskData.CallBack(AsyncTaskData.UserData, AsyncTaskData.LocalData);
  finally
    AsyncTaskData.Free;
  end;
end;

initialization
  AsyncTaskHandler := TAsyncTaskHandler.Create(nil);
end.
