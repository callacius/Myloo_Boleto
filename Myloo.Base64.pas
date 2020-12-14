unit Myloo.Base64;

interface

uses
  System.SysUtils,
  System.StrUtils,
  System.Classes,
  Soap.EncdDecd;

type
  TBase64 = class
    class Function EncodeFile(const FileName: string): AnsiString;
    class procedure DecodeFile(const base64: AnsiString; const FileName: string);
    class Function DecodeforStream(const base64: AnsiString): TStream; static;

  end;


implementation

{ TBase64 }

class Function TBase64.EncodeFile(const FileName: string): AnsiString;
var
  stream: TMemoryStream;
begin
  stream := TMemoryStream.Create;
  try
    stream.LoadFromFile(Filename);
    result := EncodeBase64(stream.Memory, stream.Size);
  Finally
    stream.Free;
  end;
end;

class procedure TBase64.DecodeFile(const base64: AnsiString; const FileName: string);
var
  stream: TBytesStream;
begin
  stream := TBytesStream.Create(DecodeBase64(base64));
  try
    stream.SaveToFile(Filename);
  Finally
    stream.Free;
  end;
end;

class Function TBase64.DecodeforStream(const base64: AnsiString): TStream;
begin
  Result := TBytesStream.Create(DecodeBase64(base64));
end;

end.
