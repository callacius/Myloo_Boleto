unit Myloo.Boleto.Report.FastReport;

interface

uses
  System.SysUtils,
  System.Classes,
  Data.DB,
  Datasnap.DBClient,
  Myloo.Boleto,
  System.StrUtils,
  FrxClass,
  FrxDBSet,
  FrxBarcode,
  FrxExportHTML,
  FrxExportPDF,
  Vcl.Graphics,
  Vcl.Imaging.pngimage,
  Vcl.Imaging.jpeg,
  Vcl.Imaging.GIFImg,
  Myloo.Imaging,
  Myloo.Base64,
  Myloo.Boleto.Report.FastReport.Report,
  Myloo.Boleto.Images.LogoBancoColor,
  Myloo.Boleto.Images.LogoBancoPtoBco;

const
  CBoletoFCFR_Versao = '0.0.15';

type
  TTpReportStream = (tpsBoleto, tpsBoleto_Fatura_Novo, tpsBoletoCarne, tpsBoletoFatura, tpsBoletoFR, tpsBoletoNovo, tpsBoletoNovoAlpha, tpsBoletoUniprime);

  EBoletoFCFR = class(Exception);

  TBoletoFastReport = class;

  TBoletoFCFR = class(TBoletoFCClass)
  private
    MensagemPadrao: TStringList;
    { Private declarations }
    FUseStream:Boolean;
    FUseImgColor:Boolean;
    FTpRelatorioStream: TTpReportStream;
    FFastReportFile: String;
    FFastReportStream: TStream;
    FImpressora: String;
    FIndice: Integer;
    FBoletoFastReport: TBoletoFastReport;
    FModoThread: Boolean;
    FIncorporarFontesPdf: Boolean;
    FIncorporarBackgroundPdf: Boolean;
    Function PrepareBoletos: Boolean;
    Function PreparaRelatorio: Boolean;
    Function GetTitulo: TTitulo;
    Procedure SetTpRelatorioStream(Value:TTpReportStream);
  public
    { Public declarations }
    constructor Create;
    destructor Destroy; override;
    procedure Imprimir; override;
    Function CarregaFastReportFile: Boolean;
    Function CarregaFastReportStream: Boolean;
    Function PreparedReport: TfrxReport;
    property Titulo: TTitulo read GetTitulo;
//  published
    property UseStream:Boolean                  read FUseStream               write FUseStream default True;
    property UseImgColor:Boolean                read FUseImgColor             write FUseImgColor;
    property TpRelatorioStream: TTpReportStream read FTpRelatorioStream       write SetTpRelatorioStream;
    property FastReportFile: String             read FFastReportFile          write FFastReportFile;
    property FastReportStream: TStream          read FFastReportStream        write FFastReportStream;
    property Impressora: String                 read FImpressora              write FImpressora;
    property ModoThread: Boolean                read FModoThread              write FModoThread;
    property IncorporarBackgroundPdf: Boolean   read FIncorporarBackgroundPdf write FIncorporarBackgroundPdf;
    property IncorporarFontesPdf: Boolean       read FIncorporarFontesPdf     write FIncorporarFontesPdf;
  end;

  TBoletoFastReport = class
  private
    FUseStream:Boolean;
    FUseImgColor:Boolean;
    FImageLogo:TBitmap;
    FcdsTitulo: TClientDataSet;
    FfrxTitulo: TfrxDBDataset;
    FcdsCedente: TClientDataSet;
    FfrxCedente: TfrxDBDataset;
    FcdsBanco: TClientDataSet;
    FfrxBanco: TfrxDBDataset;
    FfrxReport: TfrxReport;
    FfrxHTMLExport: TfrxHTMLExport;
    FfrxPDFExport: TfrxPDFExport;
    FfrxBarCodeObject: TfrxBarCodeObject;
    procedure ImprimeLogoMarca(sCaminhoFoto, sfrxPicture: string); overload;
    procedure ImprimeLogoMarca(Value:TBitmap; sfrxPicture: string);overload;
    procedure SetDataSetsToFrxReport;
    Function GetImageBanco: TBitmap;
    property UseStream:Boolean                  read FUseStream               write FUseStream;
    property UseImgColor:Boolean                read FUseImgColor             write FUseImgColor;
    Property ImageLogo:TBitmap                  read FImageLogo               write FImageLogo;
  public
    constructor Create;
    procedure BeforePrint(Sender: TfrxReportComponent);
    Property cdsTitulo: TClientDataSet           read FcdsTitulo        write FcdsTitulo;
    Property FrxTitulo: TfrxDBDataset            read FfrxTitulo        write FfrxTitulo;
    Property cdsCedente: TClientDataSet          read FcdsCedente       write FcdsCedente;
    Property FrxCedente: TfrxDBDataset           read FfrxCedente       write FfrxCedente;
    Property cdsBanco: TClientDataSet            read FcdsBanco         write FcdsBanco;
    Property FrxBanco: TfrxDBDataset             read FfrxBanco         write FfrxBanco;
    Property FrxReport: TfrxReport               read FfrxReport        write FfrxReport;
    Property FrxHTMLExport: TfrxHTMLExport       read FfrxHTMLExport    write FfrxHTMLExport;
    Property FrxPDFExport: TfrxPDFExport         read FfrxPDFExport     write FfrxPDFExport;
    Property FrxBarCodeObject: TfrxBarCodeObject read FfrxBarCodeObject write FfrxBarCodeObject;
  end;

implementation

uses
  Myloo.Boleto.Utils, Myloo.Boleto.BancoBanestes;

{ TBoletoFastReport }

constructor TBoletoFastReport.Create;
begin
  FcdsTitulo            := TClientDataSet.Create(nil);
  FfrxTitulo            := TfrxDBDataset.Create(nil);
  FcdsCedente           := TClientDataSet.Create(nil);
  FfrxCedente           := TfrxDBDataset.Create(nil);
  FcdsBanco             := TClientDataSet.Create(nil);
  FfrxBanco             := TfrxDBDataset.Create(nil);
  FfrxReport            := TfrxReport.Create(nil);
  FfrxHTMLExport        := TfrxHTMLExport.Create(nil);
  FfrxPDFExport         := TfrxPDFExport.Create(nil);
  FfrxBarCodeObject     := TfrxBarCodeObject.Create(nil);

  with FcdsBanco do
  begin
    AutoCalcFields  := True;
    FetchOnDemand   := True;
    Close;
    FieldDefs.Clear;
    FieldDefs.Add('Numero', FtString, 20);
    FieldDefs.Add('Digito', FtString, 1);
    FieldDefs.Add('Nome', FtString, 100);
    FieldDefs.Add('DirLogo', FtString, 254);
    FieldDefs.Add('OrientacoesBanco', FtString, 254);
    CreateDataSet;
  end;
  with FcdsCedente do
  begin
    AutoCalcFields  := True;
    FetchOnDemand   := True;
    Close;
    FieldDefs.Clear;
    FieldDefs.Add('Nome', FtString, 100);
    FieldDefs.Add('CodigoCedente', FtString, 20);
    FieldDefs.Add('CodigoTransmissao', FtString, 20);
    FieldDefs.Add('Agencia', FtString, 5);
    FieldDefs.Add('AgenciaDigito', FtString, 2);
    FieldDefs.Add('Conta', FtString, 20);
    FieldDefs.Add('ContaDigito', FtString, 2);
    FieldDefs.Add('Modalidade', FtString, 20);
    FieldDefs.Add('Convenio', FtString, 20);
    FieldDefs.Add('ResponEmissao', FtInteger);
    FieldDefs.Add('CNPJCPF', FtString, 18);
    FieldDefs.Add('TipoInscricao', FtInteger);
    FieldDefs.Add('Logradouro', FtString, 100);
    FieldDefs.Add('NumeroRes', FtString, 10);
    FieldDefs.Add('Complemento', FtString, 100);
    FieldDefs.Add('Bairro', FtString, 100);
    FieldDefs.Add('Cidade', FtString, 100);
    FieldDefs.Add('UF', FtString, 2);
    FieldDefs.Add('CEP', FtString, 8);
    FieldDefs.Add('Telefone', FtString, 10);
    CreateDataSet;
  end;
  with FcdsTitulo do
  begin
    AutoCalcFields  := True;
    FetchOnDemand   := True;
    Close;
    FieldDefs.Clear;
    FieldDefs.Add('NossoNum', FtString, 100);
    FieldDefs.Add('CodCedente', FtString, 100);
    FieldDefs.Add('CodBarras', FtString, 100);
    FieldDefs.Add('LinhaDigitavel', FtString, 100);
    FieldDefs.Add('TipoDoc', FtString, 10);
    FieldDefs.Add('Vencimento', FtDateTime);
    FieldDefs.Add('DataDocumento', FtDateTime);
    FieldDefs.Add('NumeroDocumento', FtString, 20);
    FieldDefs.Add('TotalParcelas', FtInteger);
    FieldDefs.Add('Parcela', FtInteger);
    FieldDefs.Add('EspecieDoc', FtString, 10);
    FieldDefs.Add('EspecieMod', FtString, 10);
    FieldDefs.Add('Aceite', FtInteger);
    FieldDefs.Add('DataProcessamento', FtDateTime);
    FieldDefs.Add('NossoNumero', FtString, 20);
    FieldDefs.Add('Carteira', FtString, 20);
    FieldDefs.Add('ValorDocumento', FtBCD, 18);
    FieldDefs.Add('LocalPagamento', FtString, 100);
    FieldDefs.Add('ValorMoraJuros', FtBCD, 18);
    FieldDefs.Add('ValorDesconto', FtBCD, 18);
    FieldDefs.Add('ValorAbatimento', FtBCD, 18);
    FieldDefs.Add('DataMoraJuros', FtDateTime);
    FieldDefs.Add('DataDesconto', FtDateTime);
    FieldDefs.Add('DataAbatimento', FtDateTime);
    FieldDefs.Add('DataProtesto', FtDateTime);
    FieldDefs.Add('PercentualMulta', FtFloat);
    FieldDefs.Add('Mensagem', FtString, 300);
    FieldDefs.Add('OcorrenciaOriginal', FtInteger);
    FieldDefs.Add('Instrucao1', FtString, 300);
    FieldDefs.Add('Instrucao2', FtString, 300);
    FieldDefs.Add('TextoLivre', FtMemo, 2000);
    FieldDefs.Add('Asbace', FtString, 40);
    // Sacado
    FieldDefs.Add('Sacado_NomeSacado', FtString, 100);
    FieldDefs.Add('Sacado_CNPJCPF', FtString, 18);
    FieldDefs.Add('Sacado_Logradouro', FtString, 100);
    FieldDefs.Add('Sacado_Complemento', FtString, 100);
    FieldDefs.Add('Sacado_Numero', FtString, 10);
    FieldDefs.Add('Sacado_Bairro', FtString, 100);
    FieldDefs.Add('Sacado_Cidade', FtString, 100);
    FieldDefs.Add('Sacado_UF', FtString, 2);
    FieldDefs.Add('Sacado_CEP', FtString, 8);
    FieldDefs.Add('Sacado_Avalista', FtString, 100);
    FieldDefs.Add('Sacado_Avalista_CNPJCPF', FtString, 18);
    CreateDataSet;
  end;
  with FfrxBanco do
  begin
    DataSet    := FcdsBanco;
    Enabled    := True;
    RangeBegin := rbFirst;
    RangeEnd   := reLast;
    UserName   := 'Banco';
  end;
  with FfrxCedente do
  begin
    DataSet    := FcdsCedente;
    Enabled    := True;
    RangeBegin := rbFirst;
    RangeEnd   := reLast;
    UserName   := 'Cedente';
  end;
  with FfrxTitulo do
  begin
    DataSet    := FcdsTitulo;
    Enabled    := True;
    RangeBegin := rbFirst;
    RangeEnd   := reLast;
    UserName   := 'Titulo';
  end;
  with FfrxReport do
  begin
    OnBeforePrint := BeforePrint;
    PreviewOptions.Buttons := [pbPrint, pbLoad, pbSave, pbExport, pbZoom, pbFind, pbOutline, pbPageSetup, pbTools, pbNavigator, pbExportQuick];
    EngineOptions.UseGlobalDataSetList := False;
  end;
end;

procedure TBoletoFastReport.BeforePrint(Sender: TfrxReportComponent);
begin
  if UseStream then
  begin
    ImprimeLogoMarca(GetImageBanco, 'Logo_1');
    ImprimeLogoMarca(GetImageBanco, 'Logo_2');
    ImprimeLogoMarca(GetImageBanco, 'Logo_3');
  end
  else
  begin
    ImprimeLogoMarca(cdsBanco.FieldByName('DirLogo').AsString + '\' + cdsBanco.FieldByName('Numero').AsString + '.bmp', 'Logo_1');
    ImprimeLogoMarca(cdsBanco.FieldByName('DirLogo').AsString + '\' + cdsBanco.FieldByName('Numero').AsString + '.bmp', 'Logo_2');
    ImprimeLogoMarca(cdsBanco.FieldByName('DirLogo').AsString + '\' + cdsBanco.FieldByName('Numero').AsString + '.bmp', 'Logo_3');
  end;
end;

Function TBoletoFastReport.GetImageBanco:TBitmap;
begin
  if UseStream then
  begin
    if Self.UseImgColor then
    begin
      case FcdsBanco.FieldByName('Numero').AsInteger of
        1:   Result := TLogoBancoColorIMGs.Img001;
        3:   Result := TLogoBancoColorIMGs.Img003;
        4:   Result := TLogoBancoColorIMGs.Img004;
        8:   Result := TLogoBancoColorIMGs.Img008;
        21:  Result := TLogoBancoColorIMGs.Img021;
        24:  Result := TLogoBancoColorIMGs.Img024;
        27:  Result := TLogoBancoColorIMGs.Img027;
        28:  Result := TLogoBancoColorIMGs.Img028;
        29:  Result := TLogoBancoColorIMGs.Img029;
        31:  Result := TLogoBancoColorIMGs.Img031;
        33:  Result := TLogoBancoColorIMGs.Img033;
        36:  Result := TLogoBancoColorIMGs.Img036;
        38:  Result := TLogoBancoColorIMGs.Img038;
        41:  Result := TLogoBancoColorIMGs.Img041;
        47:  Result := TLogoBancoColorIMGs.Img047;
        70:  Result := TLogoBancoColorIMGs.Img070;
        85:  Result := TLogoBancoColorIMGs.Img085;
        97:  Result := TLogoBancoColorIMGs.Img097;
        99:  Result := TLogoBancoColorIMGs.Img099;
        104: Result := TLogoBancoColorIMGs.Img104;
        136: Result := TLogoBancoColorIMGs.Img136;
        151: Result := TLogoBancoColorIMGs.Img151;
        231: Result := TLogoBancoColorIMGs.Img231;
        237: Result := TLogoBancoColorIMGs.Img237;
        244: Result := TLogoBancoColorIMGs.Img244;
        246: Result := TLogoBancoColorIMGs.Img246;
        263: Result := TLogoBancoColorIMGs.Img263;
        275: Result := TLogoBancoColorIMGs.Img275;
        291: Result := TLogoBancoColorIMGs.Img291;
        320: Result := TLogoBancoColorIMGs.Img320;
        341: Result := TLogoBancoColorIMGs.Img341;
        347: Result := TLogoBancoColorIMGs.Img347;
        353: Result := TLogoBancoColorIMGs.Img353;
        356: Result := TLogoBancoColorIMGs.Img356;
        389: Result := TLogoBancoColorIMGs.Img389;
        392: Result := TLogoBancoColorIMGs.Img392;
        399: Result := TLogoBancoColorIMGs.Img399;
        409: Result := TLogoBancoColorIMGs.Img409;
        422: Result := TLogoBancoColorIMGs.Img422;
        424: Result := TLogoBancoColorIMGs.Img424;
        453: Result := TLogoBancoColorIMGs.Img453;
        479: Result := TLogoBancoColorIMGs.Img479;
        600: Result := TLogoBancoColorIMGs.Img600;
        604: Result := TLogoBancoColorIMGs.Img604;
        610: Result := TLogoBancoColorIMGs.Img610;
        623: Result := TLogoBancoColorIMGs.Img623;
        633: Result := TLogoBancoColorIMGs.Img633;
        637: Result := TLogoBancoColorIMGs.Img637;
        641: Result := TLogoBancoColorIMGs.Img641;
        702: Result := TLogoBancoColorIMGs.Img702;
        707: Result := TLogoBancoColorIMGs.Img707;
        721: Result := TLogoBancoColorIMGs.Img721;
        741: Result := TLogoBancoColorIMGs.Img741;
        745: Result := TLogoBancoColorIMGs.Img745;
        748: Result := TLogoBancoColorIMGs.Img748;
        749: Result := TLogoBancoColorIMGs.Img749;
        756: Result := TLogoBancoColorIMGs.Img756;
      end;
    end
    else
    begin
      case FcdsBanco.FieldByName('Numero').AsInteger of
        1:   Result := TLogoBancoPtoBcoIMGs.Img001;
        3:   Result := TLogoBancoPtoBcoIMGs.Img003;
        4:   Result := TLogoBancoPtoBcoIMGs.Img004;
        8:   Result := TLogoBancoPtoBcoIMGs.Img008;
        21:  Result := TLogoBancoPtoBcoIMGs.Img021;
        24:  Result := TLogoBancoPtoBcoIMGs.Img024;
        27:  Result := TLogoBancoPtoBcoIMGs.Img027;
        28:  Result := TLogoBancoPtoBcoIMGs.Img028;
        29:  Result := TLogoBancoPtoBcoIMGs.Img029;
        31:  Result := TLogoBancoPtoBcoIMGs.Img031;
        33:  Result := TLogoBancoPtoBcoIMGs.Img033;
        36:  Result := TLogoBancoPtoBcoIMGs.Img036;
        38:  Result := TLogoBancoPtoBcoIMGs.Img038;
        41:  Result := TLogoBancoPtoBcoIMGs.Img041;
        47:  Result := TLogoBancoPtoBcoIMGs.Img047;
        70:  Result := TLogoBancoPtoBcoIMGs.Img070;
        85:  Result := TLogoBancoPtoBcoIMGs.Img085;
        97:  Result := TLogoBancoPtoBcoIMGs.Img097;
        99:  Result := TLogoBancoPtoBcoIMGs.Img099;
        104: Result := TLogoBancoPtoBcoIMGs.Img104;
        136: Result := TLogoBancoPtoBcoIMGs.Img136;
        151: Result := TLogoBancoPtoBcoIMGs.Img151;
        231: Result := TLogoBancoPtoBcoIMGs.Img231;
        237: Result := TLogoBancoPtoBcoIMGs.Img237;
        244: Result := TLogoBancoPtoBcoIMGs.Img244;
        246: Result := TLogoBancoPtoBcoIMGs.Img246;
        263: Result := TLogoBancoPtoBcoIMGs.Img263;
        275: Result := TLogoBancoPtoBcoIMGs.Img275;
        291: Result := TLogoBancoPtoBcoIMGs.Img291;
        320: Result := TLogoBancoPtoBcoIMGs.Img320;
        341: Result := TLogoBancoPtoBcoIMGs.Img341;
        347: Result := TLogoBancoPtoBcoIMGs.Img347;
        353: Result := TLogoBancoPtoBcoIMGs.Img353;
        356: Result := TLogoBancoPtoBcoIMGs.Img356;
        389: Result := TLogoBancoPtoBcoIMGs.Img389;
        392: Result := TLogoBancoPtoBcoIMGs.Img392;
        399: Result := TLogoBancoPtoBcoIMGs.Img399;
        409: Result := TLogoBancoPtoBcoIMGs.Img409;
        422: Result := TLogoBancoPtoBcoIMGs.Img422;
        424: Result := TLogoBancoPtoBcoIMGs.Img424;
        453: Result := TLogoBancoPtoBcoIMGs.Img453;
        479: Result := TLogoBancoPtoBcoIMGs.Img479;
        600: Result := TLogoBancoPtoBcoIMGs.Img600;
        604: Result := TLogoBancoPtoBcoIMGs.Img604;
        610: Result := TLogoBancoPtoBcoIMGs.Img610;
        623: Result := TLogoBancoPtoBcoIMGs.Img623;
        633: Result := TLogoBancoPtoBcoIMGs.Img633;
        637: Result := TLogoBancoPtoBcoIMGs.Img637;
        641: Result := TLogoBancoPtoBcoIMGs.Img641;
        702: Result := TLogoBancoPtoBcoIMGs.Img702;
        707: Result := TLogoBancoPtoBcoIMGs.Img707;
        721: Result := TLogoBancoPtoBcoIMGs.Img721;
        741: Result := TLogoBancoPtoBcoIMGs.Img741;
        745: Result := TLogoBancoPtoBcoIMGs.Img745;
        748: Result := TLogoBancoPtoBcoIMGs.Img748;
        749: Result := TLogoBancoPtoBcoIMGs.Img749;
        756: Result := TLogoBancoPtoBcoIMGs.Img756;
      end;
    end;
  end;
end;

procedure TBoletoFastReport.ImprimeLogoMarca(sCaminhoFoto, sfrxPicture: string);
var
  strAux: String; // Variável String auxiliar
  FrxPict: TfrxPictureView; // Componente para inserção de imagem na impressão.
begin

  // INSERE imagem do disco no relatorio
  FrxPict := TfrxPictureView(Self.frxReport.FindObject(sfrxPicture));
  if Assigned(frxPict) then
  Begin
    //frxPict.Picture.Bitmap := TIMGs.ImgColorido_001;
    strAux := sCaminhoFoto;
    if FileExists(strAux) then
      FrxPict.Picture.LoadFromFile(strAux)
    else
      FrxPict.Picture := nil;
  End;
end;

procedure TBoletoFastReport.ImprimeLogoMarca(Value:TBitmap; sfrxPicture: string);
var
  strAux: String; // Variável String auxiliar
  FrxPict: TfrxPictureView; // Componente para inserção de imagem na impressão.
begin

  // INSERE imagem do disco no relatorio
  FrxPict := TfrxPictureView(Self.frxReport.FindObject(sfrxPicture));
  if Assigned(frxPict) then
  Begin
    if Value <> nil then
      FrxPict.Picture.Bitmap := Value
    else
      FrxPict.Picture := nil;
  End;
end;

procedure TBoletoFastReport.SetDataSetsToFrxReport;
begin
  FrxReport.EnabledDataSets.Clear;
  FrxReport.EnabledDataSets.Add(frxBanco);
  FrxReport.EnabledDataSets.Add(frxTitulo);
  FrxReport.EnabledDataSets.Add(frxCedente);
end;




function TBoletoFCFR.GetTitulo: TTitulo;
begin
  Result := FBoleto.ListadeBoletos[fIndice];
end;

{ TBoletoFCFR }

function TBoletoFCFR.CarregaFastReportStream: Boolean;
begin
  Result := False;
  try
    FBoletoFastReport.frxReport.LoadFromStream(fFastReportStream);
    Result := True;
  Except
    //raise EBoletoFCFR.CreateFmt('Relatorio de Impressão no boleto selecionado inválido.');
  end;
end;

constructor TBoletoFCFR.Create;
begin
  inherited Create;
  FpAbout                  := 'BoletoFCFR ver: ' + CBoletoFCFR_Versao;
  FFastReportFile          := '';
  FImpressora              := '';
  FIndice                  := 0;
  FModoThread              := False;
  FIncorporarBackgroundPdf := False;
  FIncorporarFontesPdf     := False;
  FBoletoFastReport        := TBoletoFastReport.Create;
  FUseStream               := True;
  FUseImgColor             := True;
  MensagemPadrao           := TStringList.Create;
end;

destructor TBoletoFCFR.Destroy;
begin
  MensagemPadrao.Free;
  FBoletoFastReport.Free;
  inherited;
end;

function TBoletoFCFR.PreparedReport: TfrxReport;
begin
  Boleto.ChecarDadosObrigatorios;
  inherited Imprimir; // Verifica se a lista de boletos está vazia
  with FBoletoFastReport do
  begin
    cdsBanco.EmptyDataSet;
    cdsCedente.EmptyDataSet;
    cdsTitulo.EmptyDataSet;
    if PreparaRelatorio then
      Result := FrxReport
    else
      Result := nil;
  end;
end;

procedure TBoletoFCFR.SetTpRelatorioStream(Value: TTpReportStream);
begin
  if (FTpRelatorioStream <> Value) then
    FTpRelatorioStream := Value;
  case Value of
    tpsBoleto:             FFastReportStream := TReportBoleto.Boleto;
    tpsBoleto_Fatura_Novo: FFastReportStream := TReportBoleto.Boleto_Fatura_Novo;
    tpsBoletoCarne:        FFastReportStream := TReportBoleto.BoletoCarne;
    tpsBoletoFatura:       FFastReportStream := TReportBoleto.BoletoFatura;
    tpsBoletoFR:           FFastReportStream := TReportBoleto.BoletoFR;
    tpsBoletoNovo:         FFastReportStream := TReportBoleto.BoletoNovo;
    tpsBoletoNovoAlpha:    FFastReportStream := TReportBoleto.BoletoNovoAlpha;
    tpsBoletoUniprime:     FFastReportStream := TReportBoleto.BoletoUniprime;
  end;
end;

procedure TBoletoFCFR.Imprimir;
begin
  inherited Imprimir; // Verifica se a lista de boletos está vazia
  with FBoletoFastReport do
	begin
    cdsBanco.EmptyDataSet;
    cdsCedente.EmptyDataSet;
    cdsTitulo.EmptyDataSet;

    if PreparaRelatorio then
    begin
      FrxReport.PrintOptions.ShowDialog := (MostrarSetup) and (not FModoThread);

      if Length(Impressora) > 0 then
        FrxReport.PrintOptions.Printer := Impressora;

      case Filtro of
        FiNenhum:
        begin
          if (MostrarPreview) and (not FModoThread) then
            FrxReport.ShowReport(False)
          else
            FrxReport.Print;
        end;
        FiPDF:
        begin
          if FModoThread then
          begin
            FrxPDFExport.ShowDialog := False;
            FrxPDFExport.ShowProgress := False;
          end
          else
          begin
            FrxPDFExport.ShowDialog := MostrarSetup;
            FrxPDFExport.ShowProgress := MostrarProgresso;
          end;
          FrxPDFExport.FileName := NomeArquivo;
          FrxPDFExport.Author := SoftwareHouse;
          FrxPDFExport.Creator := SoftwareHouse;
          FrxPDFExport.Producer := SoftwareHouse;
          FrxPDFExport.Title := 'Boleto';
          FrxPDFExport.Subject := FrxPDFExport.Title;
          FrxPDFExport.Keywords := FrxPDFExport.Title;
          FrxPDFExport.Background := IncorporarBackgroundPdf;//False diminui 70% do tamanho do pdf
          FrxPDFExport.EmbeddedFonts := IncorporarFontesPdf;
          FrxReport.Export(frxPDFExport);
          if FrxPDFExport.FileName <> NomeArquivo then
            NomeArquivo := FrxPDFExport.FileName;
        end;
        FiHTML:
        begin
          FrxHTMLExport.FileName := NomeArquivo;
          FrxHTMLExport.ShowDialog := MostrarSetup;
          FrxHTMLExport.ShowProgress := MostrarSetup;
          FrxReport.Export(frxHTMLExport);
          if FrxHTMLExport.FileName <> NomeArquivo then
            NomeArquivo := FrxHTMLExport.FileName;
        end;
      else
        exit;
      end;
    end;
  end;
end;

function TBoletoFCFR.CarregaFastReportFile: Boolean;
begin
  Result := False;
  if Trim(fFastReportFile) <> '' then
  begin
    with FBoletoFastReport do
    begin
      if FileExists(fFastReportFile) then
         FrxReport.LoadFromFile(fFastReportFile)
      else
        raise EBoletoFCFR.CreateFmt('Caminho do arquivo de impressão do boleto "%s" inválido.', [fFastReportFile]);
      Result := True;
    end;
  end
  else
    raise EBoletoFCFR.Create('Caminho do arquivo de impressão do boleto não assinalado.');
end;

function TBoletoFCFR.PreparaRelatorio: Boolean;
begin
  Result := False;
  with FBoletoFastReport do
  begin
    UseStream := Self.UseStream;
    UseImgColor := Self.UseImgColor;
    SetDataSetsToFrxReport;
    if FModoThread then
    begin
      //*****************
      //* Em modo thread não pode Ficar carregando o arquivo a cada execução
      //* pois começa a gerar exception e memory leak
      //* Caso tenha mudança de arquivo pode ser chamando o CarregaFastReportFile que está public
      //*****************
      if Self.UseStream then
      begin
        if FrxReport.Report = nil then
        begin
          CarregaFastReportStream;
          FrxReport.PrintOptions.ShowDialog := False;
          FrxReport.ShowProgress := False;

          FrxReport.EngineOptions.SilentMode := True;
          FrxReport.EngineOptions.EnableThreadSafe := True;
          FrxReport.EngineOptions.DestroyForms := False;
          FrxReport.PreviewOptions.AllowEdit := False;
        end;
      end
      else
      begin
        if Trim(frxReport.FileName) = '' then
        begin
          CarregaFastReportFile;

          FrxReport.PrintOptions.ShowDialog := False;
          FrxReport.ShowProgress := False;

          FrxReport.EngineOptions.SilentMode := True;
          FrxReport.EngineOptions.EnableThreadSafe := True;
          FrxReport.EngineOptions.DestroyForms := False;
          FrxReport.PreviewOptions.AllowEdit := False;
        end;
      end;
    end
    else
    begin
      if Self.UseStream then
      begin
        FrxReport.PrintOptions.ShowDialog := MostrarSetup;
        FrxReport.ShowProgress := MostrarProgresso;

        FrxReport.EngineOptions.SilentMode := False;
        FrxReport.EngineOptions.EnableThreadSafe := False;
        FrxReport.EngineOptions.DestroyForms := True;
        FrxReport.PreviewOptions.AllowEdit := True;
        CarregaFastReportStream;
      end
      else
      begin
        FrxReport.PrintOptions.ShowDialog := MostrarSetup;
        FrxReport.ShowProgress := MostrarProgresso;

        FrxReport.EngineOptions.SilentMode := False;
        FrxReport.EngineOptions.EnableThreadSafe := False;
        FrxReport.EngineOptions.DestroyForms := True;
        FrxReport.PreviewOptions.AllowEdit := True;
        CarregaFastReportFile;
      end;
    end;

    if PrepareBoletos then
    begin
      Result := FrxReport.PrepareReport;
    end;
  end;
end;

function TBoletoFCFR.PrepareBoletos: Boolean;
var
  iFor: Integer;
  sTipoDoc: String;

  // Titulos
  Field_NossNum: TField;
  Field_CodCendente: TField;
  Field_CodBarras: TField;
  Field_LinhaDigitaval: TField;
  Field_TipoDoc: TField;
  Field_Vencimento: TField;
  Field_DataDocumento: TField;
  Field_NumeroDocumento: TField;
  Field_TotalParcelas: TField;
  Field_Parcela: TField;
  Field_EspecieMod: TField;
  Field_EspecieDoc: TField;
  Field_Aceite: TField;
  Field_DataProcessamento: TField;
  Field_NossoNumero: TField;
  Field_Carteira: TField;
  Field_ValorDocumento: TField;
  Field_LocalPagamento: TField;
  Field_ValorMoraJuros: TField;
  Field_ValorDesconto: TField;
  Field_ValorAbatimento: TField;
  Field_DataMoraJuros: TField;
  Field_DataDesconto: TField;
  Field_DataABatimento: TField;
  Field_DataProtesto: TField;
  Field_PercentualMulta: TField;
  Field_Mensagem: TField;
  Field_OcorrenciaOriginal: TField;
  Field_Instrucao1: TField;
  Field_Instrucao2: TField;
  Field_TextoLivre: TField;
  Field_Asbace: TField;

  // Sacado
  Field_Sacado_NomeSacado: TField;
  Field_Sacado_CNPJCPF: TField;
  Field_Sacado_Logradouro: TField;
  Field_Sacado_Complemento: TField;
  Field_Sacado_Numero: TField;
  Field_Sacado_Bairro: TField;
  Field_Sacado_Cidade: TField;
  Field_Sacado_UF: TField;
  Field_Sacado_CEP: TField;
  Field_Sacado_Avalista: TField;
  Field_Sacado_Avalista_CNPJCPF : TField;
begin
  with Boleto do
  begin
    // Banco
    with FBoletoFastReport.cdsBanco do
    begin
      Append;
      FieldByName('Numero').AsString := FormatFloat('000', Banco.Numero);
      FieldByName('Digito').AsString := IfThen(Banco.Digito >= 10, 'X', IntToStrZero(Banco.Digito, 1));
      FieldByName('Nome').AsString := Banco.Nome;
      FieldByName('DirLogo').AsString := DirLogo;
      FieldByName('OrientacoesBanco').AsString := Banco.OrientacoesBanco.Text;
      Post;
    end;
    // Cedente
    with FBoletoFastReport.cdsCedente do
    begin
      Append;
      FieldByName('Nome').AsString := Cedente.Nome;
      FieldByName('CodigoCedente').AsString := Banco.MontarCampoCodigoCedente(Titulo); // Cedente.CodigoCedente;
      FieldByName('CodigoTransmissao').AsString := Cedente.CodigoTransmissao;
      FieldByName('Agencia').AsString := Cedente.Agencia;
      FieldByName('AgenciaDigito').AsString := Cedente.AgenciaDigito;
      FieldByName('Conta').AsString := Cedente.Conta;
      FieldByName('ContaDigito').AsString := Cedente.ContaDigito;
      FieldByName('Modalidade').AsString := Cedente.Modalidade;
      FieldByName('Convenio').AsString := Cedente.Convenio;
      FieldByName('ResponEmissao').AsInteger := Integer(Cedente.ResponEmissao);
      FieldByName('CNPJCPF').AsString := Cedente.CNPJCPF;
      FieldByName('TipoInscricao').AsInteger := Integer(Cedente.TipoInscricao);
      FieldByName('Logradouro').AsString := Cedente.Logradouro;
      FieldByName('NumeroRes').AsString := Cedente.NumeroRes;
      FieldByName('Complemento').AsString := Cedente.Complemento;
      FieldByName('Bairro').AsString := Cedente.Bairro;
      FieldByName('Cidade').AsString := Cedente.Cidade;
      FieldByName('UF').AsString := Cedente.UF;
      FieldByName('CEP').AsString := Cedente.CEP;
      FieldByName('Telefone').AsString := Cedente.Telefone;
      Post;
    end;
    // Titulos

    with FBoletoFastReport.cdsTitulo do
    begin
      Field_NossNum := FieldByName('NossoNum');
      Field_CodCendente := FieldByName('CodCedente');
      Field_CodBarras := FieldByName('CodBarras');
      Field_LinhaDigitaval := FieldByName('LinhaDigitavel');
      Field_TipoDoc := FieldByName('TipoDoc');
      Field_Vencimento := FieldByName('Vencimento');
      Field_DataDocumento := FieldByName('DataDocumento');
      Field_NumeroDocumento := FieldByName('NumeroDocumento');
      Field_TotalParcelas := FieldByName('TotalParcelas');
      Field_Parcela := FieldByName('Parcela');
      Field_EspecieMod := FieldByName('EspecieMod');
      Field_EspecieDoc := FieldByName('EspecieDoc');
      Field_Aceite := FieldByName('Aceite');
      Field_DataProcessamento := FieldByName('DataProcessamento');
      Field_NossoNumero := FieldByName('NossoNumero');
      Field_Carteira := FieldByName('Carteira');
      Field_ValorDocumento := FieldByName('ValorDocumento');
      Field_LocalPagamento := FieldByName('LocalPagamento');
      Field_ValorMoraJuros := FieldByName('ValorMoraJuros');
      Field_ValorDesconto := FieldByName('ValorDesconto');
      Field_ValorAbatimento := FieldByName('ValorAbatimento');
      Field_DataMoraJuros := FieldByName('DataMoraJuros');
      Field_DataDesconto := FieldByName('DataDesconto');
      Field_DataABatimento := FieldByName('DataAbatimento');
      Field_DataProtesto := FieldByName('DataProtesto');
      Field_PercentualMulta := FieldByName('PercentualMulta');
      Field_Mensagem := FieldByName('Mensagem');
      Field_OcorrenciaOriginal := FieldByName('OcorrenciaOriginal');
      Field_Instrucao1 := FieldByName('Instrucao1');
      Field_Instrucao2 := FieldByName('Instrucao2');
      Field_TextoLivre := FieldByName('TextoLivre');
      Field_Asbace := FieldByName('Asbace');

      // Sacado
      Field_Sacado_NomeSacado := FieldByName('Sacado_NomeSacado');
      Field_Sacado_CNPJCPF := FieldByName('Sacado_CNPJCPF');
      Field_Sacado_Logradouro := FieldByName('Sacado_Logradouro');
      Field_Sacado_Complemento := FieldByName('Sacado_Complemento');
      Field_Sacado_Numero := FieldByName('Sacado_Numero');
      Field_Sacado_Bairro := FieldByName('Sacado_Bairro');
      Field_Sacado_Cidade := FieldByName('Sacado_Cidade');
      Field_Sacado_UF := FieldByName('Sacado_UF');
      Field_Sacado_CEP := FieldByName('Sacado_CEP');
      Field_Sacado_Avalista := FieldByName('Sacado_Avalista');
      Field_Sacado_Avalista_CNPJCPF := FieldByName('Sacado_Avalista_CNPJCPF');
    end;

    For iFor := 0 to ListadeBoletos.Count - 1 do
    begin
      case Cedente.TipoInscricao of
        pFisica:
          sTipoDoc := 'CPF: ';
        pJuridica:
          sTipoDoc := 'CNPJ: ';
      else
        sTipoDoc := 'DOC.: ';
      end;
      // Monta mensagens de multa e juros
      MensagemPadrao.Clear;
      MensagemPadrao.Text := ListadeBoletos[iFor].Mensagem.Text;
      AdicionarMensagensPadroes(ListadeBoletos[iFor], MensagemPadrao);

      with FBoletoFastReport.cdsTitulo do
      begin
        Append;
        Field_NossNum.AsString := Banco.MontarCampoNossoNumero(ListadeBoletos[iFor]);
        Field_CodCendente.AsString := Banco.MontarCampoCodigoCedente(ListadeBoletos[iFor]);
        Field_CodBarras.AsString := Banco.MontarCodigoBarras(ListadeBoletos[iFor]);
        Field_LinhaDigitaval.AsString := Banco.MontarLinhaDigitavel(Field_CodBarras.AsString, ListadeBoletos[iFor]);
        Field_TipoDoc.AsString := sTipoDoc;
        Field_Vencimento.AsDateTime := ListadeBoletos[iFor].Vencimento;
        Field_DataDocumento.AsDateTime := ListadeBoletos[iFor].DataDocumento;
        Field_NumeroDocumento.AsString := ListadeBoletos[iFor].NumeroDocumento;
        Field_TotalParcelas.AsInteger := ListadeBoletos[iFor].TotalParcelas;
        Field_Parcela.AsInteger := ListadeBoletos[iFor].Parcela;
        Field_EspecieMod.AsString := ListadeBoletos[iFor].EspecieMod;
        Field_EspecieDoc.AsString := ListadeBoletos[iFor].EspecieDoc;
        Field_Aceite.AsInteger := Integer(ListadeBoletos[iFor].Aceite);
        Field_DataProcessamento.AsDateTime := ListadeBoletos[iFor].DataProcessamento;
        Field_NossoNumero.AsString := ListadeBoletos[iFor].NossoNumero;
        Field_Carteira.AsString := Banco.MontarCampoCarteira(ListadeBoletos[iFor]);
        Field_ValorDocumento.AsCurrency := ListadeBoletos[iFor].ValorDocumento;
        Field_LocalPagamento.AsString := ListadeBoletos[iFor].LocalPagamento;
        Field_ValorMoraJuros.AsCurrency := ListadeBoletos[iFor].ValorMoraJuros;
        Field_ValorDesconto.AsCurrency := ListadeBoletos[iFor].ValorDesconto;
        Field_ValorAbatimento.AsCurrency := ListadeBoletos[iFor].ValorAbatimento;
        Field_DataMoraJuros.AsDateTime := ListadeBoletos[iFor].DataMoraJuros;
        Field_DataDesconto.AsDateTime := ListadeBoletos[iFor].DataDesconto;
        Field_DataABatimento.AsDateTime := ListadeBoletos[iFor].DataAbatimento;
        Field_DataProtesto.AsDateTime := ListadeBoletos[iFor].DataProtesto;
        Field_PercentualMulta.AsFloat := ListadeBoletos[iFor].PercentualMulta;
        Field_Mensagem.AsString := MensagemPadrao.Text;
        Field_OcorrenciaOriginal.AsInteger := Integer(ListadeBoletos[iFor].OcorrenciaOriginal);
        Field_Instrucao1.AsString := ListadeBoletos[iFor].Instrucao1;
        Field_Instrucao2.AsString := ListadeBoletos[iFor].Instrucao2;
        Field_TextoLivre.AsString := ListadeBoletos[iFor].TextoLivre;
        if Boleto.Banco.Numero = 21 then
          Field_Asbace.AsString := TBancoBanestes(Banco).CalcularCampoASBACE(ListadeBoletos[iFor]);

        // Sacado
        Field_Sacado_NomeSacado.AsString := ListadeBoletos[iFor].Sacado.NomeSacado;
        Field_Sacado_CNPJCPF.AsString := ListadeBoletos[iFor].Sacado.CNPJCPF;
        Field_Sacado_Logradouro.AsString := ListadeBoletos[iFor].Sacado.Logradouro;
        Field_Sacado_Complemento.AsString := ListadeBoletos[iFor].Sacado.Complemento;
        Field_Sacado_Numero.AsString := ListadeBoletos[iFor].Sacado.Numero;
        Field_Sacado_Bairro.AsString := ListadeBoletos[iFor].Sacado.Bairro;
        Field_Sacado_Cidade.AsString := ListadeBoletos[iFor].Sacado.Cidade;
        Field_Sacado_UF.AsString := ListadeBoletos[iFor].Sacado.UF;
        Field_Sacado_CEP.AsString := ListadeBoletos[iFor].Sacado.CEP;
        Field_Sacado_Avalista.AsString := ListadeBoletos[iFor].Sacado.Avalista;
        Field_Sacado_Avalista_CNPJCPF.asString := ListadeBoletos[iFor].Sacado.SacadoAvalista.CNPJCPF;

        Post;
      end;
    end;
  end;

  Result := True;
end;

end.
