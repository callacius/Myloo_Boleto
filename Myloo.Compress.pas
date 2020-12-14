unit Myloo.Compress;

interface

uses
  System.Classes,
  System.SysUtils,
  System.Zip,
  Myloo.Compress.GZIPUtils,
  Winapi.Windows,
  System.ZLib;

type
  TCompressType = ( ctUnknown, ctZLib, ctGZip, ctZipFile );

function DetectCompressType(AStream: TStream): TCompressType;

// Decompress: Deflate, GZip or ZLib, ZipFile
function DeCompress(const ABinaryString: AnsiString): AnsiString; overload;
function DeCompress(AStream: TStream): AnsiString; overload;
function DeCompress(inStream, outStream: TStream): Boolean; overload;

// Compress: Deflate
function ZLibCompress(const ABinaryString: AnsiString;
                  level: Tcompressionlevel = cldefault): AnsiString; overload;
function ZLibCompress(AStream: TStream;
                  level: Tcompressionlevel = cldefault): AnsiString; overload;
function ZLibCompress(inStream, outStream: TStream;
                  level: Tcompressionlevel = cldefault): Boolean; overload;

// Compress: GZip
function GZipCompress(const ABinaryString: AnsiString): AnsiString; overload;
function GZipCompress(AStream: TStream): AnsiString; overload;
function GZipCompress(inStream, outStream: TStream): Boolean; overload;

// Compress: ZipFile
function ZipFileCompress(const ABinaryString: AnsiString; AFileName: String = 'filename'): AnsiString; overload;
function ZipFileCompress(AStream: TStream; AFileName: String = 'filename'): AnsiString; overload;
function ZipFileCompress(inStream, outStream: TStream; AFileName: String = 'filename'): Boolean; overload;

// DeCompress: ZipFile
function ZipFileDeCompress(const ABinaryString: AnsiString): AnsiString; overload;
function ZipFileDeCompress(AStream: TStream): AnsiString; overload;
function ZipFileDeCompress(inStream, outStream: TStream): Boolean; overload;

implementation

uses
  synautil;

function DetectCompressType(AStream: TStream): TCompressType;
var
  hdr: LongWord;
  OldPos: Int64;
begin
  hdr := 0;
  OldPos := AStream.Position;
  AStream.Position := 0;
  AStream.ReadBuffer(hdr, 4);
  AStream.Position := OldPos;

  if (hdr and $88B1F) = $88B1F then
    Result := ctGZip
  else if (hdr and $9C78) = $9C78 then
    Result := ctZLib
  else if (hdr and $4034B50) = $4034B50 then
    Result := ctZipFile
  else
    Result := ctUnknown;
end;

function DeCompress(const ABinaryString: AnsiString): AnsiString;
var
  MS: TMemoryStream;
begin
  MS := TMemoryStream.Create;
  try
    WriteStrToStream(MS, ABinaryString);
    MS.Position := 0;
    Result := DeCompress(MS);
  Finally
    MS.Free;
  end;
end;

function DeCompress(AStream: TStream): AnsiString;
var
  outMemStream: TMemoryStream;
begin
  outMemStream := TMemoryStream.Create;
  try
    AStream.Position := 0;
    DeCompress(AStream, outMemStream);

    outMemStream.Position := 0;
    Result := ReadStrFromStream(outMemStream, outMemStream.Size);
  Finally
    outMemStream.Free;
  end;
end;

function DeCompress(inStream, outStream: TStream): Boolean;
begin
  if (DetectCompressType(inStream) = ctZipFile) then
    Result := ZipFileDeCompress(inStream, outStream)
  else
    Result := Myloo.Compress.GZIPUtils.unzipStream(inStream, outStream)
end;

function ZLibCompress(const ABinaryString: AnsiString; level: Tcompressionlevel): AnsiString;
var
  MS: TMemoryStream;
begin
  MS := TMemoryStream.Create;
  try
    WriteStrToStream(MS, ABinaryString);
    MS.Position := 0;
    Result := ZLibCompress(MS, level);
  Finally
    MS.Free;
  end;
end;

function ZLibCompress(AStream: TStream; level: Tcompressionlevel): AnsiString;
var
  outMemStream: TMemoryStream;
begin
  outMemStream := TMemoryStream.Create;
  try
    AStream.Position := 0;
    ZLibCompress(AStream, outMemStream, level);
    outMemStream.Position := 0;
    Result := ReadStrFromStream(outMemStream, outMemStream.Size);
  Finally
    outMemStream.Free;
  end;
end;

function ZLibCompress(inStream, outStream: TStream; level: Tcompressionlevel): Boolean;
var
  cs: Tcompressionstream;
begin
  cs := Tcompressionstream.create(level, outStream);
  try
    cs.CopyFrom(inStream, inStream.Size);
  Finally
    cs.Free;
  end;
  Result := True;
end;

function GZipCompress(const ABinaryString: AnsiString): AnsiString;
var
  MS: TMemoryStream;
begin
  MS := TMemoryStream.Create;
  try
    WriteStrToStream(MS, ABinaryString);
    MS.Position := 0;
    Result := GZipCompress(MS);
  Finally
    MS.Free;
  end;
end;

function GZipCompress(AStream: TStream): AnsiString;
var
  outMemStream: TMemoryStream;
begin
  outMemStream := TMemoryStream.Create;
  try
    AStream.Position := 0;
    GZipCompress(AStream, outMemStream);
    outMemStream.Position := 0;
    Result := ReadStrFromStream(outMemStream, outMemStream.Size);
  Finally
    outMemStream.Free;
  end;
end;

function GZipCompress(inStream, outStream: TStream): Boolean;
begin
   Result := Myloo.Compress.GZIPUtils.zipStream(inStream, outStream, cldefault, zsGZip);
end;

function ZipFileCompress(const ABinaryString: AnsiString; AFileName: String): AnsiString;
var
  MS: TMemoryStream;
begin
  MS := TMemoryStream.Create;
  try
    WriteStrToStream(MS, ABinaryString);
    MS.Position := 0;
    Result := ZipFileCompress(MS, AFileName);
  Finally
    MS.Free;
  end;
end;

function ZipFileCompress(AStream: TStream; AFileName: String): AnsiString;
var
  outMemStream: TMemoryStream;
begin
  outMemStream := TMemoryStream.Create;
  try
    AStream.Position := 0;
    ZipFileCompress(AStream, outMemStream, AFileName);
    outMemStream.Position := 0;
    Result := ReadStrFromStream(outMemStream, outMemStream.Size);
  Finally
    outMemStream.Free;
  end;
end;

function ZipFileCompress(inStream, outStream: TStream; AFileName: String): Boolean;
var
  z: TZipFile;
begin
  z := TZipFile.Create;
  try
    z.Open(outStream, zmWrite);
    z.Add(inStream, AFileName);
    z.Close;
    Result := True;
  Finally
    z.Free;
  end;
end;

function ZipFileDeCompress(const ABinaryString: AnsiString): AnsiString;
var
  MS: TMemoryStream;
begin
  MS := TMemoryStream.Create;
  try
    WriteStrToStream(MS, ABinaryString);
    MS.Position := 0;
    Result := ZipFileDeCompress(MS);
  Finally
    MS.Free;
  end;
end;

function ZipFileDeCompress(AStream: TStream): AnsiString;
var
  outMemStream: TMemoryStream;
begin
  outMemStream := TMemoryStream.Create;
  try
    AStream.Position := 0;
    ZipFileDeCompress(AStream, outMemStream);
    outMemStream.Position := 0;
    Result := ReadStrFromStream(outMemStream, outMemStream.Size);
  Finally
    outMemStream.Free;
  end;
end;

function ZipFileDeCompress(inStream, outStream: TStream): Boolean;
var
  Z: TZipFile;
  s: TStream;
  h: TZipHeader;
begin
  z := TZipFile.Create;
  try
    z.Open(inStream, zmRead);
    z.Read(0, s, h);
    try
      outStream.CopyFrom(s, s.Size);
      Result := True;
    Finally
      s.Free;
    end;
  Finally
    z.Free;
  end;
end;

end.


