unit Myloo.Boleto.BancoMercantil;

interface

uses
  System.Classes,
  System.SysUtils,
  Myloo.Boleto;

type

  { TBancoMercantil }

  TBancoMercantil = class(TBancoClass)
  private
    FBoleto: TBoleto;
    property Boleto:TBoleto read FBoleto write Fboleto;
    Function FormataNossoNumero(const Titulo :TTitulo): String;
  public
    Constructor create(AOwner: TBanco);
    Function CalcularDigitoVerificador(const Titulo:TTitulo): String; override;
    Function MontarCodigoBarras(const Titulo : TTitulo): String; override;
    Function MontarCampoNossoNumero(const Titulo :TTitulo): String; override;
    Function MontarCampoCodigoCedente(const Titulo: TTitulo): String; override;
    procedure GerarRegistroHeader400(NumeroRemessa : Integer; aRemessa: TStringList); override;
    procedure GerarRegistroTransacao400(Titulo : TTitulo; aRemessa: TStringList); override;
    procedure GerarRegistroTrailler400(ARemessa:TStringList);  override;

    Function CodOcorrenciaToTipoRemessa(const CodOcorrencia:Integer): TTipoOcorrencia; override;
  end;

implementation

uses
  dateutils, StrUtils, Myloo.Boleto.Utils;

{ TBancoMercantil }

function TBancoMercantil.CodOcorrenciaToTipoRemessa(const CodOcorrencia: Integer): TTipoOcorrencia;
begin
  case CodOcorrencia of
    02 : Result:= toRemessaBaixar;                          {Pedido de Baixa}
    04 : Result:= toRemessaConcederAbatimento;              {Concessão de Abatimento}
    05 : Result:= toRemessaCancelarAbatimento;              {Cancelamento de Abatimento concedido}
    06 : Result:= toRemessaAlterarVencimento;               {Alteração de vencimento}
    08 : Result:= toRemessaAlterarNumeroControle;           {Alteração de seu número}
    09 : Result:= toRemessaProtestar;                       {Pedido de protesto}
    18 : Result:= toRemessaCancelarInstrucaoProtestoBaixa;  {Sustar protesto e baixar}
    19 : Result:= toRemessaCancelarInstrucaoProtesto;       {Sustar protesto e manter na carteira}
    31 : Result:= toRemessaOutrasOcorrencias;               {Alteração de Outros Dados}
  else
     Result:= toRemessaRegistrar;                           {Remessa}
  end;
end;

constructor TBancoMercantil.create(AOwner: TBanco);
begin
   inherited create(AOwner);
   FpDigito                := 1;
   FpNome                  := 'Banco Mercantil';
   FpNumero                := 389;
   FpTamanhoMaximoNossoNum := 6;
   FpTamanhoCarteira       := 2;
end;

function TBancoMercantil.FormataNossoNumero(const Titulo :TTitulo): String;
var
  ANossoNumero: string;
  aModalidade: String;
begin
   aModalidade:= IfThen(Length(trim(Titulo.Boleto.Cedente.Modalidade)) = 2,
                        Titulo.Boleto.Cedente.Modalidade,'22');

   ANossoNumero := PadRight(Titulo.Boleto.Cedente.Agencia,4,'0') + //4
                   aModalidade                                       + //6
                   Titulo.Carteira                               + //8
                   PadRight(Titulo.NossoNumero, 6, '0')              + //14
                   CalcularDigitoVerificador(Titulo);              //15

   Result := ANossoNumero;
end;

function TBancoMercantil.CalcularDigitoVerificador(const Titulo: TTitulo ): String;
var
  aModalidade: String;
begin
   Modulo.CalculoPadrao;
   Modulo.MultiplicadorAtual   := 2;

   aModalidade:= IfThen(Length(trim(Titulo.Boleto.Cedente.Modalidade)) = 2,
                        Titulo.Boleto.Cedente.Modalidade,'22');

   Modulo.Documento := Titulo.Boleto.Cedente.Agencia +
                       aModalidade +
                       Titulo.Carteira +
                       PadRight(Titulo.NossoNumero, 6, '0');

   Modulo.Calcular;
   Result:= IntToStr(Modulo.DigitoFinal);
   
end;

function TBancoMercantil.MontarCodigoBarras ( const Titulo: TTitulo) : String;
var
  FatorVencimento, DigitoCodBarras, CpObrigatorio , CpLivre:String;
begin

   with Titulo.Boleto do
   begin
      FatorVencimento := CalcularFatorVencimento(Titulo.Vencimento);

      // comum a todos bancos
      CpObrigatorio := IntToStr( Numero )+  //4
                       '9'               +  //5
                       FatorVencimento   +  //9
                       IntToStrZero(Round(Titulo.ValorDocumento*100),10);//19

                       // AG+22+01+123456
      CpLivre       := FormataNossoNumero(Titulo)    + //34
                       PadRight(Cedente.CodigoCedente,9,'0') + //43
                       ifthen(Titulo.ValorDesconto > 0,'2','0') ;// ?? indicador Desconto 2-Sem 0-Com  // 44

      DigitoCodBarras := CalcularDigitoCodigoBarras(CpObrigatorio+CpLivre);

   end;

   Result:= IntToStr(Numero) +
            '9'+
            DigitoCodBarras +
            Copy( (CpObrigatorio + CpLivre),5,39);

end;

function TBancoMercantil.MontarCampoNossoNumero (
   const Titulo: TTitulo ) : String;
begin
   Result := Copy(FormataNossoNumero(Titulo),5,11);
end;

// usado no carnê
function TBancoMercantil.MontarCampoCodigoCedente (
   const Titulo: TTitulo ) : String;
begin
   Result := Titulo.Boleto.Cedente.Agencia       + '-' +
             Titulo.Boleto.Cedente.AgenciaDigito + '/' +
             Titulo.Boleto.Cedente.CodigoCedente;
end;

procedure TBancoMercantil.GerarRegistroHeader400(NumeroRemessa : Integer; aRemessa:TStringList);
var
  wLinha: String;
begin
   with Banco.Boleto.Cedente do
   begin
      wLinha:= '0'                                        + // ID do Registro
               '1'                                        + // ID do Arquivo( 1 - Remessa)
               'REMESSA'                                  + // Literal de Remessa
               '01'                                       + // Código do Tipo de Serviço
               PadRight( 'COBRANCA', 15 )                     + // Descrição do tipo de serviço
               PadRight( OnlyNumber(Agencia), 4)              + // agencia origem
	       PadLeft( OnlyNumber(CNPJCPF),15,'0')          + // CNPJ/CPF CEDENTE
	       ' '                                        + // BRANCO
	       PadRight( Nome, 30)                            + // Nome da Empresa
	       '389'                                      + // ID BANCO
	       'BANCO MERCANTIL'                          + // nome banco
	       FormatDateTime('ddmmyy',Now)               + // data geração
               Space(281)                                 + // espaços branco
	       '01600   '                                 + // densidade da gravação
	       IntToStrZero(NumeroRemessa,5)              + // nr. sequencial remessa
	       IntToStrZero(1,6);                           // Nr. Sequencial de Remessa

      aRemessa.Text:= aRemessa.Text + UpperCase(wLinha);
   end;
end;

procedure TBancoMercantil.GerarRegistroTransacao400(Titulo :TTitulo; aRemessa: TStringList);
var
  Ocorrencia,wLinha       :String;
  TipoSacado, ATipoAceite :String;
begin

   with Titulo do
   begin
      {Pegando Código da Ocorrencia}
      case OcorrenciaOriginal.Tipo of
         toRemessaBaixar                         : Ocorrencia := '02'; {Pedido de Baixa}
         toRemessaConcederAbatimento             : Ocorrencia := '04'; {Concessão de Abatimento}
         toRemessaCancelarAbatimento             : Ocorrencia := '05'; {Cancelamento de Abatimento concedido}
         toRemessaAlterarVencimento              : Ocorrencia := '06'; {Alteração de vencimento}
         toRemessaAlterarNumeroControle          : Ocorrencia := '08'; {Alteração de seu número}
         toRemessaProtestar                      : Ocorrencia := '09'; {Pedido de protesto}
         toRemessaCancelarInstrucaoProtestoBaixa : Ocorrencia := '18'; {Sustar protesto e baixar}
         toRemessaCancelarInstrucaoProtesto      : Ocorrencia := '19'; {Sustar protesto e manter na carteira}
         toRemessaOutrasOcorrencias              : Ocorrencia := '31'; {Alteração de Outros Dados}
      else
         Ocorrencia := '01';                                          {Remessa}
      end;

      {Pegando Tipo de Sacado}
      case Sacado.Pessoa of
         pFisica   : TipoSacado := '01';
         pJuridica : TipoSacado := '02';
      else
         TipoSacado := '99';
      end;

      { Pegando o Aceite do Titulo }
      case Aceite of
        atSim :  ATipoAceite := 'S';
        atNao :  ATipoAceite := 'N';
      end;

      with Boleto do
      begin
         wLinha:= '1'                                                     +  // ID Registro
                  IfThen( PercentualMulta > 0, '092', '000')              +  // Indica se exite Multa ou não
	          IntToStrZero( round( PercentualMulta * 100 ), 13)       +  // Percentual de Multa Formatado com 2 casas decimais
		  FormatDateTime( 'ddmmyy', Vencimento + 1)               +  // data Multa
		  Space(5)                                                +
		  PadLeft( Cedente.CodigoCedente, 9, '0')                    +  // numero do contrato ???
		  PadLeft( SeuNumero,25,'0')                                 +  // Numero de Controle do Participante
                  FormataNossoNumero(Titulo)                          +
                  Space(5)                                                +
                  PadLeft( OnlyNumber(Cedente.CNPJCPF), 15 , '0')            +
                  IntToStrZero( Round( ValorDocumento * 100 ), 10)        +  // qtde de moeda
                  '1'                                                     +  // Codigo Operação 1- Cobrança Simples
                  Ocorrencia                                              +
                  PadRight( NumeroDocumento,  10)                             + // numero titulo atribuido pelo cliente
                  FormatDateTime( 'ddmmyy', Vencimento)                   +
                  IntToStrZero(Round( ValorDocumento * 100 ),13)          +  // valor nominal do titulo
                  '389'                                                   +  // banco conbrador
                  '00000'                                                 +  // agencia cobradora
                  '01'                                                    +  // codigo da especie, duplicata mercantil
                  ATipoAceite                                             +  // N
                  FormatDateTime( 'ddmmyy', DataDocumento )               +  // Data de Emissão
                  PadRight(Instrucao1,2,'0')                                  +  // instruçoes de cobrança
                  PadRight(Instrucao2,2,'0')                                  +  // instruçoes de cobrança
                  IntToStrZero(round(ValorMoraJuros * 100),13)            + // juros mora 11.2
                  FormatDateTime( 'ddmmyy', DataDesconto)                 + // data limite desconto
                  IntToStrZero(round(ValorDesconto * 100) ,13)            + // valor desconto
                  StringOfChar( '0', 13)                                  + // iof - caso seguro
                  StringOfChar( '0', 13)                                  + // valor abatimento ?????
                  TipoSacado                                              +
                  PadLeft( OnlyNumber(Sacado.CNPJCPF),14,'0')                +
                  PadRight( Sacado.NomeSacado, 40, ' ')                       +
                  PadRight( Sacado.Logradouro + Sacado.Numero , 40)           +
                  PadRight( Sacado.Bairro ,12)                                +
                  PadRight( Sacado.CEP, 8 , '0' )                             +
                  PadRight( Sacado.Cidade ,15)                                +
                  PadRight( Sacado.UF, 2)                                     +
                  PadRight( Sacado.Avalista, 30)                              + // Avalista
                  Space(12)                                               +
                  '1'                                                     + // codigo moeda
                  IntToStrZero(aRemessa.Count + 1, 6 );

         aRemessa.Text:= aRemessa.Text + UpperCase(wLinha);
      end;
   end;
end;

procedure TBancoMercantil.GerarRegistroTrailler400( ARemessa:TStringList );
var
  wLinha: String;
begin
   wLinha:= '9' + Space(393)                     + // ID Registro
            IntToStrZero( ARemessa.Count + 1, 6);  // Contador de Registros

   ARemessa.Text:= ARemessa.Text + UpperCase(wLinha);
end;


end.

