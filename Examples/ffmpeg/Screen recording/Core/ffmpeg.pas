unit ffmpeg;

interface

uses
  CoreBase,
  SysUtils, Classes;

type
  Tffmpeg = class (TCoreBase, Iffmpeg)
  private
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Start;
    procedure Stop;

    procedure WriteAudio(AData:pointer; ASize:integer);
    procedure WriteVideo(AData:pointer; ASize:integer);
  end;

implementation

{ Tffmpeg }

constructor Tffmpeg.Create(AOwner: TComponent);
begin
  inherited;

end;

destructor Tffmpeg.Destroy;
begin

  inherited;
end;

procedure Tffmpeg.Start;
begin

end;

procedure Tffmpeg.Stop;
begin

end;

procedure Tffmpeg.WriteAudio(AData: pointer; ASize: integer);
begin

end;

procedure Tffmpeg.WriteVideo(AData: pointer; ASize: integer);
begin

end;

end.
