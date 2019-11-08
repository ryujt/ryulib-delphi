unit JsonData;

interface

uses
  DebugTools,
  System.JSON, System.Generics.Collections,
  Windows, Classes, SysUtils;

type
  TJSONValueClass = class of TJSONValue;

  TJSONValueHelper = class helper for TJSONValue
  private
    function GetValueAsBoolean(AName: string): boolean;
    function GetValueAsString(AName: string): string;
    function GetValueAsInt(AName: string): integer;
    function GetValueAsJson(AName: string): TJSONValue;
    procedure SetValueAsBoolean(AName: string; const Value: boolean);
    procedure SetValueAsInt(AName: string; const Value: integer);
    procedure SetValueAsJson(AName: string; const Value: TJSONValue);
    procedure SetValueAsString(AName: string; const Value: string);
  public
    class function LoadFromFile(AFileName: string): TJSONValue;
    procedure SaveToFile(AFileName: string);
  public
    property ValueAsJson[AName: string]: TJSONValue read GetValueAsJson write SetValueAsJson;
    property ValueAsInt[AName: string]: integer read GetValueAsInt write SetValueAsInt;
    property ValueAsString[AName: string]: string read GetValueAsString write SetValueAsString;
    property ValueAsBoolean[AName: string]: boolean read GetValueAsBoolean write SetValueAsBoolean;
  end;

  TJsonData = class
  private
    FJSONObject: TJSONObject;
    function GetText: string;
    procedure SetText(const Value: string);
    function GetBooleans(AName: string): boolean;
    function GetDoubles(AName: string): double;
    function GetInt64s(AName: string): int64;
    function GetIntegers(AName: string): integer;
    procedure SetBooleans(AName: string; const Value: boolean);
    procedure SetDoubles(AName: string; const Value: double);
    procedure SetInt64s(AName: string; const Value: int64);
    procedure SetIntegers(AName: string; const Value: integer);
    function GetValues(AName: string): string;
    procedure SetValues(AName: string; const Value: string);
    function GetCount: integer;
    function GetNames(Index: integer): string;
  public
    constructor Create; overload;
    constructor Create(AJsonObject: TJSONObject); overload;
    constructor Create(AText: string); overload;
    destructor Destroy; override;

    procedure LoadFromFile(AFileName: string);
    procedure SaveToFile(AFileName: string);

    function GetJsonData(const AName: string): TJsonData; overload;
    function GetJsonData(AIndex: integer): TJsonData; overload;

    function GetJsonText(const AName: string): string; overload;
    function GetJsonText(AIndex: integer): string; overload;

    procedure SetJsonData(AName, AText: string);

    procedure Delete(AIndex: integer); overload;
    procedure Delete(AName: string); overload;

    property Names[Index: integer]: string read GetNames;
    property Values[AName: string]: string read GetValues write SetValues;

    property Integers[AName: string]: integer read GetIntegers write SetIntegers;
    property Int64s[AName: string]: int64 read GetInt64s write SetInt64s;
    property Doubles[AName: string]: double read GetDoubles write SetDoubles;
    property Booleans[AName: string]: boolean read GetBooleans write SetBooleans;

    property Count: integer read GetCount;
    property Text: string read GetText write SetText;
  end;

procedure StringsToJson(const AText, ADelimiter: string; const AJsonData: TJsonData); overload;
function StringsToJson(const AText, ADelimiter: string): string; overload;

implementation

procedure StringsToJson(const AText, ADelimiter: string; const AJsonData: TJsonData);
var
  i: integer;
  lines: TStringList;
  name, Value: string;
begin
  lines := TStringList.Create;
  try
    lines.StrictDelimiter := true;
    lines.Delimiter := '/';
    lines.DelimitedText := AText;

    for i := 0 to lines.Count - 1 do
    begin
      if Pos('=', lines[i]) = 0 then
        Continue;

      name := lines.Names[i];
      Value := lines.ValueFromIndex[i];

      // TODO: escape 문자가 오류를 일으키고 있어서 / 로 치환해서 임시 처리
      Value := StringReplace(Value, '\', '/', [rfReplaceAll]);

      AJsonData.Values[name] := Value;

{$IFDEF DEBUG}
      // Trace( Format('name: %s, value: %s - %s', [name, value, AJsonData.Text]) );
{$ENDIF}
    end;
  finally
    lines.Free;
  end;
end;

function StringsToJson(const AText, ADelimiter: string): string;
var
  JsonData: TJsonData;
begin
  Result := '';

  JsonData := TJsonData.Create;
  try
    StringsToJson(AText, ADelimiter, JsonData);
    Result := JsonData.Text;
  finally
    JsonData.Free;
  end;
end;

{ TResponseData }

constructor TJsonData.Create;
begin
  inherited;

  FJSONObject := nil;
end;

constructor TJsonData.Create(AJsonObject: TJSONObject);
begin
  inherited Create;

  FJSONObject := TJSONObject(AJsonObject.Clone);
end;

procedure TJsonData.Delete(AIndex: integer);
begin
  FJSONObject.RemovePair(GetNames(AIndex));
end;

constructor TJsonData.Create(AText: string);
begin
  FJSONObject := TJSONObject(TJSONObject.ParseJSONValue(AText));
end;

procedure TJsonData.Delete(AName: string);
begin
  FJSONObject.RemovePair(AName);
end;

destructor TJsonData.Destroy;
begin
  if FJSONObject <> nil then
    FreeAndNil(FJSONObject);

  inherited;
end;

function TJsonData.GetBooleans(AName: string): boolean;
var
  Pair: TJSONPair;
begin
  Result := False;
  if FJSONObject = nil then
    Exit;

  Pair := FJSONObject.Get(AName);
  if Pair <> nil then
    Result := TJSONNumber(Pair.JSONValue).AsInt = 1;
end;

function TJsonData.GetDoubles(AName: string): double;
var
  Pair: TJSONPair;
begin
  Result := 0;
  if FJSONObject = nil then
    Exit;

  Pair := FJSONObject.Get(AName);
  if Pair <> nil then
    Result := TJSONNumber(Pair.JSONValue).AsDouble;
end;

function TJsonData.GetInt64s(AName: string): int64;
var
  Pair: TJSONPair;
begin
  Result := 0;
  if FJSONObject = nil then
    Exit;

  Pair := FJSONObject.Get(AName);
  if Pair <> nil then
    Result := TJSONNumber(Pair.JSONValue).AsInt64;
end;

function TJsonData.GetIntegers(AName: string): integer;
var
  Pair: TJSONPair;
begin
  Result := 0;
  if FJSONObject = nil then
    Exit;

  Pair := FJSONObject.Get(AName);
  if Pair <> nil then
    Result := TJSONNumber(Pair.JSONValue).AsInt;
end;

function TJsonData.GetJsonData(const AName: string): TJsonData;
var
  Pair: TJSONPair;
begin
  Result := TJsonData.Create;
  if FJSONObject = nil then
    Exit;

  Pair := FJSONObject.Get(AName);
  if Pair <> nil then
    Result.Text := TJSONObject(Pair.JSONValue).ToString;
end;

function TJsonData.GetJsonText(const AName: string): string;
var
  JsonData: TJsonData;
begin
  JsonData := GetJsonData(AName);
  try
    Result := JsonData.Text;
  finally
    JsonData.Free;
  end;
end;

function TJsonData.GetNames(Index: integer): string;
begin
  Result := '';
  if FJSONObject = nil then
    Exit;

  Result := TJSONPair(FJSONObject.Pairs[Index]).JsonString.Value;
end;

function TJsonData.GetCount: integer;
begin
  Result := 0;
  if FJSONObject = nil then
    Exit;

  Result := FJSONObject.Count
end;

function TJsonData.GetText: string;
begin
  Result := '';
  if FJSONObject = nil then
    Exit;

  Result := FJSONObject.ToString
end;

function TJsonData.GetValues(AName: string): string;
var
  Pair: TJSONPair;
begin
  Result := '';
  try
    if FJSONObject = nil then
      Exit;

    Pair := FJSONObject.Get(AName);
    if (Pair <> nil) and (Pair.JSONValue <> nil) then
      Result := Pair.JSONValue.Value;
  except
    on E: Exception do
      Trace(Format('TJsonData.GetValues - %s', [E.Message]));
  end;
end;

procedure TJsonData.LoadFromFile(AFileName: string);
var
  List: TStringList;
begin
  List := TStringList.Create;
  try
    if FileExists(AFileName) then
    begin
      List.LoadFromFile(AFileName);
      SetText(List.Text);
    end
    else
    begin
      SetText('');
    end;
  finally
    List.Free;
  end;
end;

procedure TJsonData.SaveToFile(AFileName: string);
var
  List: TStringList;
begin
  List := TStringList.Create;
  try
    List.Text := Text;
    List.SaveToFile(AFileName);
  finally
    List.Free;
  end;
end;

procedure TJsonData.SetBooleans(AName: string; const Value: boolean);
var
  Pair: TJSONPair;
begin
  if FJSONObject = nil then
  begin
    FJSONObject := TJSONObject.Create;
    FJSONObject.AddPair(AName, TJSONNumber.Create(integer(Value)));
    Exit;
  end;

  Pair := FJSONObject.RemovePair(AName);
  if Assigned(Pair) then
    FreeAndNil(Pair);
  FJSONObject.AddPair(AName, TJSONNumber.Create(integer(Value)));
end;

procedure TJsonData.SetDoubles(AName: string; const Value: double);
var
  Pair: TJSONPair;
begin
  if FJSONObject = nil then
  begin
    FJSONObject := TJSONObject.Create;
    FJSONObject.AddPair(AName, TJSONNumber.Create(Value));
    Exit;
  end;

  Pair := FJSONObject.RemovePair(AName);
  if Assigned(Pair) then
    FreeAndNil(Pair);
  FJSONObject.AddPair(AName, TJSONNumber.Create(Value));
end;

procedure TJsonData.SetInt64s(AName: string; const Value: int64);
var
  Pair: TJSONPair;
begin
  if FJSONObject = nil then
  begin
    FJSONObject := TJSONObject.Create;
    FJSONObject.AddPair(AName, TJSONNumber.Create(Value));
    Exit;
  end;

  Pair := FJSONObject.RemovePair(AName);
  if Assigned(Pair) then
    FreeAndNil(Pair);
  FJSONObject.AddPair(AName, TJSONNumber.Create(Value));
end;

procedure TJsonData.SetIntegers(AName: string; const Value: integer);
var
  Pair: TJSONPair;
begin
  if FJSONObject = nil then
  begin
    FJSONObject := TJSONObject.Create;
    FJSONObject.AddPair(AName, TJSONNumber.Create(Value));
    Exit;
  end;

  Pair := FJSONObject.RemovePair(AName);
  if Assigned(Pair) then
    FreeAndNil(Pair);
  FJSONObject.AddPair(AName, TJSONNumber.Create(Value));
end;

procedure TJsonData.SetJsonData(AName, AText: string);
var
  Pair: TJSONPair;
begin
  if FJSONObject = nil then
  begin
    FJSONObject := TJSONObject.Create;
    FJSONObject.AddPair(AName, TJSONObject(TJSONObject.ParseJSONValue(AText)));
    Exit;
  end;

  Pair := FJSONObject.RemovePair(AName);
  if Assigned(Pair) then
    FreeAndNil(Pair);
  FJSONObject.AddPair(AName, TJSONObject(TJSONObject.ParseJSONValue(AText)));
end;

procedure TJsonData.SetText(const Value: string);
begin
  if Assigned(FJSONObject) then
    FJSONObject.Free;
  FJSONObject := TJSONObject(TJSONObject.ParseJSONValue(Value));
end;

procedure TJsonData.SetValues(AName: string; const Value: string);
var
  Pair: TJSONPair;
begin
  if FJSONObject = nil then
  begin
    FJSONObject := TJSONObject.Create;
    FJSONObject.AddPair(AName, Value);
    Exit;
  end;

  Pair := FJSONObject.RemovePair(AName);
  if Assigned(Pair) then
    FreeAndNil(Pair);
  FJSONObject.AddPair(AName, TJSONString.Create(Value));
end;

{ TJSONValueHelper }

function TJSONValueHelper.GetValueAsJson(AName: string): TJSONValue;
var
  Pair: TJSONPair;
begin
  Result := nil;
  if Self is TJSONObject then
  begin
    try
      Pair := TJSONObject(Self).Get(AName);
      if Pair <> nil then
      begin
        Result := Pair.JSONValue;
      end;
    except
    end;
  end;
end;

function TJSONValueHelper.GetValueAsBoolean(AName: string): boolean;
var
  Pair: TJSONPair;
begin
  Result := False;
  if Self is TJSONObject then
  begin
    try
      Pair := TJSONObject(Self).Get(AName);
      if Pair <> nil then
      begin
        if Pair.JSONValue is TJSONNumber then
          Result := TJSONNumber(Pair.JSONValue).AsInt = 1
        else
          Result := Pair.JSONValue is TJSONTrue;
      end;
    except
    end;
  end;
end;

function TJSONValueHelper.GetValueAsInt(AName: string): integer;
var
  Pair: TJSONPair;
begin
  Result := 0;

  if Self is TJSONObject then
  begin
    try
      Pair := TJSONObject(Self).Get(AName);
      if (Pair <> nil) then
        Result := StrToIntDef(Pair.JSONValue.Value, 0);
    except
    end;
  end;
end;

function TJSONValueHelper.GetValueAsString(AName: string): string;
var
  Pair: TJSONPair;
begin
  Result := '';

  if Self is TJSONObject then
  begin
    try
      Pair := TJSONObject(Self).Get(AName);
      if Pair <> nil then
        Result := Pair.JSONValue.Value;
    except
    end;
  end;
end;

class function TJSONValueHelper.LoadFromFile(AFileName: string): TJSONValue;
var
  Buffer: TStringList;
begin
  Result := nil;

  if FileExists(AFileName) then
  begin
    Buffer := TStringList.Create;
    try
      Buffer.LoadFromFile(AFileName);
      Result := TJSONObject.ParseJSONValue(Buffer.GetText);
    finally
      Buffer.Free;
    end;
  end;
end;

procedure TJSONValueHelper.SaveToFile(AFileName: string);
var
  Buffer: TStringList;
begin
  Buffer := TStringList.Create;
  try
    Buffer.Text := ToString;
    Buffer.SaveToFile(AFileName);
  finally
    Buffer.Free;
  end;
end;

procedure TJSONValueHelper.SetValueAsBoolean(AName: string; const Value: boolean);
var
  Pair: TJSONPair;
  NewValueClass: TJSONValueClass;
begin
  if Self is TJSONObject then
  begin
    if Value then
      NewValueClass := TJSONTrue
    else
      NewValueClass := TJSONFalse;

    with TJSONObject(Self) do
    begin
      Pair := RemovePair(AName);
      if Pair <> nil then
        Pair.Free;
      AddPair(AName, NewValueClass.Create);
    end;
  end;
end;

procedure TJSONValueHelper.SetValueAsInt(AName: string; const Value: integer);
var
  Pair: TJSONPair;
  NewValue: TJSONValue;
begin
  if Self is TJSONObject then
  begin
    NewValue := TJSONNumber.Create(Value);
    with TJSONObject(Self) do
    begin
      Pair := RemovePair(AName);
      if Pair <> nil then
        Pair.Free;
      AddPair(AName, NewValue);
    end;
  end;
end;

procedure TJSONValueHelper.SetValueAsJson(AName: string; const Value: TJSONValue);
var
  Pair: TJSONPair;
  NewValue: TJSONValue;
begin
  if Self is TJSONObject then
  begin
    NewValue := Value;
    with TJSONObject(Self) do
    begin
      Pair := RemovePair(AName);
      if Pair <> nil then
        Pair.Free;
      AddPair(AName, NewValue);
    end;
  end;
end;

procedure TJSONValueHelper.SetValueAsString(AName: string; const Value: string);
var
  Pair: TJSONPair;
  NewValue: TJSONValue;
begin
  if Self is TJSONObject then
  begin
    NewValue := TJSONString.Create(Value);
    with TJSONObject(Self) do
    begin
      Pair := RemovePair(AName);
      if Pair <> nil then
        Pair.Free;
      AddPair(AName, NewValue);
    end;
  end;
end;

function TJsonData.GetJsonData(AIndex: integer): TJsonData;
var
  Pair: TJSONPair;
begin
  Result := TJsonData.Create;
  if FJSONObject = nil then
    Exit;

  Pair := FJSONObject.Pairs[AIndex];
  if Pair <> nil then
    Result.Text := TJSONObject(Pair.JSONValue).ToString;
end;

function TJsonData.GetJsonText(AIndex: integer): string;
var
  JsonData: TJsonData;
begin
  JsonData := GetJsonData(AIndex);
  try
    Result := JsonData.Text;
  finally
    JsonData.Free;
  end;
end;

end.
