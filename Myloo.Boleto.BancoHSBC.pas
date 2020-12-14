unit Myloo.Boleto.BancoHSBC;

interface

uses
  System.Classes,
  System.SysUtils,
  Myloo.Boleto;

type

  { TBancoHSBC }

  TBancoHSBC = class(TBancoClass)
  private
    FBoleto: TBoleto;
    property Boleto:TBoleto read FBoleto write Fboleto;
    Function DataToJuliano(const AData: TDateTime): String;
  public
    Constructor create(AOwner: TBanco);

    Function CalcularTamMaximoNossoNumero(const Carteira : String; NossoNumero : String = ''; Convenio: String = ''): Integer; override;

    Function CalcularDigitoVerificador(const Titulo:TTitulo): String; override;
    Function MontarCodigoBarras(const Titulo : TTitulo): String; override;
    Function MontarCampoNossoNumero(const Titulo :TTitulo): String; override;
    Function MontarCampoCodigoCedente(const Titulo: TTitulo): String; override;
    procedure GerarRegistroHeader400(NumeroRemessa : Integer; aRemessa: TStringList); override;
    procedure GerarRegistroTransacao400(Titulo : TTitulo; aRemessa: TStringList); override;
    procedure GerarRegistroTrailler400(ARemessa:TStringList);  override;
    Procedure LerRetorno400(ARetorno:TStringList); override;
    procedure LerRetorno240(ARetorno: TStringList); override;

    Function TipoOcorrenciaToDescricao(const TipoOcorrencia: TTipoOcorrencia) : String; override;
    Function CodOcorrenciaToTipo(const CodOcorrencia:Integer): TTipoOcorrencia; override;
    Function TipoOCorrenciaToCod(const TipoOcorrencia: TTipoOcorrencia):String; override;
    Function CodMotivoRejeicaoToDescricao(const TipoOcorrencia:TTipoOcorrencia; CodMotivo:Integer): String; override;

    Function CodOcorrenciaToTipoRemessa(const CodOcorrencia:Integer): TTipoOcorrencia; override;
  end;

implementation

uses
  dateutils, StrUtils, Myloo.Boleto.Utils;

{ TBancoHSBC }

function TBancoHSBC.DataToJuliano(const AData: TDateTime): String;
var
  DiaDoAno: String;
  UltDigAno: String;
begin
   if AData = 0 then
      Result := '0000'
   else
    begin
      UltDigAno := FormatDateTime('yyyy', AData)[4];
      DiaDoAno  := Format('%3.3d', [DayOfTheYear(AData)]);
      Result    := DiaDoAno + UltDigAno;
    end;
end;

function TBancoHSBC.CalcularTamMaximoNossoNumero(
  const Carteira: String; NossoNumero : String = ''; Convenio: String = ''): Integer;
begin
   Result := FpTamanhoMaximoNossoNum;

   if (trim(Carteira) = '') then
      raise Exception.Create(Str('Banco HSBC requer que a carteira seja '+
                                     'informada antes do Nosso Número.'));

   if (trim(Carteira) = 'CSB') or (trim(Carteira) = '1') then
   begin
    Result := 5;
    FpTamanhoMaximoNossoNum := 5;
   end;
end;

constructor TBancoHSBC.create(AOwner: TBanco);
begin
   inherited create(AOwner);
   FpDigito                := 9;
   FpNome                  := 'HSBC';
   FpNumero                := 399;
   FpTamanhoMaximoNossoNum := 13;
   FpTamanhoAgencia        := 4;
   FpTamanhoConta          := 5;
   FpTamanhoCarteira       := 3;
end;

function TBancoHSBC.CalcularDigitoVerificador(const Titulo: TTitulo ): String;
var
  ANumeroDoc, ANumeroBase, ADigito1: AnsiString;
  ADigito2, ADigito: AnsiString;
  Numero, Cedente, Vencimento: Extended;

  Function CalcularDigito(const ANumero: AnsiString): AnsiString;
  begin
     Modulo.CalculoPadrao;
     Modulo.Documento := AnsiString(ANumero);
     Modulo.Calcular;

     Result := AnsiString(IntToStr(Modulo.DigitoFinal));
  end;

begin
   Result := '0';

   // numero base para o calculo do primeiro e segundo digitos
   ANumeroDoc := PadLeft(RightStr(Titulo.NossoNumero,13),13,'0');

   // Calculo do primeiro digito
   ANumeroBase := ANumeroDoc;
   ADigito     := CalcularDigito(ANumeroDoc);
   ADigito1    := ADigito + '4';

   // calculo do segundo digito
   Vencimento  := StrToFloat(FormatDateTime('ddmmyy', Titulo.Vencimento));
   Cedente     := StrToFloat(Self.Banco.Boleto.Cedente.CodigoCedente);
   Numero      := StrToFloat(ANumeroBase + ADigito1);

   ANumeroBase := FloatToStr(Numero + Cedente + Vencimento);
   ADigito2    := CalcularDigito(ANumeroBase);

   // digito Final 3 posicoes = digito 1 + '4' + digito 2
   Result := ADigito1 + ADigito2;
end;

function TBancoHSBC.MontarCampoNossoNumero (
   const Titulo: TTitulo ) : String;
var
  wNossoNumero: String;
begin
  if (Titulo.Carteira = 'CSB') or (Titulo.Carteira = '1') then
   begin
     if Length(Titulo.NossoNumero) < 6 then
        wNossoNumero:= PadLeft(trim(Titulo.Boleto.Cedente.Convenio),5,'0') +
                       RightStr(Titulo.NossoNumero,5)
     else
        wNossoNumero:= RightStr(Titulo.NossoNumero,10);

     Modulo.CalculoPadrao;
     Modulo.MultiplicadorFinal := 7;
     Modulo.Documento := wNossoNumero;
     Modulo.Calcular;


     Result := RightStr(wNossoNumero,10) + AnsiString(IntToStr(Modulo.DigitoFinal));
   end
  else
     Result :=Titulo.NossoNumero + '-' +
              CalcularDigitoVerificador(Titulo);
end;

function TBancoHSBC.MontarCampoCodigoCedente (
   const Titulo: TTitulo ) : String;
begin
   if (Titulo.Carteira = 'CSB') or (Titulo.Carteira = '1') then
      Result := Titulo.Boleto.Cedente.Agencia + '-' +
                Titulo.Boleto.Cedente.CodigoCedente
   else 
      Result := Titulo.Boleto.Cedente.CodigoCedente;

end;

function TBancoHSBC.MontarCodigoBarras ( const Titulo: TTitulo) : String;
var
  Parte1, Parte2, CodigoBarras :String;
  ACarteira, ANossoNumero, DigitoCodBarras: String;
begin
   if (Titulo.Carteira = 'CSB') then
      ACarteira := '1'
   else if (Titulo.Carteira = 'CNR')then
      ACarteira := '2'
   else if (Titulo.Carteira <> '1') and  (Titulo.Carteira <> '2') then
      raise Exception.Create(Str('Carteira Inválida.'+sLineBreak+'Utilize "CSB", "CNR", "1" ou "2"') ) ;

   ANossoNumero := MontarCampoNossoNumero(Titulo);   // precisa passar nosso numero + digito

   with Titulo do
   begin

      Parte1 := IntToStr( Boleto.Banco.Numero ) + '9';

      {'CSB' Cobranca Registrada}
      if aCarteira = '1' then
       begin
         Parte2 := CalcularFatorVencimento(Vencimento) +
                   IntToStrZero(Round(ValorDocumento * 100), 10) +
                   RightStr(PadLeft(ANossoNumero, 13, '0'),11) +       // precisa passar nosso numero + digito
                   PadLeft(OnlyNumber(Boleto.Cedente.Agencia), 4, '0') +
                   PadLeft(OnlyNumber(Boleto.Cedente.Conta), 5, '0' ) +
                   PadLeft(OnlyNumber(Boleto.Cedente.ContaDigito), 2, '0' ) +
                   '00'

       end
      {'CNR' Cobranca Nao Registrada}
      else
       begin
         Parte2 := CalcularFatorVencimento(Vencimento) +
                   IntToStrZero(Round(ValorDocumento * 100), 10) +
                   PadLeft(trim(Boleto.Cedente.CodigoCedente), 7, '0') +
                   PadLeft(RightStr(NossoNumero, 13), 13, '0') +
                   DataToJuliano(Vencimento);
       end;

      Parte2 := Parte2 + ACarteira;

      CodigoBarras    := Parte1 + Parte2;
      DigitoCodBarras := CalcularDigitoCodigoBarras(CodigoBarras);
  end;

  Result := Parte1 + DigitoCodBarras + Parte2;
end;

procedure TBancoHSBC.GerarRegistroHeader400(NumeroRemessa : Integer; aRemessa: TStringList);
var
  wLinha, wAgencia, wConta: String;
begin
   with Banco.Boleto.Cedente do
   begin
      wAgencia := PadLeft(OnlyNumber(Agencia), 4, '0');
      wConta   := PadLeft( OnlyNumber(Conta) + ContaDigito, 7, '0');

      wLinha:= '0'                           + // ID do Registro
               '1'                           + // ID do Arquivo( 1 - Remessa)
               'REMESSA'                     + // Literal de Remessa
               '01'                          + // Código do Tipo de Serviço
               PadRight( 'COBRANCA', 15 )    + // Descrição do tipo de serviço
               '0'                           + // Zero
               wAgencia                      + // Agencia cedente
               '55'                          + // Sub-Conta
               wAgencia + wConta             + // Conta Corrente
               PadRight( '', 2,' ')          + // Uso do banco
               PadRight( Nome, 30,' ')       + // Nome da Empresa
               '399'                         + // Número do Banco na compensação
               PadRight('HSBC', 15)          + // Nome do Banco por extenso
               FormatDateTime('ddmmyy',Now)  + // Data de geração do arquivo
               '01600'                       + // Densidade de gravação
               'BPI'                         + // Literal  Densidade
               PadRight( '', 2,' ')          + // Uso do banco
               'LANCV08'                     + // Sigla Layout
               PadRight( '', 277,' ')        + // Uso do Banco
               '000001' ;                      // Número Seqüencial

      aRemessa.Text:= aRemessa.Text + UpperCase(wLinha);
   end;
end;

procedure TBancoHSBC.GerarRegistroTransacao400(Titulo :TTitulo; aRemessa: TStringList);
var
  Ocorrencia, aEspecie, wLinha :String;
  TipoSacado, MensagemCedente, TipoBoleto :String;
  I :Integer;
  wAgencia: String;
  wConta: String;
  AbatimentoMulta : String;
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
         Ocorrencia := '01';                                           {Remessa}
      end;

      {Pegando Tipo de Boleto}
      case Boleto.Cedente.ResponEmissao of
         tbCliEmite : TipoBoleto := ' ';
      else
         TipoBoleto := 'S';
      end;

      {Pegando Especie}
      if trim(EspecieDoc) = 'DP' then
         aEspecie:= '01'
      else if trim(EspecieDoc) = 'NP' then
         aEspecie:= '02'
      else if trim(EspecieDoc) = 'NS' then
         aEspecie:= '03'
      else if trim(EspecieDoc) = 'RC' then
         aEspecie:= '05'
      else if trim(EspecieDoc) = 'DS' then
         aEspecie:= '10'
      else if trim(EspecieDoc) = 'SD' then
         aEspecie:= '08'
      else if trim(EspecieDoc) = 'CE' then
         aEspecie:= '09'
      else if trim(EspecieDoc) = 'PD' then
         aEspecie:= '98'
      else
         aEspecie := EspecieDoc;

      {Pegando Tipo de Sacado}
      case Sacado.Pessoa of
         pFisica   : TipoSacado := '01';
         pJuridica : TipoSacado := '02';
      else
         TipoSacado := '99';
      end;

      with Boleto do
      begin
         MensagemCedente:= '';
         For I:= 0 to Mensagem.count-1 do
             MensagemCedente:= MensagemCedente + Mensagem[i];

         if length(MensagemCedente) > 60 then
            MensagemCedente:= copy(MensagemCedente,1,60);

         //"Valor do Abatimento" - Valor do abatimento concedido somente quando o código de ocorrência For igual a “04” ou “05” / "Multa" - Quando utilizar as instruções 15,16,19,22,24,29,73 e 74.
         if ((Ocorrencia  = '04') or (Ocorrencia  = '05')) and (ValorAbatimento > 0) then
           AbatimentoMulta := IntToStrZero( round( ValorAbatimento * 100 ), 13)  // valor do abatimento
         else if ((Trim(Instrucao1) = '15') or (Trim(Instrucao1) = '16')) and (PercentualMulta > 0) then
           AbatimentoMulta := FormatDateTime( 'ddmmyy', DataMoraJuros) + IntToStrZero( round( PercentualMulta * 100 ), 4) + '   ' // Multa
         else if (Trim(Instrucao1) = '22') and (PercentualMulta > 0) then
           AbatimentoMulta := IntToStrZero( round( (ValorDocumento *(PercentualMulta/100)) * 100 ), 10) + IntToStrZero(DaysBetween(Vencimento, DataMoraJuros),3)  // Multa
         else if (Trim(Instrucao1) = '24') and (PercentualMulta > 0) then
           AbatimentoMulta := IntToStrZero( round( (ValorDocumento *(PercentualMulta/100)) * 100 ), 10) + '000'  // Multa
         else if ((Trim(Instrucao1) = '73') or (Trim(Instrucao1) = '74')) and (PercentualMulta > 0) then
           AbatimentoMulta := '      ' + IntToStrZero( round( PercentualMulta * 100 ), 4) + IntToStrZero(DaysBetween(Vencimento, DataMoraJuros),3)  // Multa
         else
           AbatimentoMulta := IntToStrZero(0,13);

         wAgencia := PadLeft(OnlyNumber(Cedente.Agencia), 4, '0');
         wConta   := PadLeft(OnlyNumber(Cedente.Conta) + Cedente.ContaDigito, 7, '0');
         wLinha:= '1'                                                             + // ID Registro
                  '02'                                                            + //Código de Inscrição
                  PadLeft(OnlyNumber(Cedente.CNPJCPF),14,'0')                     + //Número de inscrição do Cliente (CPF/CNPJ)
                  '0'                                                             + // Zero
                  wAgencia                                                        + // Agencia cedente
                 '55'                                                             + // Sub-Conta
                  wAgencia + wConta                                               +
                  PadRight('',2,' ')                                              + // uso banco
                  PadRight( SeuNumero,25,' ')                                     + // Numero de Controle do Participante
                  OnlyNumber(MontarCampoNossoNumero(Titulo))                  + // Nosso Numero tam 10 + digito tam 1

                  IfThen(DataDesconto < EncodeDate(2000,01,01),'000000',
                         FormatDateTime( 'ddmmyy', DataDesconto))                 + // data limite para desconto (2)
                  IntToStrZero( round( ValorDesconto * 100 ), 11)                 + // valor desconto (2)
                  IfThen(DataDesconto < EncodeDate(2000,01,01),'000000',
                         FormatDateTime( 'ddmmyy', DataDesconto))                 + // data limite para desconto (3)
                  IntToStrZero( round( ValorDesconto * 100 ), 11)                 + // valor desconto (3)
                  '1'                                                             + // 1 - Cobrança Simples
                  PadLeft(Ocorrencia,2,'0')                                       + // ocorrencia
                  PadRight( NumeroDocumento,  10)                                 + // numero da duplicata
                  FormatDateTime( 'ddmmyy', Vencimento)                           + // vencimento
                  IntToStrZero( Round( ValorDocumento * 100 ), 13)                + // valor do titulo
                  '399'                                                           + // banco cobrador
                  '00000'                                                         + // Agência depositaria
                  PadRight(aEspecie,2) + 'N'                                      + //  Especie do documento + Idntificação(valor Fixo N)
                  FormatDateTime( 'ddmmyy', DataDocumento )                       + // Data de Emissão
                  PadLeft(Instrucao1,2,'0')                                       + // instrução 1
                  PadLeft(Instrucao2,2,'0')                                       + // instrução 2
                  IntToStrZero( round(ValorMoraJuros * 100 ), 13)                 + // Juros de Mora
                  IfThen(DataDesconto < EncodeDate(2000,01,01),'000000',
                         FormatDateTime( 'ddmmyy', DataDesconto))                 + // data limite para desconto  //ADICIONEI ZERO ESTAVA E BRANCO ALFEU
                  IntToStrZero( round( ValorDesconto * 100), 13)                  + // valor do desconto
                  IntToStrZero( round( ValorIOF * 100 ), 13)                      + // Valor do  IOF
                  AbatimentoMulta                                                 + // valor do abatimento / multa
                  TipoSacado                                                      + // codigo de inscrição do sacado
                  PadLeft(OnlyNumber(Sacado.CNPJCPF),14,'0')                      + // numero de inscrição do sacado
                  PadRight(Sacado.NomeSacado, 40, ' ')                            + // nome sacado
                  PadRight(Sacado.Logradouro + Sacado.Numero +
                       Sacado.Complemento,38)                                     + // endereço sacado
                  PadRight('', 2, ' ')                                            + // Instrução de  não recebimento do bloqueto
                  PadRight(Sacado.Bairro, 12, ' ')                                + // bairro sacado
                  PadLeft(copy(Sacado.CEP,1,5), 5 , '0' )                         + // cep do sacado
                  PadLeft(copy(Sacado.CEP,6,3), 3 , '0' )                         + // sufixo  cep do sacado
                  PadRight(Sacado.Cidade,15,' ')                                  + // cidade do sacado
                  PadRight(Sacado.UF,2,' ')                                       + // uf do sacado
                  PadRight(Sacado.Avalista,39,' ')                                + // nome do sacado
                  TipoBoleto                                                      + // Tipo de Bloqueto
                  IfThen(DataProtesto <> 0 ,
                         IntToStrZero(DaysBetween(DataProtesto,Vencimento),2)
                         ,'  ')                                                   + // nro de dias para protesto
                  '9'                                                             + // Tipo Moeda
                  IntToStrZero( aRemessa.Count + 1, 6 );

         aRemessa.Text:= aRemessa.Text + UpperCase(wLinha);
      end;
   end;
end;

procedure TBancoHSBC.GerarRegistroTrailler400( ARemessa:TStringList);
var
  wLinha: String;
begin
   wLinha:= '9' + Space(393)                     + // ID Registro
            IntToStrZero( ARemessa.Count + 1, 6);  // Contador de Registros

   ARemessa.Text:= ARemessa.Text + UpperCase(wLinha);
end;

Procedure TBancoHSBC.LerRetorno400 ( ARetorno: TStringList );
var
  Titulo : TTitulo;
  ContLinha, CodOcorrencia, CodMotivo, i, MotivoLinha : Integer;
  CodMotivo_19, rAgencia, rConta, rDigitoConta, Linha, rCedente, rCNPJCPF,
  rCodigoCedente: String;
Begin
  If StrToIntDef(copy(ARetorno.Strings[0], 77, 3), -1) <> Numero Then
    Raise Exception.Create(Str(Banco.Boleto.NomeArqRetorno +
      'não é um arquivo de retorno do ' + Nome));

  rCedente       := trim(Copy(ARetorno[0], 47, 30));
  rCodigoCedente := Copy(ARetorno[0], 109, 11);
  rAgencia       := trim(Copy(ARetorno[0], 28, 4));
  rConta         := trim(Copy(ARetorno[0], 38, 5));
  rDigitoConta   := Copy(ARetorno[0], 43, 2); 

  Banco.Boleto.NumeroArquivo := StrToIntDef(Copy(ARetorno[0], 389, 5), 0);

  Banco.Boleto.DataArquivo := StringToDateTimeDef(Copy(ARetorno[0], 95, 2) + '/' +
                                                          Copy(ARetorno[0], 97, 2) + '/' +
                                                          Copy(ARetorno[0], 99, 2), 0, 'DD/MM/YY');

  if Trim(Copy(ARetorno[0], 12, 15)) <> 'COBRANCA CNR' Then
     Banco.Boleto.DataCreditoLanc := StringToDateTimeDef(Copy(ARetorno[0], 120, 2) + '/' +
                                                                 Copy(ARetorno[0], 122, 2) + '/' +
                                                                 Copy(ARetorno[0], 124, 2), 0, 'DD/MM/YY');

  case StrToIntDef(Copy(ARetorno[1], 2, 2), 0) Of
    11: rCNPJCPF := Copy(ARetorno[1], 7, 11);
    14: rCNPJCPF := Copy(ARetorno[1], 4, 14);
  else
    rCNPJCPF := '';
  end;

  with Banco.Boleto Do
  begin
    // alguns arquivos não estão vindo a informação
     if rCNPJCPF <> '' then
     begin
        if (Not LeCedenteRetorno) And (rCNPJCPF <> OnlyNumber(Cedente.CNPJCPF)) then
           Raise Exception.Create(Str('CNPJ\CPF do arquivo inválido'));
     end;

     if not(LeCedenteRetorno) and
       (StrToIntDef(rCodigoCedente, -1) <> StrToIntDef(OnlyNumber(Cedente.CodigoCedente), 0)) then
        raise Exception.Create(Str('Cedente do arquivo inválido' + #13 + #13 +
                                       'Informado = ' + OnlyNumber(Cedente.CodigoCedente) + #13 +
                                       'Esperado = '+ rCodigoCedente));

     if not(LeCedenteRetorno) and (rAgencia <> OnlyNumber(Cedente.Agencia)) then
        raise Exception.Create(Str('Agencia do arquivo inválido' + #13 + #13 +
                                        'Informado = ' + OnlyNumber(Cedente.Agencia) + #13 +
                                        'Esperado = '+ rAgencia));

    if (not LeCedenteRetorno) and (StrToIntDef(rConta, -1) <> StrToIntDef(Cedente.Conta, 0)) then
       raise Exception.Create(Str('Conta do arquivo inválido' + #13 + #13 +
                                      'Informado = ' + IntToStr(StrToIntDef(Cedente.Conta, 0)) + #13 +
                                      'Esperado = '+ IntToStr(StrToIntDef(rConta, 0))));

    Cedente.Nome := rCedente;
    if Trim(Copy(ARetorno[0], 12, 15)) <> 'COBRANCA CNR' Then
       Cedente.CNPJCPF := rCNPJCPF;

    Cedente.Agencia       := rAgencia;
    Cedente.AgenciaDigito := '';
    Cedente.Conta         := rConta;
    Cedente.ContaDigito   := rDigitoConta;

    case StrToIntDef(Copy(ARetorno[1], 2, 2), 0) Of
      11: Cedente.TipoInscricao := pFisica;
    else
      Cedente.TipoInscricao := pJuridica;
    end;

    Banco.Boleto.ListadeBoletos.Clear;
  end;

  For ContLinha := 1 To ARetorno.Count - 2 Do
  begin
     Linha := ARetorno[ContLinha];

     if Copy(Linha, 1, 1) <> '1' Then
        Continue;

     Titulo := Banco.Boleto.CriarTituloNaLista;

     with Titulo Do
     begin
        if Trim(Copy(ARetorno[0], 12, 15)) = 'COBRANCA CNR' Then
           SeuNumero := copy(Linha, 117, 06)
        else
           SeuNumero := copy(Linha, 38, 25);
        NumeroDocumento := copy(Linha, 117, 10);
        OcorrenciaOriginal.Tipo := CodOcorrenciaToTipo(StrToIntDef(copy(Linha, 109, 2), 0));

        CodOcorrencia := StrToInt(IfThen(copy(Linha, 109, 2) = '  ', '00', copy(Linha, 109, 2)));

        //-|Se a ocorrencia For igual a 19 - Confirmação de Receb. de Protesto
        //-|Verifica o motivo na posição 295 - A = Aceite , D = Desprezado
        if (CodOcorrencia = 19) Then
         begin
           CodMotivo_19 := copy(Linha, 295, 1);
           if (CodMotivo_19 = 'A') Then
            begin
              MotivoRejeicaoComando.Add(copy(Linha, 295, 1));
              DescricaoMotivoRejeicaoComando.Add('A - Aceito');
            end
           else
            begin
              MotivoRejeicaoComando.Add(copy(Linha, 295, 1));
              DescricaoMotivoRejeicaoComando.Add('D - Desprezado');
            end;
         end
        else
         begin
           MotivoLinha := 319;
           For i := 0 To 4 Do
           begin
              CodMotivo := StrToInt(IfThen(copy(Linha, MotivoLinha, 2) = '  ', '00', copy(Linha, MotivoLinha, 2)));
              if (i = 0) Then
               begin
                 if (CodOcorrencia In [02, 06, 09, 10, 15, 17]) then //Somente estas ocorrencias possuem motivos 00
                  begin
                    MotivoRejeicaoComando.Add(IfThen(copy(Linha, MotivoLinha, 2) = '  ', '00', copy(Linha, MotivoLinha, 2)));
                    DescricaoMotivoRejeicaoComando.Add(CodMotivoRejeicaoToDescricao(OcorrenciaOriginal.Tipo, CodMotivo));
                  end
                 else
                  begin
                    if (CodMotivo = 0) Then
                     begin
                       MotivoRejeicaoComando.Add('00');
                       DescricaoMotivoRejeicaoComando.Add('Sem Motivo');
                     end
                    else
                     begin
                       MotivoRejeicaoComando.Add(IfThen(copy(Linha, MotivoLinha, 2) = '  ', '00', copy(Linha, MotivoLinha, 2)));
                       DescricaoMotivoRejeicaoComando.Add(CodMotivoRejeicaoToDescricao(OcorrenciaOriginal.Tipo, CodMotivo));
                     end;
                  end;
               end
              else
               begin
                 if CodMotivo <> 0 Then //Apos o 1º motivo os 00 significam que não existe mais motivo
                 begin
                    MotivoRejeicaoComando.Add(IfThen(copy(Linha, MotivoLinha, 2) = '  ', '00', copy(Linha, MotivoLinha, 2)));
                    DescricaoMotivoRejeicaoComando.Add(CodMotivoRejeicaoToDescricao(OcorrenciaOriginal.Tipo, CodMotivo));
                 end;
               end;
              MotivoLinha := MotivoLinha + 2; //Incrementa a coluna dos motivos
           end;
         end;

        DataOcorrencia := StringToDateTimeDef(Copy(Linha, 111, 2) + '/' +
                                              Copy(Linha, 113, 2) + '/' +
                                              Copy(Linha, 115, 2), 0, 'DD/MM/YY');

        Vencimento := StringToDateTimeDef(Copy(Linha, 147, 2) + '/' +
                                          Copy(Linha, 149, 2) + '/' +
                                          Copy(Linha, 151, 2), 0, 'DD/MM/YY');

        ValorDocumento := StrToFloatDef(Copy(Linha, 153, 13), 0) / 100;
        ValorIOF := 0;
        ValorAbatimento := StrToFloatDef(Copy(Linha, 228, 13), 0) / 100;
        ValorDesconto := StrToFloatDef(Copy(Linha, 241, 13), 0) / 100;
        ValorMoraJuros := StrToFloatDef(Copy(Linha, 267, 13), 0) / 100;
        ValorOutrosCreditos := 0;
        ValorRecebido := StrToFloatDef(Copy(Linha, 254, 13), 0) / 100;

        Carteira := Copy(Linha, 108, 1);
        if Trim(Copy(ARetorno[0], 12, 15)) <> 'COBRANCA CNR' Then
           NossoNumero := Copy(Linha, 127, 11)
        else // 3 ultimos digitos são digitos verificadores
           NossoNumero := Copy(Linha, 63, 13);

        ValorDespesaCobranca := StrToFloatDef(Copy(Linha, 176, 13), 0) / 100;
        ValorOutrasDespesas := 0;

        if Trim(Copy(ARetorno[0], 12, 15)) = 'COBRANCA CNR' Then
        begin
           if StrToIntDef(Copy(Linha, 83, 6), 0) <> 0 Then
              DataCredito := StringToDateTimeDef(Copy(Linha, 83, 2) + '/' +
                                                 Copy(Linha, 85, 2) + '/' +
                                                 Copy(Linha, 87, 2), 0, 'DD/MM/YY');

        end;
     end;
  end;
end;

Function TBancoHSBC.TipoOcorrenciaToDescricao(Const TipoOcorrencia: TTipoOcorrencia): String;
Var
  CodOcorrencia: Integer;
Begin

  CodOcorrencia := StrToIntDef(TipoOCorrenciaToCod(TipoOcorrencia), 0);

  Case CodOcorrencia Of
    02: Result := '02-Entrada Confirmada';
    03: Result := '03-Entrada Rejeitada';
    06: Result := '06-Liquidação normal';
    09: Result := '09-Baixado Automaticamente via Arquivo';
    10: Result := '10-Baixado conforme instruções da Agência';
    11: Result := '11-Em Ser - Arquivo de Títulos pendentes';
    12: Result := '12-Abatimento Concedido';
    13: Result := '13-Abatimento Cancelado';
    14: Result := '14-Vencimento Alterado';
    15: Result := '15-Liquidação em Cartório';
    16: Result := '16-Titulo Pago em Cheque - Vinculado';
    17: Result := '17-Liquidação após baixa ou Título não registrado';
    18: Result := '18-Acerto de Depositária';
    19: Result := '19-Confirmação Recebimento Instrução de Protesto';
    20: Result := '20-Confirmação Recebimento Instrução Sustação de Protesto';
    21: Result := '21-Acerto do Controle do Participante';
    22: Result := '22-Titulo com Pagamento Cancelado';
    23: Result := '23-Entrada do Título em Cartório';
    24: Result := '24-Entrada rejeitada por CEP Irregular';
    27: Result := '27-Baixa Rejeitada';
    28: Result := '28-Débito de tarifas/custas';
    29: Result := '29-Ocorrências do Sacado';
    30: Result := '30-Alteração de Outros Dados Rejeitados';
    31: Result := '31-Liquidação normal em Cheque/Compensação/Banco Correspondente';
    32: Result := '32-Instrução Rejeitada';
    33: Result := '33-Confirmação Pedido Alteração Outros Dados';
    34: Result := '34-Retirado de Cartório e Manutenção Carteira';
    35: Result := '35-Desagendamento do débito automático';
    38: Result := '38-Liquidação de título não registrado - em dinheiro';
    40: Result := '40-Estorno de Pagamento';
    55: Result := '55-Sustado Judicial';
    68: Result := '68-Acerto dos dados do rateio de Crédito';
    69: Result := '69-Cancelamento dos dados do rateio';
  End;
End;

Function TBancoHSBC.CodOcorrenciaToTipo(Const CodOcorrencia:
  Integer): TTipoOcorrencia;
Begin
  Case CodOcorrencia Of
    02: Result := toRetornoRegistroConfirmado;
    03: Result := toRetornoRegistroRecusado;
    06: Result := toRetornoLiquidado;
    09: Result := toRetornoBaixadoViaArquivo;
    10: Result := toRetornoBaixadoInstAgencia;
    11: Result := toRetornoTituloEmSer;
    12: Result := toRetornoAbatimentoConcedido;
    13: Result := toRetornoAbatimentoCancelado;
    14: Result := toRetornoVencimentoAlterado;
    15: Result := toRetornoLiquidadoEmCartorio;
    16: Result := toRetornoLiquidado;
    17: Result := toRetornoLiquidadoAposBaixaouNaoRegistro;
    18: Result := toRetornoAcertoDepositaria;
    19: Result := toRetornoRecebimentoInstrucaoProtestar;
    20: Result := toRetornoRecebimentoInstrucaoSustarProtesto;
    21: Result := toRetornoAcertoControleParticipante;
    22: Result := toRetornoRecebimentoInstrucaoAlterarDados;
    23: Result := toRetornoEncaminhadoACartorio;
    24: Result := toRetornoEntradaRejeitaCEPIrregular;
    27: Result := toRetornoBaixaRejeitada;
    28: Result := toRetornoDebitoTarifas;
    29: Result := toRetornoOcorrenciasdoSacado;
    30: Result := toRetornoALteracaoOutrosDadosRejeitada;
    31: Result := toRetornoLiquidadoPorConta;  // utilizado para diferenciaro cód. 31 (verificar necessidade de criar tipo novo)
    32: Result := toRetornoComandoRecusado;
    33: Result := toRetornoRecebimentoInstrucaoAlterarDados;
    34: Result := toRetornoRetiradoDeCartorio;
    35: Result := toRetornoDesagendamentoDebitoAutomatico;
    38: Result := toRetornoLiquidadoSemRegistro;
    99: Result := toRetornoRegistroRecusado;
  Else
    Result := toRetornoOutrasOcorrencias;
  End;
End;

function TBancoHSBC.CodOcorrenciaToTipoRemessa(const CodOcorrencia: Integer): TTipoOcorrencia;
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

Function TBancoHSBC.TipoOCorrenciaToCod(
  Const TipoOcorrencia: TTipoOcorrencia): String;
Begin
  Case TipoOcorrencia Of
    toRetornoRegistroConfirmado: Result := '02';
    toRetornoRegistroRecusado: Result := '03';
    toRetornoLiquidado: Result := '06';
    toRetornoBaixadoViaArquivo: Result := '09';
    toRetornoBaixadoInstAgencia: Result := '10';
    toRetornoTituloEmSer: Result := '11';
    toRetornoAbatimentoConcedido: Result := '12';
    toRetornoAbatimentoCancelado: Result := '13';
    toRetornoVencimentoAlterado: Result := '14';
    toRetornoLiquidadoEmCartorio: Result := '15';
    toRetornoTituloPagoemCheque: Result := '16';
    toRetornoLiquidadoAposBaixaouNaoRegistro: Result := '17';
    toRetornoAcertoDepositaria: Result := '18';
    toRetornoRecebimentoInstrucaoProtestar: Result := '19';
    toRetornoRecebimentoInstrucaoSustarProtesto: Result := '20';
    toRetornoAcertoControleParticipante: Result := '21';
    toRetornoRecebimentoInstrucaoAlterarDados: Result := '22';
    toRetornoEncaminhadoACartorio: Result := '23';
    toRetornoEntradaRejeitaCEPIrregular: Result := '24';
    toRetornoBaixaRejeitada: Result := '27';
    toRetornoDebitoTarifas: Result := '28';
    toRetornoOcorrenciasdoSacado: Result := '29';
    toRetornoALteracaoOutrosDadosRejeitada: Result := '30';
    toRetornoLiquidadoPorConta: Result := '31';
    toRetornoComandoRecusado: Result := '32';
    toRetornoDesagendamentoDebitoAutomatico: Result := '35';
    toRetornoLiquidadoSemRegistro: Result := '38';
  Else
    Result := '02';
  End;
End;

Function TBancoHSBC.COdMotivoRejeicaoToDescricao(Const TipoOcorrencia: TTipoOcorrencia; CodMotivo: Integer): String;
Begin
  Case TipoOcorrencia Of
    toRetornoRegistroConfirmado:
      Case CodMotivo Of
        00: Result := '00-Ocorrencia aceita';
        01: Result := '01-Codigo de banco inválido';
        04: Result := '04-Cod. movimentacao nao permitido p/ a carteira';
        15: Result := '15-Caracteristicas de Cobranca Imcompativeis';
        17: Result := '17-Data de vencimento anterior a data de emissão';
        21: Result := '21-Espécie do Título inválido';
        24: Result := '24-Data da emissão inválida';
        38: Result := '38-Prazo para protesto inválido';
        39: Result := '39-Pedido para protesto não permitido para título';
        43: Result := '43-Prazo para baixa e devolução inválido';
        45: Result := '45-Nome do Sacado inválido';
        46: Result := '46-Tipo/num. de inscrição do Sacado inválidos';
        47: Result := '47-Endereço do Sacado não informado';
        48: Result := '48-CEP invalido';
        50: Result := '50-CEP referente a Banco correspondente';
        53: Result := '53-Nº de inscrição do Sacador/avalista inválidos (CPF/CNPJ)';
        54: Result := '54-Sacador/avalista não informado';
        67: Result := '67-Débito automático agendado';
        68: Result := '68-Débito não agendado - erro nos dados de remessa';
        69: Result := '69-Débito não agendado - Sacado não consta no cadastro de autorizante';
        70: Result := '70-Débito não agendado - Cedente não autorizado pelo Sacado';
        71: Result := '71-Débito não agendado - Cedente não participa da modalidade de débito automático';
        72: Result := '72-Débito não agendado - Código de moeda diferente de R$';
        73: Result := '73-Débito não agendado - Data de vencimento inválida';
        75: Result := '75-Débito não agendado - Tipo do número de inscrição do sacado debitado inválido';
        86: Result := '86-Seu número do documento inválido';
        89: Result := '89-Email sacado nao enviado - Titulo com debito automatico';
        90: Result := '90-Email sacado nao enviado - Titulo com cobranca sem registro';
      Else
        Result := IntToStrZero(CodMotivo, 2) + ' - Outros Motivos';
      End;
    toRetornoRegistroRecusado:
      Case CodMotivo Of
        02: Result := '02-Codigo do registro detalhe invalido';
        03: Result := '03-Codigo da Ocorrencia Invalida';
        04: Result := '04-Codigo da Ocorrencia nao permitida para a carteira';
        05: Result := '05-Codigo de Ocorrencia nao numerico';
        07: Result := 'Agencia\Conta\Digito invalido';
        08: Result := 'Nosso numero invalido';
        09: Result := 'Nosso numero duplicado';
        10: Result := 'Carteira invalida';
        13: Result := 'Idetificacao da emissao do boleto invalida';
        16: Result := 'Data de vencimento invalida';
        18: Result := 'Vencimento Fora do prazo de operacao';
        20: Result := 'Valor do titulo invalido';
        21: Result := 'Especie do titulo invalida';
        22: Result := 'Especie nao permitida para a carteira';
        24: Result := 'Data de emissao invalida';
        28: Result := 'Codigo de desconto invalido';
        38: Result := 'Prazo para protesto invalido';
        44: Result := 'Agencia cedente nao prevista';
        45: Result := 'Nome cedente nao informado';
        46: Result := 'Tipo/numero inscricao sacado invalido';
        47: Result := 'Endereco sacado nao informado';
        48: Result := 'CEP invalido';
        50: Result := 'CEP irregular - Banco correspondente';
        63: Result := 'Entrada para titulo ja cadastrado';
        65: Result := 'Limite excedido';
        66: Result := 'Numero autorizacao inexistente';
        68: Result := 'Debito nao agendado - Erro nos dados da remessa';
        69: Result := 'Debito nao agendado - Sacado nao consta no cadastro de autorizante';
        70: Result := 'Debito nao agendado - Cedente nao autorizado pelo sacado';
        71: Result := 'Debito nao agendado - Cedente nao participa de debito automatico';
        72: Result := 'Debito nao agendado - Codigo de moeda diferente de R$';
        73: Result := 'Debito nao agendado - Data de vencimento invalida';
        74: Result := 'Debito nao agendado - Conforme seu pedido titulo nao registrado';
        75: Result := 'Debito nao agendado - Tipo de numero de inscricao de debitado invalido';
      Else
        Result := IntToStrZero(CodMotivo, 2) + ' - Outros Motivos';
      End;
    toRetornoLiquidado:
      Case CodMotivo Of
        00: Result := '00-Titulo pago com dinheiro';
        15: Result := '15-Titulo pago com cheque';
        42: Result := '42-Rateio nao efetuado';
      Else
        Result := IntToStrZero(CodMotivo, 2) + ' - Outros Motivos';
      End;
    toRetornoBaixadoViaArquivo:
      Case CodMotivo Of
        00: Result := '00-Ocorrencia aceita';
        10: Result := '10=Baixa comandada pelo cliente';
      Else
        Result := IntToStrZero(CodMotivo, 2) + ' - Outros Motivos';
      End;
    toRetornoBaixadoInstAgencia:
      Case CodMotivo Of
        00: Result := '00-Baixado conforme instrucoes na agencia';
        14: Result := '14-Titulo protestado';
        15: Result := '15-Titulo excluido';
        16: Result := '16-Titulo baixado pelo banco por decurso de prazo';
        20: Result := '20-Titulo baixado e transferido para desconto';
      Else
        Result := IntToStrZero(CodMotivo, 2) + ' - Outros Motivos';
      End;
    toRetornoLiquidadoAposBaixaouNaoRegistro:
      Case CodMotivo Of
        00: Result := '00-Pago com dinheiro';
        15: Result := '15-Pago com cheque';
      Else
        Result := IntToStrZero(CodMotivo, 2) + ' - Outros Motivos';
      End;

    toRetornoLiquidadoEmCartorio:
      Case CodMotivo Of
        00: Result := '00-Pago com dinheiro';
        15: Result := '15-Pago com cheque';
      Else
        Result := IntToStrZero(CodMotivo, 2) + ' - Outros Motivos';
      End;

    toRetornoEntradaRejeitaCEPIrregular:
      Case CodMotivo Of
        48: Result := '48-CEP invalido';
      Else
        Result := IntToStrZero(CodMotivo, 2) + ' - Outros Motivos';
      End;

    toRetornoBaixaRejeitada:
      Case CodMotivo Of
        04: Result := '04-Codigo de ocorrencia nao permitido para a carteira';
        07: Result := '07-Agencia\Conta\Digito invalidos';
        08: Result := '08-Nosso numero invalido';
        10: Result := '10-Carteira invalida';
        15: Result := '15-Carteira\Agencia\Conta\NossoNumero invalidos';
        40: Result := '40-Titulo com ordem de protesto emitido';
        42: Result := '42-Codigo para baixa/devolucao via Telebradesco invalido';
        60: Result := '60-Movimento para titulo nao cadastrado';
        77: Result := '70-Transferencia para desconto nao permitido para a carteira';
        85: Result := '85-Titulo com pagamento vinculado';
      Else
        Result := IntToStrZero(CodMotivo, 2) + ' - Outros Motivos';
      End;

    toRetornoDebitoTarifas:
      Case CodMotivo Of
        02: Result := '02-Tarifa de permanência título cadastrado';
        03: Result := '03-Tarifa de sustação';
        04: Result := '04-Tarifa de protesto';
        05: Result := '05-Tarifa de outras instrucoes';
        06: Result := '06-Tarifa de outras ocorrências';
        08: Result := '08-Custas de protesto';
        12: Result := '12-Tarifa de registro';
        13: Result := '13-Tarifa titulo pago no Bradesco';
        14: Result := '14-Tarifa titulo pago compensacao';
        15: Result := '15-Tarifa título baixado não pago';
        16: Result := '16-Tarifa alteracao de vencimento';
        17: Result := '17-Tarifa concessão abatimento';
        18: Result := '18-Tarifa cancelamento de abatimento';
        19: Result := '19-Tarifa concessão desconto';
        20: Result := '20-Tarifa cancelamento desconto';
        21: Result := '21-Tarifa título pago cics';
        22: Result := '22-Tarifa título pago Internet';
        23: Result := '23-Tarifa título pago term. gerencial serviços';
        24: Result := '24-Tarifa título pago Pág-Contas';
        25: Result := '25-Tarifa título pago Fone Fácil';
        26: Result := '26-Tarifa título Déb. Postagem';
        27: Result := '27-Tarifa impressão de títulos pendentes';
        28: Result := '28-Tarifa título pago BDN';
        29: Result := '29-Tarifa título pago Term. Multi Funcao';
        30: Result := '30-Impressão de títulos baixados';
        31: Result := '31-Impressão de títulos pagos';
        32: Result := '32-Tarifa título pago Pagfor';
        33: Result := '33-Tarifa reg/pgto – guichê caixa';
        34: Result := '34-Tarifa título pago retaguarda';
        35: Result := '35-Tarifa título pago Subcentro';
        36: Result := '36-Tarifa título pago Cartao de Credito';
        37: Result := '37-Tarifa título pago Comp Eletrônica';
        38: Result := '38-Tarifa título Baix. Pg. Cartorio';
        39: Result := '39-Tarifa título baixado acerto BCO';
        40: Result := '40-Baixa registro em duplicidade';
        41: Result := '41-Tarifa título baixado decurso prazo';
        42: Result := '42-Tarifa título baixado Judicialmente';
        43: Result := '43-Tarifa título baixado via remessa';
        44: Result := '44-Tarifa título baixado rastreamento';
        45: Result := '45-Tarifa título baixado conf. Pedido';
        46: Result := '46-Tarifa título baixado protestado';
        47: Result := '47-Tarifa título baixado p/ devolucao';
        48: Result := '48-Tarifa título baixado Franco pagto';
        49: Result := '49-Tarifa título baixado SUST/RET/CARTÓRIO';
        50: Result := '50-Tarifa título baixado SUS/SEM/REM/CARTÓRIO';
        51: Result := '51-Tarifa título transferido desconto';
        52: Result := '52-Cobrado baixa manual';
        53: Result := '53-Baixa por acerto cliente';
        54: Result := '54-Tarifa baixa por contabilidade';
        55: Result := '55-BIFAX';
        56: Result := '56-Consulta informações via internet';
        57: Result := '57-Arquivo retorno via internet';
        58: Result := '58-Tarifa emissão Papeleta';
        59: Result := '59-Tarifa Fornec papeleta semi preenchida';
        60: Result := '60-Acondicionador de papeletas (RPB)S';
        61: Result := '61-Acond. De papelatas (RPB)s PERSONAL';
        62: Result := '62-Papeleta Formulário branco';
        63: Result := '63-Formulário A4 serrilhado';
        64: Result := '64-Fornecimento de softwares transmiss';
        65: Result := '65-Fornecimento de softwares consulta';
        66: Result := '66-Fornecimento Micro Completo';
        67: Result := '67-Fornecimento MODEN';
        68: Result := '68-Fornecimento de máquina FAX';
        69: Result := '69-Fornecimento de maquinas oticas';
        70: Result := '70-Fornecimento de Impressoras';
        71: Result := '71-Reativação de título';
        72: Result := '72-Alteração de produto negociado';
        73: Result := '73-Tarifa emissao de contra recibo';
        74: Result := '74-Tarifa emissao 2ª via papeleta';
        75: Result := '75-Tarifa regravação arquivo retorno';
        76: Result := '76-Arq. Títulos a vencer mensal';
        77: Result := '77-Listagem auxiliar de crédito';
        78: Result := '78-Tarifa cadastro cartela instrução permanente';
        79: Result := '79-Canalização de Crédito';
        80: Result := '80-Cadastro de Mensagem Fixa';
        81: Result := '81-Tarifa reapresentação automática título';
        82: Result := '82-Tarifa registro título déb. Automático';
        83: Result := '83-Tarifa Rateio de Crédito';
        84: Result := '84-Emissão papeleta sem valor';
        85: Result := '85-Sem uso';
        86: Result := '86-Cadastro de reembolso de diferença';
        87: Result := '87-Relatório Fluxo de pagto';
        88: Result := '88-Emissão Extrato mov. Carteira';
        89: Result := '89-Mensagem campo local de pagto';
        90: Result := '90-Cadastro Concessionária serv. Publ.';
        91: Result := '91-Classif. Extrato Conta Corrente';
        92: Result := '92-Contabilidade especial';
        93: Result := '93-Realimentação pagto';
        94: Result := '94-Repasse de Créditos';
        95: Result := '95-Tarifa reg. pagto Banco Postal';
        96: Result := '96-Tarifa reg. Pagto outras mídias';
        97: Result := '97-Tarifa Reg/Pagto – Net Empresa';
        98: Result := '98-Tarifa título pago vencido';
        99: Result := '99-TR Tít. Baixado por decurso prazo';
        100: Result := '100-Arquivo Retorno Antecipado';
        101: Result := '101-Arq retorno Hora/Hora';
        102: Result := '102-TR. Agendamento Déb Aut';
        103: Result := '103-TR. Tentativa cons Déb Aut';
        104: Result := '104-TR Crédito on-line';
        105: Result := '105-TR. Agendamento rat. Crédito';
        106: Result := '106-TR Emissão aviso rateio';
        107: Result := '107-Extrato de protesto';
        110: Result := '110-Tarifa reg/pagto Bradesco Expresso';
      Else
        Result := IntToStrZero(CodMotivo, 2) + ' - Outros Motivos';
      End;

    toRetornoOcorrenciasdoSacado:
      Case CodMotivo Of
        78: Result := '78-Sacado alega que Faturamento e indevido';
        116: Result := '116-Sacado aceita/reconhece o Faturamento';
      Else
        Result := IntToStrZero(CodMotivo, 2) + ' - Outros Motivos';
      End;

    toRetornoALteracaoOutrosDadosRejeitada:
      Case CodMotivo Of
        01: Result := '01-Código do Banco inválido';
        04: Result := '04-Código de ocorrência não permitido para a carteira';
        05: Result := '05-Código da ocorrência não numérico';
        08: Result := '08-Nosso número inválido';
        15: Result := '15-Característica da cobrança incompatível';
        16: Result := '16-Data de vencimento inválido';
        17: Result := '17-Data de vencimento anterior a data de emissão';
        18: Result := '18-Vencimento Fora do prazo de operação';
        24: Result := '24-Data de emissão Inválida';
        26: Result := '26-Código de juros de mora inválido';
        27: Result := '27-Valor/taxa de juros de mora inválido';
        28: Result := '28-Código de desconto inválido';
        29: Result := '29-Valor do desconto maior/igual ao valor do Título';
        30: Result := '30-Desconto a conceder não confere';
        31: Result := '31-Concessão de desconto já existente ( Desconto anterior )';
        32: Result := '32-Valor do IOF inválido';
        33: Result := '33-Valor do abatimento inválido';
        34: Result := '34-Valor do abatimento maior/igual ao valor do Título';
        38: Result := '38-Prazo para protesto inválido';
        39: Result := '39-Pedido de protesto não permitido para o Título';
        40: Result := '40-Título com ordem de protesto emitido';
        42: Result := '42-Código para baixa/devolução inválido';
        46: Result := '46-Tipo/número de inscrição do sacado inválidos';
        48: Result := '48-Cep Inválido';
        53: Result := '53-Tipo/Número de inscrição do sacador/avalista inválidos';
        54: Result := '54-Sacador/avalista não informado';
        57: Result := '57-Código da multa inválido';
        58: Result := '58-Data da multa inválida';
        60: Result := '60-Movimento para Título não cadastrado';
        79: Result := '79-Data de Juros de mora Inválida';
        80: Result := '80-Data do desconto inválida';
        85: Result := '85-Título com Pagamento Vinculado.';
        88: Result := '88-E-mail Sacado não lido no prazo 5 dias';
        91: Result := '91-E-mail sacado não recebido';
      Else
        Result := IntToStrZero(CodMotivo, 2) + ' - Outros Motivos';
      End;

    toRetornoComandoRecusado:
      Case CodMotivo Of
        01: Result := '01-Código do Banco inválido';
        02: Result := '02-Código do registro detalhe inválido';
        04: Result := '04-Código de ocorrência não permitido para a carteira';
        05: Result := '05-Código de ocorrência não numérico';
        07: Result := '07-Agência/Conta/dígito inválidos';
        08: Result := '08-Nosso número inválido';
        10: Result := '10-Carteira inválida';
        15: Result := '15-Características da cobrança incompatíveis';
        16: Result := '16-Data de vencimento inválida';
        17: Result := '17-Data de vencimento anterior a data de emissão';
        18: Result := '18-Vencimento Fora do prazo de operação';
        20: Result := '20-Valor do título inválido';
        21: Result := '21-Espécie do Título inválida';
        22: Result := '22-Espécie não permitida para a carteira';
        24: Result := '24-Data de emissão inválida';
        28: Result := '28-Código de desconto via Telebradesco inválido';
        29: Result := '29-Valor do desconto maior/igual ao valor do Título';
        30: Result := '30-Desconto a conceder não confere';
        31: Result := '31-Concessão de desconto - Já existe desconto anterior';
        33: Result := '33-Valor do abatimento inválido';
        34: Result := '34-Valor do abatimento maior/igual ao valor do Título';
        36: Result := '36-Concessão abatimento - Já existe abatimento anterior';
        38: Result := '38-Prazo para protesto inválido';
        39: Result := '39-Pedido de protesto não permitido para o Título';
        40: Result := '40-Título com ordem de protesto emitido';
        41: Result := '41-Pedido cancelamento/sustação para Título sem instrução de protesto';
        42: Result := '42-Código para baixa/devolução inválido';
        45: Result := '45-Nome do Sacado não informado';
        46: Result := '46-Tipo/número de inscrição do Sacado inválidos';
        47: Result := '47-Endereço do Sacado não informado';
        48: Result := '48-CEP Inválido';
        50: Result := '50-CEP referente a um Banco correspondente';
        53: Result := '53-Tipo de inscrição do sacador avalista inválidos';
        60: Result := '60-Movimento para Título não cadastrado';
        85: Result := '85-Título com pagamento vinculado';
        86: Result := '86-Seu número inválido';
        94: Result := '94-Título Penhorado – Instrução Não Liberada pela Agência';

      Else
        Result := IntToStrZero(CodMotivo, 2) + ' - Outros Motivos';
      End;

    toRetornoDesagendamentoDebitoAutomatico:
      Case CodMotivo Of
        81: Result := '81-Tentativas esgotadas, baixado';
        82: Result := '82-Tentativas esgotadas, pendente';
        83: Result := '83-Cancelado pelo Sacado e Mantido Pendente, conforme negociação';
        84: Result := '84-Cancelado pelo sacado e baixado, conforme negociação';
      Else
        Result := IntToStrZero(CodMotivo, 2) + ' - Outros Motivos';
      End;
  Else
    Result := IntToStrZero(CodMotivo, 2) + ' - Outros Motivos';
  End;
End;



procedure TBancoHSBC.LerRetorno240(ARetorno: TStringList);  // CLAUDIO TENTANDO IMPLEMENTAR
var
  ContLinha: Integer;
  Titulo   : TTitulo;
  Linha, rCedente, rCNPJCPF: String;
  rAgencia, rConta,rDigitoConta: String;
  IdxMotivo : Integer;
begin

   if (copy(ARetorno.Strings[0],1,3) <> '399') then
      raise Exception.Create(Str(Banco.Boleto.NomeArqRetorno +
                             'não é um arquivo de retorno do '+ Nome));


   rAgencia     := trim(Copy(ARetorno[0],53,5));
   rConta       := trim(Copy(ARetorno[0],59,12));
   rDigitoConta := Copy(ARetorno[0],71,1);
   rCedente     := trim(Copy(ARetorno[0],73,30));

   Banco.Boleto.NumeroArquivo := StrToIntDef(Copy(ARetorno[0], 158, 6), 0);


   Banco.Boleto.DataArquivo := StringToDateTimeDef(Copy(ARetorno[0],144,2)+'/'+
                                                           Copy(ARetorno[0],146,2)+'/'+
                                                           Copy(ARetorno[0],148,4),0, 'DD/MM/YYYY' );


   if StrToIntDef(Copy(ARetorno[1],200,6),0) <> 0 then
      Banco.Boleto.DataCreditoLanc := StringToDateTimeDef(Copy(ARetorno[1],200,2)+'/'+
                                                                  Copy(ARetorno[1],202,2)+'/'+
                                                                  Copy(ARetorno[1],204,4),0, 'DD/MM/YYYY' );


   rCNPJCPF := trim( Copy(ARetorno[0],19,14)) ;

   if Banco.Boleto.Cedente.TipoInscricao = pJuridica then
    begin
      rCNPJCPF := trim( Copy(ARetorno[1],19,15));
      rCNPJCPF := RightStr(rCNPJCPF,14) ;
    end
   else
    begin
      rCNPJCPF := trim( Copy(ARetorno[1],23,11));
      rCNPJCPF := RightStr(rCNPJCPF,11) ;
    end;

   ValidarDadosRetorno(rAgencia, rConta+rDigitoConta, rCNPJCPF, True);
   with Banco.Boleto do
   begin
      if LeCedenteRetorno then
      begin
         Cedente.Nome         := rCedente;
         Cedente.CNPJCPF      := rCNPJCPF;
         Cedente.Agencia      := rAgencia;
         Cedente.AgenciaDigito:= '0';
         Cedente.Conta        := rConta;
         Cedente.ContaDigito  := rDigitoConta;
         Cedente.CodigoCedente:= rConta+rDigitoConta;

         case StrToIntDef(Copy(ARetorno[1],18,1),0) of
            1: Cedente.TipoInscricao:= pFisica;
            2: Cedente.TipoInscricao:= pJuridica;
            else
               Cedente.TipoInscricao:= pJuridica;
         end;
      end;

      Banco.Boleto.ListadeBoletos.Clear;
   end;

   Linha := '';
   Titulo := nil;

   For ContLinha := 1 to ARetorno.Count - 2 do
   begin
      Linha := ARetorno[ContLinha] ;

      {Segmento T - Só cria após passar pelo seguimento T depois U}
      if Copy(Linha,14,1)= 'T' then
         Titulo := Banco.Boleto.CriarTituloNaLista;

      if Assigned(Titulo) then
      with Titulo do
      begin
         {Segmento T}
         if Copy(Linha,14,1)= 'T' then
          begin
            SeuNumero                   := Trim(copy(Linha,59,15));
            NumeroDocumento             := copy(Linha,59,15);
            OcorrenciaOriginal.Tipo     := CodOcorrenciaToTipo(StrToIntDef(copy(Linha,16,2),0));

            //05 = Liquidação Sem Registro
            Vencimento := StringToDateTimeDef( Copy(Linha,74,2)+'/'+
                                               Copy(Linha,76,2)+'/'+
                                               Copy(Linha,80,4),0, 'DD/MM/YYYY' );

            ValorDocumento            := StrToFloatDef(Copy(Linha,82,15),0)/100;
            ValorDespesaCobranca      := StrToFloatDef(Copy(Linha,199,15),0)/100;
            Carteira                  := Copy(Linha,58,1);
            NossoNumero               := Copy(Linha,38,13);
            CodigoLiquidacao          := Copy(Linha,214,10);
            //CodigoLiquidacaoDescricao := CodigoLiquidacaoDescricao(StrToIntDef(CodigoLiquidacao,0) );

            // codigos motivos de ocorrencias
            IdxMotivo := 214;

            while (IdxMotivo < 223) do
            begin
               if (trim(Copy(Linha, IdxMotivo, 2)) <> '') then
               begin
                  MotivoRejeicaoComando.Add(Copy(Linha, IdxMotivo, 2));
                  DescricaoMotivoRejeicaoComando.Add(CodMotivoRejeicaoToDescricao(OcorrenciaOriginal.Tipo, StrToIntDef(Copy(Linha, IdxMotivo, 2), 0)));
               end;
               Inc(IdxMotivo, 2);
            end;

            // informações do local de pagamento
            Liquidacao.Banco      := StrToIntDef(Copy(Linha,97,3), -1);
            Liquidacao.Agencia    := Copy(Linha,100,5);
            Liquidacao.Origem     := '';
            Liquidacao.FormaPagto := '';

            // quando a liquidação ocorre nos canais do HSBC o banco vem zero
            // então acertar
            if Liquidacao.Banco = 0 then
              Liquidacao.Banco := 399;
          end


         {Segmento U}
         else if Copy(Linha,14,1)= 'U' then
          begin

            if StrToIntDef(Copy(Linha,138,6),0) <> 0 then
               DataOcorrencia := StringToDateTimeDef( Copy(Linha,138,2)+'/'+
                                                      Copy(Linha,140,2)+'/'+
                                                      Copy(Linha,142,4),0, 'DD/MM/YYYY' );

            if StrToIntDef(Copy(Linha,146,6),0) <> 0 then
               DataCredito:= StringToDateTimeDef( Copy(Linha,146,2)+'/'+
                                                  Copy(Linha,148,2)+'/'+
                                                  Copy(Linha,150,4),0, 'DD/MM/YYYY' );

            ValorMoraJuros       := StrToFloatDef(Copy(Linha,18,15),0)/100;
            ValorDesconto        := StrToFloatDef(Copy(Linha,33,15),0)/100;
            ValorAbatimento      := StrToFloatDef(Copy(Linha,48,15),0)/100;
            ValorIOF             := StrToFloatDef(Copy(Linha,63,15),0)/100;
            ValorPago            := StrToFloatDef(Copy(Linha,78,15),0)/100;
            ValorRecebido        := StrToFloatDef(Copy(Linha,93,15),0)/100;
            ValorOutrasDespesas  := StrToFloatDef(Copy(Linha,108,15),0)/100;
            ValorOutrosCreditos  := StrToFloatDef(Copy(Linha,123,15),0)/100;
         end;
      end;
   end;

end;




End.




