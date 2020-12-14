unit Myloo.Consts;

interface

Uses
   SysUtils;

var
  Fmtst: TFormatSettings;
  CurrencyString: string;
  CurrencyFormat: Byte;
  NegCurrFormat: Byte;
  ThousandSeparator: Char;
  DecimalSeparator: Char;
  CurrencyDecimals: Byte;
  DateSeparator: Char;
  ShortDateFormat: string;
  LongDateFormat: string;
  TimeSeparator: Char;
  TimeAMString: string;
  TimePMString: string;
  ShortTimeFormat: string;
  LongTimeFormat: string;
  TwoDigitYearCenturyWindow: Word = 50;
  ListSeparator: Char;

const
  VERSAO = '0.9.0a';
  NUL = #00 ;
  SOH = #01 ;
  STX = #02 ;
  ETX = #03 ;
  EOT = #04 ;
  ENQ = #05 ;
  ACK = #06 ;
  BELL= #07 ;
  BS  = #08 ;
  TAB = #09 ;
  LF  = #10 ;
  FF  = #12 ;
  CR  = #13 ;
  SO  = #14 ;
  SI  = #15 ;
  DLE = #16 ;
  WAK = #17 ;
  DC2 = #18 ;
  DC4 = #20 ;
  NAK = #21 ;
  SYN = #22 ;
  ESC = #27 ;
  FS  = #28 ;
  GS  = #29 ;
  CTRL_Z = #26 ;
  CRLF = CR + LF ;

  CUTF8CodPage = 65001;
  CUTF8BOM = #239+#187+#191;
  CUTF8DeclaracaoXML = '<?xml version="1.0" encoding="UTF-8"?>';

  cTimeout = 3 ;  { Tempo PADRAO para msg de Falha de comunicacao }

  cTagLigaExpandido         = '<e>';
  cTagDesligaExpandido      = '</e>';
  cTagLigaAlturaDupla       = '<a>';
  cTagDesligaAlturaDupla    = '</a>';
  cTagLigaNegrito           = '<n>';
  cTagDesligaNegrito        = '</n>';
  cTagLigaSublinhado        = '<s>';
  cTagDesligaSublinhado     = '</s>';
  cTagLigaCondensado        = '<c>';
  cTagDesligaCondensado     = '</c>';
  cTagLigaItalico           = '<i>';
  cTagDesligaItalico        = '</i>';
  cTagLigaInvertido         = '<in>';
  cTagDesligaInvertido      = '</in>';
  cTagFonteNormal           = '</fn>';
  cTagFonteA                = '</fa>';
  cTagFonteB                = '</fb>';
  cTagFonteAlinhadaDireita  = '</ad>';
  cTagFonteAlinhadaEsquerda = '</ae>';
  cTagfonteAlinhadaCentro   = '</ce>';

  cTAGS_CARACTER: array[0..12] of String = (
    cTagLigaExpandido, cTagDesligaExpandido,
    cTagLigaAlturaDupla, cTagDesligaAlturaDupla,
    cTagLigaNegrito, cTagDesligaNegrito,
    cTagLigaSublinhado, cTagDesligaSublinhado,
    cTagLigaCondensado, cTagDesligaCondensado,
    cTagLigaItalico, cTagDesligaItalico,
    cTagFonteNormal);
  cTAGS_CARACTER_HELP: array[0..12] of String = (
    'Liga Expandido', 'Desliga Expandido',
    'Liga Altura Dupla', 'Desliga Altura Dupla',
    'Liga Negrito', 'Desliga Negrito',
    'Liga Sublinhado', 'Desliga Sublinhado',
    'Liga Condensado', 'Desliga Condensado',
    'Liga Italico', 'Desliga Italico',
    'Fonte Normal');

  cTagLinhaSimples = '</linha_simples>';
  cTagLinhaDupla   = '</linha_dupla>';
  cTagPuloDeLinhas = '</pular_linhas>';

  cTAGS_LINHAS: array[0..2] of String = (
    cTagLinhaSimples, cTagLinhaDupla, cTagPuloDeLinhas);
  cTAGS_LINHAS_HELP: array[0..2] of String = (
    'Imprime Linha Simples', 'Imprime Linha Dupla',
    'Pula N Linhas de acordo com propriedade do componente');

  cTagLogotipo = '</logo>';
  cTagLogoImprimir = '<logo_imprimir>';
  cTagLogoKC1 = '<logo_kc1>';
  cTagLogoKC2 = '<logo_kc2>';
  cTagLogoFatorX = '<logo_fatorx>';
  cTagLogoFatorY = '<logo_fatory>';

  cTagCorteParcial = '</corte_parcial>';
  cTagCorteTotal = '</corte_total>';
  cTagAbreGaveta = '</abre_gaveta>';
  cTagAbreGavetaEsp = '<abre_gaveta>';
  cTagBeep = '</beep>';
  cTagZera = '</zera>';
  cTagReset = '</reset>';
  cTagPulodeLinha = '</lf>';
  cTagRetornoDeCarro = '</cr>';

  cTAGS_FUNCOES: array[0..8] of String = (
    cTagLogotipo, cTagCorteParcial, cTagCorteTotal, cTagAbreGaveta,
    cTagBeep, CTagZera, cTagPulodeLinha, cTagRetornoDeCarro, cTagReset);
  cTAGS_FUNCOES_HELP: array[0..8] of String = (
    'Imprime Logotipo j� gravado na Impressora (use utilit�rio do Fabricante)',
    'Efetua Corte Parcial no Papel (n�o disponivel em alguns modelos)',
    'Efetua Corte Total no papel',
    'Aciona a abertura da Gaveta de Dinheiro',
    'Emite um Beep na Impressora (n�o disponivel em alguns modelos)',
    'Reseta as configura��es de Fonte Alinhamento.<LF>Ajusta P�gina de C�digo e Espa�o entre Linhas',
    'Pula para a pr�pxima linha',
    'Retorna para o Inicio da Linha',
    'Reseta as configura��es de Fonte Alinhamento');

  cTagAlinhadoDireita = '<ad>';
  cTagAlinhadoEsquerda = '<ae>';
  cTagAlinhadoCentro = '<ce>';

  cTAGS_ALINHAMENTO: array[0..2] of String = (
    cTagAlinhadoDireita, cTagAlinhadoEsquerda, cTagAlinhadoCentro );
  cTAGS_ALINHAMENTO_HELP: array[0..2] of String = (
    'Texto Alinhado a Direita',
    'Texto Alinhado a Esquerda',
    'Texto Centralizado' );

  cTagBarraEAN8 = '<ean8>';
  cTagBarraEAN13 = '<ean13>';
  cTagBarraStd = '<std>';
  cTagBarraInter = '<inter>';
  cTagBarraCode11 = '<code11>';
  cTagBarraCode39 = '<code39>';
  cTagBarraCode93 = '<code93>';
  cTagBarraCode128 = '<code128>';
  cTagBarraCode128a = '<code128a>';
  cTagBarraCode128b = '<code128b>';
  cTagBarraCode128c = '<code128c>';
  cTagBarraUPCA = '<upca>';
  cTagBarraUPCE = '<upce>';
  cTagBarraCodaBar = '<codabar>';
  cTagBarraMSI = '<msi>';
  cTagBarraMostrar = '<barra_mostrar>';
  cTagBarraLargura = '<barra_largura>';
  cTagBarraAltura = '<barra_altura>';

  cTagQRCode = '<qrcode>';
  cTagQRCodeTipo = '<qrcode_tipo>';
  cTagQRCodeLargura = '<qrcode_largura>';
  cTagQRCodeError = '<qrcode_error>';

  cTagModoPaginaLiga       = '<mp>';
  cTagModoPaginaDesliga    = '</mp>';
  cTagModoPaginaImprimir   = '</mp_imprimir>';
  cTagModoPaginaDirecao    = '<mp_direcao>';
  cTagModoPaginaPosEsquerda= '<mp_esquerda>';
  cTagModoPaginaPosTopo    = '<mp_topo>';
  cTagModoPaginaLargura    = '<mp_largura>';
  cTagModoPaginaAltura     = '<mp_altura>';
  cTagModoPaginaEspaco     = '<mp_espaco>';
  cTagModoPaginaConfigurar = '</mp_configurar>';

  cTAGS_BARRAS: array[0..15] of String = (
    cTagBarraEAN8, cTagBarraEAN13, cTagBarraStd, cTagBarraInter, cTagBarraCode11,
    cTagBarraCode39, cTagBarraCode93, cTagBarraCode128,
	cTagBarraUPCA, cTagBarraUPCE,
    cTagBarraCodaBar, cTagBarraMSI,
    cTagBarraCode128a, cTagBarraCode128b, cTagBarraCode128c, cTagQRCode);
  cTAGS_BARRAS_HELP: array[0..15] of String = (
    'Cod.Barras EAN8 - 7 numeros e 1 dig.verificador',
    'Cod.Barras EAN13 - 12 numeros e 1 dig.verificador',
    'Cod.Barras "Standard 2 of 5" - apenas n�meros, tamanho livre',
    'Cod.Barras "Interleaved 2 of 5" - apenas n�meros, tamanho PAR',
    'Cod.Barras Code11 - apenas n�meros, tamanho livre',
    'Cod.Barras Code39 - Aceita: 0..9,A..Z, ,$,%,*,+,-,.,/, tamanho livre',
    'Cod.Barras Code93 - Aceita: 0..9,A..Z,-,., ,$,/,+,%, tamanho livre',
    'Cod.Barras Code128 - Todos os caracteres ASCII, tamanho livre',
    'Cod.Barras UPCA - 11 numeros e 1 dig.verificador',
    'Cod.Barras UPCE - 11 numeros e 1 dig.verificador',
    'Cod.Barras CodaBar - Aceita: 0..9,A..D,a..d,$,+,-,.,/,:, tamanho livre',
    'Cod.Barra MSI - Apenas n�meros, 1 d�gito verificador',
    'Cod.Barras Code128 - Subtipo A',
    'Cod.Barras Code128 - Subtipo B (padr�o) = '+cTagBarraCode128,
    'Cod.Barras Code128 - Subtipo C (informar valores em BCD)',
    'Cod.Barras QrCode'
    );

  cTagIgnorarTags = '<ignorar_tags>';

  cDeviceAtivarPortaException    = 'Porta n�o definida' ;
  cDeviceAtivarException         = 'Erro abrindo: %s ' + sLineBreak +' %s ' ;
  cDeviceAtivarPortaNaoEncontrada= 'Porta %s n�o encontrada' ;
  cDeviceAtivarPortaNaoAcessivel = 'Porta %s n�o acess�vel' ;
  cDeviceSetBaudException        = 'Valor deve estar na Faixa de 50 a 4000000.'+#10+
                                       'Normalmente os equipamentos Seriais utilizam: 9600' ;
  cDeviceSetDataException        = 'Valor deve estar na Faixa de 5 a 8.'+#10+
                                       'Normalmente os equipamentos Seriais utilizam: 7 ou 8' ;
  cDeviceSetPortaException       = 'N�o � poss�vel mudar a Porta com o Dispositivo Ativo' ;
  cDeviceSetTypeException        = 'Tipo de dispositivo informado n�o condiz com o valor da Porta';
  cDeviceSemImpressoraPadrao     = 'Erro Nenhuma impressora Padr�o Foi detectada';
  cDeviceImpressoraNaoEncontrada = 'Impressora n�o encontrada [%s]';
  cDeviceEnviaStrThreadException = 'Erro gravando em: %s ' ;
  cDeviceEnviaStrFailCount       = 'Erro ao enviar dados para a porta: %s';

  { constantes para exibi��o na inicializa��o e no sobre do delphi a partir da vers�o 2009 }
  cSobreDialogoTitulo = 'Projeto Myloo Framework';
  cSobreTitulo = 'Projeto Myloo Framework';
  cSobreDescricao = '#################################' + #13#10 +
                        '################################' + #13#10 +
                        'Lesser General Public License version 2.0';
  cSobreLicencaStatus = 'LGPLv2';

  {****                                  *}

  {* Unit ECFClass *}
  cTempoInicioMsg                  = 3 ;  { Tempo para iniciar a exibi�ao da mensagem Aguardando a Resposta da Impressora' }
  cMsgAguardando                   = 'Aguardando a resposta da Impressora: %d segundos' ;
  cMsgTrabalhando                  = 'Impressora est� trabalhando' ;
  cMsgPoucoPapel                   = 30 ; {Exibe alerta de Pouco Papel somente a cada 30 segundos}
  cMsgRelatorio                    = 'Imprimindo %s  %d� Via ' ;
  cPausaRelatorio                  = 5 ;
  cMsgPausaRelatorio               = 'Destaque a %d� via, <ENTER> proxima, %d seg.';
  cLinhasEntreCupons               = 7 ;
  cMaxLinhasBuffer                 = 0 ;
  cIntervaloAposComando            = 100 ; { Tempo em milisegundos a esperar apos o termino de EnviaComando }
  cECFAliquotaSetTipoException     = 'Valores v�lidos para TECFAliquota.Tipo: "T" - ICMS ou "S" - ISS' ;
  cECFConsumidorCPFCNPJException   = 'CPF/CNPJ N�o informado' ;
  cECFConsumidorNomeException      = 'Para informar o Endere�o � necess�rio informar o Nome' ;
  cECFClassCreateException         = 'Essa Classe deve ser instanciada por TECF' ;
  cECFNaoInicializadoException     = 'Componente ECF n�o est� Ativo' ;
  cECFOcupadoException             = 'Componente ECF ocupado' + sLineBreak +
                                         'Aguardando resposta do comando anterior' ;
  cECFSemRespostaException         = 'Impressora %s n�o est� respondendo' ;
  cECFSemPapelException            = 'FIM DE PAPEL' ;
  cECFCmdSemRespostaException      = 'Comandos n�o est�o sendo enviados para Impressora %s ' ;
  cECFEnviaCmdSemRespostaException = 'Erro ao enviar comandos para a Impressora %s ' ;
  cECFDoOnMsgSemRespostaRetentar   = 'A impressora %s n�o est� repondendo.' ;
  cECFVerificaFimLeituraException  = 'Erro Function VerificaFimLeitura n�o implementada em %s ' ;
  cECFVerificaEmLinhaMsgRetentar   = 'A impressora %s n�o est� pronta.' ;
  cECFVerificaEmLinhaException     = 'Impressora %s n�o est� em linha' ;
  cECFPodeAbrirCupomRequerX        = 'A impressora %s requer Leitura X todo inicio de dia.'+#10+
                                         ' Imprima uma Leitura X para poder vender' ;
  cECFPodeAbrirCupomRequerZ        = 'Redu��o Z de dia anterior n�o emitida.'+#10+
                                         ' Imprima uma Redu��o Z para poder vender' ;
  cECFPodeAbrirCupomBloqueada      = 'Redu�ao Z de hoje j� emitida, ECF bloqueado at� as 00:00' ;
  cECFPodeAbrirCupomCFAberto       = 'Cupom Fiscal aberto' ;
  cECFPodeAbrirCupomNaoAtivada     = 'Impressora nao Foi Inicializada (Ativo = False)' ;
  cECFPodeAbrirCupomEstado         = 'Estado da impressora %s  � '+sLineBreak+' %s (n�o � Livre) ' ;
  cECFAbreGavetaException          = 'A Impressora %s n�o manipula Gavetas' ;
  cECFImpactoAgulhasException      = 'A Impressora %s n�o permite ajustar o Impacto das Agulhas' ;
  cECFImprimeChequeException       = 'Rotina de Impress�o de Cheques n�o implementada para '+
                                         'Impressora %s ';
  cECFLeituraCMC7Exception         = 'Rotina de Leitura de CMC7 de Cheques n�o implementada para '+
                                         'Impressora %s ';
  cECFAchaCNFException             = 'N�o existe nenhum Comprovante N�o Fiscal '+
                                        'cadastrado como: "%s" ' ;
  cECFAchaFPGException             = 'N�o existe nenhuma Forma de Pagamento '+
                                         'cadastrada como: "%s" ' ;
  cECFCMDInvalidoException         = 'Procedure: %s '+ sLineBreak +
                                         ' n�o implementada para a Impressora: %s'+sLineBreak + sLineBreak +
                                         'Ajude no desenvolvimento do ECF. '+ sLineBreak+
                                         'Acesse nosso Forum em: http://' ;
  cECFDoOnMsgPoucoPapel            = 'Detectado pouco papel' ;
  cECFDoOnMsgRetentar              = 'Deseja tentar novamente ?' ;
  cECFAchaICMSAliquotaInvalida     = 'Aliquota inv�lida: ' ;
  cECFAchaICMSCMDInvalido          = 'Aliquota n�o encontrada: ' ;
  cECFAbrindoRelatorioGerencial    = 'Abrindo Relat�rio Gerencial, aguarde %d seg' ;
  cECFFechandoRelatorioGerencial   = 'Fechando Relat�rio Gerencial' ;
  cECFFormMsgDoProcedureException  = 'Erro. Chamada recurssiva de FormMsgDoProcedure' ;


  {* Unit ECF *}
  cECFSetModeloException             = 'N�o � poss�vel mudar o Modelo com o ECF Ativo' ;
  cECFModeloNaoDefinidoException     = 'Modelo n�o definido' ;
  cECFModeloBuscaPortaException      = 'Modelo: %s n�o consegue efetuar busca autom�tica de Porta'+sLineBreak+
                                           'Favor definir a Porta Ex: (COM1, LPT1, /dev/lp0, etc)' ;
  cECFMsgDoAcharPorta                = 'Procurando por ECF: %s na porta: %s ' ;
  cECFSetDecimaisPrecoException      = 'Valor de DecimaisPreco deve estar entre 0-3' ;
  cECFSetDecimaisQtdException        = 'Valor de DecimaisQtd deve estar entre 0-4' ;
  cECFVendeItemQtdeException         = 'Quantidade deve ser superior a 0.' ;
  cECFVendeItemValorUnitException    = 'Valor Unitario deve ser superior a 0.' ;
  cECFVendeItemValDescAcreException  = 'ValorDescontoAcrescimo deve ser positivo' ;
  cECFVendeItemDescAcreException     = 'DescontoAcrescimo deve ser "A"-Acrescimo, ou "D"-Desconto' ;
  cECFVendeItemTipoDescAcreException = 'TipoDescontoAcrescimo deve ser "%"-Porcentagem, ou "$"-Valor' ;
  cECFVendeItemAliqICMSException     = 'Aliquota de ICMS n�o pode ser vazia.' ;
  cECFAchaFPGIndiceException         = 'Forma de Pagamento: %s inv�lida' ;
  cECFFPGPermiteVinculadoException   = 'Forma de Pagamento: %s '+#10+
                                           'n�o permite Cupom Vinculado' ;
  cECFPAFFuncaoNaoSuportada          = 'Fun��o n�o suportada pelo modelo de ECF utilizado';
  cECFRegistraItemNaoFiscalException = 'Comprovante n�o Fiscal: %s inv�lido' ;
  cECFSetRFDException                = 'N�o � poss�vel mudar ECF.RFD com o componente ativo' ;
  cECFSetAACException                = 'N�o � poss�vel mudar ECF.AAC com o componente ativo' ;
  cECFVirtualClassCreateException    = 'Essa Classe deve ser instanciada por TECFVirtual' ;
  cECFSetECFVirtualException         = 'N�o � poss�vel mudar ECF.ECFVirtual com o componente ativo' ;
  cECFSemECFVirtualException         = 'ECF.ECFVirtual n�o Foi atribuido' ;

  cAACNumSerieNaoEncontardoException = 'ECF de N�mero de s�rie %s n�o encontrado no Arquivo Auxiliar Criptografado.' ;
  cAACValorGTInvalidoException       = 'Diverg�ncia no Valor do Grande Total.';

  cDFeSSLEnviarException = 'Erro Interno: %d'+sLineBreak+'Erro HTTP: %d'+sLineBreak+
                               'URL: %s';

  sDisplayFormat = ',#0.%.*d';

implementation

initialization
    Fmtst := TFormatSettings.Create('');
    CurrencyString := Fmtst.CurrencyString;
    CurrencyFormat := Fmtst.CurrencyFormat;
    NegCurrFormat := Fmtst.NegCurrFormat;
    ThousandSeparator := Fmtst.ThousandSeparator;
    DecimalSeparator := Fmtst.DecimalSeparator;
    CurrencyDecimals := Fmtst.CurrencyDecimals;
    DateSeparator := Fmtst.DateSeparator;
    ShortDateFormat := Fmtst.ShortDateFormat;
    LongDateFormat := Fmtst.LongDateFormat;
    TimeSeparator := Fmtst.TimeSeparator;
    TimeAMString := Fmtst.TimeAMString;
    TimePMString := Fmtst.TimePMString;
    ShortTimeFormat := Fmtst.ShortTimeFormat;
    LongTimeFormat := Fmtst.LongTimeFormat;
    TwoDigitYearCenturyWindow := Fmtst.TwoDigitYearCenturyWindow;
    ListSeparator := Fmtst.ListSeparator;

end.
