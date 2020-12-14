unit Myloo.Boleto.Utils;

interface

Uses
  SysUtils,
  Math,
  Classes,
  Myloo.Consts,
  IniFiles,
  StrUtils,
  DateUtils,
  Windows,
  ShellAPI,
  Forms;

const
{$IFDEF CPU64}
  CINPOUTDLL = 'inpoutx64.dll';
{$ELSE}
  CINPOUTDLL = 'inpout32.dll';
{$ENDIF}
  AllFilesMask = '*.*';
type
  TSetOfChars = set of AnsiChar;
  TFormatMask = (msk4x2, msk7x2, msk9x2, msk10x2, msk13x2, msk15x2, msk6x3, msk6x4, mskAliq);
  TFindFileSortType = (fstNone, FstDateTime, FstFileName);
  TFindFileSortDirection = (fsdNone, FsdAscending, FsdDescending);

  TSplitResult = array of string;
   TLibHandle = THandle;

function ParseText( const Texto : AnsiString; const Decode : Boolean = True;
   const IsUTF8: Boolean = True) : String;

function LerTagXML( const AXML, ATag: String; IgnoreCase: Boolean = True) : String;
function XmlEhUTF8(const AXML: String): Boolean;
function ConverteXMLtoUTF8(const AXML: String): String;
function ConverteXMLtoNativeString(const AXML: String): String;
function ObtemDeclaracaoXML(const AXML: String): String;
function RemoverDeclaracaoXML(const AXML: String): String;

function Split(const ADelimiter: Char; const AString: string): TSplitResult;
function DecodeToString( const ABinaryString : AnsiString; const StrIsUTF8: Boolean ) : String ;
function SeparaDados( const AString : String; const Chave : String; const MantemChave : Boolean = False ) : String;
function SeparaDadosArray( const AArray : Array of String;const AString : String; const MantemChave : Boolean = False ) : String;
function RetornarConteudoEntre(const Frase, Inicio, Fim: String; IncluiInicioFim: Boolean = False): string;
procedure EncontrarInicioFinalTag(aText, ATag: ansistring;
  var PosIni, PosFim: integer;const PosOffset: integer = 0);

procedure QuebrarLinha(const Alinha: string; const ALista: TStringList;
  const QuoteChar: char = '"'; Delimiter: char = ';');

function Str( const AString : String ) : String ;
function StrToAnsi( const AString : String ) : String ;

function NativeStringToUTF8( AString : String ) : AnsiString;
function UTF8ToNativeString( AUTF8String : AnsiString ) : String;

function NativeStringToAnsi( AString : String ) : AnsiString;
function AnsiToNativeString( AAnsiString : AnsiString ) : String;

function UTF8ToAnsi( AUTF8String : AnsiString ) : AnsiString;
function AnsiToUTF8( AAnsiString : AnsiString ) : AnsiString;

function AnsiChr( b: Byte) : AnsiChar;

function ComparaValor(const ValorUm, ValorDois : Double; const Tolerancia : Double = 0 ): Integer;

function TestBit(const Value: Integer; const Bit: Byte): Boolean;
function IntToBin (value: LongInt; digits: integer ): string;
function BinToInt(Value: String): LongInt;

Function BcdToAsc( const StrBCD : AnsiString) : String ;
Function AscToBcd( const ANumStr: String ; const TamanhoBCD : Byte) : AnsiString ;

function IntToLEStr(AInteger: Integer; BytesStr: Integer = 2): AnsiString;
function LEStrToInt(ALEStr: AnsiString): Integer;
function IntToBEStr(AInteger: Integer; BytesStr: Integer = 2): AnsiString;
function BEStrToInt(ABEStr: AnsiString): Integer;

Function HexToAscii(const HexStr : String) : AnsiString ;
Function AsciiToHex(const ABinaryString: AnsiString): String;

function BinaryStringToString(const AString: AnsiString): AnsiString;
function StringToBinaryString(const AString: AnsiString): AnsiString;

function PadRight(const AString : String; const nLen : Integer;
   const Caracter : Char = ' ') : String;
function PadLeft(const AString : String; const nLen : Integer;
   const Caracter : Char = ' ') : String;
function PadCenter(const AString : String; const nLen : Integer;
   const Caracter : Char = ' ') : String;

function RemoveString(const sSubStr, sString: String): String;
function RemoveStrings(const AText: AnsiString; StringsToRemove: array of AnsiString): AnsiString;
function RemoverEspacosDuplos(const AString: String): String;
function StripHTML(const AHTMLString : String) : String;
procedure AcharProximaTag(const AString: String;
  const PosIni: Integer; var ATag: String; var PosTag: Integer);
procedure RemoveEmptyLines( AStringList: TStringList) ;
function RandomName(const LenName : Integer = 8) : String ;

function PosEx(const SubStr, S: AnsiString; Offset: Cardinal = 1): Integer;

  type TRoundToRange = -37..37;
  Function RoundTo(const AValue: Double; const ADigit: TRoundToRange): Double;
  Function SimpleRoundTo(const AValue: Double; const ADigit: TRoundToRange = -2): Double;

function IfEmptyThen( const AValue, DefaultValue: String; DoTrim: Boolean = True) : String;
function PosAt(const SubStr, S: AnsiString; Ocorrencia : Cardinal = 1): Integer;
function RPos(const aSubStr, aString : AnsiString; const aStartPos: Integer): Integer; overload;
function RPos(const aSubStr, aString : AnsiString): Integer; overload;
function PosLast(const SubStr, S: AnsiString): Integer;
function CountStr(const AString, SubStr : String ) : Integer ;
Function Poem_Zeros(const Texto : String; const Tamanho : Integer) : String; overload;
function Poem_Zeros(const NumInteiro : Int64 ; Tamanho : Integer) : String ; overload;
function RemoveZerosEsquerda( ANumStr: String): String;

Function IntToStrZero(const NumInteiro : Int64; Tamanho : Integer) : String;
function FloatToIntStr(const AValue: Double; const DecimalDigits: SmallInt = 2): String;
function FloatToString(const AValue: Double; SeparadorDecimal: Char = '.';
  AFormat: String = ''): String;
function FormatFloatBr(const AValue: Extended; AFormat: String = ''): String; overload;
function FormatFloatBr(const AFormat: TFormatMask; const AValue: Extended): String; overload;
function FloatMask(const DecimalDigits: SmallInt = 2; UseThousandSeparator: Boolean = True): String;
Function StringToFloat( NumString : String ) : Double ;
Function StringToFloatDef( const NumString : String ;
   const DefaultValue : Double ) : Double ;

function FormatDateBr(const ADateTime: TDateTime; AFormat: String = ''): String;
function FormatDateTimeBr(const ADate: TDateTime; AFormat: String = ''): String;
Function StringToDateTime( const DateTimeString : String;
   const Format : String = '') : TDateTime ;
Function StringToDateTimeDef( const DateTimeString : String ;
   const DefaultValue : TDateTime; const Format : String = '') : TDateTime ;
function StoD( YYYYMMDDhhnnss: String) : TDateTime;
function DtoS( ADate : TDateTime) : String;
function DTtoS( ADateTime : TDateTime) : String;

function Iso8601ToDateTime(const AISODate: string): TDateTime;
function DateTimeToIso8601(ADate: TDateTime; ATimeZone: string = ''): string;

function StrIsAlpha(const S: String): Boolean;
function StrIsAlphaNum(const S: String): Boolean;
function StrIsNumber(const S: String): Boolean;
function StrIsHexa(const S: String): Boolean;
function CharIsAlpha(const C: Char): Boolean;
function CharIsAlphaNum(const C: Char): Boolean;
function CharIsNum(const C: Char): Boolean;
function CharIsHexa(const C: Char): Boolean;
function OnlyNumber(const AValue: String): String;
function OnlyAlpha(const AValue: String): String;
function OnlyAlphaNum(const AValue: String): String;
function OnlyCharsInSet(const AValue: String; SetOfChars: TSetOfChars): String;

function StrIsIP(const AValue: String): Boolean;

function EstaVazio(const AValue: String): Boolean;overload;
procedure EstaVazio(const AValue, AMensagem: String);overload;
function NaoEstaVazio(AValue: String): Boolean;
function EstaZerado(AValue: Double): Boolean;overload;
function EstaZerado(AValue: Integer): Boolean;overload;
procedure EstaZerado(AValue: Integer; AMensagem: String);overload;
function NaoEstaZerado(AValue: Double): Boolean;overload;
function NaoEstaZerado(AValue: Integer): Boolean;overload;
function TamanhoIgual(const AValue: String; const ATamanho: Integer): Boolean;overload;
procedure TamanhoIgual(const AValue: String; const ATamanho: Integer; AMensagem: String);overload;
function TamanhoIgual(const AValue: Integer; const ATamanho: Integer): Boolean;overload;
procedure TamanhoIgual(const AValue: Integer; const ATamanho: Integer; AMensagem: String);overload;
function TamanhoMenor(const AValue: String; const ATamanho: Integer): Boolean;

function TiraAcentos( const AString : String ) : String ;
function TiraAcento( const AChar : AnsiChar ) : AnsiChar ;

function AjustaLinhas(const Texto: AnsiString; Colunas: Integer ;
   NumMaxLinhas: Integer = 0; PadLinhas: Boolean = False): AnsiString;
function QuebraLinhas(const Texto: String; const Colunas: Integer;
   const CaracterQuebrar : AnsiChar = ' '): String;

function TraduzComando( const AString : String ) : AnsiString ;
Function StringToAsc( const AString : AnsiString ) : String ;
Function AscToString( const AString : String ) : AnsiString ;

function InPort(const PortAddr:word): byte;
procedure OutPort(const PortAddr: word; const Databyte: byte); overload ;

function StrCrypt(const AString, StrChave: AnsiString): AnsiString;
function SomaAscII(const AString : AnsiString): Integer;
function StringCrc16(const AString : AnsiString ) : word;

function ApplicationPath: String;
Procedure FindFiles( const FileMask : String; AStringList : TStrings;
  IncludePath : Boolean = True;
  SortType: TFindFileSortType = FstNone;
  SortDirection: TFindFileSortDirection = FsdNone ) ;
Function FilesExists(const FileMask: String) : Boolean ;
Procedure DeleteFiles(const FileMask: String; RaiseExceptionOnFail : Boolean = True)  ;
Procedure TryDeleteFile(const AFile: String; WaitTime: Integer = 1000)  ;
function CopyFileTo(const AFromFileName, AToFileName : String;
   const AFailIfExists : Boolean = False) : Boolean;
Function PathWithDelim( const APath : String ) : String ;
Function PathWithoutDelim( const APath : String ) : String ;
Procedure CopyFilesToDir( FileMask : String ; ToDirName : String;
   const ForceDirectory : Boolean = False)  ;
procedure RunCommand(const Command: String; const Params: String = '';
   Wait : Boolean = False; WindowState : Word = 5);
procedure OpenURL( const URL : String ) ;

function FunctionDetect (LibName, FuncName: String; var LibPointer: Pointer)
 : boolean; overload ;
function FunctionDetect (LibName, FuncName: String; var LibPointer: Pointer;
   var LibHandle: TLibHandle ): boolean; overload ;
function UnLoadLibrary(LibName: String ): Boolean ;

function FlushToDisk(const sFile: string): boolean;
function FlushFileToDisk(const sFile: string): boolean;

Procedure DesligarMaquina(Reboot: Boolean = False; Forcar: Boolean = False;
   LogOff: Boolean = False) ;
function TranslateUnprintable( const ABinaryString: AnsiString ): String;

function TiraPontos(Str: string): string;
function TBStrZero(const i: string; const Casas: byte): string;
function Space(Tamanho: Integer): string;
function LinhaSimples(Tamanho: Integer): string;
function LinhaDupla(Tamanho: Integer): string;

function TranslateString(const S: AnsiString; CP_Destino: Word; CP_Atual: Word = 0): AnsiString;
function MatchText(const AText: String; const AValues: array of String): Boolean;

function FindDelimiterInText( const AText: String; ADelimiters: String = ''): Char;
function AddDelimitedTextToList( const AText: String; const ADelimiter: Char;
   AStringList: TStrings; const AQuoteChar: Char = '"'): Integer;

function UnZip(S: TStream): AnsiString; overload;
function UnZip(const ABinaryString: AnsiString): AnsiString; overload;
function Zip(AStream: TStream): AnsiString; overload;
function Zip(const ABinaryString: AnsiString): AnsiString; overload;

function ChangeLineBreak(const AText: String; NewLineBreak: String = ';'): String;

function IsWorkingDay(ADate: TDateTime): Boolean;
function WorkingDaysBetween(StartDate,EndDate: TDateTime): Integer;
function IncWorkingDay(ADate: TDateTime; WorkingDays: Integer): TDatetime;

procedure LerIniArquivoOuString(const IniArquivoOuString: AnsiString; AMemIni: TMemIniFile);

var xInp32 : Function (wAddr: word): byte; stdcall;
var xOut32 : Function (wAddr: word; bOut: byte): byte; stdcall;
var xBlockInput : Function (Block: BOOL): BOOL; stdcall;

var InpOutLoaded: Boolean;
var BlockInputLoaded: Boolean;

procedure LoadInpOut;
procedure LoadBlockInput;

implementation

Uses
  synautil,
  Myloo.Compress;

var
  Randomized : Boolean ;

{-------------------------------------------------------------------------------
Procedure para trocar a quebra de linha por um caracter separador
-------------------------------------------------------------------------------}
function ChangeLineBreak(const AText: String; NewLineBreak: String = ';'): String;
begin
  Result := AText;
  if Trim(Result) <> '' then
  begin
    // Troca todos CR+LF para apenas LF
    Result := StringReplace(Result, CRLF, LF, [rfReplaceAll]);

    // Se existe apenas CR, também troca os mesmos para LF
    Result := StringReplace(Result, CR, LF, [rfReplaceAll]);

    { Agora temos todas quebras como LF... Se a Quebra de linha Final For
      diferente de LF, aplique a substituição }
    if NewLineBreak <> LF then
      Result := StringReplace(Result, LF, NewLineBreak, [rfReplaceAll]);
  end
end;

{-----------------------------------------------------------------------------
  Retornar True, se a Data For de Segunda a Sexta-feira. Falso para Sábado e Domingo
 -----------------------------------------------------------------------------}
function IsWorkingDay(ADate: TDateTime): Boolean;
begin
  Result := (DayOfWeek(ADate) in [2..6]);
end;

{-----------------------------------------------------------------------------
  Retornar o total de dias úteis em um período de datas, exceto Feriados.
 -----------------------------------------------------------------------------}
function WorkingDaysBetween(StartDate, EndDate: TDateTime): Integer;
var
  ADate: TDateTime;
begin
  Result := 0;
  if (StartDate <= 0) then
    exit;

  ADate  := IncDay(StartDate, 1);
  while (ADate <= EndDate) do
  begin
    if IsWorkingDay(ADate) then
      Inc(Result);

    ADate := IncDay(ADate, 1)
  end;
end;

{-----------------------------------------------------------------------------
  Retornar uma data calculando apenas dias úteis, a partir de uma data inicial,
  exceto Feriados.
 -----------------------------------------------------------------------------}
function IncWorkingDay(ADate: TDateTime; WorkingDays: Integer): TDatetime;
var
  DaysToIncrement, WorkingDaysAdded: Integer;

  Function GetNextWorkingDay(ADate: TDateTime): TDateTime;
  begin
    Result := ADate;
    while not IsWorkingDay(Result) do
      Result := IncDay(Result, DaysToIncrement);
  end;

begin
  DaysToIncrement := ifthen(WorkingDays < 0,-1,1);

  if (WorkingDays = 0) then
    Result := GetNextWorkingDay(ADate)
  else
  begin
    Result := ADate;
    WorkingDaysAdded := 0;

    while (WorkingDaysAdded <> WorkingDays) do
    begin
      Result := GetNextWorkingDay( IncDay(Result, DaysToIncrement) );
      WorkingDaysAdded := WorkingDaysAdded + DaysToIncrement;
    end;
  end;
end;

{-----------------------------------------------------------------------------
  Todos os Fontes usam Encoding CP1252, para manter compatibilidade com
  D5 a D2007, Porém D2009 e superiores usam Unicode, e Lazarus 0.9.27 ou superior,
  usam UTF-8. A Função abaixo converte a "AString" de ANSI CP1252, para UNICODE
  ou UTF8, de acordo com as diretivas do Compilador
 -----------------------------------------------------------------------------}
function Str( const AString : String ) : String ;
begin
  Result := AString
end ;

{-----------------------------------------------------------------------------
   Todos os Fontes usam Encoding CP1252, para manter compatibilidade com
  D5 a D2007, Porém D2009 e superiores usam Unicode, e Lazarus 0.9.27 ou superior,
  usam UTF-8. A Função abaixo, Converte a AString de UTF8 ou Unicode para a página
  de código nativa do Sistema Operacional, (apenas se o Compilador usar UNICODE)
 -----------------------------------------------------------------------------}
function StrToAnsi( const AString: String): String;
begin
  Result := AString
end;

{-----------------------------------------------------------------------------
  Converte a AString nativa do Compilador, para UTF8, de acordo o suporte a
  UNICODE/UTF8 do Compilador
 -----------------------------------------------------------------------------}
function NativeStringToUTF8( AString : String ) : AnsiString;
begin
  Result := UTF8Encode(AString);
end;

function UTF8ToNativeString(AUTF8String: AnsiString): String;
begin
  Result := UTF8ToString(AUTF8String);
end;

function NativeStringToAnsi(AString: String): AnsiString;
begin
  Result := AnsiString(AString);
end;

function AnsiToNativeString(AAnsiString: AnsiString): String;
begin
  Result := String(AAnsiString);
end;

{-----------------------------------------------------------------------------
  Converte uma String que está em UTF8 para ANSI, considerando as diferetes IDEs
  suportadas
 -----------------------------------------------------------------------------}
function UTF8ToAnsi( AUTF8String : AnsiString ) : AnsiString;
begin
    Result := AnsiString( UTF8ToNativeString(AUTF8String));
end;

{-----------------------------------------------------------------------------
  Converte uma String que está em ANSI para UTF8, considerando as diferetes IDEs
  suportadas
 -----------------------------------------------------------------------------}
function AnsiToUTF8(AAnsiString: AnsiString): AnsiString;
begin
    Result := NativeStringToUTF8(String(AAnsiString));
end;

{-----------------------------------------------------------------------------
 Faz o mesmo que o comando chr(), porém retorna um AnsiChar ao invés de Char
 Util quando For usada para compor valores em AnsiString,
 veja exemplos nesse mesmo Fonte...
 -----------------------------------------------------------------------------}
function AnsiChr(b: Byte): AnsiChar;
begin
  Result := AnsiChar(chr(b));
end;


{-----------------------------------------------------------------------------
Compara valores levando em conta uma Tolerancia que pode ser aplicada
tanto para positivo quando negativo.
Retorna -1 se ValorUm For menor; 1 Se ValorUm For maior; 0 - Se Forem iguais
Inspirada em "CompareValue" do FPC, math
------------------------------------------------------------------------------}
function ComparaValor(const ValorUm, ValorDois: Double;
  const Tolerancia: Double): Integer;
var
  diff: Extended;
begin
 Result := 1;

 diff := SimpleRoundTo( abs(ValorUm - ValorDois), -9);
 if diff <= Tolerancia then
   Result := 0
  else
    if ValorUm < ValorDois then
      Result := -1;
end;

{-----------------------------------------------------------------------------
 *** Adaptado de JclLogic.pas  - Project JEDI Code Library (JCL) ***
 Retorna True se o nBit está ativo (ligado) dentro do valor Value. Inicia em 0
 ---------------------------------------------------------------------------- }
function TestBit(const Value: Integer; const Bit: Byte): Boolean;
Var Base : Byte ;
begin
  Base := (Trunc(Bit/8)+1) * 8 ;
  Result := (Value and (1 shl (Bit mod Base))) <> 0;
end;

{-----------------------------------------------------------------------------
 Extraido de  http://delphi.about.com/od/mathematics/a/baseconvert.htm (Zago)
 Converte um Inteiro para uma string com a representação em Binário
 4,4 = '0100'; 15,4 = '1111'; 100,8 = '01100100'; 255,8 = '11111111'
 -----------------------------------------------------------------------------}
function IntToBin ( value: LongInt; digits: integer ): string;
begin
  Result := StringOfChar( '0', digits ) ;
  while value > 0 do
  begin
    if ( value and 1 ) = 1 then
      result [ digits ] := '1';

    dec ( digits ) ;
    value := value shr 1;
  end;
end;

{-----------------------------------------------------------------------------
 converte uma String com a representação de Binário para um Inteiro
 '0100' = 4; '1111' = 15; '01100100' = 100; '11111111' = 255
 -----------------------------------------------------------------------------}
function BinToInt(Value: String): LongInt;
var
  L, I, B: Integer;
begin
  Result := 0;

  // remove zeros a esquerda
  while Copy(Value,1,1) = '0' do
    Value := Copy(Value,2,Length(Value)-1) ;

  L := Length(Value);
  For I := L downto 1 do
  begin
    if Value[I] = '1' then
    begin
      B := (1 shl (L-I));
      Result := Result + B ;
    end;
  end;
end;

{-----------------------------------------------------------------------------
  Converte uma String no Formato BCD para uma String que pode ser convertida em
  Integer ou Double.  // Adaptada do manual da Bematech //   Exemplo:
  - Se uma variável retornada For de 9 bytes BCD, e seu valor For R$ 1478401.7 os
    7 bytes retornados em caracter (14 dígitos BCD) serão:  0 0 0 0 1 71 132 1 112.
    ou chr(00)+chr(00)+chr(00)+chr(00)+chr(01)+chr(71)+chr(132)+chr(01)+chr(112).
    O retorno deve ser convertido para Hexa: 71dec = 47hex; 132dec = 84hex; 112dec = 70hex
    Nesse caso essa Função irá retornar:  "00 00 00 00 01 47 84 01 70"
 ---------------------------------------------------------------------------- }
function BcdToAsc(const StrBCD: AnsiString): String;
Var
  A,BCD_CHAR : Integer ;
  BH,BL,ASC_CHAR : String ;
begin
  result := '' ;

  For A := 1 to Length( StrBCD ) do
  begin
     BCD_CHAR := ord( StrBCD[A] ) ;
     BH := IntToStr( Trunc(BCD_CHAR / 16) ) ;
     If ( BCD_CHAR mod 16 ) > 9 Then
        BL := chr( 48 + BCD_CHAR mod 16 )
     Else
        BL := IntToStr( BCD_CHAR mod 16 ) ;

     ASC_CHAR := BH + BL ;
     Result := Result + ASC_CHAR
  end ;
end;

{-----------------------------------------------------------------------------
  Converte uma String com Numeros para uma String no Formato BCD
  - TamanhoBCD define quantos bytes a String Resultante deve ter
  - Para transformar o valor For  "123456" em 7 bytes BCD, teriamos:
    00 00 00 00 12 34 56    ou
    chr(00) + chr(00) + chr(00) + chr(00) + chr(18) + chr(52) + chr(86).
 ---------------------------------------------------------------------------- }
function AscToBcd(const ANumStr: String; const TamanhoBCD: Byte): AnsiString;
Var
  StrBCD, BCDChar : String ;
  I, L, DecVal: Integer;
begin
  Result := '' ;

  if not StrIsNumber( ANumStr ) then
     raise Exception.Create('Parâmetro "ANumStr" deve conter apenas números') ;

  L := TamanhoBCD*2;
  StrBCD := PadLeft( ANumStr, L , '0' );
  For I := 1 to TamanhoBCD do
  begin
     BCDChar := copy(StrBCD, (I*2)-1, 2);
     DecVal := StrToInt( '$'+BCDChar );
     Result := Result + AnsiChr( DecVal )  ;
  end;
end ;

{-----------------------------------------------------------------------------
  Converte um "AInteger" em uma String binária codificada como Little Endian,
  no tamanho máximo de "BytesStr"
  Exemplos: IntToLEStr( 106 ) = chr(106) + chr(0)
 ---------------------------------------------------------------------------- }
function IntToLEStr(AInteger: Integer; BytesStr: Integer): AnsiString;
var
   AHexStr: String;
   LenHex, P, DecVal: Integer;
begin
  LenHex  := BytesStr * 2 ;
  AHexStr := IntToHex(AInteger,LenHex);
  Result  := '' ;

  P := 1;
  while P < LenHex do
  begin
    DecVal := StrToInt('$'+copy(AHexStr,P,2)) ;
    Result := AnsiChar( DecVal ) + Result;
    P := P + 2 ;
  end ;
end;

{-----------------------------------------------------------------------------
  converte uma String binária codificada como Little Endian em Inteiro
  Veja exemplos na Function acima
 ---------------------------------------------------------------------------- }
function LEStrToInt(ALEStr: AnsiString): Integer;
var
   AHexStr: String;
   LenLE, P : Integer ;
begin
  LenLE   := Length(ALEStr);
  AHexStr := '';

  P := 1;
  while P <= LenLE do
  begin
    AHexStr := IntToHex(ord(ALEStr[P]),2) + AHexStr;
    Inc( P ) ;
  end ;

  if AHexStr <> '' then
    Result := StrToInt( '$'+AHexStr )
  else
    Result := 0;
end;

{-----------------------------------------------------------------------------
  Converte um "AInteger" em uma String binária codificada como Big Endian,
  no tamanho máximo de "BytesStr"
  Exemplos: IntToBEStr( 106, 2 ) = chr(0) + chr(106)
 ---------------------------------------------------------------------------- }
function IntToBEStr(AInteger: Integer; BytesStr: Integer): AnsiString;
var
   AHexStr: String;
   LenHex, P, DecVal: Integer;
begin
  LenHex  := BytesStr * 2 ;
  AHexStr := IntToHex(AInteger,LenHex);
  Result  := '' ;

  P := 1;
  while P < LenHex do
  begin
    DecVal := StrToInt('$'+copy(AHexStr,P,2)) ;
    Result := Result + AnsiChar( DecVal );
    P := P + 2 ;
  end ;
end;

{-----------------------------------------------------------------------------
  converte uma String binária codificada como Big Endian em Inteiro
  Veja exemplos na Function acima
 ---------------------------------------------------------------------------- }
function BEStrToInt(ABEStr: AnsiString): Integer;
var
   AHexStr: String;
   LenBE, P : Integer ;
begin
  LenBE   := Length(ABEStr);
  AHexStr := '';

  P := 1;
  while P <= LenBE do
  begin
    AHexStr := AHexStr + IntToHex(ord(ABEStr[P]),2);
    Inc( P ) ;
  end ;

  if AHexStr <> '' then
    Result := StrToInt( '$'+AHexStr )
  else
    Result := 0;
end;


{-----------------------------------------------------------------------------
  Converte uma String em HexaDecimal <HexStr> pela sua representação em ASCII
  Ex: "C080" em Hexadecimal é igual a "+Ç" em ASCII que é igual a 49280 que é
      igual a "1100000010000000" em binário
      Portanto se HexStr = "CO80", Result = "+Ç"
 ---------------------------------------------------------------------------- }
function HexToAscii(const HexStr : String) : AnsiString ;
Var
  B   : Byte ;
  Cmd : String ;
  I, L: Integer ;
begin
  Result := '' ;
  Cmd    := Trim(HexStr);
  I      := 1 ;
  L      := Length( HexStr ) ;

  while I < L do
  begin
     B := StrToIntDef('$' + copy(Cmd, I, 2), 32) ;
     Result := Result + AnsiChr( B ) ;
     Inc( I, 2) ;
  end ;
end ;

{-----------------------------------------------------------------------------
  Converte uma String pela sua representação em HexaDecimal
  Ex: "C080" em Hexadecimal é igual a "+Ç" em ASCII que é igual a 49280 que é
      igual a "1100000010000000" em binário
      Portanto se AString = "+Ç", Result = "C080"
 ---------------------------------------------------------------------------- }
function AsciiToHex(const ABinaryString: AnsiString): String;
 Var I, L: Integer;
begin
  Result := '' ;
  L := Length(ABinaryString) ;
  For I := 1 to L do
     Result := Result + IntToHex(Ord(ABinaryString[I]), 2);
end;

{-----------------------------------------------------------------------------
  Retorna o numero de caracteres dentro de uma String, semelhante a Length()
  Porém Lenght() não Funciona corretamente em FPC com UTF8 e acentos
 ---------------------------------------------------------------------------- }
function LenghtNativeString(const AString: String): Integer;
begin
  Result := Length(AString);
end;

{-----------------------------------------------------------------------------
  Completa <AString> com <Caracter> a direita, até o tamanho <nLen>, Alinhando
  a <AString> a Esquerda. Se <AString> For maior que <nLen>, ela será truncada
 ---------------------------------------------------------------------------- }
function PadRight(const AString : String; const nLen : Integer;
   const Caracter : Char) : String ;
var
  Tam: Integer;
begin
  Tam := LenghtNativeString( AString );
  if Tam < nLen then
    Result := AString + StringOfChar(Caracter, (nLen - Tam))
  else
    Result := LeftStr(AString, nLen);
end ;

{-----------------------------------------------------------------------------
  Completa <AString> com <Caracter> a esquerda, até o tamanho <nLen>, Alinhando
  a <AString> a Direita. Se <AString> For maior que <nLen>, ela será truncada
 ---------------------------------------------------------------------------- }
function PadLeft(const AString : String; const nLen : Integer;
   const Caracter : Char) : String ;
var
  Tam: Integer;
begin
  Tam := LenghtNativeString( AString );
  if Tam < nLen then
    Result := StringOfChar(Caracter, (nLen - Tam)) + AString
  else
    Result := LeftStr(AString, nLen) ;  //RightStr(AString,nLen) ;
end ;

{-----------------------------------------------------------------------------
 Completa <AString> Centralizando, preenchendo com <Caracter> a esquerda e direita
 ---------------------------------------------------------------------------- }
function PadCenter(const AString : String; const nLen : Integer;
   const Caracter : Char) : String ;
var
  nCharLeft: Integer;
  Tam: integer;
begin
  Tam := LenghtNativeString( AString );
  if Tam < nLen then
  begin
    nCharLeft := Trunc( (nLen - Tam) / 2 ) ;
    Result    := PadRight( StringOfChar(Caracter, nCharLeft) + AString, nLen, Caracter) ;
  end
  else
    Result := LeftStr(AString, nLen) ;
end ;

{-----------------------------------------------------------------------------
   Remove todos os espacos duplos do texto
 ---------------------------------------------------------------------------- }
function RemoverEspacosDuplos(const AString: String): String;
begin
  Result := Trim(AString);
  while Pos('  ', Result) > 0 do
    Result := StringReplace( Result, '  ', ' ', [rfReplaceAll]);
end;

{-----------------------------------------------------------------------------
   Remove todas ocorrencias do array <StringsToRemove> da String <AText>
   retornando a String alterada
 ---------------------------------------------------------------------------- }
function RemoveStrings(const AText: AnsiString;
  StringsToRemove: array of AnsiString): AnsiString;
Var
  I, J : Integer ;
  StrToFind : AnsiString ;
begin
  Result := AText ;
  { Verificando parâmetros de Entrada }
  if (AText = '') or (Length(StringsToRemove) = 0) then
     exit ;

  { Efetua um Sort no Array de acordo com o Tamanho das Substr a remover,
    para Pesquisar da Mais Larga a Mais Curta (Pois as Substr Mais Curtas podem
    estar contidas nas mais Largas) }
  For I := High( StringsToRemove ) downto Low( StringsToRemove )+1 do
     For j := Low( StringsToRemove ) to I-1 do
        if Length(StringsToRemove[J]) > Length(StringsToRemove[J+1]) then
        begin
           StrToFind := StringsToRemove[J];
           StringsToRemove[J] := StringsToRemove[J+1];
           StringsToRemove[J+1] := StrToFind;
        end;

  For I := High(StringsToRemove) downto Low(StringsToRemove) do
  begin
     StrToFind := StringsToRemove[I] ;
     J := Pos( StrToFind, Result ) ;
     while J > 0 do
     begin
        Delete( Result, J, Length( StrToFind ) ) ;
        J := PosEx( String(StrToFind), String(Result), J) ;
     end ;
  end ;
end ;

{-----------------------------------------------------------------------------
   Remove todas as TAGS de HTML de uma String, retornando a String alterada
 ---------------------------------------------------------------------------- }
function StripHTML(const AHTMLString: String): String;
var
  ATag, VHTMLString: String;
  PosTag, LenTag: Integer;
begin
  VHTMLString := AHTMLString;
  ATag   := '';
  PosTag := 0;

  AcharProximaTag( VHTMLString, 1, ATag, PosTag);
  while ATag <> '' do
  begin
    LenTag := Length( ATag );
    Delete(VHTMLString, PosTag, LenTag);

    ATag := '';
    AcharProximaTag( VHTMLString, PosTag, ATag, PosTag );
  end ;
  Result := VHTMLString;
end;

{-----------------------------------------------------------------------------
   Localiza uma Tag dentro de uma String, iniciando a busca em PosIni.
   Se encontrar uma Tag, Retorna a mesma em ATag, e a posição inicial dela em PosTag
 ---------------------------------------------------------------------------- }
procedure AcharProximaTag(const AString: String;
  const PosIni: Integer; var ATag: String; var PosTag: Integer);
var
   PosTagAux, FimTag, LenTag : Integer ;
begin
  ATag   := '';
  PosTag := PosEx( '<', AString, PosIni);
  if PosTag > 0 then
  begin
    PosTagAux := PosEx( '<', AString, PosTag + 1);  // Verificando se Tag é inválida
    FimTag    := PosEx( '>', AString, PosTag + 1);
    if FimTag = 0 then                             // Tag não Fechada ?
    begin
      PosTag := 0;
      exit ;
    end ;

    while (PosTagAux > 0) and (PosTagAux < FimTag) do  // Achou duas aberturas Ex: <<e>
    begin
      PosTag    := PosTagAux;
      PosTagAux := PosEx( '<', AString, PosTag + 1);
    end ;

    LenTag := FimTag - PosTag + 1 ;
    ATag   := LowerCase( copy( AString, PosTag, LenTag ) );
  end ;
end ;

{-----------------------------------------------------------------------------
   Remove todas ocorrencias <sSubStr> de <sString>, retornando a String alterada
 ---------------------------------------------------------------------------- }
function RemoveString(const sSubStr, sString : String) : String ;
begin
   Result := StringReplace( sString, sSubStr, '', [rfReplaceAll]);
end;

{-----------------------------------------------------------------------------
   Remove todas as linhas vazias de um TStringList
 ---------------------------------------------------------------------------- }
procedure RemoveEmptyLines(AStringList : TStringList) ;
var
  I : Integer ;
begin
  I := 0;
  while I < AStringList.Count do
  begin
    if trim(AStringList[I]) = '' then
      AStringList.Delete(I)
    else
      Inc(I);
  end;
end;

{-----------------------------------------------------------------------------
   Cria um Nome Aleatório (usado por exemplo, em arquivos temporários)
 ---------------------------------------------------------------------------- }
function RandomName(const LenName : Integer ) : String ;
 Var I, N : Integer ;
     C : Char ;
begin
   if not Randomized then
   begin
      Randomize ;
      Randomized := True ;
   end ;

   Result := '' ;

   For I := 1 to LenName do
   begin
      N := Random( 25 ) ;
      C := Char( 65 + N ) ;

      Result := Result + C ;
   end ;
end ;

{-----------------------------------------------------------------------------
  Retorna quantas ocorrencias de <SubStr> existem em <AString>
 ---------------------------------------------------------------------------- }
function CountStr(const AString, SubStr : String ) : Integer ;
Var ini : Integer ;
begin
  result := 0 ;
  if SubStr = '' then exit ;

  ini := Pos( SubStr, AString ) ;
  while ini > 0 do
  begin
     Result := Result + 1 ;
     ini    := PosEx( SubStr, AString, ini + 1 ) ;
  end ;
end ;

//{$IFNDEF COMPILER6_UP}
function RoundTo(const AValue: Double; const ADigit: TRoundToRange): Double;
var
  LFactor: Double;
begin
  LFactor := IntPower(10, ADigit);
  Result := Round(AValue / LFactor) * LFactor;
end;

function SimpleRoundTo(const AValue: Double; const ADigit: TRoundToRange = -2): Double;
var
  LFactor: Double;
begin
  LFactor := IntPower(10, ADigit);
  Result := Trunc((AValue / LFactor) + 0.5) * LFactor;
end;

{-----------------------------------------------------------------------------
 *** PosEx, retirada de StrUtils.pas do Borland Delphi ***
  para compatibilizar com o Delphi 6  (que nao possui essa Funçao)
 ---------------------------------------------------------------------------- }
function PosEx(const SubStr, S: AnsiString; Offset: Cardinal = 1): Integer;
var
  I,X: Integer;
  Len, LenSubStr: Integer;
begin
  if Offset = 1 then
    Result := Pos(SubStr, S)
  else
  begin
    I := Offset;
    LenSubStr := Length(SubStr);
    Len := Length(S) - LenSubStr + 1;
    while I <= Len do
    begin
      if S[I] = SubStr[1] then
      begin
        X := 1;
        while (X < LenSubStr) and (S[I + X] = SubStr[X + 1]) do
          Inc(X);
        if (X = LenSubStr) then
        begin
          Result := I;
          exit;
        end;
      end;
      Inc(I);
    end;
    Result := 0;
  end;
end;

{-----------------------------------------------------------------------------
  Verifica se "AValue" é vazio, se For retorna "DefaultValue". "DoTrim", se
  verdadeiro (default) Faz Trim em "AValue" antes da comparação
 ---------------------------------------------------------------------------- }
function IfEmptyThen(const AValue, DefaultValue: String; DoTrim: Boolean
  ): String;
Var
  AStr : String;
begin
  if DoTrim then
     AStr := Trim(AValue)
  else
     AStr := AValue;

  if AStr = EmptyStr then
     Result := DefaultValue
  else
     Result := AValue;
end;

{-----------------------------------------------------------------------------
  Acha a e-nesima "Ocorrencia" de "SubStr" em "S"
 ---------------------------------------------------------------------------- }
function PosAt(const SubStr, S: AnsiString; Ocorrencia : Cardinal = 1): Integer;
Var Count : Cardinal ;
begin
  Result := Pos( SubStr, S) ;
  Count  := 1 ;
  while (Count < Ocorrencia) and (Result > 0) do
  begin
     Result := PosEx( String(SubStr), String(S), Result+1) ;
     Count  := Count + 1 ;
  end ;
end ;

function RPos(const aSubStr, aString : AnsiString; const aStartPos: Integer): Integer; overload;
var
  i: Integer;
  pStr: PChar;
  pSub: PChar;
begin
  pSub := Pointer(aSubStr);

  For i := aStartPos downto 1 do
  begin
    pStr := @(aString[i]);
    if (pStr^ = pSub^) then
    begin
      if CompareMem(pSub, pStr, Length(aSubStr)) then
      begin
        result := i;
        EXIT;
      end;
    end;
  end;

  result := 0;
end;

function RPos(const aSubStr, aString : AnsiString): Integer; overload;
begin
  result := RPos(aSubStr, aString, Length(aString) - Length(aSubStr) + 1);
end;

{-----------------------------------------------------------------------------
  Acha a Ultima "Ocorrencia" de "SubStr" em "S"
 ---------------------------------------------------------------------------- }
function PosLast(const SubStr, S: AnsiString ): Integer;
Var P : Integer ;
begin
  Result := 0 ;
  P := Pos( SubStr, S) ;
  while P <> 0 do
  begin
     Result := P ;
     P := PosEx( String(SubStr), String(S), P+1) ;
  end ;
end ;

{-----------------------------------------------------------------------------
  Insere ZEROS (0) a esquerda de <Texto> até completar <Tamanho>
 ---------------------------------------------------------------------------- }
function Poem_Zeros(const Texto : String ; const Tamanho : Integer) : String ;
begin
  Result := PadLeft(Trim(Texto),Tamanho,'0') ;
end ;

function Poem_Zeros(const NumInteiro : Int64 ; Tamanho : Integer) : String ;
begin
  Result := IntToStrZero( NumInteiro, Tamanho) ;
end ;

function RemoveZerosEsquerda(ANumStr: String): String;
var
  I, L: Integer;
begin
  L := Length(ANumStr);
  I := 1;
  while (I < L) and (ANumStr[I] = '0') do
    Inc(I);

  Result := Copy(ANumStr, I, L);
end;

function CreateFormatSettings: TFormatSettings;
begin
   Result := TFormatSettings.Create('');
   Result.CurrencyString            := CurrencyString;
   Result.CurrencyFormat            := CurrencyFormat;
   Result.NegCurrFormat             := NegCurrFormat;
   Result.ThousandSeparator         := ThousandSeparator;
   Result.DecimalSeparator          := DecimalSeparator;
   Result.CurrencyDecimals          := CurrencyDecimals;
   Result.DateSeparator             := DateSeparator;
   Result.ShortDateFormat           := ShortDateFormat;
   Result.LongDateFormat            := LongDateFormat;
   Result.TimeSeparator             := TimeSeparator;
   Result.TimeAMString              := TimeAMString;
   Result.TimePMString              := TimePMString;
   Result.ShortTimeFormat           := ShortTimeFormat;
   Result.LongTimeFormat            := LongTimeFormat;
   Result.TwoDigitYearCenturyWindow := TwoDigitYearCenturyWindow;
   Result.ListSeparator             := ListSeparator;
end;

{-----------------------------------------------------------------------------
  Transforma <NumInteiro> em String, preenchendo com Zeros a Esquerda até
  atingiros digitos de <Tamnho>
 ---------------------------------------------------------------------------- }
function IntToStrZero(const NumInteiro : Int64 ; Tamanho : Integer) : String ;
begin
  Result := Poem_Zeros( IntToStr( NumInteiro ), Tamanho) ;
end ;

{-----------------------------------------------------------------------------
  Converte uma <NumString> para Double, semelhante ao StrToFloatDef, mas
  verifica se a virgula é '.' ou ',' efetuando a conversão se necessário
  Se não For possivel converter, retorna <DefaultValue>
 ---------------------------------------------------------------------------- }
function StringToFloatDef(const NumString : String ; const DefaultValue : Double
   ) : Double ;
begin
  if EstaVazio(NumString) then
     Result := DefaultValue
  else
   begin
     try
        Result := StringToFloat( NumString ) ;
     except
        Result := DefaultValue ;
     end ;
   end;
end ;

{-----------------------------------------------------------------------------
  Faz o mesmo que FormatFloat, porém garante que o resultado Final terá
  o separador de decimal = ',' e o separador de milhar como Ponto
 ---------------------------------------------------------------------------- }
function FormatFloatBr(const AValue: Extended; AFormat: String): String;
Var
  OldDecimalSeparator, OldThousandSeparator : Char ;
begin
  if AFormat = '' then
     AFormat := FloatMask();

  OldDecimalSeparator := DecimalSeparator;
  OldThousandSeparator := ThousandSeparator;
  try
    DecimalSeparator := ',';
    ThousandSeparator := '.';
    Result := FormatFloat(AFormat, AValue);
  Finally
    DecimalSeparator := OldDecimalSeparator;
    ThousandSeparator := OldThousandSeparator;
  end;
end;

function FloatMask(const DecimalDigits: SmallInt; UseThousandSeparator: Boolean
  ): String;
begin
  if DecimalDigits > 0 then
  begin
    if UseThousandSeparator then
      Result := ','
    else
      Result := '';

    Result := Result + '0.' + StringOfChar('0',DecimalDigits)
  end
  else
    Result := '0';
end;

{-----------------------------------------------------------------------------
  Converte uma <NumString> para Double, semelhante ao StrToFloat, mas
  verifica se a virgula é '.' ou ',' efetuando a conversão se necessário
  Se não For possivel converter, dispara Exception
 ---------------------------------------------------------------------------- }
function StringToFloat(NumString : String) : Double ;
var
  DS: Char;
begin
  NumString := Trim( NumString ) ;

  DS := FormatSettings.DecimalSeparator;

  if DS <> '.' then
     NumString := StringReplace(NumString,'.',DS,[rfReplaceAll]) ;

  if DS <> ',' then
     NumString := StringReplace(NumString,',',DS,[rfReplaceAll]) ;

  Result := StrToFloat(NumString)
end ;

{-----------------------------------------------------------------------------
  Converte um Double para string, SEM o separator decimal, considerando as
  decimais como parte Final da String. Ex: 100,00 = "10000"; 1,23 = "123"
 ---------------------------------------------------------------------------- }
function FloatToIntStr(const AValue : Double ; const DecimalDigits : SmallInt
   ) : String ;
var
   Pow : Extended ;
begin
  Pow    := intpower(10, abs(DecimalDigits) );
  Result := IntToStr( Trunc( SimpleRoundTo( AValue * Pow ,0) ) ) ;
end;

{-----------------------------------------------------------------------------
  Converte um Double para string, semelhante a FloatToStr(), porém
  garante que não haverá separador de Milhar e o Separador Decimal será igual a
  "SeparadorDecimal" ( o default é .(ponto))
 ---------------------------------------------------------------------------- }
function FloatToString(const AValue: Double; SeparadorDecimal: Char;
  AFormat: String): String;
var
  DS, TS: Char;
begin
  if EstaVazio(AFormat) then
    Result := FloatToStr(AValue)
  else
    Result := FormatFloat(AFormat, AValue);

  DS := FormatSettings.DecimalSeparator;
  TS := FormatSettings.ThousandSeparator;

  // Removendo Separador de milhar //
  if ( DS <> TS ) then
    Result := StringReplace(Result, TS, '', [rfReplaceAll]);

  // Verificando se precisa mudar Separador decimal //
  if DS <> SeparadorDecimal then
    Result := StringReplace(Result, DS, SeparadorDecimal, [rfReplaceAll]);
end;

{-----------------------------------------------------------------------------
  Converte uma <ADateTime> para String, semelhante ao FormatDateTime,
  porém garante que o separador de Data SEMPRE será a '/'.
  Usa o padrão Brasileiro DD/MM/YYYY.
  <AFormat> pode ser especificado, para mudar a apresentação.
 ---------------------------------------------------------------------------- }
function FormatDateBr(const ADateTime: TDateTime; AFormat: String): String;
begin
  if AFormat = '' then
     AFormat := 'DD/MM/YYYY';

  Result := FormatDateTimeBr( DateOf(ADateTime), AFormat);
end;

{-----------------------------------------------------------------------------
  Converte uma <ADateTime> para String, semelhante ao FormatDateTime,
  porém garante que o separador de Data SEMPRE será a '/', e o de Hora ':'.
  Usa o padrão Brasileiro DD/MM/YYYY hh:nn:ss.
  <AFormat> pode ser especificado, para mudar a apresentação.
 ---------------------------------------------------------------------------- }
function FormatDateTimeBr(const ADate: TDateTime; AFormat: String): String;
Var
  OldDateSeparator: Char ;
  OldTimeSeparator: Char ;
begin
  if AFormat = '' then
     AFormat := 'DD/MM/YYYY hh:nn:ss';

  OldDateSeparator := DateSeparator;
  OldTimeSeparator := TimeSeparator;
  try
    DateSeparator := '/';
    TimeSeparator := ':';
    Result := FormatDateTime(AFormat, ADate);
  Finally
    DateSeparator := OldDateSeparator;
    TimeSeparator := OldTimeSeparator;
  end;
end;

{-----------------------------------------------------------------------------
  Converte uma <DateTimeString> para TDateTime, semelhante ao StrToDateTime,
  mas verifica se o seprador da Data é compativo com o S.O., efetuando a
  conversão se necessário. Se não For possivel converter, dispara Exception
 ---------------------------------------------------------------------------- }
function StringToDateTime(const DateTimeString : String ; const Format : String
   ) : TDateTime ;
Var
  AStr : String;
  OldShortDateFormat: String ;
begin
  Result := 0;
  if (DateTimeString = '0') or (DateTimeString = '') then
    exit;
  OldShortDateFormat := ShortDateFormat ;
  try
    if Format <> '' then
      ShortDateFormat := Format ;

    AStr := Trim( StringReplace(DateTimeString,'/',DateSeparator, [rfReplaceAll])) ;
    AStr := StringReplace(AStr,':',TimeSeparator, [rfReplaceAll]) ;

    Result := StrToDateTime( AStr ) ;
  Finally
    ShortDateFormat := OldShortDateFormat ;
  end ;
end ;

{-----------------------------------------------------------------------------
  Converte uma <DateTimeString> para TDateTime, semelhante ao StrToDateTimeDef,
  mas verifica se o seprador da Data é compativo com o S.O., efetuando a
  conversão se necessário. Se não For possivel converter, retorna <DefaultValue>
 ---------------------------------------------------------------------------- }
function StringToDateTimeDef(const DateTimeString : String ;
   const DefaultValue : TDateTime ; const Format : String) : TDateTime ;
begin
  if EstaVazio(DateTimeString) then
     Result := DefaultValue
  else
   begin
     try
        Result := StringToDateTime( DateTimeString, Format ) ;
     except
        Result := DefaultValue ;
     end ;
   end;
end ;

{-----------------------------------------------------------------------------
  Converte uma String no Formato YYYYMMDDhhnnss  para TDateTime
 ---------------------------------------------------------------------------- }
function StoD( YYYYMMDDhhnnss: String) : TDateTime;
begin
  YYYYMMDDhhnnss := trim( YYYYMMDDhhnnss ) ;

  try
    Result := EncodeDateTime( StrToIntDef(copy(YYYYMMDDhhnnss, 1,4),0),  // YYYY
                              StrToIntDef(copy(YYYYMMDDhhnnss, 5,2),0),  // MM
                              StrToIntDef(copy(YYYYMMDDhhnnss, 7,2),0),  // DD
                              StrToIntDef(copy(YYYYMMDDhhnnss, 9,2),0),  // hh
                              StrToIntDef(copy(YYYYMMDDhhnnss,11,2),0),  // nn
                              StrToIntDef(copy(YYYYMMDDhhnnss,13,2),0),  // ss
                              0 );
  except
    Result := 0;
  end;
end;

{-----------------------------------------------------------------------------
  Converte um TDateTime para uma String no Formato YYYYMMDD
 ---------------------------------------------------------------------------- }
function DtoS( ADate : TDateTime) : String;
begin
  Result := FormatDateTime('yyyymmdd', ADate ) ;
end ;

{-----------------------------------------------------------------------------
  Converte um TDateTime para uma String no Formato YYYYMMDDhhnnss
 ---------------------------------------------------------------------------- }
function DTtoS( ADateTime : TDateTime) : String;
begin
  Result := FormatDateTime('yyyymmddhhnnss', ADateTime ) ;
end ;


function Iso8601ToDateTime(const AISODate: string): TDateTime;
var
  y, m, d, h, n, s: word;
begin
  y := StrToInt(Copy(AISODate, 1, 4));
  m := StrToInt(Copy(AISODate, 6, 2));
  d := StrToInt(Copy(AISODate, 9, 2));
  h := StrToInt(Copy(AISODate, 12, 2));
  n := StrToInt(Copy(AISODate, 15, 2));
  s := StrToInt(Copy(AISODate, 18, 2));

  Result := EncodeDateTime(y,m,d, h,n,s,0);
end;

function DateTimeToIso8601(ADate: TDateTime; ATimeZone: string = ''): string;
const
  SDateFormat: string = 'yyyy''-''mm''-''dd''T''hh'':''nn'':''ss''.''zzz''Z''';
begin
  Result := FormatDateTime(SDateFormat, ADate);
  if ATimeZone <> '' then
  begin ;
    // Remove the Z, in order to add the UTC_Offset to the string.
    SetLength(Result, Length(Result) - 1);
    Result := Result + ATimeZone;
  end;
end;

{-----------------------------------------------------------------------------
 *** Extraido de JclStrings.pas  - Project JEDI Code Library (JCL) ***
  Retorna <True> se <S> contem apenas caracteres Alpha maiusculo/minuscula
 ---------------------------------------------------------------------------- }
function StrIsAlpha(const S: String): Boolean;
Var A : Integer ;
begin
  Result := true ;
  A      := 1 ;
  while Result and ( A <= Length( S ) )  do
  begin
     Result := CharIsAlpha( S[A] ) ;
     Inc(A) ;
  end;
end ;

{-----------------------------------------------------------------------------
 *** Extraido de JclStrings.pas  - Project JEDI Code Library (JCL) ***
  Retorna <True> se <S> contem apenas caracteres Numericos.
  Retorna <False> se <S> For vazio
 ---------------------------------------------------------------------------- }
function StrIsNumber(const S: String): Boolean;
Var
  A, LenStr : Integer ;
begin
  LenStr := Length( S ) ;
  Result := (LenStr > 0) ;
  A      := 1 ;
  while Result and ( A <= LenStr )  do
  begin
     Result := CharIsNum( S[A] ) ;
     Inc(A) ;
  end;
end ;

{-----------------------------------------------------------------------------
 *** Extraido de JclStrings.pas  - Project JEDI Code Library (JCL) ***
  Retorna <True> se <S> contem apenas caracteres Alpha maiusculo/minuscula
  ou Numericos
 ---------------------------------------------------------------------------- }
function StrIsAlphaNum(const S: String): Boolean;
Var
  A : Integer ;
begin
  Result := true ;
  A      := 1 ;
  while Result and ( A <= Length( S ) )  do
  begin
     Result := CharIsAlphaNum( S[A] ) ;
     Inc(A) ;
  end;
end ;

{-----------------------------------------------------------------------------
  Retorna <True> se <S> contem apenas caracteres em Hexa decimal
 ---------------------------------------------------------------------------- }
function StrIsHexa(const S: String): Boolean;
Var
  A : Integer ;
begin
  Result := True ;
  A      := 1 ;
  while Result and ( A <= Length( S ) )  do
  begin
     Result := CharIsHexa( S[A] ) ;
     Inc(A) ;
  end;
end;

{-----------------------------------------------------------------------------
 *** Extraido de JclStrings.pas  - Project JEDI Code Library (JCL) ***
  Retorna <True> se <C> é Alpha maiusculo/minusculo
 ---------------------------------------------------------------------------- }
function CharIsAlpha(const C: Char): Boolean;
begin
  Result := CharInSet( C, ['A'..'Z','a'..'z'] ) ;
end ;

{-----------------------------------------------------------------------------
 *** Extraido de JclStrings.pas  - Project JEDI Code Library (JCL) ***
  Retorna <True> se <C> é Númerico
 ---------------------------------------------------------------------------- }
function CharIsNum(const C: Char): Boolean;
begin
  Result := CharInSet( C, ['0'..'9'] ) ;
end ;

{-----------------------------------------------------------------------------
 *** Extraido de JclStrings.pas  - Project JEDI Code Library (JCL) ***
  Retorna <True> se <C> é Alpha maiusculo/minusculo ou Numerico
 ---------------------------------------------------------------------------- }
function CharIsAlphaNum(const C: Char): Boolean;
begin
  Result := ( CharIsAlpha( C ) or CharIsNum( C ) );
end ;

{-----------------------------------------------------------------------------
  Retorna <True> se <C> é um char hexa válido
 ---------------------------------------------------------------------------- }
function CharIsHexa(const C: Char): Boolean;
begin
  Result := CharInSet( C, ['0'..'9','A'..'F','a'..'f'] ) ;
end;

{-----------------------------------------------------------------------------
  Retorna uma String apenas com os char Numericos contidos em <Value>
 ---------------------------------------------------------------------------- }
function OnlyNumber(const AValue: String): String;
Var
  I : Integer ;
  LenValue : Integer;
begin
  Result   := '' ;
  LenValue := Length( AValue ) ;
  For I := 1 to LenValue  do
  begin
     if CharIsNum( AValue[I] ) then
        Result := Result + AValue[I];
  end;
end ;

{-----------------------------------------------------------------------------
  Retorna uma String apenas com os char Alpha contidos em <Value>
 ---------------------------------------------------------------------------- }
function OnlyAlpha(const AValue: String): String;
Var
  I : Integer ;
  LenValue : Integer;
begin
  Result := '' ;
  LenValue := Length( AValue ) ;
  For I := 1 to LenValue do
  begin
     if CharIsAlpha( AValue[I] ) then
        Result := Result + AValue[I];
  end;
end ;
{-----------------------------------------------------------------------------
  Retorna uma String apenas com os char Alpha-Numericos contidos em <Value>
 ---------------------------------------------------------------------------- }
function OnlyAlphaNum(const AValue: String): String;
Var
  I : Integer ;
  LenValue : Integer;
begin
  Result := '' ;
  LenValue := Length( AValue ) ;
  For I := 1 to LenValue do
  begin
     if CharIsAlphaNum( AValue[I] ) then
        Result := Result + AValue[I];
  end;
end ;

function OnlyCharsInSet(const AValue: String; SetOfChars: TSetOfChars): String;
Var
  I : Integer ;
  LenValue : Integer;
begin
  Result := '' ;
  LenValue := Length( AValue ) ;
  For I := 1 to LenValue do
  begin
     if CharInSet( AValue[I], SetOfChars) then
        Result := Result + AValue[I];
  end;
end;

{-----------------------------------------------------------------------------
 ** Baseada em "IsIp" de synautil.pas - Synapse http://www.ararat.cz/synapse/ **
  Retorna <True> se <Value> é um IP Valido
 ---------------------------------------------------------------------------- }
function StrIsIP(const AValue: String): Boolean;
var
  TempIP : string;
  Function ByteIsOk(const AValue: string): Boolean;
  var
    x: integer;
  begin
    x := StrToIntDef(AValue, -1);
    Result := (x >= 0) and (x < 256);
    // X may be in correct range, but value still may not be correct value!
    // i.e. "$80"
    if Result then
       Result := StrIsNumber( AValue ) ;
  end;

  Function Fetch(var AValue: string; const Delimiter: string): string;
  var
    p : Integer ;
  begin
    p := pos(Delimiter,AValue) ;
    Result := copy(AValue, 1, p-1);
    AValue := copy(AValue, p+1, Length(AValue));
  end;
begin
  TempIP := AValue;
  Result := False;
  if not ByteIsOk(Fetch(TempIP, '.')) then
    Exit;
  if not ByteIsOk(Fetch(TempIP, '.')) then
    Exit;
  if not ByteIsOk(Fetch(TempIP, '.')) then
    Exit;
  if ByteIsOk(TempIP) then
    Result := True;
end;

function EstaVazio(const AValue: String): Boolean;
begin
  Result := (AValue = '');
end;

procedure EstaVazio(const AValue, AMensagem: String);
begin
  if EstaVazio(AValue) then
    raise Exception.Create(AMensagem);
end;

function NaoEstaVazio(AValue: String): Boolean;
begin
  Result := not EstaVazio(AValue);
end;

function EstaZerado(AValue: Double): Boolean;
begin
  Result := (AValue = 0);
end;

function EstaZerado(AValue: Integer): Boolean;
begin
  Result := (AValue = 0);
end;

procedure EstaZerado(AValue: Integer; AMensagem: String);
begin
  if EstaZerado(AValue) then
    raise Exception.Create(AMensagem);
end;

function NaoEstaZerado(AValue: Double): Boolean;
begin
  Result := not EstaZerado(AValue);
end;

function NaoEstaZerado(AValue: Integer): Boolean;
begin
  Result := not EstaZerado(AValue);
end;

function TamanhoIgual(const AValue: String; const ATamanho: Integer): Boolean;
begin
 Result := (Length(AValue) = ATamanho);
end;

procedure TamanhoIgual(const AValue: String; const ATamanho: Integer;
  AMensagem: String);
begin
  if not TamanhoIgual(AValue, ATamanho) then
    raise Exception.Create(AMensagem);
end;

function TamanhoIgual(const AValue: Integer; const ATamanho: Integer): Boolean;
begin
  Result := (Length(IntToStr(AValue)) = ATamanho);
end;

procedure TamanhoIgual(const AValue: Integer; const ATamanho: Integer;
  AMensagem: String);
begin
  if not TamanhoIgual(AValue, ATamanho) then
    raise Exception.Create(AMensagem);
end;

function TamanhoMenor(const AValue: String; const ATamanho: Integer): Boolean;
begin
  Result := (Length(AValue) < ATamanho);
end;

{-----------------------------------------------------------------------------
  Substitui todos os caracteres acentuados por compativeis.
 ---------------------------------------------------------------------------- }
function TiraAcentos( const AString : String ) : String ;
Var A : Integer ;
    Letra : AnsiChar ;
    AnsiStr, Ret : AnsiString ;
begin
  Result  := '' ;
  Ret     := '' ;
  AnsiStr := AnsiString( StrToAnsi( AString ));
  For A := 1 to Length( AnsiStr ) do
  begin
     Letra := TiraAcento( AnsiStr[A] ) ;
     if not (Byte(Letra) in [32..126,13,10,8]) then    {Letras / numeros / pontos / sinais}
        Letra := ' ' ;
     Ret := Ret + Letra ;
  end ;

  Result := Str(string(Ret))
end ;

{-----------------------------------------------------------------------------
  Substitui caracter acentuado por compativel
 ---------------------------------------------------------------------------- }
function TiraAcento( const AChar : AnsiChar ) : AnsiChar ;
begin
  case Byte(AChar) of
    192..198 : Result := 'A' ;
    199      : Result := 'C' ;
    200..203 : Result := 'E' ;
    204..207 : Result := 'I' ;
    208      : Result := 'D' ;
    209      : Result := 'N' ;
    210..214 : Result := 'O' ;
    215      : Result := 'x' ;
    216,248  : Result := '0' ;
    217..220 : Result := 'U' ;
    221      : Result := 'Y' ;
    222,254  : Result := 'b' ;
    223      : Result := 'B' ;
    224..230 : Result := 'a' ;
    231      : Result := 'c' ;
    232..235 : Result := 'e' ;
    236..239 : Result := 'i' ;
    240,242..246 : Result := 'o' ;
    247      : Result := '/';
    241      : Result := 'n' ;
    249..252 : Result := 'u' ;
    253,255  : Result := 'y' ;
  else
    Result := AChar ;
  end;
end ;

{-----------------------------------------------------------------------------
  Quebra Linhas grandes no máximo de Colunas especificado, ou caso encontre
  uma quebra de Linha (CR ou CR+LF)
  Retorna uma String usando o #10 como separador de Linha
  Se <NumMaxLinhas> For especificado, para ao chegar no Limite de Linhas
  Se <PadLinhas> For True, Todas as linhas terão o mesmo tamanho de Colunas
    com espaços a esquerda se necessário.
 ---------------------------------------------------------------------------- }
function AjustaLinhas(const Texto: AnsiString; Colunas: Integer;
  NumMaxLinhas: Integer; PadLinhas: Boolean): AnsiString;
Var
  Count,P,I : Integer ;
  Linha, CurrLineBreak, VTexto : String;
begin
  VTexto := String(Texto);
  { Trocando todos os #13+#10 por #10 }
  CurrLineBreak := sLineBreak ;
  if (CurrLineBreak <> #13+#10) then
     VTexto := StringReplace(VTexto, #13+#10, #10, [rfReplaceAll]) ;

  if (CurrLineBreak <> #10) then
     VTexto := StringReplace(VTexto, CurrLineBreak, #10, [rfReplaceAll]) ;

  { Ajustando a largura das Linhas para o máximo permitido em  "Colunas"
    e limitando em "NumMaxLinhas" o total de Linhas}
  Count  := 0 ;
  Result := '' ;
  while ((Count < NumMaxLinhas) or (NumMaxLinhas = 0)) and
        (Length(VTexto) > 0) do
  begin
     P := pos(#10, VTexto ) ;
     if P > (Colunas + 1) then
        P := Colunas + 1 ;

     if P = 0 then
        P := min( Length( VTexto ), Colunas ) + 1 ;

     // somar 2 quando encontrar uma tag para não quebrar ela
     if (Copy(VTexto, P-1, 1) = '<') or (Copy(VTexto, P-2, 2) = '</') then
        inc(P, 2);

     I := 0 ;
     if copy(VTexto,P,1) = #10 then   // Pula #10 ?
        I := 1 ;

     Linha := copy(VTexto,1,P-1) ;    // Remove #10 (se hover)

     if PadLinhas then
        Result := Result + AnsiString(PadRight( Linha, Colunas)) + #10
     else
        Result := Result + AnsiString(Linha) + #10 ;

     Inc(Count) ;
     VTexto := copy(VTexto, P+I, Length(VTexto) ) ;
  end ;

  { Permitir impressão de uma linha em branco }
  if Result = '' then
  begin
    if PadLinhas then
      Result := Space(Colunas) + #10
    else
      Result := #10;
  end;
end;

{-----------------------------------------------------------------------------
  Quebra amigável de Linhas de um <Texto>, em um determinado numero de <Colunas>,
  respeitando o espaço existente entre as palavras. Permite especificar um
  separador diferente de espaço em <CaracterQuebrar>
 ---------------------------------------------------------------------------- }
function QuebraLinhas(const Texto: String; const Colunas: Integer;
   const CaracterQuebrar : AnsiChar = ' '): String;
Var
  PosIni, PosFim, PosLF, Tamanho : Integer ;
  AnsiStr, Resp: String;
begin
  Resp := '';
  // Converte para Ansi, para não se perder com caracteres UTF8
  AnsiStr := StrToAnsi(Texto);
  if sLineBreak <> LF then
    AnsiStr := StringReplace(AnsiStr, sLineBreak, LF, [rfReplaceAll]);

  Tamanho := Length(AnsiStr) ;
  PosIni  := 1 ;
  if Colunas > 0 then
  begin
    repeat
       if (PosIni > 1) and (AnsiStr[PosIni-1] <> LF) then
          Resp := Resp + LF;

       PosFim := PosIni + Colunas - 1 ;

       if Tamanho > PosFim then  // Ainda tem proxima linha ?
       begin
          if CharInSet(AnsiStr[PosFim+1], [CaracterQuebrar, LF]) then  // Proximo já é uma Quebra ?
             Inc(PosFim)
          else
          begin
            while (not CharInSet(AnsiStr[PosFim], [CaracterQuebrar, LF])) and (PosFim > PosIni) do  // Ache uma Quebra
              Dec(PosFim) ;
          end;
       end;

       if PosFim = PosIni then  // Não Foi capaz de encontrar uma quebra, divida a palavra em "Coluna"
          PosFim := PosIni + Colunas - 1 ;

       PosLF := PosEx(LF, AnsiStr, PosIni+1);
       if (PosLF > 0) and (PosLF < PosFim) then
         PosFim := PosLF;

       Resp := Resp + Copy( AnsiStr, PosIni, (PosFim-PosIni)+1 );
       PosIni := PosFim + 1 ;

       // Pula CaracterQuebrar no Inicio da String
       if (PosIni <= Tamanho) then
          while CharInSet(AnsiStr[PosIni], [CaracterQuebrar, LF]) and (PosIni <= Tamanho) do
             Inc(PosIni) ;

    until (PosIni > Tamanho);
  end
  else
    Resp := AnsiStr;

  if sLineBreak <> LF then
    Resp := StringReplace(Resp, LF, sLineBreak, [rfReplaceAll]);

  Result := Str(Resp);
end;

{-----------------------------------------------------------------------------
  Traduz Strings do Tipo '#13,v,#10', substituindo #nn por chr(nn). Ignora todo
   texto apos a String ' | '
 ---------------------------------------------------------------------------- }
function TraduzComando(const AString: String): AnsiString;
Var
  A : Integer ;
  VString : String;
begin
  VString := AString;
  A := pos(' | ', VString ) ;
  if A > 0 then
     VString := copy(VString,1,A-1) ;   { removendo texto apos ' | ' }

  Result := AscToString( VString ) ;
end ;

{-----------------------------------------------------------------------------
  Traduz Strings do Tipo chr(13)+chr(10) para uma representação que possa ser
   lida por AscToString Ex: '#13,#10'
 ---------------------------------------------------------------------------- }
function StringToAsc(const AString: AnsiString): String;
Var A : Integer ;
begin
  Result := '' ;
  For A := 1 to Length( AString ) do
     Result := Result + '#'+IntToStr( Ord( AString[A] ) )+',' ;

  Result := copy(Result,1, Length( Result )-1 ) ;
end;

{-----------------------------------------------------------------------------
  Traduz Strings do Tipo '#13,v,#10', substituindo #nn por chr(nn).
  Usar , para separar um campo do outro... No exemplo acima o resultado seria
  chr(13)+'v'+chr(10)
 ---------------------------------------------------------------------------- }
function AscToString(const AString: String): AnsiString;
Var
  A : Integer ;
  Token : AnsiString ;
  VString : string;
  C : Char ;
begin
  VString := Trim( AString  );
  Result  := '' ;
  A       := 1  ;
  Token   := '' ;

  while A <= length( VString ) + 1 do
  begin
     if A > length( VString ) then
        C := ','
     else
        C := VString[A] ;

     if (C = ',') and (Length( Token ) >= 1) then
      begin
        if Token[1] = '#' then
        try
           Token := AnsiChr(StrToInt(copy(String(Token),2,length(String(Token)))));
        except
        end ;

        Result := Result + Token ;
        Token := '' ;
      end
     else
        Token := Token + AnsiString(C) ;

     A := A + 1 ;
  end ;
end;

{-----------------------------------------------------------------------------
 Substitui todos os caracteres de Controle ( menor que ASCII 32 ou maior que
 ASCII 127), de <AString> por sua representação em HEXA. (\xNN)
 Use StringToBinaryString para Converter para o valor original.
 ---------------------------------------------------------------------------- }
function BinaryStringToString(const AString: AnsiString): AnsiString;
var
   ASC : Integer;
   I, N : Integer;
begin
  Result  := '' ;
  N := Length(AString) ;
  For I := 1 to N do
  begin
     ASC := Ord(AString[I]) ;
     if (ASC < 32) or (ASC > 127) then
        Result := Result + AnsiString('\x'+Trim(IntToHex(ASC,2)))
     else
        Result := Result + AString[I] ;
  end ;
end ;

{-----------------------------------------------------------------------------
 Substitui toda representação em HEXA de <AString> (Iniciada por \xNN, (onde NN,
 é o valor em Hexa)).
 Retornana o Estado original, AString de BinaryStringToString.
 ---------------------------------------------------------------------------- }
function StringToBinaryString(const AString: AnsiString): AnsiString;
var
   P, I : LongInt;
   Hex : String;
   CharHex : AnsiString;
begin
  Result := AString ;

  P := pos('\x',String(Result)) ;
  while P > 0 do
  begin
     Hex := copy(String(Result),P+2,2) ;

     if (Length(Hex) = 2) and StrIsHexa(Hex) then
     begin
       try
          CharHex := AnsiChr(StrToInt('$'+Hex));
       except
          CharHex := ' ' ;
       end ;

       Result := ReplaceString(Result, '\x'+Hex, String(CharHex) );
       I := 1;
     end
     else
       I := 4;

     P := PosEx('\x', String(Result), P + I) ;
  end ;
end ;

{-----------------------------------------------------------------------------
 Retorna a String <AString> encriptada por <StrChave>.
 Use a mesma chave para Encriptar e Desencriptar
 ---------------------------------------------------------------------------- }
function StrCrypt(const AString, StrChave: AnsiString): AnsiString;
var
  i, TamanhoString, pos, PosLetra, TamanhoChave: Integer;
  C : AnsiChar ;
begin
  Result        := AString;
  TamanhoString := Length(AString);
  TamanhoChave  := Length(StrChave);
  if (TamanhoChave = 0) or (TamanhoString = 0) then
    Exit;

  For i := 1 to TamanhoString do
  begin
     pos := (i mod TamanhoChave);
     if pos = 0 then
        pos := TamanhoChave;

     posLetra := ord(Result[i]) xor ord(StrChave[pos]);
     if posLetra = 0 then
        posLetra := ord(Result[i]);

     C := AnsiChr(posLetra);
     Result[i] := C ;
  end;
end ;

{-----------------------------------------------------------------------------
 Retorna a soma dos Valores ASCII de todos os char de <AString>
 -----------------------------------------------------------------------------}
function SomaAscII(const AString : AnsiString): Integer;
Var A , TamanhoString : Integer ;
begin
  Result        := 0 ;
  TamanhoString := Length(AString);

  For A := 1 to TamanhoString do
     Result := Result + ord( AString[A] ) ;
end ;

{-----------------------------------------------------------------------------
 Retorna valor de CRC16 de <AString>    http://www.ibrtses.com/delphi/dcrc.html
 -----------------------------------------------------------------------------}
function StringCrc16(const AString : AnsiString ):word;

  procedure ByteCrc(data:byte;var crc:word);
   Var i : Byte;
  begin
    For i := 0 to 7 do
    begin
       if ((data and $01) xor (crc and $0001)<>0) then
        begin
          crc := crc shr 1;
          crc := crc xor $A001;
        end
       else
          crc := crc shr 1;

       data := data shr 1; // this line is not ELSE and executed anyway.
    end;
  end;

  var len,i : integer;
begin
 len    := length(AString);
 Result := 0;

 For i := 1 to len do
    bytecrc( ord( AString[i] ), Result);
end;


{-----------------------------------------------------------------------------
 Lê 1 byte de uma porta de Hardware
 Nota: - Essa Funçao Funciona normalmente em Win9x,
        - XP /NT /2000, deve-se usar um device driver que permita acesso direto
          a porta do Hardware a ser acessado (consulte o Fabricante do Hardware)
        - Linux: é necessário ser ROOT para acessar man man
          (use: su  ou  chmod u+s SeuPrograma )
 ---------------------------------------------------------------------------- }
{$WARNINGS OFF}
function InPort(const PortAddr:word): byte;
var
  Buffer : Pointer ;
  FDevice : String ;
  N : Integer ;
  FHandle : Integer ;
begin
  LoadInpOut;
  if Assigned( xInp32 ) then
     Result := xInp32(PortAddr)
end ;
{$WARNINGS ON}

{-----------------------------------------------------------------------------
 Envia 1 byte para uma porta de Hardware
 Nota: - Essa Funçao Funciona normalmente em Win9x,
        - XP /NT /2000, deve-se usar um device driver que permita acesso direto
          a porta do Hardware a ser acessado (consulte o Fabricante do Hardware)
        - Linux: é necessário ser ROOT para acessar /dev/port
          (use: su  ou  chmod u+s SeuPrograma )
 ---------------------------------------------------------------------------- }
procedure OutPort(const PortAddr: word; const Databyte: byte);
var
  Buffer : Pointer ;
  FDevice : String ;
  N : Integer ;
  FHandle : Integer ;
begin
  LoadInpOut;
  if Assigned( xOut32 ) then
     xOut32(PortAddr, Databyte)
end ;

{-----------------------------------------------------------------------------
 Retorna String contendo o Path da Aplicação
-----------------------------------------------------------------------------}
function ApplicationPath: String;
begin
  Result := PathWithDelim(ExtractFilePath(ParamStr(0)));
end;

{-----------------------------------------------------------------------------
 Encontra arquivos que correspondam a "FileMask" e cria lista com o Path e nome
 dos mesmos em "AstringList"
-----------------------------------------------------------------------------}
procedure FindFiles(const FileMask: String; AStringList: TStrings;
  IncludePath: Boolean; SortType: TFindFileSortType;
  SortDirection: TFindFileSortDirection);
var
  SearchRec: TSearchRec;
  RetFind, I: Integer;
  LastFile, AFileName, APath: String;
  SL: TStringList;
begin
 AStringList.Clear;

  LastFile := '' ;
  if IncludePath then
    APath := ExtractFilePath(FileMask)
  else
    APath := '';

  RetFind := SysUtils.FindFirst(FileMask, FaAnyFile, SearchRec);
  try
    while (RetFind = 0) and (LastFile <> SearchRec.Name) do
    begin
      LastFile := SearchRec.Name ;

      if pos(LastFile, '..') = 0 then    { ignora . e .. }
      begin
        AFileName := APath + LastFile;
        if (SortType = FstDateTime) then
          AFileName := DTtoS(FileDateToDateTime(SearchRec.Time)) + '|' + AFileName;

        AStringList.Add( AFileName ) ;
      end;

      SysUtils.FindNext(SearchRec) ;
    end ;
  Finally
    SysUtils.FindClose(SearchRec) ;
  end;

  if (SortType <> FstNone) then
  begin
    SL := TStringList.Create;
    try
      SL.Assign(AStringList);
      SL.Sort;

      AStringList.Clear;
      For I := 0 to SL.Count-1 do
      begin
        AFileName := SL[I];
        if (SortType = FstDateTime) then
          AFileName := copy(AFileName, pos('|', AFileName)+1, Length(SL[I]));

        if (SortDirection = FsdDescending) then
          AStringList.Insert(0, AFileName)
        else
          AStringList.Add(AFileName);
      end;
    Finally
      SL.Free;
    end;
  end;
end;

{-----------------------------------------------------------------------------
  Semelhante a FileExists, mas permite uso de mascaras Ex:(*.BAK, TEST*.PX, etc)
 ---------------------------------------------------------------------------- }
function FilesExists(const FileMask : String) : Boolean ;
var SearchRec : TSearchRec ;
    RetFind   : Integer ;
    LastFile  : string ;
begin
  LastFile := '' ;
  Result   := False ;
  RetFind  := SysUtils.FindFirst(FileMask, FaAnyFile, SearchRec) ;
  try
     while (not Result) and (RetFind = 0) and (LastFile <> SearchRec.Name) do
     begin
        LastFile := SearchRec.Name ;
        Result   := (pos(LastFile, '..') = 0) ;   { ignora . e .. }
        SysUtils.FindNext(SearchRec) ;
     end ;
  Finally
     SysUtils.FindClose(SearchRec) ;
  end ;
end ;


{-----------------------------------------------------------------------------
  Semelhante a DeleteFile, porem tenta deletar o Arquivo por
  <WaitTime> milisegundos. Gera Exceção se não conseguir apagar o arquivo.
 ---------------------------------------------------------------------------- }
procedure TryDeleteFile(const AFile : String ; WaitTime : Integer) ;
Var
  TFim : TDateTime ;
  Ok: Boolean;
begin
  if EstaVazio(AFile) or (not FileExists(AFile)) then
    exit ;

  TFim := IncMilliSecond(now,WaitTime) ;
  repeat
     SysUtils.DeleteFile( AFile ) ;
     Ok := (not FileExists( AFile ));
     if Ok then
       Break;

     Sleep(100);
  until (now > TFim) ;

  if not Ok then
     raise Exception.Create('Erro ao apagar: ' + AFile);
end ;
{-----------------------------------------------------------------------------
  Semelhante a DeleteFile, mas permite uso de mascaras Ex:(*.BAK, TEST*.PX, etc)
  Gera Exceção se não conseguir apagar algum dos arquivos.
 ---------------------------------------------------------------------------- }
procedure DeleteFiles(const FileMask : String ; RaiseExceptionOnFail : Boolean
   ) ;
var SearchRec : TSearchRec ;
    RetFind   : Integer ;
    LastFile  : string ;
    Path      : String ;
begin
  LastFile := '' ;
  Path     := ExtractFilePath(FileMask) ;
  RetFind  := SysUtils.FindFirst(FileMask, FaAnyFile, SearchRec);
  try
     while (RetFind = 0) and (LastFile <> SearchRec.Name) do
     begin
        LastFile := SearchRec.Name ;

        if pos(LastFile, '..') = 0 then    { ignora . e .. }
        begin
           if not SysUtils.DeleteFile(Path + LastFile) then
             if RaiseExceptionOnFail then
               raise Exception.Create('Erro ao apagar: ' + Path + LastFile);
        end ;

        SysUtils.FindNext(SearchRec) ;
     end ;
  Finally
     SysUtils.FindClose(SearchRec) ;
  end ;
end ;

{-----------------------------------------------------------------------------
 *** CopyFileTo Extraida de idGlobals.pas - INDY ***
 Copia arquivo "AFromFilename" para "AToFilename".  Retorna true se OK
 Nao copia, e retorna False se o destino "AToFilename" já existir e
   "AFailIfExists"  For true
 ---------------------------------------------------------------------------- }
function CopyFileTo(const AFromFileName, AToFileName : String;
   const AFailIfExists : Boolean) : Boolean;
var LStream : TStream;
begin
  Result := CopyFile(PChar(AFromFileName), PChar(AToFileName), AFailIfExists);
end;

{-----------------------------------------------------------------------------
  Verifica se <APath> possui "PathDelim" no Final. Retorna String com o Path
  já ajustado
 ---------------------------------------------------------------------------- }
function PathWithDelim(const APath : String) : String ;
begin
  Result := Trim(APath) ;
  if Result <> '' then
  begin
    if RightStr(Result,1) <> PathDelim then   { Tem delimitador no Final ? }
      Result := Result + PathDelim ;
  end;
end ;

{-----------------------------------------------------------------------------
  Verifica se <APath> possui "PathDelim" no Final. Retorna String SEM o
  DELIMITADOR de Path no Final
 ---------------------------------------------------------------------------- }
function PathWithoutDelim(const APath : String) : String ;
Var
  Delimiters : AnsiString ;
begin
  Result := Trim(APath) ;

  Delimiters := PathDelim+'/\' ;
  while (Result <> '') and (pos(String(RightStr(Result,1)), String(Delimiters) ) > 0) do   { Tem delimitador no Final ? }
     Result := copy(Result,1,Length(Result)-1)
end;

{-----------------------------------------------------------------------------
  Copia todos os arquivos especificados na mascara <FileMask> para o diretório
  <ToDirName>   Gera Exceção se não conseguir copiar algum dos arquivos.
 ---------------------------------------------------------------------------- }
procedure CopyFilesToDir(FileMask : String ; ToDirName : String ;
   const ForceDirectory : Boolean) ;
var SearchRec : TSearchRec ;
    RetFind   : Integer ;
    LastFile  : string ;
    Path      : String ;
begin
  ToDirName := PathWithDelim(ToDirName) ;
  FileMask  := Trim(FileMask) ;

  if ToDirName = '' then
     raise Exception.Create('Diretório destino não especificado') ;

  if not DirectoryExists(ToDirName) then
  begin
     if not ForceDirectory then
        raise Exception.Create('Diretório ('+ToDirName+') não existente.')
     else
      begin
        ForceDirectories( ToDirName ) ;  { Tenta criar o diretório }
        if not DirectoryExists( ToDirName ) then
           raise Exception.Create( 'Não Foi possivel criar o diretório' + sLineBreak +
                                   ToDirName);
      end ;
  end ;

  LastFile := '' ;
  Path     := ExtractFilePath(FileMask) ;
  RetFind  := SysUtils.FindFirst(FileMask, FaAnyFile, SearchRec);
  try
     while (RetFind = 0) and (LastFile <> SearchRec.Name) do
     begin
        LastFile := SearchRec.Name ;

        if pos(LastFile, '..') = 0 then    { ignora . e .. }
        begin
           if not CopyFileTo(Path + LastFile, ToDirName + LastFile) then
             raise Exception.Create('Erro ao Copiar o arquivo ('+
                  Path + LastFile + ') para o diretório ('+ToDirName+')') ;
        end ;

        SysUtils.FindNext(SearchRec) ;
     end ;
  Finally
     SysUtils.FindClose(SearchRec) ;
  end ;
end ;

{-----------------------------------------------------------------------------
 - Executa programa Externo descrito em "Command", adcionando os Parametros
   "Params" na linha de comando
 - Se "Wait" For true para a execução da aplicação para esperar a conclusao do
   programa externo executado por "Command"
 - WindowState apenas é utilizado na plataforma Windows
 ---------------------------------------------------------------------------- }
procedure RunCommand(const Command: String; const Params: String;
   Wait : Boolean; WindowState : Word);
var
   SUInfo: TStartupInfo;
   ProcInfo: TProcessInformation;
   Executed : Boolean ;
   PCharStr : PChar ;
  ConnectCommand : PChar;
begin
     PCharStr := PChar(Trim(Params)) ;
     if Length(PCharStr) = 0 then
        PCharStr := nil ;

     if not Wait then
        ShellExecute(0,'open',PChar(Trim(Command)),PCharStr, nil, WindowState )
     else
      begin
        ConnectCommand := PChar(Trim(Command) + ' ' + Trim(Params));
        PCharStr := PChar(ExtractFilePath(Command)) ;
        if Length(PCharStr) = 0 then
           PCharStr := nil ;
        FillChar(SUInfo, SizeOf(SUInfo), #0);
        with SUInfo do
        begin
           cb          := SizeOf(SUInfo);
           dwFlags     := STARTF_USESHOWWINDOW;
           wShowWindow := WindowState;
        end;

        Executed := CreateProcess(nil, ConnectCommand, nil, nil, False,
                    CREATE_NEW_CONSOLE or NORMAL_PRIORITY_CLASS, nil,
                    PCharStr, SUInfo, ProcInfo);

        try
           { Aguarda até ser Finalizado }
           if Executed then
              WaitForSingleObject(ProcInfo.hProcess, INFINITE);
        Finally
           { Libera os Handles }
           CloseHandle(ProcInfo.hProcess);
           CloseHandle(ProcInfo.hThread);
        end;
      end;
end;

procedure OpenURL( const URL : String ) ;
begin
  RunCommand(URL);
end ;

 Function FlushToDisk(const sFile: string): boolean;
 { Fonte: http://stackoverflow.com/questions/1635947/how-to-make-sure-that-a-file-was-permanently-saved-on-usb-when-user-doesnt-use }
 var
   hDrive: THandle;
   S:      string;
   OSFlushed: boolean;
   bResult: boolean;
 begin
   bResult := False;
   S := '\\.\' + ExtractFileDrive( sFile )[1] + ':';

   //NOTE: this may only work For the SYSTEM user
   hDrive    := CreateFile(PChar(S), GENERIC_READ or
     GENERIC_WRITE, FILE_SHARE_READ or FILE_SHARE_WRITE, nil,
     OPEN_EXISTING, 0, 0);
   OSFlushed := FlushFileBuffers(hDrive);

   CloseHandle(hDrive);

   if OSFlushed then
   begin
     bResult := True;
   end;

   Result := bResult;
 end;

 Function FlushFileToDisk(const sFile: string): boolean;
 { Discussão em: http://www.djsystem.com.br/acbr/forum/viewtopic.php?f=5&t=5811 }
 var
   hFile: THandle;
   //bResult: boolean;
   //lastErr: Cardinal;
   Filename: WideString;
 begin
   //Result := False;

   Filename := '\\.\' + sFile; //Para usar a versão Wide da Função CreateFile e aceitar o caminho completo do arquivo

   hFile := Windows.CreateFileW( PWideChar(filename),
               GENERIC_READ or GENERIC_WRITE,
               FILE_SHARE_READ or FILE_SHARE_WRITE, nil, OPEN_EXISTING,
               FILE_ATTRIBUTE_NORMAL  or FILE_FLAG_WRITE_THROUGH or FILE_FLAG_NO_BUFFERING, 0);

//   GetLasError Verifica se houve algum erro na execução de CreateFile
//   lastErr := GetLastError();
//
//   if (lastErr <> ERROR_SUCCESS) then
//   begin
//     Beep( 750, 100);
////     try
//       RaiseLastOSError(lastErr);
////     except
////       on Ex : EOSError do
////       begin
////          MessageDlg('Caught an OS error with code: ' +
////             IntToStr(Ex.ErrorCode), mtError, [mbOK], 0);
////          SetLastError(ERROR_SUCCESS);
////       end
////     end;
//   end;

    Result := FlushFileBuffers(hFile);

//   GetLasError Verifica se houve algum erro na execução de FlushFileBuffers
//    lastErr := GetLastError();
//
//    if (lastErr <> ERROR_SUCCESS) then
//    begin
//   if (lastErr <> ERROR_SUCCESS) then
//   begin
//     Beep( 750, 100);
////     try
//       RaiseLastOSError(lastErr);
////     except
////       on Ex : EOSError do
////       begin
////          MessageDlg('Caught an OS error with code: ' +
////             IntToStr(Ex.ErrorCode), mtError, [mbOK], 0);
////          SetLastError(ERROR_SUCCESS);
////       end
////     end;
//   end;

    CloseHandle(hFile);
 end;

{-----------------------------------------------------------------------------
 - Tenta desligar a Maquina.
 - Se "Reboot" For true Reinicializa
 *** Versão Windows extraida do www.forumweb.com.br/forum  por: Rafael Luiz ***
 ---------------------------------------------------------------------------- }
procedure DesligarMaquina(Reboot : Boolean ; Forcar : Boolean ; LogOff : Boolean
   ) ;

   Function WindowsNT: Boolean;
   var
     osVersao : TOSVersionInfo;
   begin
     osVersao.dwOSVersionInfoSize := SizeOf(TOSVersionInfo);
     GetVersionEx(osVersao);
     Result := osVersao.dwPlatformID = VER_PLATFORM_WIN32_NT;
   end;

   procedure ObtemPrivilegios;
   var
     tmpLUID : TLargeInteger;
     hdlProc, hdlToken : THandle;
     tkpNovo, tkpIgnore : TTokenPrivileges;
     dwBuffer, dwIgnoreBuffer : DWord;
   begin
     // Abrir token do processo para ajustar privilégios
     hdlProc := GetCurrentProcess;
     OpenProcessToken(hdlProc, TOKEN_ADJUST_PRIVILEGES or TOKEN_QUERY,
         hdlToken);

     // Obter o identificador único do privilégio de shutdown
     LookupPrivilegeValue('', 'SeShutdownPrivilege', tmpLUID);

     // Habilita o privilégio de shutdown em novo token
     tkpNovo.PrivilegeCount := 1;
     tkpNovo.Privileges[0].Luid := tmpLUID;
     tkpNovo.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
     dwBuffer := SizeOf(TTokenPrivileges);

     // Ajusta o privilégio com o novo token
     AdjustTokenPrivileges(hdlToken, False, tkpNovo,
         dwbuffer, tkpIgnore, dwIgnoreBuffer);
   end;


Var
  RebootParam : Longword ;
begin
    if WindowsNT then
       ObtemPrivilegios;

    if Reboot then
       RebootParam := EWX_REBOOT
    else if LogOff then
       RebootParam := EWX_LOGOFF
    else
       RebootParam := EWX_SHUTDOWN  ;

    if Forcar then
       RebootParam := RebootParam or EWX_FORCE ;

    ExitWindowsEx(RebootParam, 0);
end;

// Origem: https://www.experts-exchange.com/questions/20294536/WM-ACTIVATE.html
function ForceForeground(AppHandle:{$IfDef FPC}LCLType.HWND{$Else}THandle{$EndIf}): boolean;
const
  SPI_GETFOREGROUNDLOCKTIMEOUT = $2000;
  SPI_SETFOREGROUNDLOCKTIMEOUT = $2001;
var
  ForegroundThreadID: DWORD;
  ThisThreadID      : DWORD;
  timeout           : DWORD;
  OSVersionInfo     : TOSVersionInfo;
  Win32Platform     : Integer;
begin
  if IsIconic(AppHandle) then
    ShowWindow(AppHandle, SW_RESTORE);

  if (GetForegroundWindow = AppHandle) then
    Result := True
  else
  begin
    Win32Platform := 0;
    OSVersionInfo.dwOSVersionInfoSize := SizeOf(OSVersionInfo);
    if GetVersionEx(OSVersionInfo) then
      Win32Platform := OSVersionInfo.dwPlatformId;

    { Windows 98/2000 doesn't want to Foreground a window when some other window has keyboard Focus}

    if ((Win32Platform = VER_PLATFORM_WIN32_NT) and (OSVersionInfo.dwMajorVersion > 4)) or
       ((Win32Platform = VER_PLATFORM_WIN32_WINDOWS) and ((OSVersionInfo.dwMajorVersion > 4) or
       ((OSVersionInfo.dwMajorVersion = 4) and (OSVersionInfo.dwMinorVersion > 0)))) then
    begin
      Result := False;
      ForegroundThreadID := GetWindowThreadProcessID(GetForegroundWindow,nil);
      ThisThreadID := GetWindowThreadPRocessId(AppHandle,nil);

      if AttachThreadInput(ThisThreadID, ForegroundThreadID, true) then
      begin
        BringWindowToTop(AppHandle);
        SetForegroundWindow(AppHandle);
        AttachThreadInput(ThisThreadID, ForegroundThreadID, False);
        Result := (GetForegroundWindow = AppHandle);
      end;

      if not Result then
      begin
        SystemParametersInfo(SPI_GETFOREGROUNDLOCKTIMEOUT, 0, @timeout, 0);
        SystemParametersInfo(SPI_SETFOREGROUNDLOCKTIMEOUT, 0, TObject(0), SPIF_SENDCHANGE);
        BringWindowToTop(AppHandle);
        SetForegroundWindow(AppHandle);
        SystemParametersInfo(SPI_SETFOREGROUNDLOCKTIMEOUT, 0, TObject(timeout), SPIF_SENDCHANGE);
        Result := (GetForegroundWindow = AppHandle);

        if not Result then
        begin
          ShowWindow(AppHandle,SW_HIDE);
          ShowWindow(AppHandle,SW_SHOWMINIMIZED);
          ShowWindow(AppHandle,SW_SHOWNORMAL);
          BringWindowToTop(AppHandle);
          SetForegroundWindow(AppHandle);
        end;
      end;
    end
    else
    begin
      BringWindowToTop(AppHandle);
      SetForegroundWindow(AppHandle);
    end;

    Result := (GetForegroundWindow = AppHandle);
  end;
end;

function TranslateUnprintable(const ABinaryString: AnsiString): String;
Var
  Buf, Ch : String ;
  I   : Integer ;
  ASC : Byte ;
begin
  Buf := '' ;
  For I := 1 to Length(ABinaryString) do
  begin
     ASC := Ord(ABinaryString[I]) ;

     case ABinaryString[I] of
        NUL   : Ch := '[NUL]' ;
        SOH   : Ch := '[SOH]' ;
        STX   : Ch := '[STX]' ;
        ETX   : Ch := '[ETX]' ;
        ENQ   : Ch := '[ENQ]' ;
        ACK   : Ch := '[ACK]' ;
        TAB   : Ch := '[TAB]' ;
        BS    : Ch := '[BS]' ;
        LF    : Ch := '[LF]' ;
        FF    : Ch := '[FF]' ;
        CR    : Ch := '[CR]' ;
        WAK   : Ch := '[WAK]' ;
        NAK   : Ch := '[NAK]' ;
        ESC   : Ch := '[ESC]' ;
        FS    : Ch := '[FS]' ;
        GS    : Ch := '[GS]' ;
        #32..#126 : Ch := String(ABinaryString[I]) ;
     else ;
       Ch := '['+IntToStr(ASC)+']'
     end;

     Buf := Buf + Ch ;
  end ;

  Result := Buf;
end;

{-----------------------------------------------------------------------------
  Tenta carregar a Biblioteca (DLL) <LibName> e veirica se a Função <FuncName>
  existe na DLL. Se existir, retorna ponteiro para a DLL em <LibPointer>
  Veja Exempo de uso em InPort e OutPort (logo acima)
  ( Função encontrada na Internet - Autor desconhecido )
 -----------------------------------------------------------------------------}
function FunctionDetect (LibName, FuncName: String; var LibPointer: Pointer): boolean;
Var
  LibHandle: TLibHandle;
begin
 Result := FunctionDetect(LibName, FuncName, LibPointer, LibHandle);
end;

function FunctionDetect(LibName, FuncName: String; var LibPointer: Pointer;
  var LibHandle: TLibHandle): boolean;
begin
 Result := False;
 LibPointer := NIL;
// {$IFDEF FPC}
//  LibHandle := dynlibs.LoadLibrary(LibName) ;
// {$ELSE}
  if LoadLibrary(PChar(LibName)) = 0 then
     exit;                                 { não consegiu ler a DLL }

  LibHandle := GetModuleHandle(PChar(LibName));  { Pega o handle da DLL }
// {$ENDIF}

 if LibHandle <> 0 then                    { Se 0 não pegou o Handle, Falhou }
  begin
     LibPointer := GetProcAddress(LibHandle, PChar(FuncName));{Procura a Função}
     if LibPointer <> NIL then
        Result := true;
  end;
end;

function UnLoadLibrary(LibName: String ): Boolean ;
var
  LibHandle: TLibHandle ;
begin
 Result := True ;

 if LibName = '' then Exit;

 LibHandle := GetModuleHandle( PChar( LibName ) );
 if LibHandle <> 0 then
    Result := FreeLibrary( LibHandle )
end ;


//funcoes para uso com o modulo Sintegra ***********************************************

function TBStrZero(const i: string; const Casas: byte): string;
var
  Ch: Char;
begin
  Result := I;

  if length(i)>Casas then
    Exit
  else
    Ch := '0';

  while Length(Result) < Casas do
    Result := Ch + Result;
end;

function TiraPontos(Str: string): string;
var
  i, Count: Integer;
begin
  SetLength(Result, Length(str));
  Count := 0;
  For i := 1 to Length(str) do
  begin
    if not CharInSet(str[i], [ '/',',','-','.',')','(',' ' ]) then
    begin
      inc(Count);
      Result[Count] := str[i];
    end;
  end;
  SetLength(Result, Count);
end;

function Space(Tamanho: Integer): string;
begin
  Result := StringOfChar(' ', Tamanho);
end;

function LinhaSimples(Tamanho: Integer): string;
begin
  Result := StringOfChar('-', Tamanho);
end;

function LinhaDupla(Tamanho: Integer): string;
begin
  Result := StringOfChar('=', Tamanho);
end;

{------------------------------------------------------------------------------
  Traduz uma String de uma página de código para outra
http://www.experts-exchange.com/Programming/Languages/Pascal/Delphi/Q_10147769.html
 ------------------------------------------------------------------------------}
function TranslateString(const S: AnsiString; CP_Destino: Word; CP_Atual: Word = 0): AnsiString;
   Function WideStringToStringEx(const WS: WideString; CodePage: Word): AnsiString;
   var
     L: Integer;
   begin
     L := WideCharToMultiByte(CodePage, 0, PWideChar(WS), -1, nil, 0, nil, nil);
     SetLength(Result, L - 1);
     WideCharToMultiByte(CodePage, 0, PWideChar(WS), -1, PAnsiChar(Result), L - 1, nil, nil);
   end;

   Function StringToWideStringEx(const S: AnsiString; CodePage: Word): WideString;
   var
     L: Integer;
   begin
     L:= MultiByteToWideChar(CodePage, 0, PAnsiChar(S), -1, nil, 0);
     SetLength(Result, L - 1);
     MultiByteToWideChar(CodePage, 0, PAnsiChar(S), -1, PWideChar(Result), L - 1);
   end;
 begin
   Result := WideStringToStringEx( StringToWideStringEx(S, CP_Atual), CP_Destino);
 end;

function MatchText(const AText: String; const AValues: array of String
  ): Boolean;
var
  I: Integer;
begin
  Result := False;
  For I := Low(AValues) to High(AValues) do
    if AText = AValues[I] then
    begin
      Result := True;
      Break;
    end;
end;

{------------------------------------------------------------------------------
  Encontra qual é o primeiro Delimitador usado, em "AText", em uma lista de
  delimitadores, informada em "ADelimiters".
  Se "ADelimiters" For vazio, usa como padrão ";,|"
 ------------------------------------------------------------------------------}
function FindDelimiterInText(const AText: String; ADelimiters: String): Char;
var
  I: Integer;
begin
  if (ADelimiters = '') then
    ADelimiters := ';,|';

  Result := ' ';
  I := 1;
  while (Result = ' ') and (I <= Length(ADelimiters)) do
  begin
    if (pos( ADelimiters[I], AText) > 0) then
      Result := ADelimiters[I];

    Inc(I);
  end;
end;

{------------------------------------------------------------------------------
  Quebra a String "AText", em várias linhas, separando-a de acordo com a ocorrência
  de "ADelimiter", e adiciona os Itens encontrados em "AStringList".
  Retorna o número de Itens Inseridos.
  Informe #0 em "AQuoteChar", para que as Aspas Duplas sejam ignoradas na divisão
  Se AQuoteChar For diferente de #0, ele será considerado, para evitar os delimitadores
  que estão dentro de um contexto do QuoteChar...
  Veja exemplos de uso e retorno em: "UtilTeste"
 ------------------------------------------------------------------------------}
function AddDelimitedTextToList(const AText: String; const ADelimiter: Char;
  AStringList: TStrings; const AQuoteChar: Char): Integer;
var
  SL: TStringList;
begin
  Result := 0;
  if (AText = '') then
    Exit;

  SL := TStringList.Create;
  try
     SL.Delimiter := ADelimiter;
     SL.QuoteChar := AQuoteChar;
     SL.StrictDelimiter := True;
     SL.DelimitedText := AText;
    Result := SL.Count;

    AStringList.AddStrings(SL);
  Finally
    SL.Free;
  end;
end;

function UnZip(S: TStream): AnsiString;
begin
  Result := Myloo.Compress.DeCompress(S);
end;

function UnZip(const ABinaryString: AnsiString): AnsiString;
begin
  Result := Myloo.Compress.DeCompress(ABinaryString);
end;

function Zip(AStream: TStream): AnsiString;
begin
  Result := Myloo.Compress.ZLibCompress(AStream);
end;

function Zip(const ABinaryString: AnsiString): AnsiString;
begin
 Result := Myloo.Compress.ZLibCompress(ABinaryString);
end;

function Split(const ADelimiter: Char; const AString: string): TSplitResult;
var
  i, ACount: Integer;
  vRows: TStrings;
begin
  vRows := TStringList.Create;
  try
    ACount := AddDelimitedTextToList(AString, ADelimiter, vRows);
    SetLength(Result, ACount);
    For i := 0 to ACount - 1 do
      Result[i] := vRows.Strings[i];
  Finally
    FreeAndNil(vRows);
  end;
end;

{------------------------------------------------------------------------------
   Realiza o tratamento de uma String recebida de um Serviço Web

   - Se a String recebida For UTF8:
     - Delphi 7, converte a String para Ansi
     - Delphi XE, converte para UnicodeString (UTF16)
     - Lazarus converte de AnsiString para String
   - Se a String recebida For Ansi
     - No Delphi 7, converte de AnsiString para String
     - No Delphi XE, converte de Ansi para UnicodeString
     - No Lazarus, converte de Ansi para UTF8
 ------------------------------------------------------------------------------}
function DecodeToString(const ABinaryString: AnsiString; const StrIsUTF8: Boolean
  ): String;
begin
  if StrIsUTF8 then
    Result := UTF8ToNativeString(ABinaryString)
  else
    Result := AnsiToNativeString(ABinaryString);
end;

function SeparaDados(const AString: String; const Chave: String;
  const MantemChave: Boolean): String;
var
  PosIni, PosFim : Integer;
  UTexto, UChave :String;
begin
  UTexto := AnsiUpperCase(AString);
  UChave := AnsiUpperCase(Chave);
  PosFim := 0;

  if MantemChave then
   begin
     PosIni := Pos('<' + UChave, UTexto);
     if PosIni > 0 then
       PosFim := Pos('/' + UChave, UTexto) + length(UChave) + 3;

     if (PosFim = 0) then
      begin
        PosIni := Pos('NS2:' + UChave, UTexto) - 1;
        if PosIni > 0 then
          PosFim := Pos('/NS2:' + UChave, UTexto) + length(UChave) + 3;
      end;
   end
  else
   begin
     PosIni := Pos('<' + UChave, UTexto) ;
     if PosIni > 0 then
     begin
       PosIni := PosIni + Pos('>', copy(UTexto, PosIni, length(UTexto)));
       PosFim := Pos('/' + UChave, UTexto);
     end;

     if (PosFim = 0) then
      begin
        PosIni := Pos('NS2:' + UChave, UTexto) ;
        if PosIni > 0 then
        begin
          PosIni := PosIni + Pos('>', copy(UTexto, PosIni, length(UTexto)));
          PosFim := Pos('/NS2:' + UChave, UTexto);
        end ;
      end;
   end;

  Result := copy(AString, PosIni, PosFim - (PosIni + 1));
end;

function SeparaDadosArray(const AArray: array of String; const AString: String;
  const MantemChave: Boolean): String;
var
  I : Integer;
begin
 For I:=Low(AArray) to High(AArray) do
 begin
   Result := Trim(SeparaDados(AString,AArray[I], MantemChave));
   if Result <> '' then
      Exit;
 end;
end;

function RetornarConteudoEntre(const Frase, Inicio, Fim: String;
  IncluiInicioFim: Boolean): string;
var
  i: integer;
  s: string;
begin
  result := '';
  i := pos(Inicio, Frase);
  if i = 0 then
    Exit;

  if IncluiInicioFim then
  begin
    s := Copy(Frase, i, maxInt);
    result := Copy(s, 1, pos(Fim, s) + Length(Fim) - 1);
  end
  else
  begin
    s := Copy(Frase, i + length(Inicio), maxInt);
    result := Copy(s, 1, pos(Fim, s) - 1);
  end;
end;

{------------------------------------------------------------------------------
   Retorna a posição inicial e Final da Tag do XML
 ------------------------------------------------------------------------------}
procedure EncontrarInicioFinalTag(aText, ATag: ansistring;
  var PosIni, PosFim: integer; const PosOffset: integer = 0);
begin
  PosFim := 0;
  PosIni := PosEx('<' + ATag + '>', aText, PosOffset);
  if (PosIni > 0) then
  begin
    PosIni := PosIni + Length(ATag) + 1;
    PosFim := PosLast('</' + ATag + '>', aText);
    if PosFim < PosIni then
      PosFim := 0;
  end;
end;


{------------------------------------------------------------------------------
   Realiza o tratamento de uma String recebida de um Serviço Web
   Transforma caracteres HTML Entity em ASCII ou vice versa.
   No caso de decodificação, também transforma o Encoding de UTF8 para a String
   nativa da IDE
 ------------------------------------------------------------------------------}
function ParseText( const Texto : AnsiString; const Decode : Boolean = True;
   const IsUTF8: Boolean = True ) : String;
var
  AStr: String;

  Function InternalStringReplace(const S, OldPatern, NewPattern: String ): String;
  begin
    if pos(OldPatern, S) > 0 then
      Result := ReplaceString(AnsiString(S), AnsiString(OldPatern), AnsiString(Str(NewPattern)))
    else
      Result := S;
  end;

begin
  if Decode then
  begin
    Astr := DecodeToString( Texto, IsUTF8 ) ;

    Astr := InternalStringReplace(AStr, '&amp;'   , '&');
    AStr := InternalStringReplace(AStr, '&lt;'    , '<');
    AStr := InternalStringReplace(AStr, '&gt;'    , '>');
    AStr := InternalStringReplace(AStr, '&quot;'  , '"');
    AStr := InternalStringReplace(AStr, '&#39;'   , #39);
    AStr := InternalStringReplace(AStr, '&aacute;', 'á');
    AStr := InternalStringReplace(AStr, '&Aacute;', 'Á');
    AStr := InternalStringReplace(AStr, '&acirc;' , 'â');
    AStr := InternalStringReplace(AStr, '&Acirc;' , 'Â');
    AStr := InternalStringReplace(AStr, '&atilde;', 'ã');
    AStr := InternalStringReplace(AStr, '&Atilde;', 'Ã');
    AStr := InternalStringReplace(AStr, '&agrave;', 'à');
    AStr := InternalStringReplace(AStr, '&Agrave;', 'À');
    AStr := InternalStringReplace(AStr, '&eacute;', 'é');
    AStr := InternalStringReplace(AStr, '&Eacute;', 'É');
    AStr := InternalStringReplace(AStr, '&ecirc;' , 'ê');
    AStr := InternalStringReplace(AStr, '&Ecirc;' , 'Ê');
    AStr := InternalStringReplace(AStr, '&iacute;', 'í');
    AStr := InternalStringReplace(AStr, '&Iacute;', 'Í');
    AStr := InternalStringReplace(AStr, '&oacute;', 'ó');
    AStr := InternalStringReplace(AStr, '&Oacute;', 'Ó');
    AStr := InternalStringReplace(AStr, '&otilde;', 'õ');
    AStr := InternalStringReplace(AStr, '&Otilde;', 'Õ');
    AStr := InternalStringReplace(AStr, '&ocirc;' , 'ô');
    AStr := InternalStringReplace(AStr, '&Ocirc;' , 'Ô');
    AStr := InternalStringReplace(AStr, '&uacute;', 'ú');
    AStr := InternalStringReplace(AStr, '&Uacute;', 'Ú');
    AStr := InternalStringReplace(AStr, '&uuml;'  , 'ü');
    AStr := InternalStringReplace(AStr, '&Uuml;'  , 'Ü');
    AStr := InternalStringReplace(AStr, '&ccedil;', 'ç');
    AStr := InternalStringReplace(AStr, '&Ccedil;', 'Ç');
    AStr := InternalStringReplace(AStr, '&apos;'  , '''');
  end
  else
  begin
    AStr := string(Texto);
    AStr := StringReplace(AStr, '&', '&amp;' , [rfReplaceAll]);
    AStr := StringReplace(AStr, '<', '&lt;'  , [rfReplaceAll]);
    AStr := StringReplace(AStr, '>', '&gt;'  , [rfReplaceAll]);
    AStr := StringReplace(AStr, '"', '&quot;', [rfReplaceAll]);
    AStr := StringReplace(AStr, #39, '&#39;' , [rfReplaceAll]);
    AStr := StringReplace(AStr, '''','&apos;', [rfReplaceAll]);
  end;

  Result := AStr;
end;

{------------------------------------------------------------------------------
   Retorna o conteudo de uma Tag dentro de um arquivo XML
 ------------------------------------------------------------------------------}
function LerTagXML(const AXML, ATag: String; IgnoreCase: Boolean): String;
Var
  PI, PF : Integer ;
  UXML, UTAG: String;
begin
  Result := '';
  if IgnoreCase then
  begin
    UXML := UpperCase(AXML) ;
    UTAG := UpperCase(ATag) ;
  end
  else
  begin
    UXML := AXML ;
    UTAG := ATag ;
  end;

  PI := pos('<'+UTAG+'>', UXML ) ;
  if PI = 0 then exit ;

  PI := PI + Length(UTAG) + 2;
  PF := PosEx('</'+UTAG+'>', UXML, PI) ;
  if PF = 0 then
     PF := Length(AXML);

  Result := copy(AXML, PI, PF-PI)
end ;


{------------------------------------------------------------------------------
   Retorna True se o XML contêm a TAG de encoding em UTF8, no seu início.
 ------------------------------------------------------------------------------}
function XmlEhUTF8(const AXML: String): Boolean;
begin
  Result := (pos('encoding="utf-8"', LowerCase(LeftStr(AXML, 50))) > 0);
end;

{------------------------------------------------------------------------------
   Se XML não contiver a TAG de encoding em UTF8, no seu início, adiciona a TAG
   e converte o conteudo do mesmo para UTF8 (se necessário, dependendo da IDE)
 ------------------------------------------------------------------------------}
function ConverteXMLtoUTF8(const AXML: String): String;
var
  UTF8Str: AnsiString;
begin
  if not XmlEhUTF8(AXML) then   // Já Foi convertido antes ou montado em UTF8 ?
  begin
    UTF8Str := NativeStringToUTF8(AXML);
    Result := CUTF8DeclaracaoXML + String(UTF8Str);
  end
  else
    Result := AXML;
end;

{------------------------------------------------------------------------------
   Se XML contiver a TAG de encoding em UTF8, no seu início, remove a TAG
   e converte o conteudo do mesmo para String Nativa da IDE (se necessário, dependendo da IDE)
 ------------------------------------------------------------------------------}
function ConverteXMLtoNativeString(const AXML: String): String;
begin
  if XmlEhUTF8(AXML) then   // Já Foi convertido antes ou montado em UTF8 ?
  begin
    Result := UTF8ToNativeString(AnsiString(AXML));
  end
  else
    Result := AXML;
end;

{------------------------------------------------------------------------------
   Retorna a Declaração do XML, Ex: <?xml version="1.0"?>
   http://www.tizag.com/xmlTutorial/xmlprolog.php
 ------------------------------------------------------------------------------}
function ObtemDeclaracaoXML(const AXML: String): String;
var
  P1, P2: Integer;
begin
  Result := '';
  P1 := pos('<?', AXML);
  if P1 > 0 then
  begin
    P2 := PosEx('?>', AXML, P1+2);
    if P2 > 0 then
      Result := copy(AXML, P1, P2-P1+2);
  end;
end;

{------------------------------------------------------------------------------
   Retorna XML sem a Declaração, Ex: <?xml version="1.0"?>
 ------------------------------------------------------------------------------}
function RemoverDeclaracaoXML(const AXML: String): String;
var
  DeclaracaoXML: String;
begin
  DeclaracaoXML := ObtemDeclaracaoXML(AXML);

  if DeclaracaoXML <> '' then
    Result := StringReplace(AXML, DeclaracaoXML, '', [])
  else
    Result := AXML;
end;

{------------------------------------------------------------------------------
   Valida se é um arquivo válido para carregar em um MenIniFile, caso contrário
   adiciona a String convertendo representações em Hexa.
 ------------------------------------------------------------------------------}
procedure LerIniArquivoOuString(const IniArquivoOuString: AnsiString;
  AMemIni: TMemIniFile);
var
  SL: TStringList;
begin
  SL := TStringList.Create;
  try
    if (pos(LF, IniArquivoOuString) = 0) and FilesExists(IniArquivoOuString) then
      SL.LoadFromFile(IniArquivoOuString)
    else
      SL.Text := StringToBinaryString( IniArquivoOuString );

    AMemIni.SetStrings(SL);
  Finally
    SL.Free;
  end;
end;

procedure QuebrarLinha(const Alinha: string; const ALista: TStringList;
  const QuoteChar: char; Delimiter: char);
var
  P, P1: PChar;
  S: string;
begin
  ALista.BeginUpdate;
  try
    ALista.Clear;
    P := PChar(Alinha);

    while P^ <> #0 do
    begin
      if P^ = QuoteChar then
        S := AnsiExtractQuotedStr(P, QuoteChar)
      else
      begin
        P1 := P;
        while (P^ <> #0) and (P^ <> Delimiter) do
          P := CharNext(P);
        SetString(S, P1, P - P1);
      end;
      ALista.Add(S);

      if P^ = Delimiter then
      begin
        P1 := P;

        if CharNext(P1)^ = #0 then
          ALista.Add('');

        repeat
          P := CharNext(P);
          Inc(P);
        until not (CharInSet(P^, [#1..' ']));
      end;
    end;
  Finally
    ALista.EndUpdate;
  end;
end;

function FormatFloatBr(const AFormat: TFormatMask; const AValue: Extended): String; overload;
var
  Mask: String;
begin
  case AFormat of
    msk4x2  : Mask := '#,##0.00';
    msk7x2  : Mask := '#,###,##0.00';
    msk9x2  : Mask := '###,###,##0.00';
    msk10x2 : Mask := '#,###,###,##0.00';
    msk13x2 : Mask := '#,###,###,###,##0.00';
    msk15x2 : Mask := '###,###,###,###,##0.00';
    msk6x3  : Mask := ',0.000';
    msk6x4  : Mask := ',0.0000';
    mskAliq : Mask := '#00%';
  end;

  Result := FormatFloatBr(AValue, Mask);
end;

//*****************************************************************************************

procedure LoadInpOut;
begin
  if InpOutLoaded then exit;

  if not FunctionDetect(CINPOUTDLL,'Inp32',@xInp32) then
    xInp32 := NIL ;

  if not FunctionDetect(CINPOUTDLL,'Out32',@xOut32) then
    xOut32 := NIL ;

  InpOutLoaded := True;
end;

procedure LoadBlockInput;
begin
  if BlockInputLoaded then exit;

  if not FunctionDetect('USER32.DLL', 'BlockInput', @xBlockInput) then
     xBlockInput := NIL ;

  BlockInputLoaded := True;
end;

initialization
  InpOutLoaded := False;
  BlockInputLoaded := False;
  xInp32 := Nil;
  xOut32 := Nil;
  xBlockInput := Nil;
  Randomized := False ;
end.

