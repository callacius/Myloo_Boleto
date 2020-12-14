unit Myloo.Imaging;

interface

uses
  System.SysUtils,
  System.StrUtils,
  System.Classes,
  Soap.EncdDecd,
  Vcl.Graphics,
  Vcl.Imaging.pngimage,
  Vcl.Imaging.jpeg,
  Vcl.Imaging.GIFImg,
  System.NetEncoding;

Type
  TImgBase64 = class
  public
    class Function BitmapFromBase64(const base64: string):TBitmap;
    class Function Base64FromBitmap(Img: TBitmap):string;
    class Function PngFromBase64(const base64: string):TPNGImage;
    class Function Base64FromPng(Img: TPNGImage):string;
    class Function JpegFromBase64(const base64: string):TJPEGImage;
    class Function Base64FromJpeg(Img: TJPEGImage):string;
  end;


implementation

{ TImgBase64 }

class Function TImgBase64.Base64FromBitmap(Img: TBitmap): string;
var
  Input: TBytesStream;
  Output: TStringStream;
begin
  Input := TBytesStream.Create;
  try
    Img.SaveToStream(Input);
    Input.Position := 0;
    Output := TStringStream.Create('', TEncoding.ASCII);
    try
      Soap.EncdDecd.EncodeStream(Input, Output);
      Result := Output.DataString;
    Finally
      Output.Free;
    end;
  Finally
    Input.Free;
  end;
end;

class Function TImgBase64.Base64FromJpeg(Img: TJPEGImage): string;
var
  Input: TBytesStream;
  Output: TStringStream;
begin
  Input := TBytesStream.Create;
  try
    Img.SaveToStream(Input);
    Input.Position := 0;
    Output := TStringStream.Create('', TEncoding.ASCII);
    try
      Soap.EncdDecd.EncodeStream(Input, Output);
      Result := Output.DataString;
    Finally
      Output.Free;
    end;
  Finally
    Input.Free;
  end;
end;

class Function TImgBase64.Base64FromPng(Img: TPNGImage): string;
var
  Input: TBytesStream;
  Output: TStringStream;
begin
  Input := TBytesStream.Create;
  try
    Img.SaveToStream(Input);
    Input.Position := 0;
    Output := TStringStream.Create('', TEncoding.ASCII);
    try
      Soap.EncdDecd.EncodeStream(Input, Output);
      Result := Output.DataString;
    Finally
      Output.Free;
    end;
  Finally
    Input.Free;
  end;
end;

class Function TImgBase64.BitmapFromBase64(const base64: string): TBitmap;
var
  Input: TStringStream;
  Output: TBytesStream;
begin
  Input := TStringStream.Create(base64, TEncoding.ASCII);
  try
    Output := TBytesStream.Create;
    try
      Soap.EncdDecd.DecodeStream(Input, Output);
      Output.Position := 0;
      Result := TBitmap.Create;
      try
        Result.LoadFromStream(Output);
      except
        Result.Free;
        raise;
      end;
    Finally
      Output.Free;
    end;
  Finally
    Input.Free;
  end;
end;

class Function TImgBase64.JpegFromBase64(const base64: string): TJPEGImage;
var
  Input: TStringStream;
  Output: TBytesStream;
begin
  Input := TStringStream.Create(base64, TEncoding.ASCII);
  try
    Output := TBytesStream.Create;
    try
      Soap.EncdDecd.DecodeStream(Input, Output);
      Output.Position := 0;
      Result := TJPEGImage.Create;
      try
        Result.LoadFromStream(Output);
      except
        Result.Free;
        raise;
      end;
    Finally
      Output.Free;
    end;
  Finally
    Input.Free;
  end;
end;

class Function TImgBase64.PngFromBase64(const base64: string): TPNGImage;
var
  Input: TStringStream;
  Output: TBytesStream;
begin
  Input := TStringStream.Create(base64, TEncoding.ASCII);
  try
    Output := TBytesStream.Create;
    try
      Soap.EncdDecd.DecodeStream(Input, Output);
      Output.Position := 0;
      Result := TPNGImage.Create;
      try
        Result.LoadFromStream(Output);
      except
        Result.Free;
        raise;
      end;
    Finally
      Output.Free;
    end;
  Finally
    Input.Free;
  end;
end;

end.
