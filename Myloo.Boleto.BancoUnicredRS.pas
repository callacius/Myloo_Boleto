unit Myloo.Boleto.BancoUnicredRS;

interface

uses
  System.Classes,
  System.SysUtils,
  Myloo.Boleto;

type

  { TBancoUnicredRS }

  TBancoUnicredRS = class(TBancoClass)
  private
    FBoleto: TBoleto;
    property Boleto:TBoleto read FBoleto write Fboleto;
  protected
  public
    Constructor create(AOwner: TBanco);
    Function CalcularDigitoVerificador(const Titulo:TTitulo): String; override;
    Function MontarCodigoBarras(const Titulo : TTitulo): String; override;
    Function MontarCampoNossoNumero(const Titulo :TTitulo): String; override;
    Function MontarCampoCodigoCedente(const Titulo: TTitulo): String; override;
    procedure GerarRegistroHeader400(NumeroRemessa : Integer; ARemessa:TStringList); override;
    procedure GerarRegistroTransacao400(Titulo : TTitulo; aRemessa: TStringList); override;
    procedure GerarRegistroTrailler400(ARemessa:TStringList);  override;
    Procedure LerRetorno400(ARetorno:TStringList); override;

    Function TipoOcorrenciaToDescricao(const TipoOcorrencia: TTipoOcorrencia) : String; override;
    Function CodOcorrenciaToTipo(const CodOcorrencia:Integer): TTipoOcorrencia; override;
    Function TipoOCorrenciaToCod(const TipoOcorrencia: TTipoOcorrencia):String; override;
    Function CodMotivoRejeicaoToDescricao(const TipoOcorrencia:TTipoOcorrencia; CodMotivo:Integer): String; override;

    Function CodOcorrenciaToTipoRemessa(const CodOcorrencia:Integer): TTipoOcorrencia; override;
  end;

implementation

uses
  dateutils, StrUtils, Myloo.Boleto.Utils;

{ TBancoUnicredRS }

constructor TBancoUnicredRS.create(AOwner: TBanco);
begin
   inherited create(AOwner);
   FpDigito                 := 4;
   FpNome                   := 'Unicred';
   FpNumero                 := 091;
   FpTamanhoMaximoNossoNum  := 10;
   FpTamanhoAgencia         := 4;
   FpTamanhoConta           := 7;
   FpTamanhoCarteira        := 2;
end;

function TBancoUnicredRS.CalcularDigitoVerificador(const Titulo: TTitulo ): String;
begin
   Modulo.CalculoPadrao;
   Modulo.MultiplicadorFinal := 7;
   Modulo.Documento := Titulo.Carteira + Titulo.NossoNumero;
   Modulo.Calcular;

   if Modulo.ModuloFinal = 1 then
      Result:= 'P'
   else
      Result:= IntToStr(Modulo.DigitoFinal);
end;

function TBancoUnicredRS.MontarCodigoBarras ( const Titulo: TTitulo) : String;
var
  sCodigoBarras   : String;
  sFatorVencimento: String;
  sDigitoCodBarras: String;
begin
   with Titulo.Boleto do
   begin
      sFatorVencimento  := CalcularFatorVencimento(Titulo.Vencimento);

      sCodigoBarras     := IntToStrZero(Numero, 3) +                                              { Institui��o Financ }
                           '9' +                                                                  { C�d. Moeda = Real }
                           sFatorVencimento +                                                     { Fator Vencimento }
                           IntToStrZero(Round(Titulo.ValorDocumento * 100), 10) +             { Valor Nominal }
                           PadLeft(OnlyNumber(Cedente.Agencia), FpTamanhoAgencia, '0') +          { Campo Livre 1 - Ag�ncia }
                           PadLeft(RightStr(Cedente.Conta + Cedente.ContaDigito, 10), 10, '0') +  { Campo Livre 2 - Conta }
                           Titulo.NossoNumero +                                               { Campo Livre 3 - Nosso N�m }
                           CalcularDigitoVerificador(Titulo);                                 {                C/ D�gito }

      sDigitoCodBarras  := CalcularDigitoCodigoBarras(sCodigoBarras);
   end;

   { Insere o digito verificador calculado no c�digo de barras }
   Result := IntToStrZero(Numero, 3) + '9' + sDigitoCodBarras + Copy(sCodigoBarras, 5, 39);
end;

function TBancoUnicredRS.MontarCampoNossoNumero (
   const Titulo: TTitulo ) : String;
begin
   Result := Titulo.Carteira + '/'+ Titulo.NossoNumero + '-'+ CalcularDigitoVerificador(Titulo);
end;

function TBancoUnicredRS.MontarCampoCodigoCedente (
   const Titulo: TTitulo ) : String;
begin
   Result := Titulo.Boleto.Cedente.Agencia        + '-' +
             Titulo.Boleto.Cedente.AgenciaDigito  + '/' +
             Titulo.Boleto.Cedente.Conta          + '-' +
             Titulo.Boleto.Cedente.ContaDigito;
end;

procedure TBancoUnicredRS.GerarRegistroHeader400(NumeroRemessa : Integer; ARemessa:TStringList);
var
  wLinha: String;
begin
   with Banco.Boleto.Cedente do
   begin
      wLinha:= '0'                                                +  { ID do Registro }
               '1'                                                +  { ID do Arquivo( 1 - Remessa) }
               'REMESSA'                                          +  { Literal de Remessa }
               '01'                                               +  { C�digo do Tipo de Servi�o }
               PadRight('COBRANCA', 15)                           +  { Descri��o do tipo de servi�o }
               PadLeft(CodigoCedente, 20, '0')                    +  { Codigo da Empresa no Banco }
               PadRight(Nome, 30)                                 +  { Nome da Empresa }
               IntToStrZero(Numero, 3) + PadRight('UNICRED', 15)  +  { C�digo e Nome do Banco(091 - Unicred ) }
               FormatDateTime('ddmmyy',Now) + Space(07)           +  { Data de gera��o do arquivo + brancos }
               '113'                                              +  { C�d. Par�m. Movto da Unicred }
               IntToStrZero(NumeroRemessa, 7) + Space(277)        +  { Nr. Sequencial de Remessa + brancos }
               IntToStrZero(1, 6);                                   { Nr. Sequencial de Remessa + brancos + Contador }

      ARemessa.Text:= ARemessa.Text + UpperCase(wLinha);
   end;
end;

procedure TBancoUnicredRS.GerarRegistroTransacao400(Titulo :TTitulo; aRemessa: TStringList);
var
  sDigitoNossoNumero, sOcorrencia, sAgencia           : String;
  sProtesto, sTipoSacado, sConta                      : String;
  sCarteira, sLinha, sNossoNumero, sNumContrato       : String;
  iTamNossoNum: Integer;

  Function DoMontaInstrucoes1: string;
  begin
     Result := '';
     with Titulo, Boleto do
     begin

        {Primeira instru��o vai no registro 1}
        if Mensagem.Count <= 1 then
        begin
           Result := '';
           Exit;
        end;

        Result := sLineBreak +
                  '2'               +                                    // IDENTIFICA��O DO LAYOUT PARA O REGISTRO
                  Copy(PadRight(Mensagem[1], 80, ' '), 1, 80);               // CONTE�DO DA 1� LINHA DE IMPRESS�O DA �REA "INSTRU��ES� DO BOLETO

        if Mensagem.Count >= 3 then
           Result := Result +
                     Copy(PadRight(Mensagem[2], 80, ' '), 1, 80)              // CONTE�DO DA 2� LINHA DE IMPRESS�O DA �REA "INSTRU��ES� DO BOLETO
        else
           Result := Result + PadRight('', 80, ' ');                          // CONTE�DO DO RESTANTE DAS LINHAS

        if Mensagem.Count >= 4 then
           Result := Result +
                     Copy(PadRight(Mensagem[3], 80, ' '), 1, 80)              // CONTE�DO DA 3� LINHA DE IMPRESS�O DA �REA "INSTRU��ES� DO BOLETO
        else
           Result := Result + PadRight('', 80, ' ');                          // CONTE�DO DO RESTANTE DAS LINHAS

        if Mensagem.Count >= 5 then
           Result := Result +
                     Copy(PadRight(Mensagem[4], 80, ' '), 1, 80)              // CONTE�DO DA 4� LINHA DE IMPRESS�O DA �REA "INSTRU��ES� DO BOLETO
        else
           Result := Result + PadRight('', 80, ' ');                          // CONTE�DO DO RESTANTE DAS LINHAS


        Result := Result                                              +
                  space(45)                                           +  // COMPLEMENTO DO REGISTRO
                  sCarteira                                           +
                  sAgencia                                            +
                  sConta                                              +
                  Cedente.ContaDigito                                 +
                  NossoNumero + sDigitoNossoNumero                    +
                  IntToStrZero( aRemessa.Count + 2, 6);                  // N� SEQ�ENCIAL DO REGISTRO NO ARQUIVO
     end;
  end;

begin

   with Titulo do
   begin
      sNossoNumero := Titulo.NossoNumero;
      iTamNossoNum := CalcularTamMaximoNossoNumero(Titulo.Carteira,
                                                   Titulo.NossoNumero);

      if (Boleto.Cedente.ResponEmissao = tbBancoEmite) then
      begin
        sNossoNumero      := StringOfChar('0', iTamNossoNum);
        sDigitoNossoNumero := '0';
      end
      else
      begin
        sNossoNumero      := Titulo.NossoNumero;
        sDigitoNossoNumero := CalcularDigitoVerificador(Titulo);
      end;

      sAgencia      := IntToStrZero(StrToIntDef(OnlyNumber(Boleto.Cedente.Agencia), 0), 5);
      sConta        := IntToStrZero(StrToIntDef(OnlyNumber(Boleto.Cedente.Conta)  , 0), 7);
      sCarteira     := IntToStrZero(StrToIntDef(trim(Carteira), 0), 3);
      sNumContrato  := sAgencia + sConta + Boleto.Cedente.ContaDigito;

      {Pegando C�digo da Ocorrencia}
      case OcorrenciaOriginal.Tipo of
         toRemessaBaixar                         : sOcorrencia := '02'; {Pedido de Baixa}
         toRemessaConcederAbatimento             : sOcorrencia := '04'; {Concess�o de Abatimento}
         toRemessaCancelarAbatimento             : sOcorrencia := '05'; {Cancelamento de Abatimento concedido}
         toRemessaAlterarVencimento              : sOcorrencia := '06'; {Altera��o de vencimento}
         toRemessaAlterarNumeroControle          : sOcorrencia := '08'; {Altera��o de seu n�mero}
         toRemessaProtestar                      : sOcorrencia := '09'; {Pedido de protesto}
         toRemessaNaoProtestar                   : sOcorrencia := '10'; {N�o Protestar}
         toRemessaCancelarInstrucaoProtestoBaixa : sOcorrencia := '18'; {Sustar protesto e baixar}
         toRemessaCancelarInstrucaoProtesto      : sOcorrencia := '19'; {Sustar protesto e manter na carteira}
         toRemessaOutrasOcorrencias              : sOcorrencia := '31'; {Altera��o de Outros Dados}
      else
         sOcorrencia := '01';                                           {Remessa}
      end;

      {Pegando Tipo de Boleto}
      if not(Boleto.Cedente.ResponEmissao = tbCliEmite) then
        if (NossoNumero = EmptyStr) then
           sDigitoNossoNumero := '0';

      {Pegando campo Intru��es}
      if (DataProtesto > 0) and (DataProtesto > Vencimento) then
         sProtesto := '06' + IntToStrZero(DaysBetween(DataProtesto, Vencimento), 2)
      else if sOcorrencia = '31' then
         sProtesto := '9999'
      else
         sProtesto := '0000';

      {Pegando Tipo de Sacado}
      case Sacado.Pessoa of
         pFisica   : sTipoSacado := '01';
         pJuridica : sTipoSacado := '02';
      else
         sTipoSacado := '99';
      end;

      with Boleto do
      begin
         sLinha:= '1'                                                     +  { 001: ID Registro }
                  sAgencia                                                +  { 002: Ag�ncia }
                  Cedente.AgenciaDigito                                   +  { 007: Ag�ncia D�gito }
                  PadLeft(sConta, 12, '0')                                +  { 008: Conta Corrente }
                  Cedente.ContaDigito                                     +  { 020: Conta Corrente D�gito }
                  '0' + sCarteira                                         +  { 021: Zero + Carteira }
                  sNumContrato                                            +  { 025: N�mero Contrato }
                  PadRight(SeuNumero, 25, ' ')                            +  { 038: Numero Controle do Participante }
                  IntToStrZero(Numero, 3) + '00'                          +  { 063: C�d. do Banco = 091 }
                  PadLeft(sNossoNumero + sDigitoNossoNumero, 15, '0')     +  { 068: Nosso N�mero }
                  IntToStrZero(Round(ValorDescontoAntDia * 100), 10)      +  { 083: Desconto Bonifica��o por dia }
                  '0' + Space(12) + '0' + Space(2)                        +  { 093: Zero | 094: Branco |
                                                                               095: 10 Brancos | 105: Branco |
                                                                               106: Zeros | 107: 2 Brancos }
                  sOcorrencia                                             +  { 109: Ocorr�ncia }
                  PadRight(NumeroDocumento, 10)                           +  { 111: N�mero DOcumento }
                  FormatDateTime( 'ddmmyy', Vencimento)                   +  { 121: Vencimento }
                  IntToStrZero(Round(ValorDocumento * 100 ), 13)          +  { 127: Valor do T�tulo }
                  StringOfChar('0', 11)                                   +  { 140: Zeros }
                  FormatDateTime('ddmmyy', DataDocumento)                 +  { 151: Data de Emiss�o }
                  sProtesto                                               +  { 157: Protesto }
                  IntToStrZero(Round(ValorMoraJuros * 100), 13)           +  { 161: Valor por dia de Atraso }
                  IfThen(DataDesconto < EncodeDate(2000,01,01), '000000',
                         FormatDateTime('ddmmyy', DataDesconto))         +  { 174: Data Limite Desconto }
                  IntToStrZero(Round(ValorDesconto * 100), 13)           +  { 180: Valor Desconto }
                  sNossoNumero + sDigitoNossoNumero + '00'               +  { 193: Nosso N�mero na Unicred }
                  IntToStrZero(Round(ValorAbatimento * 100), 13)         +  { 206: Valor Abatimento }
                  sTipoSacado                                            +  { 219: Tipo Inscri��o Sacado }
                  PadLeft(OnlyNumber(Sacado.CNPJCPF), 14, '0')           +  { 221: N�m. Incri��o Sacado }
                  PadRight(Sacado.NomeSacado, 40, ' ')                   +  { 235: Nome do Sacado }
                  PadRight(Sacado.Logradouro + ' ' + Sacado.Numero, 40)  +  { 275: Endere�o do Sacado }
                  PadRight(Sacado.Bairro, 12, ' ')                       +  { 315: Bairro do Sacado }
                  PadRight(Sacado.CEP, 8, ' ')                           +  { 327: CEP do Sacado }
                  PadRight(Sacado.Cidade, 20, ' ')                       +  { 335: Cidade do Sacado }
                  PadRight(Sacado.UF, 2, ' ')                            +  { 355: UF Cidade do Sacado }
                  Space(38)                                              +  { 357: Sacador/Avalista }
                  IntToStrZero(aRemessa.Count + 1, 6);                      { 395: N�m Sequencial arquivo }

         sLinha := sLinha + DoMontaInstrucoes1;

         aRemessa.Text := aRemessa.Text + UpperCase(sLinha);
      end;
   end;
end;

procedure TBancoUnicredRS.GerarRegistroTrailler400( ARemessa:TStringList );
var
  wLinha: String;
begin
   wLinha := '9' + Space(393)                     +  { ID Registro }
             IntToStrZero( ARemessa.Count + 1, 6);   { Contador de Registros }

   ARemessa.Text:= ARemessa.Text + UpperCase(wLinha);
end;

Procedure TBancoUnicredRS.LerRetorno400 ( ARetorno: TStringList );
var
  vTitulo                     : TTitulo;
  iContLinha, iCodOcorrencia  : Integer;
  iCodMotivo, i, iMotivoLinha : Integer;
  sCodMotivo_19, sAgencia     : String;
  sConta, sDigitoConta        : String;
  sLinha, sCedente, sCNPJCPF  : String;
  sCodEmpresa                 : String;
begin
   if (StrToIntDef(Copy(ARetorno.Strings[0], 77, 3), -1) <> Numero) then
      raise Exception.Create(Str(Banco.Boleto.NomeArqRetorno +
                             'n�o � um arquivo de retorno da ' + Nome));

   sCodEmpresa  := Trim(Copy(ARetorno[0], 27, 20));
   sCedente     := Trim(Copy(ARetorno[0], 47, 30));
   sAgencia     := Trim(Copy(ARetorno[1], 25, Banco.TamanhoAgencia));
   sConta       := Trim(Copy(ARetorno[1], 30, Banco.TamanhoConta));
   sDigitoConta :=      Copy(ARetorno[1], 42, 1);

   Banco.Boleto.NumeroArquivo := 0;//StrToIntDef(Copy(ARetorno[0], 109, 5), 0);

   Banco.Boleto.DataArquivo := StringToDateTimeDef(Copy(ARetorno[0], 95, 2) + '/' +
                                                           Copy(ARetorno[0], 97, 2) + '/' +
                                                           Copy(ARetorno[0], 99, 2), 0, 'DD/MM/YY' );

   Banco.Boleto.DataCreditoLanc := StringToDateTimeDef(Copy(ARetorno[0], 380, 2) + '/' +
                                                               Copy(ARetorno[0], 382, 2) + '/' +
                                                               Copy(ARetorno[0], 384, 2), 0, 'DD/MM/YY');

   case StrToIntDef(Copy(ARetorno[1],2,2),0) of
      11: sCNPJCPF := Copy(ARetorno[1],7,11);
      14: sCNPJCPF := Copy(ARetorno[1],4,14);
   else
     sCNPJCPF := Copy(ARetorno[1],4,14);
   end;

   ValidarDadosRetorno(sAgencia, sConta);
   with Banco.Boleto do
   begin
      if (not LeCedenteRetorno) and (sCodEmpresa <> PadLeft(Cedente.CodigoCedente, 20, '0')) then
         raise Exception.Create(Str('C�digo da Empresa do arquivo inv�lido'));

      case StrToIntDef(Copy(ARetorno[1],2,2),0) of
         11: Cedente.TipoInscricao:= pFisica;
         14: Cedente.TipoInscricao:= pJuridica;
      else
         Cedente.TipoInscricao := pJuridica;
      end;

      if LeCedenteRetorno then
      begin
         try
           Cedente.CNPJCPF := sCNPJCPF;
         except
           // Retorno quando � CPF est� vindo errado por isso ignora erro na atribui��o
         end;

         Cedente.CodigoCedente:= sCodEmpresa;
         Cedente.Nome         := sCedente;
         Cedente.Agencia      := sAgencia;
         Cedente.AgenciaDigito:= '0';
         Cedente.Conta        := sConta;
         Cedente.ContaDigito  := sDigitoConta;
      end;

      Banco.Boleto.ListadeBoletos.Clear;
   end;

   For iContLinha := 1 to ARetorno.Count - 2 do
   begin
      sLinha := ARetorno[iContLinha] ;

      if Copy(sLinha,1,1)<> '1' then
         Continue;

      vTitulo := Banco.Boleto.CriarTituloNaLista;

      with vTitulo do
      begin
         SeuNumero                   := copy(sLinha,38,25);
         NumeroDocumento             := copy(sLinha,117,10);
         OcorrenciaOriginal.Tipo     := CodOcorrenciaToTipo(StrToIntDef(
                                        copy(sLinha,109,2),0));

         iCodOcorrencia := StrToInt(IfThen(copy(sLinha,109,2) = '00','00',copy(sLinha,109,2)));

         //-|Se a ocorrencia For igual a 19 - Confirma��o de Receb. de Protesto
         //-|Verifica o motivo na posi��o 295 - A = Aceite , D = Desprezado
         if(iCodOcorrencia = 19)then
          begin
            sCodMotivo_19:= copy(sLinha,295,1);
            if(sCodMotivo_19 = 'A')then
             begin
               MotivoRejeicaoComando.Add(copy(sLinha,295,1));
               DescricaoMotivoRejeicaoComando.Add('A - Aceito');
             end
            else
             begin
               MotivoRejeicaoComando.Add(copy(sLinha,295,1));
               DescricaoMotivoRejeicaoComando.Add('D - Desprezado');
             end;
          end
         else
          begin
            iMotivoLinha := 319;
            For i := 0 to 4 do
            begin
               iCodMotivo := StrToInt(IfThen(copy(sLinha,iMotivoLinha,2) = '00','00',copy(sLinha,iMotivoLinha,2)));

               {Se For o primeiro motivo}
               if (i = 0) then
                begin
                  {Somente estas ocorrencias possuem motivos 00}
                  if(iCodOcorrencia in [02, 06, 09, 10, 15, 17])then
                   begin
                     MotivoRejeicaoComando.Add(IfThen(copy(sLinha,iMotivoLinha,2) = '00','00',copy(sLinha,iMotivoLinha,2)));
                     DescricaoMotivoRejeicaoComando.Add(CodMotivoRejeicaoToDescricao(OcorrenciaOriginal.Tipo,iCodMotivo));
                   end
                  else
                   begin
                     if(iCodMotivo = 0)then
                      begin
                        MotivoRejeicaoComando.Add('00');
                        DescricaoMotivoRejeicaoComando.Add('Sem Motivo');
                      end
                     else
                      begin
                        MotivoRejeicaoComando.Add(IfThen(copy(sLinha,iMotivoLinha,2) = '00','00',copy(sLinha,iMotivoLinha,2)));
                        DescricaoMotivoRejeicaoComando.Add(CodMotivoRejeicaoToDescricao(OcorrenciaOriginal.Tipo,iCodMotivo));
                      end;
                   end;
                end
               else
                begin
                  //Apos o 1� motivo os 00 significam que n�o existe mais motivo
                  if iCodMotivo <> 0 then
                  begin
                     MotivoRejeicaoComando.Add(IfThen(copy(sLinha,iMotivoLinha,2) = '00','00',copy(sLinha,iMotivoLinha,2)));
                     DescricaoMotivoRejeicaoComando.Add(CodMotivoRejeicaoToDescricao(OcorrenciaOriginal.Tipo,iCodMotivo));
                  end;
                end;

               iMotivoLinha := iMotivoLinha + 2; //Incrementa a coluna dos motivos
            end;
          end;

         DataOcorrencia := StringToDateTimeDef( Copy(sLinha,111,2)+'/'+
                                                Copy(sLinha,113,2)+'/'+
                                                Copy(sLinha,115,2),0, 'DD/MM/YY' );
         if Copy(sLinha,147,2)<>'00' then
            Vencimento := StringToDateTimeDef( Copy(sLinha,147,2)+'/'+
                                               Copy(sLinha,149,2)+'/'+
                                               Copy(sLinha,151,2),0, 'DD/MM/YY' );

         ValorDocumento       := StrToFloatDef(Copy(sLinha,153,13),0)/100;
         ValorIOF             := StrToFloatDef(Copy(sLinha,215,13),0)/100;
         ValorAbatimento      := StrToFloatDef(Copy(sLinha,228,13),0)/100;
         ValorDesconto        := StrToFloatDef(Copy(sLinha,241,13),0)/100;
         ValorMoraJuros       := StrToFloatDef(Copy(sLinha,267,13),0)/100;
         ValorOutrosCreditos  := StrToFloatDef(Copy(sLinha,280,13),0)/100;
         ValorRecebido        := StrToFloatDef(Copy(sLinha,254,13),0)/100;
         NossoNumero          := Copy(sLinha,71,11);
         Carteira             := Copy(sLinha,22,3);
         ValorDespesaCobranca := StrToFloatDef(Copy(sLinha,176,13),0)/100;
         ValorOutrasDespesas  := StrToFloatDef(Copy(sLinha,189,13),0)/100;

         if StrToIntDef(Copy(sLinha,296,6),0) <> 0 then
            DataCredito:= StringToDateTimeDef( Copy(sLinha,296,2)+'/'+
                                               Copy(sLinha,298,2)+'/'+
                                               Copy(sLinha,300,2),0, 'DD/MM/YY' );
      end;
   end;
end;

function TBancoUnicredRS.TipoOcorrenciaToDescricao(const TipoOcorrencia: TTipoOcorrencia): String;
var
  CodOcorrencia: Integer;
begin
  Result        := EmptyStr;
  CodOcorrencia := StrToIntDef(TipoOCorrenciaToCod(TipoOcorrencia),0);

  case CodOcorrencia of
    02: Result := '02-Entrada Confirmada';
    03: Result := '03-Entrada Rejeitada';
    06: Result := '06-Liquida��o Normal';
    09: Result := '09-Baixado Automaticamente via Arquivo';
    10: Result := '10-Baixado conforme instru��es da Ag�ncia';
    12: Result := '12-Abatimento Concedido';
    13: Result := '13-Abatimento Cancelado';
    14: Result := '14-Vencimento Alterado';
    15: Result := '15-Liquida��o em Cart�rio';
    19: Result := '19-Confirma��o Recebimento Instru��o de Protesto';
    20: Result := '20-Confirma��o Recebimento Instru��o Susta��o de Protesto';
    21: Result := '21-Confirma Recebimento de Instru��o de N�o Protestar';
    24: Result := '24-Entrada rejeitada por CEP Irregular';
    27: Result := '27-Baixa Rejeitada';
    30: Result := '30-Altera��o de Outros Dados Rejeitados';
    32: Result := '32-Instru��o Rejeitada';
    33: Result := '33-Confirma��o Pedido Altera��o Outros Dados';
  end;
end;

function TBancoUnicredRS.CodOcorrenciaToTipo(const CodOcorrencia:
   Integer ) : TTipoOcorrencia;
begin

  case CodOcorrencia of
    02: Result := toRetornoRegistroConfirmado;
    03: Result := toRetornoRegistroRecusado;
    06: Result := toRetornoLiquidado;
    09: Result := toRetornoBaixadoViaArquivo;
    10: Result := toRetornoBaixadoInstAgencia;
    12: Result := toRetornoAbatimentoConcedido;
    13: Result := toRetornoAbatimentoCancelado;
    14: Result := toRetornoVencimentoAlterado;
    15: Result := toRetornoLiquidadoEmCartorio;
    19: Result := toRetornoRecebimentoInstrucaoProtestar;
    20: Result := toRetornoRecebimentoInstrucaoSustarProtesto;
    21: Result := toRetornoAcertoControleParticipante;
    24: Result := toRetornoEntradaRejeitaCEPIrregular;
    27: Result := toRetornoBaixaRejeitada;
    30: Result := toRetornoAlteracaoOutrosDadosRejeitada;
    32: Result := toRetornoInstrucaoRejeitada;
    33: Result := toRetornoRecebimentoInstrucaoAlterarDados;
  else
    Result := toRetornoOutrasOcorrencias;
  end;
end;

function TBancoUnicredRS.TipoOcorrenciaToCod ( const TipoOcorrencia: TTipoOcorrencia ) : String;
begin
  Result := '';

  case TipoOcorrencia of
    toRetornoRegistroConfirmado                             : Result := '02';
    toRetornoRegistroRecusado                               : Result := '03';
    toRetornoLiquidado                                      : Result := '06';
    toRetornoBaixadoViaArquivo                              : Result := '09';
    toRetornoBaixadoInstAgencia                             : Result := '10';
    toRetornoAbatimentoConcedido                            : Result := '12';
    toRetornoAbatimentoCancelado                            : Result := '13';
    toRetornoVencimentoAlterado                             : Result := '14';
    toRetornoLiquidadoEmCartorio                            : Result := '15';
    toRetornoRecebimentoInstrucaoProtestar                  : Result := '19';
    toRetornoRecebimentoInstrucaoSustarProtesto             : Result := '20';
    toRetornoAcertoControleParticipante                     : Result := '21';
    toRetornoEntradaRejeitaCEPIrregular                     : Result := '24';
    toRetornoBaixaRejeitada                                 : Result := '27';
    toRetornoAlteracaoOutrosDadosRejeitada                  : Result := '30';
    toRetornoInstrucaoRejeitada                             : Result := '32';
    toRetornoRecebimentoInstrucaoAlterarDados               : Result := '33';
  else
    Result := '02';
  end;
end;

function TBancoUnicredRS.COdMotivoRejeicaoToDescricao( const TipoOcorrencia:TTipoOcorrencia ;CodMotivo: Integer) : String;
begin
   case TipoOcorrencia of
     toRetornoRegistroConfirmado:
       case CodMotivo  of
         00: Result := '00-Ocorrencia aceita';
       else
         Result := IntToStrZero(CodMotivo,2) +' - Outros Motivos';
       end;
    toRetornoRegistroRecusado:
      case CodMotivo of
         02: Result := '02-Codigo do registro detalhe invalido';
         03: Result := '03-Codigo da Ocorrencia Invalida';
         04: Result := '04-Codigo da Ocorrencia nao permitida para a carteira';
         05: Result := '05-Codigo de Ocorrencia nao numerico';
         07: Result := '07-Agencia\Conta\Digito invalido';
         08: Result := '08-Nosso numero invalido';
         09: Result := '09-Nosso numero duplicado';
         10: Result := '10-Carteira invalida';
         16: Result := '16-Data de vencimento invalida';
         18: Result := '18-Vencimento Fora do prazo de operacao';
         20: Result := '20-Valor do titulo invalido';
         21: Result := '21-Especie do titulo invalida';
         22: Result := '22-Especie nao permitida para a carteira';
         24: Result := '24-Data de emissao invalida';
         38: Result := '38-Prazo para protesto invalido';
         44: Result := '44-Agencia cedente nao prevista';
         45: Result := '45-Nome Sacado nao informado';
         46: Result := '46-Tipo/numero inscricao sacado invalido';
         47: Result := '47-Endereco sacado nao informado';
         48: Result := '48-CEP invalido';
         63: Result := '63-Entrada para titulo ja cadastrado';
      else
         Result := IntToStrZero(CodMotivo,2) +' - Outros Motivos';
      end;
    toRetornoLiquidado:
      case CodMotivo of
         00: Result := '00-Titulo pago com dinheiro';
         15: Result := '15-Titulo pago com cheque';
         42: Result := '42-Rateio nao efetuado';
      else
         Result := IntToStrZero(CodMotivo,2) +' - Outros Motivos';
      end;
    toRetornoBaixadoViaArquivo:
      case CodMotivo of
         00: Result := '00-Ocorrencia aceita';
         10: Result := '10=Baixa comandada pelo cliente';
      else
         Result := IntToStrZero(CodMotivo,2) +' - Outros Motivos';
      end;
    toRetornoBaixadoInstAgencia:
         case CodMotivo of
            00: Result := '00-Baixado comandada';
         else
            Result := IntToStrZero(CodMotivo,2) +' - Outros Motivos';
         end;
    toRetornoLiquidadoEmCartorio:
      case CodMotivo of
         00: Result := '00-Pago com dinheiro';
         15: Result := '15-Pago com cheque';
      else
         Result := IntToStrZero(CodMotivo,2) +' - Outros Motivos';
      end;
    toRetornoEntradaRejeitaCEPIrregular:
      case CodMotivo of
         00: Result := '00-CEP invalido';
      else
         Result := IntToStrZero(CodMotivo,2) +' - Outros Motivos';
      end;
    toRetornoBaixaRejeitada:
      case CodMotivo of
         04: Result := '04-Codigo de ocorrencia nao permitido para a carteira';
         07: Result := '07-Agencia\Conta\Digito invalidos';
         08: Result := '08-Nosso numero invalido';
         10: Result := '10-Carteira invalida';
         15: Result := '15-Carteira\Agencia\Conta\NossoNumero invalidos';
         40: Result := '40-Titulo com ordem de protesto emitido';
         60: Result := '60-Movimento para titulo nao cadastrado';
         77: Result := '70-Transferencia para desconto nao permitido para a carteira';
         85: Result := '85-Titulo com pagamento vinculado';
      else
         Result := IntToStrZero(CodMotivo,2) +' - Outros Motivos';
      end;
    toRetornoALteracaoOutrosDadosRejeitada:
      case CodMotivo of
         01: Result := '01-C�digo do Banco inv�lido';
         04: Result := '04-C�digo de ocorr�ncia n�o permitido para a carteira';
         05: Result := '05-C�digo da ocorr�ncia n�o num�rico';
         08: Result := '08-Nosso n�mero inv�lido';
         15: Result := '15-Caracter�stica da cobran�a incompat�vel';
         16: Result := '16-Data de vencimento inv�lido';
         17: Result := '17-Data de vencimento anterior a data de emiss�o';
         18: Result := '18-Vencimento Fora do prazo de opera��o';
         24: Result := '24-Data de emiss�o Inv�lida';
         29: Result := '29-Valor do desconto maior/igual ao valor do T�tulo';
         30: Result := '30-Desconto a conceder n�o confere';
         31: Result := '31-Concess�o de desconto j� existente ( Desconto anterior )';
         33: Result := '33-Valor do abatimento inv�lido';
         34: Result := '34-Valor do abatimento maior/igual ao valor do T�tulo';
         38: Result := '38-Prazo para protesto inv�lido';
         39: Result := '39-Pedido de protesto n�o permitido para o T�tulo';
         40: Result := '40-T�tulo com ordem de protesto emitido';
         42: Result := '42-C�digo para baixa/devolu��o inv�lido';
         60: Result := '60-Movimento para T�tulo n�o cadastrado';
         85: Result := '85-T�tulo com Pagamento Vinculado.';
      else
         Result := IntToStrZero(CodMotivo,2) +' - Outros Motivos';
      end;
    toRetornoInstrucaoRejeitada:
      case CodMotivo of
         01 : Result := '01-C�digo do Banco inv�lido';
         02 : Result := '02-C�digo do registro detalhe inv�lido';
         04 : Result := '04-C�digo de ocorr�ncia n�o permitido para a carteira';
         05 : Result := '05-C�digo de ocorr�ncia n�o num�rico';
         07 : Result := '07-Ag�ncia/Conta/d�gito inv�lidos';
         08 : Result := '08-Nosso n�mero inv�lido';
         10 : Result := '10-Carteira inv�lida';
         15 : Result := '15-Caracter�sticas da cobran�a incompat�veis';
         16 : Result := '16-Data de vencimento inv�lida';
         17 : Result := '17-Data de vencimento anterior a data de emiss�o';
         18 : Result := '18-Vencimento Fora do prazo de opera��o';
         20 : Result := '20-Valor do t�tulo inv�lido';
         21 : Result := '21-Esp�cie do T�tulo inv�lida';
         22 : Result := '22-Esp�cie n�o permitida para a carteira';
         24 : Result := '24-Data de emiss�o inv�lida';
         28 : Result := '28-C�digo de desconto inv�lido';
         29 : Result := '29-Valor do desconto maior/igual ao valor do T�tulo';
         30 : Result := '30-Desconto a conceder n�o confere';
         31 : Result := '31-Concess�o de desconto - J� existe desconto anterior';
         33 : Result := '33-Valor do abatimento inv�lido';
         34 : Result := '34-Valor do abatimento maior/igual ao valor do T�tulo';
         36 : Result := '36-Concess�o abatimento - J� existe abatimento anterior';
         38 : Result := '38-Prazo para protesto inv�lido';
         39 : Result := '39-Pedido de protesto n�o permitido para o T�tulo';
         40 : Result := '40-T�tulo com ordem de protesto emitido';
         41 : Result := '41-Pedido cancelamento/susta��o para T�tulo sem instru��o de protesto';
         42 : Result := '42-C�digo para baixa/devolu��o inv�lido';
         45 : Result := '45-Nome do Sacado n�o informado';
         46 : Result := '46-Tipo/n�mero de inscri��o do Sacado inv�lidos';
         47 : Result := '47-Endere�o do Sacado n�o informado';
         48 : Result := '48-CEP Inv�lido';
         60 : Result := '60-Movimento para T�tulo n�o cadastrado';
         85 : Result := '85-T�tulo com pagamento vinculado';
         86 : Result := '86-Seu n�mero inv�lido';
      else
         Result:= IntToStrZero(CodMotivo,2) +' - Outros Motivos';
      end;
    toRetornoDesagendamentoDebitoAutomatico:
         Result := IntToStrZero(CodMotivo,2) + ' - Outros Motivos';
   else
      Result := IntToStrZero(CodMotivo,2) + ' - Outros Motivos';
   end;
end;

function TBancoUnicredRS.CodOcorrenciaToTipoRemessa(const CodOcorrencia:Integer): TTipoOcorrencia;
begin
  case CodOcorrencia of
    02 : Result:= toRemessaBaixar;                          {Pedido de Baixa}
    03 : Result:= toRemessaProtestoFinsFalimentares;        {Pedido de Protesto Falimentar}
    04 : Result:= toRemessaConcederAbatimento;              {Concess�o de Abatimento}
    05 : Result:= toRemessaCancelarAbatimento;              {Cancelamento de Abatimento concedido}
    06 : Result:= toRemessaAlterarVencimento;               {Altera��o de vencimento}
    07 : Result:= toRemessaAlterarControleParticipante;     {Altera��o do controle do participante}
    08 : Result:= toRemessaAlterarNumeroControle;           {Altera��o de seu n�mero}
    09 : Result:= toRemessaProtestar;                       {Pedido de protesto}
    18 : Result:= toRemessaCancelarInstrucaoProtestoBaixa;  {Sustar protesto e baixar}
    19 : Result:= toRemessaCancelarInstrucaoProtesto;       {Sustar protesto e manter na carteira}
    22 : Result:= toRemessaTransfCessaoCreditoIDProd10;     {Transfer�ncia Cess�o cr�dito ID. Prod.10}
    23 : Result:= toRemessaTransferenciaCarteira;           {Transfer�ncia entre Carteiras}
    24 : Result:= toRemessaDevTransferenciaCarteira;        {Dev. Transfer�ncia entre Carteiras}
    31 : Result:= toRemessaOutrasOcorrencias;               {Altera��o de Outros Dados}
    68 : Result:= toRemessaAcertarRateioCredito;            {Acerto nos dados do rateio de Cr�dito}
    69 : Result:= toRemessaCancelarRateioCredito;           {Cancelamento do rateio de cr�dito.}
  else
     Result:= toRemessaRegistrar;                           {Remessa}
  end;
end;


end.


