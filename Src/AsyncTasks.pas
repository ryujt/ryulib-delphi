unit AsyncTasks;

interface

uses
  DebugTools,
  HandleComponent, ThreadPool,
  Windows, Messages, Classes, SysUtils;

type
  {*
    @param AUserData ����� ���� ������ (�ܺο��� �����ϴ� ������)
    @param ALocalData AsyncTask ������ ��������ó�� ����Ѵ�. AProcedure,ACallBack ���� ������ �����Ͱ� ���� �� ����Ѵ�.
  *}
  TAsyncTaskProcedure = reference to procedure (AUserData:pointer; var ALocalData:pointer);

{* �����带 �̿��ؼ� AProcedure�� �����ϰ� �Ϸ��ϸ� ACallBack�� ���� �����忡�� �����Ѵ�.
  @param AProcedure ���� �����带 �̿��ؼ� ������ �Լ�
  @param ACallBack AProcedure ó���� �Ϸ�Ǹ� ���� �����忡�� ����Ǵ� �Լ�
  @param AUserData ����� ���� ������
}
procedure AsyncTask(AProcedure,ACallBack:TAsyncTaskProcedure; AUserData:pointer=nil); overload;

{* �����忡�� GUI ���� �����ϸ� �ȵǱ� ������ ������ �޽����� �̿��Ͽ� ACallBack�� ���� �����忡�� �����Ѵ�.
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
