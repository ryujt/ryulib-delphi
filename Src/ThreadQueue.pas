unit ThreadQueue;

interface

uses
  Classes, SysUtils, SyncObjs;

type
  TIterateProcedure<T> = reference to procedure(AItem:T; var ANeedStop:boolean);

  TNode<T> = class
    Item : T;
    Next : TNode<T>;
  end;

  TThreadQueue<T> = class
  private
    FCS : TCriticalSection;
    FCount : integer;
    FEmpty : TNode<T>;
    FHead, FTail : TNode<T>;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Clear;
    procedure Push(AItem:T);
    function Peek:T;
    function Pop():boolean; overload;
    function Pop(var AItem:T):boolean; overload;

    procedure Iterate(AProcedure:TIterateProcedure<T>); overload;

    function IsEmpty: boolean;
    function Count: integer;
  end;

implementation

{ TThreadQueue<T> }

procedure TThreadQueue<T>.Clear;
var
  Node : TNode<T>;
begin
  FCS.Acquire;
  try
     while FHead <> nil do begin
       Node := FHead;
       FHead := FHead.Next;
       Node.Free;
     end;

    FTail := nil;
    FCount := 0;
  finally
    FCS.Release;
  end;
end;

function TThreadQueue<T>.Count: integer;
begin
  FCS.Acquire;
  try
    Result := FCount;
  finally
    FCS.Release;
  end;
end;

constructor TThreadQueue<T>.Create;
begin
  FEmpty := TNode<T>.Create;
  FHead := nil;
  FTail := nil;
  FCount := 0;

  FCS := TCriticalSection.Create;
end;

destructor TThreadQueue<T>.Destroy;
begin
  Clear;

  FreeAndNil(FCS);

  inherited;
end;

function TThreadQueue<T>.IsEmpty: boolean;
begin
  FCS.Acquire;
  try
    Result := FCount <= 0;
  finally
    FCS.Release;
  end;
end;

procedure TThreadQueue<T>.Iterate(AProcedure: TIterateProcedure<T>);
var
  Node : TNode<T>;
  NeedToStop : boolean;
begin
  NeedToStop := false;

  FCS.Acquire;
  try
     Node := FHead;
     while Node <> nil do begin
       AProcedure(Node.Item, NeedToStop);
       if NeedToStop then break;       
       Node := Node.Next;
     end;
  finally
    FCS.Release;
  end;
end;

function TThreadQueue<T>.Peek: T;
var
  Node : TNode<T>;
begin
  FCS.Acquire;
  try
     Node := FHead;
     if Node = nil then Node := FEmpty;
  finally
    FCS.Release;
  end;

  Result := Node.Item;
end;

function TThreadQueue<T>.Pop(var AItem: T): boolean;
var
  Node : TNode<T>;
begin
  Result := false;

  FCS.Acquire;
  try
     Node := FHead;
     Result := Node <> nil;

     if Result then begin
       FHead := FHead.Next;
       FCount := FCount - 1;
       AItem := Node.Item;
       Node.Free;
     end else begin
       Node := FEmpty;
       AItem := Node.Item;
     end;
  finally
    FCS.Release;
  end;
end;

function TThreadQueue<T>.Pop: boolean;
var
  Node : TNode<T>;
begin
  Result := false;

  FCS.Acquire;
  try
     Node := FHead;
     Result := Node <> nil;

     if Result then begin
       FHead := FHead.Next;
       FCount := FCount - 1;
       Node.Free;
     end;
  finally
    FCS.Release;
  end;
end;

procedure TThreadQueue<T>.Push(AItem: T);
var
  Node : TNode<T>;
begin
  Node := TNode<T>.Create;
  Node.Item := AItem;
  Node.Next := nil;

  FCS.Acquire;
  try
    if FHead = nil then begin
      FHead := Node;
    end else begin
      FTail.Next := Node;
    end;

    FTail := Node;

    FCount := FCount + 1;
  finally
    FCS.Release;
  end;
end;

end.
