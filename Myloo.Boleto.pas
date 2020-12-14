unit Myloo.Boleto;

interface
uses
  Classes,
  Graphics,
  Contnrs,
  IniFiles,
  SysUtils,
  typinfo,
  Rtti,
  Myloo.Mail,
  Myloo.Boleto.Utils,
  Myloo.Validador;

const
  cBoleto_Versao = '0.0.247';
  CInstrucaoPagamento = 'Pagar preferencialmente nas agencias do %s';
  CInstrucaoPagamentoLoterica = 'Preferencialmente nas Casas Lotéricas até o valor limite';
  CCedente = 'CEDENTE';
  CBanco = 'BANCO';
  CConta = 'CONTA';
  CTitulo = 'TITULO';

  cTipoOcorrenciaDecricao: array[0..281] of String = (
    'Remessa Registrar',
    'Remessa Baixar',
    'Remessa Debitar Em Conta',
    'Remessa Conceder Abatimento',
    'Remessa Cancelar Abatimento',
    'Remessa Conceder Desconto',
    'Remessa Cancelar Desconto',
    'Remessa Alterar Vencimento',
    'Remessa Alterar Vencimento Sustar Protesto',
    'Remessa Protestar',
    'Remessa Sustar Protesto',
    'Remessa Cancelar Instrucao Protesto Baixa',
    'Remessa Cancelar Instrucao Protesto',
    'Remessa Dispensar Juros',
    'Remessa Alterar Nome Endereco Sacado',
    'Remessa Alterar Numero Controle',
    'Remessa Outras Ocorrencias',
    'Remessa Alterar Controle Participante',
    'Remessa Alterar SeuNumero',
    'Remessa Transf Cessao Credito ID Prod10',
    'Remessa Transferencia Carteira',
    'Remessa Dev Transferencia Carteira',
    'Remessa Desagendar Debito Automatico',
    'Remessa Acertar Rateio Credito',
    'Remessa Cancelar Rateio Credito',
    'Remessa Alterar Uso Empresa',
    'Remessa Nao Protestar',
    'Remessa Protesto Fins Falimentares',
    'Remessa Baixa Por Pagto Direto Cedente',
    'Remessa Cancelar Instrucao',
    'Remessa Alterar Venc Sustar Protesto',
    'Remessa Cedente Discorda Sacado',
    'Remessa Cedente Solicita Dispensa Juros',
    'Remessa Outras Alteracoes',
    'Remessa Alterar Modalidade',
    'Remessa Alterar Exclusivo Cliente',
    'Remessa Nao Cobrar Juros Mora',
    'Remessa Cobrar Juros Mora',
    'Remessa Alterar Valor Titulo',
    'Remessa Excluir Sacador Avalista',
    'Remessa Alterar Numero Dias Protesto',
    'Remessa Alterar Prazo Protesto',
    'Remessa Alterar Prazo Devolucao',
    'Remessa Alterar Outros Dados',
    'Remessa Alterar Dados Emissao Bloqueto',
    'Remessa Alterar Protesto Devolucao',
    'Remessa Alterar Devolucao Protesto',
    'Remessa Negativacao Serasa',
    'Remessa Excluir Negativacao Serasa',
    'Remessa Alterar Juros e Mora',
    'Remessa Alterar Valor/Percentual Multa',
    'Remessa Dispensar Cobrança de Multa',
    'Remessa Alterar Valor/Data de Desconto',
    'Remessa Não Conceder Desconto',
    'Remessa Alterar Valor de Abatimento',
    'Remessa Alterar Prazo Limite de Recebimento',
    'Remessa Dispensar Prazo Limite de Recebimento',
    'Remessa Alterar número do título do Beneficiário',
    'Remessa Alterar Dados Pagador',
    'Remessa Alterar dados Sacador/Avalista',
    'Remessa Recusa Alegação do Pagador',
    'Remessa Alterar Dados Rateio de Crédito',
    'Remessa Pedido de Cancelamento Dados do Rateio de Crédito',
    'Remessa Pedido de Desagendamento do Débito Automático',
    'Remessa Alterar Espécie de Título',
    'Remessa Contrato de Cobrança',
    'Remessa Negativação Sem Protesto',
    'Remessa Baixa Título Negativado Sem Protesto',
    'Remessa Alterar Valor Mínimo', 
    'Remessa Alterar Valor Máximo',
    'Retorno Abatimento Cancelado',
    'Retorno Abatimento Concedido',
    'Retorno Acerto Controle Participante',
    'Retorno Acerto Dados Rateio Credito',
    'Retorno Acerto Depositaria',
    'Retorno Aguardando Autorizacao Protesto Edital',
    'Retorno Alegacao DoSacado',
    'Retorno Alteracao Dados Baixa',
    'Retorno Alteracao Dados Nova Entrada',
    'Retorno Alteracao Dados Rejeitados',
    'Retorno Alteracao Data Emissao',
    'Retorno Alteracao Especie',
    'Retorno Alteracao Instrucao',
    'Retorno Alteracao Opcao Devolucao Para Protesto Confirmada',
    'Retorno Alteracao Opcao Protesto Para Devolucao Confirmada',
    'Retorno Alteracao Outros Dados Rejeitada',
    'Retorno Alteracao Reemissao Bloqueto Confirmada',
    'Retorno Alteracao Seu Numero',
    'Retorno Alteracao Uso Cedente',
    'Retorno Alterar Data Desconto',
    'Retorno Alterar Prazo Limite Recebimento',
    'Retorno Alterar Sacador Avalista',
    'Retorno Baixa Automatica',
    'Retorno Baixa Credito CC Atraves Sispag',
    'Retorno Baixa Credito CC Atraves Sispag Sem Titulo Corresp',
    'Retorno Baixado',
    'Retorno Baixado FrancoPagamento',
    'Retorno Baixado InstAgencia',
    'Retorno Baixado Por Devolucao',
    'Retorno Baixado Via Arquivo',
    'Retorno Baixa Liquidado Edital',
    'Retorno Baixa Manual Confirmada',
    'Retorno Baixa Ou Liquidacao Estornada',
    'Retorno Baixa Por Protesto',
    'Retorno Baixa Por Ter Sido Liquidado',
    'Retorno Baixa Rejeitada',
    'Retorno Baixa Simples',
    'Retorno Baixa Solicitada',
    'Retorno Baixa Titulo Negativado Sem Protesto',
    'Retorno Baixa Transferencia Para Desconto',
    'Retorno Cancelamento Dados Rateio',
    'Retorno Cheque Compensado',
    'Retorno Cheque Devolvido',
    'Retorno Cheque Pendente Compensacao',
    'Retorno Cobranca Contratual',
    'Retorno Cobranca Creditar',
    'Retorno Comando Recusado',
    'Retorno Conf Cancelamento Negativacao Expressa Tarifa',
    'Retorno Conf Entrada Negativacao Expressa Tarifa',
    'Retorno Conf Exclusao Entrada Negativacao Expressa Por Liquidacao Tarifa',
    'Retorno Conf Instrucao Transferencia Carteira Modalidade Cobranca',
    'Retorno Confirmacao Alteracao Banco Sacado',
    'Retorno Confirmacao Alteracao Juros Mora',
    'Retorno Confirmacao Email SMS',
    'Retorno Confirmacao Entrada Cobranca Simples',
    'Retorno Confirmacao Exclusao Banco Sacado',
    'Retorno Confirmacao Inclusao Banco Sacado',
    'Retorno Confirmacao Pedido Excl Negativacao',
    'Retorno Confirmacao Receb Pedido Negativacao',
    'Retorno Confirma Recebimento Instrucao NaoNegativar',
    'Retorno Conf Recebimento Inst Cancelamento Negativacao Expressa',
    'Retorno Conf Recebimento Inst Entrada Negativacao Expressa',
    'Retorno Conf Recebimento Inst Exclusao Entrada Negativacao Expressa',
    'Retorno Custas Cartorio',
    'Retorno Custas Cartorio Distribuidor',
    'Retorno Custas Edital',
    'Retorno Custas Irregularidade',
    'Retorno Custas Protesto',
    'Retorno Custas Sustacao',
    'Retorno Custas Sustacao Judicial',
    'Retorno Dados Alterados',
    'Retorno Debito Custas Antecipadas',
    'Retorno Debito Direto Autorizado',
    'Retorno Debito Direto NaoAutorizado',
    'Retorno Debito Em Conta',
    'Retorno Debito Mensal Tarifa Aviso Movimentacao Titulos',
    'Retorno Debito Mensal Tarifas Extrado Posicao',
    'Retorno Debito Mensal Tarifas Manutencao Titulos Vencidos',
    'Retorno Debito Mensal Tarifas Outras Instrucoes',
    'Retorno Debito Mensal Tarifas Outras Ocorrencias',
    'Retorno Debito Mensal Tarifas Protestos',
    'Retorno Debito Mensal Tarifas SustacaoProtestos',
    'Retorno Debito Tarifas',
    'Retorno Desagendamento Debito Automatico',
    'Retorno Desconto Cancelado',
    'Retorno Desconto Concedido',
    'Retorno Desconto Retificado',
    'Retorno Despesa Cartorio',
    'Retorno Despesas Protesto',
    'Retorno Despesas Sustacao Protesto',
    'Retorno Devolvido Pelo Cartorio',
    'Retorno Dispensar Indexador',
    'Retorno Dispensar Prazo Limite Recebimento',
    'Retorno Email SMS Rejeitado',
    'Retorno Emissao Bloqueto Banco Sacado',
    'Retorno Encaminhado A Cartorio',
    'Retorno Endereco Sacado Alterado',
    'Retorno Entrada Bordero Manual',
    'Retorno Entrada Confirmada Rateio Credito',
    'Retorno Entrada Em Cartorio',
    'Retorno Entrada Registrada Aguardando Avaliacao',
    'Retorno Entrada Rejeita CEP Irregular',
    'Retorno Entrada Rejeitada Carne',
    'Retorno Entrada Titulo Banco Sacado Rejeitada',
    'Retorno Equalizacao Vendor',
    'Retorno Estorno Baixa Liquidacao',
    'Retorno Estorno Pagamento',
    'Retorno Estorno Protesto',
    'Retorno Instrucao Cancelada',
    'Retorno Instrucao Negativacao Expressa Rejeitada',
    'Retorno Instrucao Protesto Rejeitada Sustada Ou Pendente',
    'Retorno Instrucao Rejeitada',
    'Retorno IOF Invalido',
    'Retorno Juros Dispensados',
    'Retorno Liquidado',
    'Retorno Liquidado Apos Baixa Ou Nao Registro',
    'Retorno Liquidado Em Cartorio',
    'Retorno Liquidado Parcialmente',
    'Retorno Liquidado PorConta',
    'Retorno Liquidado Saldo Restante',
    'Retorno Liquidado Sem Registro',
    'Retorno Manutencao Banco Sacado Rejeitada',
    'Retorno Manutencao Sacado Rejeitada',
    'Retorno Manutencao Titulo Vencido',
    'Retorno Negativacao Expressa Informacional',
    'Retorno Nome Sacado Alterado',
    'Retorno Ocorrencias Do Sacado',
    'Retorno Outras Ocorrencias',
    'Retorno Outras Tarifas Alteracao',
    'Retorno Pagador DDA',
    'Retorno Prazo Devolucao Alterado',
    'Retorno Prazo Protesto Alterado',
    'Retorno Protestado',
    'Retorno Protesto Imediato Falencia',
    'Retorno Protesto Ou Sustacao Estornado',
    'Retorno Protesto Sustado',
    'Retorno Recebimento Instrucao Alterar Dados',
    'Retorno Recebimento Instrucao Alterar EnderecoSacado',
    'Retorno Recebimento Instrucao Alterar Juros',
    'Retorno Recebimento Instrucao Alterar NomeSacado',
    'Retorno Recebimento Instrucao Alterar Tipo Cobranca',
    'Retorno Recebimento Instrucao Alterar Valor Titulo',
    'Retorno Recebimento Instrucao Alterar Vencimento',
    'Retorno Recebimento Instrucao Baixar',
    'Retorno Recebimento Instrucao Cancelar Abatimento',
    'Retorno Recebimento Instrucao Cancelar Desconto',
    'Retorno Recebimento Instrucao Conceder Abatimento',
    'Retorno Recebimento Instrucao Conceder Desconto',
    'Retorno Recebimento Instrucao Dispensar Juros',
    'Retorno Recebimento Instrucao Nao Protestar',
    'Retorno Recebimento Instrucao Protestar',
    'Retorno Recebimento Instrucao Sustar Protesto',
    'Retorno Reembolso Devolucao Desconto Vendor',
    'Retorno Reembolso Nao Efetuado',
    'Retorno Reembolso Transferencia Desconto Vendor',
    'Retorno Registro Confirmado',
    'Retorno Registro Recusado',
    'Retorno Relacao De Titulos',
    'Retorno Remessa Rejeitada',
    'Retorno Reservado',
    'Retorno Retirado De Cartorio',
    'Retorno Segunda Via Instrumento Protesto',
    'Retorno Segunda Via Instrumento Protesto Cartorio',
    'Retorno Solicitacao Impressao Titulo Confirmada',
    'Retorno Sustacao Envio Cartorio',
    'Retorno Sustado Judicial',
    'Retorno Tarifa Aviso Cobranca',
    'Retorno Tarifa De Manutencao De Titulos Vencidos',
    'Retorno Tarifa De Relacao Das Liquidacoes',
    'Retorno Tarifa Email Cobranca Ativa Eletronica',
    'Retorno Tarifa Emissao Aviso Movimentacao Titulos',
    'Retorno Tarifa Emissao Boleto Envio Duplicata',
    'Retorno Tarifa Extrato Posicao',
    'Retorno Tarifa Instrucao',
    'Retorno Tarifa Mensal Baixas Bancos Corresp Carteira',
    'Retorno Tarifa Mensal Baixas Carteira',
    'Retorno Tarifa Mensal Cancelamento Negativacao Expressa',
    'Retorno Tarifa Mensal Email Cobranca AtivaEletronica',
    'Retorno Tarifa Mensal Emissao Boleto Envio Duplicata',
    'Retorno Tarifa Mensal Exclusao Entrada Negativacao Expressa',
    'Retorno Tarifa Mensal Exclusao Negativacao Expressa Por Liquidacao',
    'Retorno Tarifa Mensal Liquidacoes Bancos Corresp Carteira',
    'Retorno Tarifa Mensal Liquidacoes Carteira',
    'Retorno Tarifa Mensal Por Boleto Ate 03 Envio Cobranca Ativa Eletronica',
    'Retorno Tarifa Mensal Ref Entradas Bancos Corresp Carteira',
    'Retorno Tarifa Mensal SMS Cobranca Ativa Eletronica',
    'Retorno Tarifa Ocorrencias',
    'Retorno Tarifa Por Boleto Ate 03 Envio Cobranca Ativa Eletronica',
    'Retorno Tarifa SMS Cobranca Ativa Eletronica',
    'Retorno Tipo Cobranca Alterado',
    'Retorno Titulo DDA Nao Reconhecido Pagador',
    'Retorno Titulo DDA Reconhecido Pagador',
    'Retorno Titulo DDA Recusado CIP',
    'Retorno Titulo Em Ser',
    'Retorno Titulo Ja Baixado',
    'Retorno Titulo Nao Existe',
    'Retorno Titulo Pagamento Cancelado',
    'Retorno Titulo Pago Em Cheque',
    'Retorno Titulo Sustado Judicialmente',
    'Retorno Transferencia Carteira',
    'Retorno Transferencia Carteira Baixa',
    'Retorno Transferencia Carteira Entrada',
    'Retorno Transferencia Cedente',
    'Retorno Transito Pago Cartorio',
    'Retorno Vencimento Alterado',
    'Retorno Rejeicao Sacado',
    'Retorno Aceite Sacado',
    'Retorno Liquidado On Line',
    'Retorno Estorno Liquidacao OnLine',
    'Retorno Confirmacao Alteracao Valor Nominal',
    'Retorno Confirmacao Alteracao Valor Percentual Minimo Maximo',
    'Tipo Ocorrencia Nenhum'
);

type
  TTipoCobranca =
   (cobNenhum,
    cobBancoDoBrasil,
    cobSantander,
    cobCaixaEconomica,
    cobCaixaSicob,
    cobBradesco,
    cobItau,
    cobBancoMercantil,
    cobSicred,
    cobBancoob,
    cobBanrisul,
    cobBanestes,
    cobHSBC,
    cobBancoDoNordeste,
    cobBRB,
    cobBicBanco,
    cobBradescoSICOOB,
    cobBancoSafra,
    cobSafraBradesco,
    cobBancoCECRED,
    cobBancoDaAmazonia,
    cobBancoDoBrasilSICOOB,
    cobUniprime,
    cobUnicredRS,
    cobBanese,
    cobCrediSIS,
    cobUnicredES
    );

  TTitulo = class;
  TBoletoFCClass = class;
  TCedente = class;
  TBanco  = class;
  TBoleto = class;

  TTipoDesconto = (tdNaoConcederDesconto, tdValorFixoAteDataInformada, tdPercentualAteDataInformada, tdValorAntecipacaoDiaCorrido, tdValorAntecipacaoDiaUtil, tdPercentualSobreValorNominalDiaCorrido, tdPercentualSobreValorNominalDiaUtil, tdCancelamentoDesconto);

  TLayoutRemessa = (c400, c240);

  {Tipos de ocorrências permitidas no arquivos remessa / retorno}
  TTipoOcorrencia =
  (
    {Ocorrências para arquivo remessa}
    toRemessaRegistrar,
    toRemessaBaixar,
    toRemessaDebitarEmConta,
    toRemessaConcederAbatimento,
    toRemessaCancelarAbatimento,
    toRemessaConcederDesconto,
    toRemessaCancelarDesconto,
    toRemessaAlterarVencimento,
    toRemessaAlterarVencimentoSustarProtesto,
    toRemessaProtestar,
    toRemessaSustarProtesto,
    toRemessaCancelarInstrucaoProtestoBaixa,
    toRemessaCancelarInstrucaoProtesto,
    toRemessaDispensarJuros,
    toRemessaAlterarNomeEnderecoSacado,
    toRemessaAlterarNumeroControle,
    toRemessaOutrasOcorrencias,
    toRemessaAlterarControleParticipante,
    toRemessaAlterarSeuNumero,
    toRemessaTransfCessaoCreditoIDProd10,
    toRemessaTransferenciaCarteira,
    toRemessaDevTransferenciaCarteira,
    toRemessaDesagendarDebitoAutomatico,
    toRemessaAcertarRateioCredito,
    toRemessaCancelarRateioCredito,
    toRemessaAlterarUsoEmpresa,
    toRemessaNaoProtestar,
    toRemessaProtestoFinsFalimentares,
    toRemessaBaixaporPagtoDiretoCedente,
    toRemessaCancelarInstrucao,
    toRemessaAlterarVencSustarProtesto,
    toRemessaCedenteDiscordaSacado,
    toRemessaCedenteSolicitaDispensaJuros,
    toRemessaOutrasAlteracoes,
    toRemessaAlterarModalidade,
    toRemessaAlterarExclusivoCliente,
    toRemessaNaoCobrarJurosMora,
    toRemessaCobrarJurosMora,
    toRemessaAlterarValorTitulo,
    toRemessaExcluirSacadorAvalista,
    toRemessaAlterarNumeroDiasProtesto,
    toRemessaAlterarPrazoProtesto,
    toRemessaAlterarPrazoDevolucao,
    toRemessaAlterarOutrosDados,
    toRemessaAlterarDadosEmissaoBloqueto,
    toRemessaAlterarProtestoDevolucao,
    toRemessaAlterarDevolucaoProtesto,
    toRemessaNegativacaoSerasa,
    toRemessaExcluirNegativacaoSerasa,
    toRemessaAlterarJurosMora,
    toRemessaAlterarMulta,
    toRemessaDispensarMulta,
    toRemessaAlterarDesconto,
    toRemessaNaoConcederDesconto,
    toRemessaAlterarValorAbatimento,
    toRemessaAlterarPrazoLimiteRecebimento,
    toRemessaDispensarPrazoLimiteRecebimento,
    toRemessaAlterarNumeroTituloBeneficiario,
    toRemessaAlterarDadosPagador,
    toRemessaAlterarDadosSacadorAvalista,
    toRemessaRecusaAlegacaoPagador,
    toRemessaAlterarDadosRateioCredito,
    toRemessaPedidoCancelamentoDadosRateioCredito,
    toRemessaPedidoDesagendamentoDebietoAutom,
    toRemessaAlterarEspecieTitulo,
    toRemessaAlterarContratoCobran,
    toRemessaNegativacaoSemProtesto,
    toRemessaBaixaTituloNegativadoSemProtesto,
    toRemessaAlterarValorMinimo,
    toRemessaAlterarValorMaximo,
    {Ocorrências para arquivo retorno}
    toRetornoAbatimentoCancelado,
    toRetornoAbatimentoConcedido,
    toRetornoAcertoControleParticipante,
    toRetornoAcertoDadosRateioCredito,
    toRetornoAcertoDepositaria,
    toRetornoAguardandoAutorizacaoProtestoEdital,
    toRetornoAlegacaoDoSacado,
    toRetornoAlteracaoDadosBaixa,
    toRetornoAlteracaoDadosNovaEntrada,
    toRetornoAlteracaoDadosRejeitados,
    toRetornoAlteracaoDataEmissao,
    toRetornoAlteracaoEspecie,
    toRetornoAlteracaoInstrucao,
    toRetornoAlteracaoOpcaoDevolucaoParaProtestoConfirmada,
    toRetornoAlteracaoOpcaoProtestoParaDevolucaoConfirmada,
    toRetornoAlteracaoOutrosDadosRejeitada,
    toRetornoAlteracaoReemissaoBloquetoConfirmada,
    toRetornoAlteracaoSeuNumero,
    toRetornoAlteracaoUsoCedente,
    toRetornoAlterarDataDesconto,
    toRetornoAlterarPrazoLimiteRecebimento,
    toRetornoAlterarSacadorAvalista,
    toRetornoBaixaAutomatica,
    toRetornoBaixaCreditoCCAtravesSispag,
    toRetornoBaixaCreditoCCAtravesSispagSemTituloCorresp,
    toRetornoBaixado,
    toRetornoBaixadoFrancoPagamento,
    toRetornoBaixadoInstAgencia,
    toRetornoBaixadoPorDevolucao,
    toRetornoBaixadoViaArquivo,
    toRetornoBaixaLiquidadoEdital,
    toRetornoBaixaManualConfirmada,
    toRetornoBaixaOuLiquidacaoEstornada,
    toRetornoBaixaPorProtesto,
    toRetornoBaixaPorTerSidoLiquidado,
    toRetornoBaixaRejeitada,
    toRetornoBaixaSimples,
    toRetornoBaixaSolicitada,
    toRetornoBaixaTituloNegativadoSemProtesto,
    toRetornoBaixaTransferenciaParaDesconto,
    toRetornoCancelamentoDadosRateio,
    toRetornoChequeCompensado,
    toRetornoChequeDevolvido,
    toRetornoChequePendenteCompensacao,
    toRetornoCobrancaContratual,
    toRetornoCobrancaCreditar,
    toRetornoComandoRecusado,
    toRetornoConfCancelamentoNegativacaoExpressaTarifa,
    toRetornoConfEntradaNegativacaoExpressaTarifa,
    toRetornoConfExclusaoEntradaNegativacaoExpressaPorLiquidacaoTarifa,
    toRetornoConfInstrucaoTransferenciaCarteiraModalidadeCobranca,
    toRetornoConfirmacaoAlteracaoBancoSacado,
    toRetornoConfirmacaoAlteracaoJurosMora,
    toRetornoConfirmacaoEmailSMS,
    toRetornoConfirmacaoEntradaCobrancaSimples,
    toRetornoConfirmacaoExclusaoBancoSacado,
    toRetornoConfirmacaoInclusaoBancoSacado,
    toRetornoConfirmacaoPedidoExclNegativacao,
    toRetornoConfirmacaoRecebPedidoNegativacao,
    toRetornoConfirmaRecebimentoInstrucaoNaoNegativar,
    toRetornoConfRecebimentoInstCancelamentoNegativacaoExpressa,
    toRetornoConfRecebimentoInstEntradaNegativacaoExpressa,
    toRetornoConfRecebimentoInstExclusaoEntradaNegativacaoExpressa,
    toRetornoCustasCartorio,
    toRetornoCustasCartorioDistribuidor,
    toRetornoCustasEdital,
    toRetornoCustasIrregularidade,
    toRetornoCustasProtesto,
    toRetornoCustasSustacao,
    toRetornoCustasSustacaoJudicial,
    toRetornoDadosAlterados,
    toRetornoDebitoCustasAntecipadas,
    toRetornoDebitoDiretoAutorizado,
    toRetornoDebitoDiretoNaoAutorizado,
    toRetornoDebitoEmConta,
    toRetornoDebitoMensalTarifaAvisoMovimentacaoTitulos,
    toRetornoDebitoMensalTarifasExtradoPosicao,
    toRetornoDebitoMensalTarifasManutencaoTitulosVencidos,
    toRetornoDebitoMensalTarifasOutrasInstrucoes,
    toRetornoDebitoMensalTarifasOutrasOcorrencias,
    toRetornoDebitoMensalTarifasProtestos,
    toRetornoDebitoMensalTarifasSustacaoProtestos,
    toRetornoDebitoTarifas,
    toRetornoDesagendamentoDebitoAutomatico,
    toRetornoDescontoCancelado,
    toRetornoDescontoConcedido,
    toRetornoDescontoRetificado,
    toRetornoDespesaCartorio,
    toRetornoDespesasProtesto,
    toRetornoDespesasSustacaoProtesto,
    toRetornoDevolvidoPeloCartorio,
    toRetornoDispensarIndexador,
    toRetornoDispensarPrazoLimiteRecebimento,
    toRetornoEmailSMSRejeitado,
    toRetornoEmissaoBloquetoBancoSacado,
    toRetornoEncaminhadoACartorio,
    toRetornoEnderecoSacadoAlterado,
    toRetornoEntradaBorderoManual,
    toRetornoEntradaConfirmadaRateioCredito,
    toRetornoEntradaEmCartorio,
    toRetornoEntradaRegistradaAguardandoAvaliacao,
    toRetornoEntradaRejeitaCEPIrregular,
    toRetornoEntradaRejeitadaCarne,
    toRetornoEntradaTituloBancoSacadoRejeitada,
    toRetornoEqualizacaoVendor,
    toRetornoEstornoBaixaLiquidacao,
    toRetornoEstornoPagamento,
    toRetornoEstornoProtesto,
    toRetornoInstrucaoCancelada,
    toRetornoInstrucaoNegativacaoExpressaRejeitada,
    toRetornoInstrucaoProtestoRejeitadaSustadaOuPendente,
    toRetornoInstrucaoRejeitada,
    toRetornoIOFInvalido,
    toRetornoJurosDispensados,
    toRetornoLiquidado,
    toRetornoLiquidadoAposBaixaOuNaoRegistro,
    toRetornoLiquidadoEmCartorio,
    toRetornoLiquidadoParcialmente,
    toRetornoLiquidadoPorConta,
    toRetornoLiquidadoSaldoRestante,
    toRetornoLiquidadoSemRegistro,
    toRetornoManutencaoBancoSacadoRejeitada,
    toRetornoManutencaoSacadoRejeitada,
    toRetornoManutencaoTituloVencido,
    toRetornoNegativacaoExpressaInformacional,
    toRetornoNomeSacadoAlterado,
    toRetornoOcorrenciasDoSacado,
    toRetornoOutrasOcorrencias,
    toRetornoOutrasTarifasAlteracao,
    toRetornoPagadorDDA,
    toRetornoPrazoDevolucaoAlterado,
    toRetornoPrazoProtestoAlterado,
    toRetornoProtestado,
    toRetornoProtestoImediatoFalencia,
    toRetornoProtestoOuSustacaoEstornado,
    toRetornoProtestoSustado,
    toRetornoRecebimentoInstrucaoAlterarDados,
    toRetornoRecebimentoInstrucaoAlterarEnderecoSacado,
    toRetornoRecebimentoInstrucaoAlterarJuros,
    toRetornoRecebimentoInstrucaoAlterarNomeSacado,
    toRetornoRecebimentoInstrucaoAlterarTipoCobranca,
    toRetornoRecebimentoInstrucaoAlterarValorTitulo,
    toRetornoRecebimentoInstrucaoAlterarVencimento,
    toRetornoRecebimentoInstrucaoBaixar,
    toRetornoRecebimentoInstrucaoCancelarAbatimento,
    toRetornoRecebimentoInstrucaoCancelarDesconto,
    toRetornoRecebimentoInstrucaoConcederAbatimento,
    toRetornoRecebimentoInstrucaoConcederDesconto,
    toRetornoRecebimentoInstrucaoDispensarJuros,
    toRetornoRecebimentoInstrucaoNaoProtestar,
    toRetornoRecebimentoInstrucaoProtestar,
    toRetornoRecebimentoInstrucaoSustarProtesto,
    toRetornoReembolsoDevolucaoDescontoVendor,
    toRetornoReembolsoNaoEfetuado,
    toRetornoReembolsoTransferenciaDescontoVendor,
    toRetornoRegistroConfirmado,
    toRetornoRegistroRecusado,
    toRetornoRelacaoDeTitulos,
    toRetornoRemessaRejeitada,
    toRetornoReservado,
    toRetornoRetiradoDeCartorio,
    toRetornoSegundaViaInstrumentoProtesto,
    toRetornoSegundaViaInstrumentoProtestoCartorio,
    toRetornoSolicitacaoImpressaoTituloConfirmada,
    toRetornoSustacaoEnvioCartorio,
    toRetornoSustadoJudicial,
    toRetornoTarifaAvisoCobranca,
    toRetornoTarifaDeManutencaoDeTitulosVencidos,
    toRetornoTarifaDeRelacaoDasLiquidacoes,
    toRetornoTarifaEmailCobrancaAtivaEletronica,
    toRetornoTarifaEmissaoAvisoMovimentacaoTitulos,
    toRetornoTarifaEmissaoBoletoEnvioDuplicata,
    toRetornoTarifaExtratoPosicao,
    toRetornoTarifaInstrucao,
    toRetornoTarifaMensalBaixasBancosCorrespCarteira,
    toRetornoTarifaMensalBaixasCarteira,
    toRetornoTarifaMensalCancelamentoNegativacaoExpressa,
    toRetornoTarifaMensalEmailCobrancaAtivaEletronica,
    toRetornoTarifaMensalEmissaoBoletoEnvioDuplicata,
    toRetornoTarifaMensalExclusaoEntradaNegativacaoExpressa,
    toRetornoTarifaMensalExclusaoNegativacaoExpressaPorLiquidacao,
    toRetornoTarifaMensalLiquidacoesBancosCorrespCarteira,
    toRetornoTarifaMensalLiquidacoesCarteira,
    toRetornoTarifaMensalPorBoletoAte03EnvioCobrancaAtivaEletronica,
    toRetornoTarifaMensalRefEntradasBancosCorrespCarteira,
    toRetornoTarifaMensalSMSCobrancaAtivaEletronica,
    toRetornoTarifaOcorrencias,
    toRetornoTarifaPorBoletoAte03EnvioCobrancaAtivaEletronica,
    toRetornoTarifaSMSCobrancaAtivaEletronica,
    toRetornoTipoCobrancaAlterado,
    toRetornoTituloDDANaoReconhecidoPagador,
    toRetornoTituloDDAReconhecidoPagador,
    toRetornoTituloDDARecusadoCIP,
    toRetornoTituloEmSer,
    toRetornoTituloJaBaixado,
    toRetornoTituloNaoExiste,
    toRetornoTituloPagamentoCancelado,
    toRetornoTituloPagoEmCheque,
    toRetornoTituloSustadoJudicialmente,
    toRetornoTransferenciaCarteira,
    toRetornoTransferenciaCarteiraBaixa,
    toRetornoTransferenciaCarteiraEntrada,
    toRetornoTransferenciaCedente,
    toRetornoTransitoPagoCartorio,
    toRetornoVencimentoAlterado,
    toRetornoRejeicaoSacado,
    toRetornoAceiteSacado,
    toRetornoLiquidadoOnLine,
    toRetornoEstornoLiquidacaoOnLine,
    toRetornoConfirmacaoAlteracaoValorNominal,
    toRetornoConfirmacaoAlteracaoValorpercentualMinimoMaximo,
    toTipoOcorrenciaNenhum
  );

  {TOcorrencia}
  TOcorrencia = class
//  private
  protected
     FTipo: TTipoOcorrencia;
     FpAOwner: TTitulo;
     Function GetCodigoBanco: String;
     Function GetDescricao: String;
  public
     constructor Create(AOwner: TTitulo);
     property Tipo: TTipoOcorrencia read FTipo write FTipo;
     property Descricao  : String  read GetDescricao;
     property CodigoBanco: String  read GetCodigoBanco;
  end;

  { TBancoClass }

  TBancoClass = class
  private
     procedure ErroAbstract( NomeProcedure : String ) ;
  protected
    FpDigito: Integer;
    FpNome:   String;
    FpNumero: Integer;
    FpModulo: TCalcDigito;
    FpTamanhoAgencia: Integer;
    FpTamanhoCarteira: Integer;
    FpTamanhoConta: Integer;
    FpAOwner: TBanco;
    FpTamanhoMaximoNossoNum: Integer;
    FpOrientacoesBanco: TStringList;
    FpCodigosMoraAceitos: String;
    FpCodigosGeracaoAceitos: String;
    FpNumeroCorrespondente: Integer;
    FpLayoutVersaoArquivo : Integer; // Versão do Hearder do arquivo
    FpLayoutVersaoLote : Integer; // Versão do Hearder do Lote

    Function GetLocalPagamento: String; virtual;
    Function CalcularFatorVencimento(const DataVencimento: TDateTime): String; virtual;
    Function CalcularDigitoCodigoBarras(const CodigoBarras: String): String; virtual;
  public
    Constructor create(AOwner: TBanco);
    Destructor Destroy; override ;

    property Banco : TBanco      read FpAOwner;
    property Numero    : Integer         read FpNumero;
    property Digito    : Integer         read FpDigito;
    property Nome      : String          read FpNome;
    Property Modulo    : TCalcDigito read FpModulo;
    property TamanhoMaximoNossoNum: Integer    read FpTamanhoMaximoNossoNum;
    property TamanhoAgencia  :Integer read FpTamanhoAgencia;
    property TamanhoConta    :Integer read FpTamanhoConta;
    property TamanhoCarteira :Integer read FpTamanhoCarteira;
    property OrientacoesBanco: TStringList read FpOrientacoesBanco;
    property CodigosMoraAceitos: String read FpCodigosMoraAceitos;
    property CodigosGeracaoAceitos: String read FpCodigosGeracaoAceitos;
    property LocalPagamento  : String read GetLocalPagamento;
    property NumeroCorrespondente : Integer read FpNumeroCorrespondente;
    Property LayoutVersaoArquivo  : Integer read FpLayoutVersaoArquivo;
    Property LayoutVersaoLote     : Integer read FpLayoutVersaoLote;

    Function CalcularDigitoVerificador(const Titulo : TTitulo): String; virtual;
    Function CalcularTamMaximoNossoNumero(const Carteira : String; NossoNumero : String = ''; Convenio: String = ''): Integer; virtual;

    Function TipoDescontoToString(const AValue: TTipoDesconto):string; virtual;
    Function TipoOcorrenciaToDescricao(const TipoOcorrencia: TTipoOcorrencia): String; virtual;
    Function CodOcorrenciaToTipo(const CodOcorrencia:Integer): TTipoOcorrencia; virtual;
    Function TipoOCorrenciaToCod(const TipoOcorrencia: TTipoOcorrencia): String; virtual;
    Function CodMotivoRejeicaoToDescricao(const TipoOcorrencia: TTipoOcorrencia;CodMotivo:Integer): String; overload; virtual;
    Function CodMotivoRejeicaoToDescricao(const TipoOcorrencia: TTipoOcorrencia;CodMotivo: String): String; overload; virtual;

    Function CodOcorrenciaToTipoRemessa(const CodOcorrencia:Integer): TTipoOcorrencia; virtual;
    Function TipoOcorrenciaToCodRemessa(const TipoOcorrencia: TTipoOcorrencia): String; virtual;

    Function MontarCodigoBarras(const Titulo : TTitulo): String; virtual;
    Function MontarCampoNossoNumero(const Titulo : TTitulo): String; virtual;
    Function MontarLinhaDigitavel(const CodigoBarras: String; Titulo : TTitulo): String; virtual;
    Function MontarCampoCodigoCedente(const Titulo: TTitulo): String; virtual;
    Function MontarCampoCarteira(const Titulo: TTitulo): String; virtual;

    procedure GerarRegistroHeader400(NumeroRemessa : Integer; ARemessa:TStringList);  Virtual;
    Function GerarRegistroHeader240(NumeroRemessa : Integer): String;    Virtual;
    procedure GerarRegistroTransacao400(Titulo : TTitulo; aRemessa: TStringList); Virtual;
    Function GerarRegistroTransacao240(Titulo : TTitulo): String; Virtual;
    procedure GerarRegistroTrailler400(ARemessa:TStringList);  Virtual;
    Function GerarRegistroTrailler240(ARemessa:TStringList): String;  Virtual;
    Procedure LerRetorno400(ARetorno:TStringList); Virtual;
    Procedure LerRetorno240(ARetorno:TStringList); Virtual;

    Function CalcularNomeArquivoRemessa : String; Virtual;
    Function ValidarDadosRetorno(const AAgencia, AContaCedente: String; const ACNPJCPF: String= '';
       const AValidaCodCedente: Boolean= False ): Boolean; Virtual;
  end;


  { TBanco }
  TBanco = class
  private
//  protected
    FBoleto        : TBoleto;
    FNumeroBanco       : Integer;
    FTipoCobranca      : TTipoCobranca;
    FBancoClass        : TBancoClass;
    FLocalPagamento    : String;
    Function GetNome   : String;
    Function GetDigito : Integer;
    Function GetNumero : Integer;
    Function GetOrientacoesBanco: TStringList;
    Function GetTamanhoAgencia: Integer;
    Function GetTamanhoCarteira: Integer;
    Function GetTamanhoConta: Integer;
    Function GetTamanhoMaximoNossoNum : Integer;
    Function GetCodigosMoraAceitos: String;
    Function GetCodigosGeracaoAceitos: string;
    Function GetLocalPagamento: String;
    Function GetNumeroCorrespondente: Integer;
    Function GetLayoutVersaoArquivo    :Integer;
    Function GetLayoutVersaoLote       :Integer;

    procedure SetDigito(const AValue: Integer);
    procedure SetNome(const AValue: String);
    procedure SetTipoCobranca(const AValue: TTipoCobranca);
    procedure SetNumero(const AValue: Integer);
    procedure SetTamMaximoNossoNumero(Const Avalue:Integer);
    procedure SetOrientacoesBanco(Const Avalue: TStringList);
    procedure SetLocalPagamento(const AValue: String);
    procedure SetNumeroCorrespondente(const AValue: Integer);
    procedure SetLayoutVersaoArquivo(const AValue: Integer);
    procedure SetLayoutVersaoLote(const AValue: Integer);
  public
    constructor Create;
    destructor Destroy ; override ;

    property Boleto : TBoleto     read FBoleto;
    property BancoClass : TBancoClass read FBancoClass ;
    property TamanhoAgencia        :Integer read GetTamanhoAgencia;
    property TamanhoConta          :Integer read GetTamanhoConta;
    property TamanhoCarteira       :Integer read GetTamanhoCarteira;
    property CodigosMoraAceitos    :String  read GetCodigosMoraAceitos;
    property CodigosGeracaoAceitos :String  read GetCodigosGeracaoAceitos;

    Function TipoOcorrenciaToDescricao(const TipoOcorrencia: TTipoOcorrencia): String;
    Function CodOcorrenciaToTipo(const CodOcorrencia:Integer): TTipoOcorrencia;
    Function TipoOCorrenciaToCod(const TipoOcorrencia: TTipoOcorrencia): String;
    Function CodMotivoRejeicaoToDescricao(const TipoOcorrencia: TTipoOcorrencia;CodMotivo:Integer): String;

    Function CodOcorrenciaToTipoRemessa(const CodOcorrencia:Integer): TTipoOcorrencia;
    Function TipoOcorrenciaToCodRemessa(const TipoOcorrencia: TTipoOcorrencia ): String;
    Function CalcularDigitoVerificador(const Titulo : TTitulo): String;
    Function CalcularTamMaximoNossoNumero(const Carteira : String; NossoNumero : String = ''; Convenio: String = ''): Integer;

    Function MontarCampoCarteira(const Titulo: TTitulo): String;
    Function MontarCampoCodigoCedente(const Titulo: TTitulo): String;
    Function MontarCampoNossoNumero(const Titulo :TTitulo): String;
    Function MontarCodigoBarras(const Titulo : TTitulo): String;
    Function MontarLinhaDigitavel(const CodigoBarras: String; Titulo : TTitulo): String;

    procedure GerarRegistroHeader400(NumeroRemessa : Integer; ARemessa:TStringList);
    Function GerarRegistroHeader240(NumeroRemessa : Integer): String;
    procedure GerarRegistroTransacao400(Titulo : TTitulo;aRemessa: TStringList);
    Function GerarRegistroTransacao240(Titulo : TTitulo): String;
    procedure GerarRegistroTrailler400(ARemessa:TStringList);
    Function GerarRegistroTrailler240(ARemessa:TStringList): String;

    procedure LerRetorno400(ARetorno:TStringList);
    procedure LerRetorno240(ARetorno:TStringList);

    Function CalcularNomeArquivoRemessa : String;
    Function ValidarDadosRetorno(const AAgencia, AContaCedente: String; const ACNPJCPF: String= '';
       const AValidaCodCedente: Boolean= False ): Boolean;
//  published
    property Numero    : Integer        read GetNumero  write SetNumero default 0;
    property Digito    : Integer        read GetDigito  write SetDigito stored False;
    property Nome      : String         read GetNome    write SetNome   stored False;
    property TamanhoMaximoNossoNum :Integer read GetTamanhoMaximoNossoNum  write SetTamMaximoNossoNumero;
    property TipoCobranca : TTipoCobranca read FTipoCobranca   write SetTipoCobranca;
    property OrientacoesBanco : TStringList read GetOrientacoesBanco write SetOrientacoesBanco;
    property LocalPagamento : String read GetLocalPagamento write SetLocalPagamento;
    property NumeroCorrespondente : Integer read GetNumeroCorrespondente write SetNumeroCorrespondente default 0;
    property LayoutVersaoArquivo  : Integer read GetLayoutVersaoArquivo write SetLayoutVersaoArquivo;
    property LayoutVersaoLote     : Integer read GetLayoutVersaoLote write SetLayoutVersaoLote;
  end;

  TResponEmissao = (tbCliEmite,tbBancoEmite,tbBancoReemite,tbBancoNaoReemite);
  TCaracTitulo = (tcSimples,tcVinculada,tcCaucionada,tcDescontada,tcVendor);
  TPessoa = (pFisica,pJuridica,pOutras);
  TPessoaCedente = pFisica..pJuridica;

  {Aceite do titulo}
  TAceiteTitulo = (atSim, atNao);

  {TipoDiasIntrucao}
  TTipoDiasIntrucao = (diCorridos, diUteis);

  {Com essa propriedade é possivel ter apenas um cedente para gerar remessa de bloquetos de impressao normal e/ou carne na mesma remessa - Para Sicredi}
  {TipoImpressao}
  TTipoImpressao = (tipCarne, tipNormal);
  TTipoDocumento = (Tradicional=1, Escritural=2);

  {Define se a carteira é Cobrança Simples / Registrada}
  TTipoCarteira = (tctSimples, tctRegistrada, tctEletronica);

  {Definir como o boleto vai ser gerado/enviado pelo Cedente ou pelo Banco }
  TCarteiraEnvio = (tceCedente, tceBanco);

  {Definir codigo Desconto }
  TCodigoDesconto    = (cdSemDesconto, cdValorFixo);

  {Definir codigo Juros }
  TCodigoJuros       = (cjValorDia, cjTaxaMensal, cjIsento, cjValorMensal, cjTaxaDiaria);

  {Definir codigo Multa }
  TCodigoMulta       = (cmValorFixo, cmPercentual);

  {Definir se o titulo será protestado, não protestado ou negativado }
  TCodigoNegativacao = (cnNenhum, cnProtestarCorrido, cnProtestarUteis, cnNaoProtestar, cnNegativar, cnNaoNegativar);


  { TCedente }
  TCedente = class
  private
//  protected
    FCodigoTransmissao: String;
    FLogradouro: String;
    FBairro: String;
    FNumeroRes: String;
    FCEP: String;
    FCidade: String;
    FCodigoCedente: String;
    FComplemento: String;
    FTelefone: String;
    FNomeCedente   : String;
    FAgencia       : String;
    FAgenciaDigito : String;
    FConta         : String;
    FContaDigito   : String;
    FModalidade    : String;
    FConvenio      : String;
    FTipoDocumento : TTipoDocumento;
    FResponEmissao : TResponEmissao;
    FCaracTitulo:TCaracTitulo;
    FCNPJCPF       : String;
    FTipoInscricao : TPessoaCedente;
    FUF            : String;
    FBoleto    : TBoleto;
    FTipoCarteira: TTipoCarteira;
    FDigitoVerificadorAgenciaConta: String;
    FBanco: TBanco;
    procedure SetAgencia(const AValue: String);
    procedure SetCNPJCPF ( const AValue: String ) ;
    procedure SetConta(const AValue: String);
    procedure SetTipoInscricao ( const AValue: TPessoaCedente ) ;
    property Banco:TBanco read FBanco write FBanco;
  public
    constructor Create;
    destructor Destroy; override;
    property Nome              : String          read FNomeCedente       write FNomeCedente;
    property CodigoCedente     : String          read FCodigoCedente     write FCodigoCedente;
    property CodigoTransmissao : String          read FCodigoTransmissao write FCodigoTransmissao;
    property Agencia           : String          read FAgencia           write SetAgencia;
    property AgenciaDigito     : String          read FAgenciaDigito     write FAgenciaDigito;
    property Conta             : String          read FConta             write SetConta;
    property ContaDigito       : String          read FContaDigito       write FContaDigito;
    property Modalidade        : String          read FModalidade        write FModalidade;
    property Convenio          : String          read FConvenio          write FConvenio;
    property TipoDocumento     : TTipoDocumento  read FTipoDocumento     write FTipoDocumento default Tradicional;
    property TipoCarteira      : TTipoCarteira   read FTipoCarteira      write FTipoCarteira default tctSimples;
    property ResponEmissao     : TResponEmissao  read FResponEmissao     write FResponEmissao default tbBancoEmite;
    property CaracTitulo       : TCaracTitulo    read FCaracTitulo       write FCaracTitulo default tcSimples;
    property CNPJCPF           : String          read FCNPJCPF           write SetCNPJCPF;
    property TipoInscricao     : TPessoaCedente  read FTipoInscricao     write SetTipoInscricao;
    property Logradouro        : String          read FLogradouro        write FLogradouro;
    property NumeroRes         : String          read FNumeroRes         write FNumeroRes;
    property Complemento       : String          read FComplemento       write FComplemento;
    property Bairro            : String          read FBairro            write FBairro;
    property Cidade            : String          read FCidade            write FCidade;
    property UF                : String          read FUF                write FUF;
    property CEP               : String          read FCEP               write FCEP;
    property Telefone          : String          read FTelefone          write FTelefone;
    property DigitoVerificadorAgenciaConta  : String read FDigitoVerificadorAgenciaConta   write FDigitoVerificadorAgenciaConta;
    property Boleto            : TBoleto         read FBoleto;
  end;


  TTituloLiquidacao = class
  private
//  protected
    FBanco: Integer;
    FAgencia: String;
    FOrigem: String;
    FFormaPagto: String;
  public
    property Banco     : Integer read FBanco      write FBanco;
    property Agencia   : String  read FAgencia    write FAgencia;
    property Origem    : String  read FOrigem     write FOrigem;
    property FormaPagto: String  read FFormaPagto write FFormaPagto;
  end;

  TSacadoAvalista = class
  private
//  protected
    FTipoPessoa  : TPessoa;

    FNomeAvalista: String;
    FCNPJCPF     : String;
    FLogradouro  : String;
    FNumero      : String;
    FComplemento : String;
    FBairro      : String;
    FCidade      : String;
    FUF          : String;
    FCEP         : String;
    FEmail       : String;
    FFone        : String;
    FInscricaoNr : String;
  public
    property Pessoa      : TPessoa read FTipoPessoa  write FTipoPessoa;
    property NomeAvalista: String  read FNomeAvalista    write FNomeAvalista;
    property CNPJCPF     : String  read FCNPJCPF     write FCNPJCPF;
    property Logradouro  : String  read FLogradouro  write FLogradouro;
    property Numero      : String  read FNumero      write FNumero;
    property Complemento : String  read FComplemento write FComplemento;
    property Bairro      : String  read FBairro      write FBairro;
    property Cidade      : String  read FCidade      write FCidade;
    property UF          : String  read FUF          write FUF;
    property CEP         : String  read FCEP         write FCEP;
    property Email       : String  read FEmail       write FEmail;
    property Fone        : String  read FFone        write FFone;
    property InscricaoNr : String  read FInscricaoNr write FInscricaoNr;
  end;

  { TSacado }
  TSacado = class
  private
//  protected
    FSacadoAvalista : TSacadoAvalista;
    FTipoPessoa     : TPessoa;
    FNomeSacado  : String;
    FCNPJCPF     : String;
    FLogradouro  : String;
    FNumero      : String;
    FComplemento : String;
    FBairro      : String;
    FCidade      : String;
    FUF          : String;
    FCEP         : String;
    FEmail       : String;
    FFone        : String;
    Function GetNomeAvalista: String;
    procedure SetNomeAvalista(AValue: String);
  public
    constructor Create;
    destructor Destroy; override;

    property Pessoa         : TPessoa         read FTipoPessoa     write FTipoPessoa;
    property SacadoAvalista : TSacadoAvalista read FSacadoAvalista write FSacadoAvalista;

    property Avalista    : String  read GetNomeAvalista write SetNomeAvalista;
    property NomeSacado  : String  read FNomeSacado  write FNomeSacado;
    property CNPJCPF     : String  read FCNPJCPF     write FCNPJCPF;
    property Logradouro  : String  read FLogradouro  write FLogradouro;
    property Numero      : String  read FNumero      write FNumero;
    property Complemento : String  read FComplemento write FComplemento;
    property Bairro      : String  read FBairro      write FBairro;
    property Cidade      : String  read FCidade      write FCidade;
    property UF          : String  read FUF          write FUF;
    property CEP         : String  read FCEP         write FCEP;
    property Email       : String  read FEmail       write FEmail;
    property Fone        : String  read FFone        write FFone;
  end;

  { TTitulo }

  TTitulo = class
  private
//  protected
    FInstrucao1        : String;
    FInstrucao2        : String;
    FInstrucao3        : String;
    FLocalPagamento    : String;
    FOcorrenciaOriginal: TOcorrencia;
    FTipoDesconto      : TTipoDesconto;
    FTipoDesconto2     : TTipoDesconto;
    FParcela           : Integer;
    FPercentualMulta   : Double;
    FMultaValorFixo    : Boolean;
    FSeuNumero         : String;
    FTipoDiasProtesto  : TTipoDiasIntrucao;
    FTipoImpressao     : TTipoImpressao;
    FTotalParcelas: Integer;
    FValorDescontoAntDia: Currency;
    FVencimento        : TDateTime;
    FDataDocumento     : TDateTime;
    FNumeroDocumento   : String;
    FEspecieDoc        : String;
    FAceite            : TAceiteTitulo;
    FDataProcessamento : TDateTime;
    FNossoNumero       : String;
    FUsoBanco          : String;
    FCarteira          : String;
    FEspecieMod        : String;
    FValorDocumento    : Currency;
    FMensagem          : TStrings;
    FInformativo       : TStrings;
    FInstrucoes        : TStrings;
    FSacado            : TSacado;
    FLiquidacao        : TTituloLiquidacao;

    FMotivoRejeicaoComando          : TStrings;
    FDescricaoMotivoRejeicaoComando : TStrings;

    FDataOcorrencia       : TDateTime;
    FDataCredito          : TDateTime;
    FDataAbatimento       : TDateTime;
    FDataDesconto         : TDateTime;
    FDataDesconto2        : TDateTime;
    FDataMoraJuros        : TDateTime;
    FDataMulta            : TDateTime;
    FDataProtesto         : TDateTime;
    FDiasDeProtesto       : Integer;
    FDataBaixa            : TDateTime;
    FDataLimitePagto      : TDateTime;
    FValorDespesaCobranca : Currency;
    FValorAbatimento      : Currency;
    FValorDesconto        : Currency;
    FValorDesconto2       : Currency;
    FValorMoraJuros       : Currency;
    FValorIOF             : Currency;
    FValorOutrasDespesas  : Currency;
    FValorOutrosCreditos  : Currency;
    FValorRecebido        : Currency;
    FReferencia           : String;
    FVersao               : String;
    FBoleto               : TBoleto;
    FTextoLivre           : String;
    FCodigoMora           : String;
    FpLinhaDigitada       : String;
    FCodigoLiquidacao     : String;
    FCodigoLiquidacaoDescricao: String;
    FCarteiraEnvio        : TCarteiraEnvio;
    FCodigoNegativacao    : TCodigoNegativacao;
    FCodigoDesconto       : TCodigoDesconto;
    FCodigoMoraJuros      : TCodigoJuros;
    FCodigoMulta          : TCodigoMulta;

    FCodigoGeracao        : String;
    FValorPago            : Currency;
    FCaracTitulo          : TCaracTitulo;

    procedure SetCarteira(const AValue: String);
    procedure SetCodigoMora(AValue: String);
    procedure SetDiasDeProtesto(AValue: Integer);
    procedure SetNossoNumero ( const AValue: String ) ;
    procedure SetParcela ( const AValue: Integer ) ;
    procedure SetTipoDiasProtesto(AValue: TTipoDiasIntrucao);
    procedure SetTotalParcelas ( const AValue: Integer );
    procedure SetCodigoGeracao (AValue: String);
    procedure SetDataProtesto(AValue: TDateTime);
    procedure SetVencimento(AValue: TDateTime);
    procedure AtualizaDadosProtesto();
   public
     constructor Create(Boleto:TBoleto);
     destructor Destroy; override;

     property Boleto            : TBoleto     read FBoleto;
     property LocalPagamento    : String      read FLocalPagamento    write FLocalPagamento;
     property Vencimento        : TDateTime   read FVencimento        write SetVencimento;
     property DataDocumento     : TDateTime   read FDataDocumento     write FDataDocumento;
     property NumeroDocumento   : String      read FNumeroDocumento   write FNumeroDocumento ;
     property EspecieDoc        : String      read FEspecieDoc        write FEspecieDoc;
     property Aceite            : TAceiteTitulo   read FAceite           write FAceite      default atNao;
     property DataProcessamento : TDateTime   read FDataProcessamento write FDataProcessamento;
     property NossoNumero       : String      read FNossoNumero       write SetNossoNumero;
     property UsoBanco          : String      read FUsoBanco          write FUsoBanco;
     property Carteira          : String      read FCarteira          write SetCarteira;
     property CarteiraEnvio     : TCarteiraEnvio read FCarteiraEnvio write FCarteiraEnvio default tceBanco;
     property CodigoDesconto    : TCodigoDesconto    read FCodigoDesconto    write FCodigoDesconto;
     property CodigoMoraJuros   : TCodigoJuros       read FCodigoMoraJuros   write FCodigoMoraJuros;
     property CodigoMulta       : TCodigoMulta       read FCodigoMulta       write FCodigoMulta;
     property CodigoNegativacao : TCodigoNegativacao read FCodigoNegativacao write FCodigoNegativacao default cnNaoProtestar;
     
     property EspecieMod        : String      read FEspecieMod        write FEspecieMod;
     property ValorDocumento    : Currency    read FValorDocumento    write FValorDocumento;
     property Mensagem          : TStrings    read FMensagem          write FMensagem;
     property Informativo       : TStrings    read FInformativo       write FInformativo;
     property Instrucao1        : String      read FInstrucao1        write FInstrucao1;
     property Instrucao2        : String      read FInstrucao2        write FInstrucao2;
     property Instrucao3        : String      read FInstrucao3        write FInstrucao3;
     property Sacado            : TSacado read FSacado            write FSacado;
     property Parcela           :Integer      read FParcela           write SetParcela default 1;
     property TotalParcelas     :Integer      read FTotalParcelas     write SetTotalParcelas default 1;
     property CodigoLiquidacao  : String      read FCodigoLiquidacao  write FCodigoLiquidacao;
     property CodigoLiquidacaoDescricao : String read FCodigoLiquidacaoDescricao write FCodigoLiquidacaoDescricao;

     property OcorrenciaOriginal : TOcorrencia read  FOcorrenciaOriginal write FOcorrenciaOriginal;
     property TipoDesconto       : TTipoDesconto read FTipoDesconto write FTipoDesconto;
     property TipoDesconto2      : TTipoDesconto read FTipoDesconto2 write FTipoDesconto2;

     property MotivoRejeicaoComando          : TStrings    read FMotivoRejeicaoComando  write FMotivoRejeicaoComando;
     property DescricaoMotivoRejeicaoComando : TStrings    read FDescricaoMotivoRejeicaoComando  write FDescricaoMotivoRejeicaoComando;

     property DataOcorrencia                 : TDateTime read FDataOcorrencia  write FDataOcorrencia;
     property DataCredito                    : TDateTime read FDataCredito     write FDataCredito;
     property DataAbatimento                 : TDateTime read FDataAbatimento  write FDataAbatimento;
     property DataDesconto                   : TDateTime read FDataDesconto    write FDataDesconto;
     property DataDesconto2                  : TDateTime read FDataDesconto2   write FDataDesconto2;
     property DataMoraJuros                  : TDateTime read FDataMoraJuros   write FDataMoraJuros;
     property DataMulta                      : TDateTime read FDataMulta       write FDataMulta;
     property DataProtesto                   : TDateTime read FDataProtesto    write SetDataProtesto;
     property DiasDeProtesto                 : Integer   read FDiasDeProtesto  write SetDiasDeProtesto;
     property DataBaixa                      : TDateTime read FDataBaixa       write FDataBaixa;
     property DataLimitePagto                : TDateTime read FDataLimitePagto write FDataLimitePagto;

     property ValorDespesaCobranca : Currency read FValorDespesaCobranca  write FValorDespesaCobranca;
     property ValorAbatimento      : Currency read FValorAbatimento       write FValorAbatimento;
     property ValorDesconto        : Currency read FValorDesconto         write FValorDesconto;
     property ValorDesconto2       : Currency read FValorDesconto2        write FValorDesconto2;
     property ValorMoraJuros       : Currency read FValorMoraJuros        write FValorMoraJuros;
     property ValorIOF             : Currency read FValorIOF              write FValorIOF;
     property ValorOutrasDespesas  : Currency read FValorOutrasDespesas   write FValorOutrasDespesas;
     property ValorOutrosCreditos  : Currency read FValorOutrosCreditos   write FValorOutrosCreditos;
     property ValorPago            : Currency read FValorPago             write FValorPago;
     property ValorRecebido        : Currency read FValorRecebido         write FValorRecebido;
     property Referencia           : String   read FReferencia            write FReferencia;
     property Versao               : String   read FVersao                write FVersao;
     property SeuNumero            : String   read FSeuNumero             write FSeuNumero;
     property PercentualMulta      : Double   read FPercentualMulta       write FPercentualMulta;
     property MultaValorFixo       : Boolean   read FMultaValorFixo       write FMultaValorFixo;
     property ValorDescontoAntDia  : Currency read FValorDescontoAntDia  write  FValorDescontoAntDia;
     property TextoLivre : String read FTextoLivre write FTextoLivre;
     property CodigoMora : String read FCodigoMora write SetCodigoMora;
     property TipoDiasProtesto     : TTipoDiasIntrucao read FTipoDiasProtesto write SetTipoDiasProtesto;
     property TipoImpressao        : TTipoImpressao read FTipoImpressao write FTipoImpressao;
     property LinhaDigitada : String read FpLinhaDigitada;
     property CodigoGeracao: String read FCodigoGeracao write SetCodigoGeracao;
     property Liquidacao: TTituloLiquidacao read FLiquidacao write FLiquidacao;
     property CaracTitulo: TCaracTitulo read FCaracTitulo  write FCaracTitulo default tcSimples;
   end;

  { TListadeBoletos }
  TListadeBoletos = class(TObjectList)
  protected
    procedure SetObject (Index: Integer; Item: TTitulo);
    Function  GetObject (Index: Integer): TTitulo;
    procedure Insert (Index: Integer; Obj: TTitulo);
  public
    Function Add (Obj: TTitulo): Integer;
    property Objects [Index: Integer]: TTitulo
      read GetObject write SetObject; default;
  end;

  TBolLayOut = (lPadrao, lCarne, lFatura, lPadraoEntrega, lReciboTopo, lPadraoEntrega2) ;

  {TTipoOcorrenciaRemessa}
  TOcorrenciaRemessa = Record
    Tipo     : TTipoOcorrencia;
    Descricao: String;
  end;

  TOcorrenciasRemessa =  Array of TOcorrenciaRemessa;

  { TBoleto }
 TBoleto = class
  private
//  protected
    FBanco: TBanco;
    FBoletoFC: TBoletoFCClass;
    FDirArqRemessa: String;
    FDirArqRetorno: String;
    FLayoutRemessa: TLayoutRemessa;
    FImprimirMensagemPadrao: boolean;
    FListadeBoletos : TListadeBoletos;
    FCedente        : TCedente;
    FMAIL: TMail;
    FNomeArqRemessa: String;
    FNomeArqRetorno: String;
    FNumeroArquivo : integer;     {Número seqüencial do arquivo remessa ou retorno}
    FDataArquivo : TDateTime;     {Data da geração do arquivo remessa ou retorno}
    FDataCreditoLanc : TDateTime; {Data de crédito dos lançamentos do arquivo retorno}
    FLeCedenteRetorno: boolean;
    FHomologacao: Boolean;
    Function GetAbout: String;
    procedure SetAbout(const AValue: String);
    procedure SetBoletoFC(const Value: TBoletoFCClass);
    procedure SetMAIL(AValue: TMail);
  public
    constructor Create(TipoCobranca:TTipoCobranca);overload;
    constructor Create;overload;
    destructor Destroy; override;
    property ListadeBoletos : TListadeBoletos read FListadeBoletos write FListadeBoletos ;

    Function CriarTituloNaLista: TTitulo;

    procedure Imprimir;

    procedure GerarPDF;
    procedure GerarHTML;
    procedure GerarJPG;

    procedure EnviarEmail(const sPara, sAssunto: String;
       sMensagem: TStrings = nil; EnviaPDF: Boolean = true; sCC: TStrings = nil;
       Anexos:TStrings = nil);

    procedure AdicionarMensagensPadroes(Titulo : TTitulo; AStringList: TStrings);

    Function GerarRemessa(NumeroRemessa : Integer) : String; overload;
    Function GerarRemessa(NumeroRemessa : Integer; TipoCobranca:TTipoCobranca) : String;overload;
    procedure LerRetorno(AStream : TStream = Nil);
    procedure ChecarDadosObrigatorios;

    Function GetOcorrenciasRemessa() : TOcorrenciasRemessa;
    Function GetTipoCobranca(NumeroBanco: Integer): TTipoCobranca;
    Function LerArqIni(const AIniBoletos: String): Boolean;
    procedure GravarArqIni(DirIniRetorno, NomeArquivo: String);

    property About : String read GetAbout write SetAbout stored False ;
    property MAIL  : TMail read FMAIL write SetMAIL;

    property Homologacao    : Boolean            read FHomologacao            write FHomologacao default False;
    property Banco          : TBanco             read FBanco                  write FBanco;
    property Cedente        : TCedente           read FCedente                write FCedente ;
    property NomeArqRemessa : String             read FNomeArqRemessa         write FNomeArqRemessa;
    property DirArqRemessa  : String             read FDirArqRemessa          write FDirArqRemessa;
    property NomeArqRetorno : String             read FNomeArqRetorno         write FNomeArqRetorno;
    property DirArqRetorno  : String             read FDirArqRetorno          write FDirArqRetorno;
    property NumeroArquivo  : integer            read FNumeroArquivo          write FNumeroArquivo;
    property DataArquivo    : TDateTime          read FDataArquivo            write FDataArquivo;
    property DataCreditoLanc: TDateTime          read FDataCreditoLanc        write FDataCreditoLanc;
    property LeCedenteRetorno :boolean           read FLeCedenteRetorno       write FLeCedenteRetorno default False;
    property LayoutRemessa  : TLayoutRemessa     read FLayoutRemessa          write FLayoutRemessa default c400;
    property ImprimirMensagemPadrao : Boolean    read FImprimirMensagemPadrao write FImprimirMensagemPadrao default True;
    property BoletoFC : TBoletoFCClass           read FBoletoFC               write SetBoletoFC;
  end;

 {TBoletoFCClass}
 TBoletoFCFiltro = (fiNenhum, FiPDF, FiHTML, FiJPG) ;

 TBoletoFCOnObterLogo = procedure( const PictureLogo : TPicture; const NumeroBanco: Integer ) of object ;

 TBoletoFCClass = class
  private
//  protected
    FDirLogo        : String;
    FFiltro: TBoletoFCFiltro;
    FLayOut         : TBolLayOut;
    FMostrarPreview : Boolean;
    FMostrarProgresso: Boolean;
    FMostrarSetup: Boolean;
    FNomeArquivo: String;
    FNumCopias      : Integer;
    FPrinterName    : String;
    FOnObterLogo : TBoletoFCOnObterLogo ;
    FSoftwareHouse  : String;
    Function GetAbout: String;
    Function GetArqLogo: String;
    Function GetDirLogo: String;
    Function GetNomeArquivo: String;
    procedure SetAbout(const AValue: String);
    procedure SetBoleto(const Value: TBoleto);
    procedure SetDirLogo(const AValue: String);
  protected
    FpAbout : String ;
    FBoleto : TBoleto;
    procedure SetNumCopias(AValue: Integer);
    Function TituloRelatorio: String;
  public

    Constructor Create;

    procedure Imprimir; virtual;
    procedure GerarPDF; virtual;
    procedure GerarHTML; virtual;
    procedure GerarJPG; virtual;

    procedure CarregaLogo( const PictureLogo : TPicture; const NumeroBanco: Integer ) ;

    property ArquivoLogo : String read GetArqLogo;
  published
    property About : String read GetAbout write SetAbout stored False ;

    property OnObterLogo     : TBoletoFCOnObterLogo read FOnObterLogo write FOnObterLogo ;
    property Boleto      : TBoleto     read FBoleto       write SetBoleto ;
    property LayOut          : TBolLayOut  read FLayOut           write FLayOut           default lPadrao;
    property DirLogo         : String          read GetDirLogo        write SetDirLogo;
    property MostrarPreview  : Boolean         read FMostrarPreview   write FMostrarPreview   default True ;
    property MostrarSetup    : Boolean         read FMostrarSetup     write FMostrarSetup     default True ;
    property MostrarProgresso: Boolean         read FMostrarProgresso write FMostrarProgresso default True ;
    property NumCopias       : Integer         read FNumCopias        write SetNumCopias      default 1;
    property Filtro          : TBoletoFCFiltro read FFiltro       write FFiltro           default FiNenhum ;
    property NomeArquivo     : String          read GetNomeArquivo    write FNomeArquivo ;
    property SoftwareHouse   : String          read FSoftwareHouse    write FSoftwareHouse;
    property PrinterName     : String          read FPrinterName      write FPrinterName;
  end;

implementation

Uses Forms, Math, dateutils, strutils,// ACBrUtil,
     Myloo.Boleto.BancoBradesco, Myloo.Boleto.BancoBrasil, Myloo.Boleto.BancoAmazonia, Myloo.Boleto.BancoBanestes,
     Myloo.Boleto.BancoItau, Myloo.Boleto.BancoSicredi, Myloo.Boleto.BancoMercantil, Myloo.Boleto.BancoCaixa, Myloo.Boleto.BancoBanrisul,
     Myloo.Boleto.BancoSantander, Myloo.Boleto.BancoBancoob, Myloo.Boleto.BancoCaixaSICOB ,Myloo.Boleto.BancoHSBC,
     Myloo.Boleto.BancoNordeste , Myloo.Boleto.BancoBRB, Myloo.Boleto.BancoBic, Myloo.Boleto.BancoBradescoSICOOB,
     Myloo.Boleto.BancoSafra, Myloo.Boleto.BancoSafraBradesco, Myloo.Boleto.BancoCecred, Myloo.Boleto.BancoBrasilSicoob,
     Myloo.Boleto.Uniprime, Myloo.Boleto.BancoUnicredRS, Myloo.Boleto.BancoBanese, Myloo.Boleto.BancoCredisis, Myloo.Boleto.BancoUnicredES;

function TBancoClass.TipoDescontoToString(const AValue: TTipoDesconto):string;
begin
  Result := '0';
  case AValue of
     tdNaoConcederDesconto : Result := '0';
     tdValorFixoAteDataInformada : Result := '1';
     tdPercentualAteDataInformada : Result := '2';
     tdValorAntecipacaoDiaCorrido : Result := '3';
     tdValorAntecipacaoDiaUtil : Result := '4';
     tdPercentualSobreValorNominalDiaCorrido : Result := '5';
     tdPercentualSobreValorNominalDiaUtil : Result := '6';
     tdCancelamentoDesconto : Result := '7';
  end;
end;

{ TCedente }

procedure TCedente.SetCNPJCPF ( const AValue: String ) ;
var
  Val: TValidador;
  ADocto: String;
begin
   if FCNPJCPF = AValue then
     Exit;

   ADocto := OnlyNumber(AValue);
   if EstaVazio(ADocto) then
   begin
      FCNPJCPF:= ADocto;
      Exit;
   end;

   Val := TValidador.Create;//(nil);
   try
     with Val do
     begin
       if TipoInscricao = pFisica then
       begin
         TipoDocto := docCPF;
         Documento := RightStr(ADocto,11);
       end
       else
       begin
         TipoDocto := docCNPJ;
         Documento := RightStr(ADocto,14);
       end;

       IgnorarChar := './-';
       RaiseExcept := True;
       Validar;    // Dispara Exception se Documento estiver errado

       FCNPJCPF := Formatar;
     end;
   Finally
     Val.Free;
   end;
end;

procedure TCedente.SetConta(const AValue: String);
var
  aConta: Integer;
begin
   if FConta = AValue then
      exit;

   FConta:= AValue;
   aConta:= StrToIntDef(trim(AValue),0);

   if aConta = 0 then
      exit;

   FConta:= IntToStrZero(aConta, Self.Banco.TamanhoConta );
end;

procedure TCedente.SetAgencia(const AValue: String);
var
  aAgencia: Integer;
  Prop: TRttiProperty;
  Field: TRttiField;
  banco: TBanco;
  value:TValue;
begin
   if FAgencia = AValue then
      exit;

   FAgencia:= AValue;

   aAgencia:= StrToIntDef(trim(AValue),0);

   if aAgencia = 0 then
      exit;
   FAgencia:= IntToStrZero(aAgencia, Self.Banco.TamanhoAgencia );
end;

procedure TCedente.SetTipoInscricao ( const AValue: TPessoaCedente ) ;
begin
   if FTipoInscricao = AValue then
      exit;

   FTipoInscricao := AValue;
end;

constructor TCedente.Create;
begin
   FNomeCedente   := '';
   FAgencia       := '';
   FAgenciaDigito := '';
   FConta         := '';
   FContaDigito   := '';
   FModalidade    := '';
   FConvenio      := '';
   FCNPJCPF       := '';
   FDigitoVerificadorAgenciaConta:= '';
   FResponEmissao := tbCliEmite;
   FCaracTitulo   := tcSimples;
   FTipoInscricao := pJuridica;
   FBoleto    := TBoleto(nil);
end;

destructor TCedente.Destroy;
begin
  inherited;
end;

{ TSacado }

function TSacado.GetNomeAvalista: String;
begin
  Result:= Self.SacadoAvalista.NomeAvalista;
end;

procedure TSacado.SetNomeAvalista(AValue: String);
begin
   if Self.SacadoAvalista.NomeAvalista = AValue then
     Exit;

   Self.SacadoAvalista.NomeAvalista:= AValue;
end;

constructor TSacado.Create;
begin
   FSacadoAvalista := TSacadoAvalista.Create;
end;

destructor TSacado.Destroy;
begin
   FSacadoAvalista.Free;
  inherited;
end;

procedure TTitulo.SetNossoNumero ( const AValue: String ) ;
var
   wTamNossoNumero: Integer;
   wNossoNumero: String;
begin
   wNossoNumero:= OnlyNumber(AValue);
   with Boleto.Banco do
   begin
      wTamNossoNumero:= CalcularTamMaximoNossoNumero(Carteira, wNossoNumero,
                                                     Boleto.Cedente.Convenio);

      if Length(trim(wNossoNumero)) > wTamNossoNumero then
         raise Exception.Create( Str('Tamanho Máximo do Nosso Número é: '+ IntToStr(wTamNossoNumero) ));

      FNossoNumero := PadLeft(wNossoNumero,wTamNossoNumero,'0');
   end;
end;

procedure TTitulo.SetCarteira(const AValue: String);
var
  aCarteira: Integer;
begin
   if FCarteira = AValue then
      exit;

   with Boleto.Banco do
   begin
      aCarteira:= StrToIntDef(trim(AValue),0);

      FCarteira:=  AValue;

      if aCarteira < 1 then
         exit;

      FCarteira:= IntToStrZero(aCarteira,TamanhoCarteira);

   end;
end;

procedure TTitulo.SetCodigoMora(AValue: String);
begin
  if FCodigoMora = AValue then
      exit;

  if Pos(AValue,Boleto.Banco.CodigosMoraAceitos) = 0 then
     raise Exception.Create( Str('Código de Mora/Juros informado não é permitido ' +
                                     'para este banco!') );

  FCodigoMora := AValue;
end;

procedure TTitulo.SetDiasDeProtesto(AValue: Integer);
begin
  if (fDiasDeProtesto = AValue) then
    Exit;

  FDiasDeProtesto := AValue;
  FDataProtesto := 0;
  AtualizaDadosProtesto();
end;

procedure TTitulo.SetCodigoGeracao(AValue: String);
begin
  if FCodigoGeracao = AValue then
    Exit;

  if Pos(AValue,Boleto.Banco.CodigosGeracaoAceitos) = 0 then
     raise Exception.Create( Str('Código de Geração Inválido!') );

  FCodigoGeracao := AValue;
end;

procedure TTitulo.SetDataProtesto(AValue: TDateTime);
begin
  if (fDataProtesto = AValue) then
    Exit;

   if (fTipoDiasProtesto = diUteis) then
     FDataProtesto:= IncWorkingDay(AValue,0)
   else
     FDataProtesto := Avalue;

  FDiasDeProtesto := 0;
  AtualizaDadosProtesto();
end;

procedure TTitulo.SetVencimento(AValue: TDateTime);
begin
  if (fVencimento = AValue) then
    Exit;

  FVencimento := AValue;
  AtualizaDadosProtesto();
end;

procedure TTitulo.SetTipoDiasProtesto(AValue: TTipoDiasIntrucao);
begin
  if FTipoDiasProtesto = AValue then
    Exit;

  FTipoDiasProtesto := AValue;
  if FDiasDeProtesto > 0 then
    FDataProtesto := 0;

  AtualizaDadosProtesto();
end;

procedure TTitulo.AtualizaDadosProtesto;
begin
  if FVencimento <= 0 then
    Exit;

  if (fDataProtesto > 0) then
  begin
    if (fTipoDiasProtesto = diUteis) then
      FDiasDeProtesto := WorkingDaysBetween(fVencimento, FDataProtesto)
    else
      FDiasDeProtesto := DaysBetween(fVencimento, FDataProtesto);
  end
  else if (fDiasDeProtesto > 0) then
  begin
    if (fTipoDiasProtesto = diUteis) then
      FDataProtesto := IncWorkingDay(fVencimento,fDiasDeProtesto)
    else
      FDataProtesto := IncDay(fVencimento,fDiasDeProtesto);
  end;
end;

procedure TTitulo.SetParcela ( const AValue: Integer ) ;
begin
   if (AValue > TotalParcelas) and (Boleto.BoletoFC.LayOut = lCarne) then
      raise Exception.Create( Str('Numero da Parcela Atual deve ser menor ' +
                                      'que o Total de Parcelas do Carnê') );
   FParcela := AValue;
end;

procedure TTitulo.SetTotalParcelas ( const AValue: Integer ) ;
begin
   if (AValue < Parcela) and (Boleto.BoletoFC.LayOut = lCarne) then
      raise Exception.Create( Str('Numero da Parcela Atual deve ser menor ou igual ' +
                                      'o Total de Parcelas do Carnê') );
   FTotalParcelas := AValue;
end;

{ TTitulo }

constructor TTitulo.Create(Boleto:TBoleto);
begin
   inherited Create;

   FBoleto        := Boleto;
   FLocalPagamento    := Boleto.Banco.LocalPagamento;
   FVencimento        := 0;
   FDataDocumento     := 0;
   FNumeroDocumento   := '';
   FEspecieDoc        := 'DM';
   FAceite            := atNao;
   FDataProcessamento := now;
   FNossoNumero       := '';
   FUsoBanco          := '';
   FCarteira          := '';
   FEspecieMod        := '';
   FValorDocumento    := 0;
   FInstrucao1        := '';
   FInstrucao2        := '';
   FInstrucao3        := '';
   FMensagem          := TStringList.Create;
   FInformativo       := TStringList.Create;
   FInstrucoes        := TStringList.Create;
   FSacado            := TSacado.Create;
   FLiquidacao        := TTituloLiquidacao.Create;

   FOcorrenciaOriginal:= TOcorrencia.Create(Self);
   FMotivoRejeicaoComando          := TStringList.Create;
   FDescricaoMotivoRejeicaoComando := TStringList.Create;

   FDataOcorrencia       := 0;
   FDataCredito          := 0;
   FDataAbatimento       := 0;
   FDataDesconto         := 0;
   FDataDesconto2        := 0;
   FDataMoraJuros        := 0;
   FDataMulta            := 0;
   FDataProtesto         := 0;
   FDiasDeProtesto       := 0;
   FDataBaixa            := 0;
   FDataLimitePagto      := 0;
   FValorDespesaCobranca := 0;
   FValorAbatimento      := 0;
   FValorDesconto        := 0;
   FValorDesconto2       := 0;
   FValorMoraJuros       := 0;
   FValorIOF             := 0;
   FValorOutrasDespesas  := 0;
   FValorOutrosCreditos  := 0;
   FValorRecebido        := 0;
   FValorDescontoAntDia  := 0;
   FPercentualMulta      := 0;
   FMultaValorFixo       := False;
   FReferencia           := '';
   FVersao               := '';
   FTipoImpressao        := tipNormal;
   FTipoDesconto         := tdNaoConcederDesconto ;
   FTipoDesconto2        := tdNaoConcederDesconto ;

   FCodigoMora    := '';
   FCodigoGeracao := '2';
   FCaracTitulo   := FBoleto.Cedente.CaracTitulo;
   
   if Boleto.Cedente.ResponEmissao = tbCliEmite then
     FCarteiraEnvio := tceCedente
   else
     FCarteiraEnvio := tceBanco;
end;

destructor TTitulo.Destroy;
begin
   FMensagem.Free;
   FInformativo.Free;
   FSacado.Free;
   FLiquidacao.Free;
   FInstrucoes.Free;
   FOcorrenciaOriginal.Free;
   FMotivoRejeicaoComando.Free;
   FDescricaoMotivoRejeicaoComando.Free;

   inherited;
end;

procedure TBoleto.SetBoletoFC ( const Value: TBoletoFCClass ) ;
Var OldValue: TBoletoFCClass;
begin
   if Value <> FBoletoFC then
   begin
//      if Assigned(fBoletoFC) then
//         FBoletoFC.RemoveFreeNotification(Self);

      OldValue      := FBoletoFC ;   // Usa outra variavel para evitar Loop Infinito
      FBoletoFC := Value;            // na remoção da associação dos componentes

      if Assigned(OldValue) then
         if Assigned(OldValue.Boleto) then
            OldValue.Boleto := nil ;

      if Value <> nil then
      begin
//         Value.FreeNotification(self);
         Value.Boleto := self ;
      end ;
   end ;
end;

procedure TBoleto.SetMAIL(AValue: TMail);
begin
  if AValue <> FMAIL then
  begin
//    if Assigned(FMAIL) then
//      FMAIL.RemoveFreeNotification(Self);

    FMAIL := AValue;

//    if AValue <> nil then
//      AValue.FreeNotification(self);
  end;
end;

function TBoleto.GetAbout: String;
begin
  Result := 'Boleto Ver: '+cBoleto_Versao;
end;

procedure TBoleto.SetAbout(const AValue: String);
begin
  {}
end;

{ TBoleto }

constructor TBoleto.Create(TipoCobranca:TTipoCobranca);
begin

   FBoletoFC           := nil;
   FMAIL                   := nil;
   FImprimirMensagemPadrao := True;

   FListadeBoletos := TListadeBoletos.Create(true);


   FBanco := TBanco.Create;//(nil);
   FBanco.TipoCobranca := TipoCobranca;
   FCedente      := TCedente.Create;//(nil);
   FCedente.Banco := FBanco;
   FBanco.fBoleto := Self;

end;

constructor TBoleto.Create;
begin
   inherited;

   FBoletoFC           := nil;
   FMAIL                   := nil;
   FImprimirMensagemPadrao := True;

   FListadeBoletos := TListadeBoletos.Create(true);

   FBanco := TBanco.Create;
end;

destructor TBoleto.Destroy;
begin
   FListadeBoletos.Free;
   FCedente.Free;
   FBanco.Free;

   inherited;
end;

function TBoleto.CriarTituloNaLista: TTitulo;
var
   I : Integer;
begin
   I      := FListadeBoletos.Add(TTitulo.Create(Self));
   Result := FListadeBoletos[I];
end;

procedure TBoleto.Imprimir;
begin
   if not Assigned(BoletoFC) then
      raise Exception.Create( Str('Nenhum componente "BoletoFC" associado' ) ) ;

   if Banco.Numero = 0 then
      raise Exception.Create( Str('Banco não definido, impossivel listar boleto') );

   ChecarDadosObrigatorios;

   BoletoFC.Imprimir;
end;

procedure TBoleto.GerarPDF;
begin
   if not Assigned(BoletoFC) then
      raise Exception.Create( Str('Nenhum componente "BoletoFC" associado' ) ) ;

   ChecarDadosObrigatorios;

   BoletoFC.GerarPDF;
end;

procedure TBoleto.GerarHTML;
begin
   if not Assigned(BoletoFC) then
      raise Exception.Create( Str('Nenhum componente "BoletoFC" associado' ) );

   ChecarDadosObrigatorios;

   BoletoFC.GerarHTML;
end;

procedure TBoleto.GerarJPG;
begin
   if not Assigned(BoletoFC) then
      raise Exception.Create( Str('Nenhum componente "BoletoFC" associado' ) ) ;

   ChecarDadosObrigatorios;

   BoletoFC.GerarJPG;
end;

procedure TBoleto.EnviarEmail(const sPara, sAssunto: String;
  sMensagem: TStrings; EnviaPDF: Boolean; sCC: TStrings; Anexos: TStrings);
var
  i: Integer;
  EMails: TStringList;
  sDelimiter: Char;
begin
  if not Assigned(FMAIL) then
    raise Exception.Create( Str('Componente Mail não associado') );

  FMAIL.Clear;

  EMails := TStringList.Create;
  try
    if Pos( ';', sPara) > 0 then
       sDelimiter := ';'
    else
       sDelimiter := ',';
    QuebrarLinha( sPara, EMails, '"', sDelimiter);

    For i := 0 to EMails.Count -1 do
       FMAIL.AddAddress( EMails[i] );

  Finally
    EMails.Free;
  end;

  //FMAIL.AddAddress(sPara);
  FMAIL.Subject := sAssunto;

  if Assigned(sMensagem) then
  begin
    MAIL.Body.Assign(sMensagem);
    MAIL.AltBody.Text := (StripHTML(sMensagem.Text));
  end;

  FMAIL.ClearAttachments;
  if (EnviaPDF) then
  begin
    if BoletoFC.NomeArquivo = '' then
      BoletoFC.NomeArquivo := ApplicationPath + 'boleto.pdf';

    GerarPDF;
    FMAIL.AddAttachment(BoletoFC.NomeArquivo,
                        ExtractFileName(BoletoFC.NomeArquivo) );
  end
  else
  begin
    if BoletoFC.NomeArquivo = '' then
      BoletoFC.NomeArquivo := ApplicationPath + 'boleto.html';;

    GerarHTML;
    FMAIL.AddAttachment(BoletoFC.NomeArquivo,
                        ExtractFileName(BoletoFC.NomeArquivo));
  end;

  if Assigned(sCC) then
  begin
    For i := 0 to sCC.Count - 1 do
      FMAIL.AddCC(sCC[i]);
  end;

  if Assigned(Anexos) then
  begin
    For i := 0 to Anexos.Count - 1 do
      FMAIL.AddAttachment(Anexos[i]);
  end;

  MAIL.Send;
end;

procedure TBoleto.AdicionarMensagensPadroes(Titulo: TTitulo;
  AStringList: TStrings);
begin
   if not ImprimirMensagemPadrao  then
      exit;

   with Titulo do
   begin
      if DataProtesto <> 0 then
      begin
         if TipoDiasProtesto = diCorridos then
            AStringList.Add(Str('Protestar em ' + IntToStr(DaysBetween(Vencimento, DataProtesto))+ ' dias corridos após o vencimento'))
         else
            AStringList.Add(Str('Protestar no '+IntToStr(max(DiasDeProtesto,1)) + 'º dia útil após o vencimento'));
      end;

      if ValorAbatimento <> 0 then
      begin
         if DataAbatimento <> 0 then
            AStringList.Add(Str('Conceder abatimento de ' +
                             FormatCurr('R$ #,##0.00',ValorAbatimento) +
                             ' para pagamento ate ' + FormatDateTime('dd/mm/yyyy',DataAbatimento)))
         else
            AStringList.Add(Str('Conceder abatimento de ' +
                             FormatCurr('R$ #,##0.00',ValorAbatimento)));
      end;

      if ValorDesconto <> 0 then
      begin
         if DataDesconto <> 0 then
            AStringList.Add(Str('Conceder desconto de '                       +
                             FormatCurr('R$ #,##0.00',ValorDesconto)       +
                             ' para pagamento até ' +
                             FormatDateTime('dd/mm/yyyy',DataDesconto)))
         else
            AStringList.Add(Str('Conceder desconto de '                 +
                             FormatCurr('R$ #,##0.00',ValorDesconto) +
                             ' por dia de antecipaçao'));
      end;

      if ValorDesconto2 <> 0 then
      begin
        if DataDesconto2 <> 0 then
          AStringList.Add(Str('Conceder desconto de '                       +
                           FormatCurr('R$ #,##0.00',ValorDesconto2)       +
                           ' para pagamento até ' +
                           FormatDateTime('dd/mm/yyyy', DataDesconto2)))
        else
          AStringList.Add(Str('Conceder desconto de '                 +
                           FormatCurr('R$ #,##0.00',ValorDesconto2) +
                           ' por dia de antecipaçao'));
      end;

      if ValorMoraJuros <> 0 then
      begin
         if DataMoraJuros <> 0 then
            AStringList.Add(Str('Cobrar juros de '                        +
                            ifthen(((CodigoMora = '2') or (CodigoMora = 'B')), FloatToStr(ValorMoraJuros) + '% ao mês',
                                   FormatCurr('R$ #,##0.00 por dia',ValorMoraJuros))         +
                             ' de atraso para pagamento a partir de ' +
                             FormatDateTime('dd/mm/yyyy',ifthen(Vencimento = DataMoraJuros,
                                                                IncDay(DataMoraJuros,1),DataMoraJuros))))
         else
            AStringList.Add(Str('Cobrar juros de '                +
                                    ifthen(((CodigoMora = '2') or (CodigoMora = 'B')), FloatToStr(ValorMoraJuros) + '% ao mês',
                                           FormatCurr('R$ #,##0.00 por dia',ValorMoraJuros))         +
                             ' de atraso'));
      end;

      if PercentualMulta <> 0 then
      begin
        if DataMulta <> 0 then
          AStringList.Add(Str('Multa de ' + FormatCurr('R$ #,##0.00',
            IfThen(MultaValorFixo, PercentualMulta, ValorDocumento*( 1+ PercentualMulta/100)-ValorDocumento)) +
                         ' a partir '+FormatDateTime('dd/mm/yyyy',ifthen(Vencimento = DataMulta,
                                                                IncDay(DataMulta,1),DataMulta))))
        else
          AStringList.Add(Str('Multa de ' + FormatCurr('R$ #,##0.00',
            IfThen(MultaValorFixo, PercentualMulta, ValorDocumento*( 1+ PercentualMulta/100)-ValorDocumento)) +
                         ' após o vencimento.'));
      end;
      if DataLimitePagto <> 0 then
      begin
        if DataLimitePagto > Vencimento then
          AStringList.Add(Str('Não Receber após ' + IntToStr(DaysBetween(Vencimento, DataLimitePagto))+ ' dias'))
        else
          AStringList.Add(Str('Não Receber após o Vencimento'));
      end;
   end;
end;

{ TListadeBoletos }

procedure TListadeBoletos.SetObject ( Index: Integer; Item: TTitulo ) ;
begin
   inherited SetItem (Index, Item) ;
end;

function TListadeBoletos.GetObject ( Index: Integer ) : TTitulo;
begin
   Result := inherited GetItem(Index) as TTitulo ;
end;

procedure TListadeBoletos.Insert ( Index: Integer; Obj: TTitulo ) ;
begin
   inherited Insert(Index, Obj);
end;

function TListadeBoletos.Add ( Obj: TTitulo ) : Integer;
begin
   Result := inherited Add(Obj) ;
end;

{ TBanco }

constructor TBanco.Create;
begin
   inherited Create;// ( AOwner ) ;

//   if not (AOwner is TBoleto) then
//      raise Exception.Create(Str('Aowner deve ser do tipo TBoleto'));

   FBoleto  := TBoleto(nil);
   FNumeroBanco := 0;

   FBancoClass := TBancoClass.create(Self);
end;

destructor TBanco.Destroy ;
begin
   FBancoClass.Free;
   inherited ;
end ;

function TBanco.GetNome: String;
begin
   Result:= Str(fBancoClass.Nome);
end;

function TBanco.GetDigito: Integer;
begin
   Result := FBancoClass.Digito;
end;

function TBanco.GetNumero: Integer;
begin
  Result:=  BancoClass.Numero ;
end;

function TBanco.GetOrientacoesBanco: TStringList;
begin
  Result:= BancoClass.OrientacoesBanco;
end;

function TBanco.GetTamanhoAgencia: Integer;
begin
  Result:= BancoClass.TamanhoAgencia;
end;

function TBanco.GetTamanhoCarteira: Integer;
begin
  Result:= BancoClass.TamanhoCarteira;
end;

function TBanco.GetTamanhoConta: Integer;
begin
   Result:= BancoClass.TamanhoConta;
end;

function TBanco.GetTamanhoMaximoNossoNum: Integer;
begin
   Result := BancoClass.TamanhoMaximoNossoNum;
end;

function TBanco.GetCodigosMoraAceitos: String;
begin
  Result := BancoClass.CodigosMoraAceitos;
end;

function TBanco.GetCodigosGeracaoAceitos: string;
begin
  Result := BancoClass.CodigosGeracaoAceitos;
end;

function TBanco.GetLocalPagamento: String;
begin
   if FLocalPagamento = '' then
      FLocalPagamento := FBancoClass.LocalPagamento;

   Result := FLocalPagamento;
end;

function TBanco.GetNumeroCorrespondente: Integer;
begin
  Result:=  BancoClass.NumeroCorrespondente ;
end;

function TBanco.GetLayoutVersaoArquivo: Integer;
begin
  Result:=  BancoClass.LayoutVersaoArquivo;
end;

function TBanco.GetLayoutVersaoLote: Integer;
begin
  Result:=  BancoClass.LayoutVersaoLote;
end;

procedure TBanco.SetDigito(const AValue: Integer);
begin
  {Apenas para aparecer no ObjectInspector do D7}
end;

procedure TBanco.SetNome(const AValue: String);
begin
  {Apenas para aparecer no ObjectInspector do D7}
end;

procedure TBanco.SetNumero(const AValue: Integer);
begin
  {Apenas para aparecer no ObjectInspector do D7}
end;

procedure TBanco.SetLocalPagamento(const AValue: String);
begin
  FLocalPagamento := TrimRight(AValue);
end;

procedure TBanco.SetNumeroCorrespondente(const AValue: Integer);
begin
  {Apenas para aparecer no ObjectInspector do D7}
end;

procedure TBanco.SetLayoutVersaoArquivo(const AValue: Integer);
begin
  BancoClass.fpLayoutVersaoArquivo:= AValue;
end;

procedure TBanco.SetLayoutVersaoLote(const AValue: Integer);
begin
  BancoClass.fpLayoutVersaoLote:= AValue;
end;

procedure TBanco.SetTamMaximoNossoNumero(const Avalue: Integer);
begin
  {Altera o tamanho maximo do Nosso Numero} 
  BancoClass.fpTamanhoMaximoNossoNum := AValue;
end;

procedure TBanco.SetOrientacoesBanco(const Avalue: TStringList);
begin
   BancoClass.fpOrientacoesBanco.Text := AValue.Text;
end;

procedure TBanco.SetTipoCobranca(const AValue: TTipoCobranca);
begin
   if FTipoCobranca = AValue then
      exit;

   if FLocalPagamento = FBancoClass.LocalPagamento then   //Usando valor Default
      FLocalPagamento := '';

   FBancoClass.Free;

   case AValue of
     cobBancoDoBrasil       : FBancoClass := TBancoBrasil.create(Self);         {001}
     cobBancoDoBrasilSICOOB : FBancoClass := TBancoBrasilSICOOB.Create(Self);   {001}
     cobBancoDaAmazonia     : FBancoClass := TBancoAmazonia.create(Self);       {003}
     cobBancoDoNordeste     : FBancoClass := TBancoNordeste.create(Self);       {004}
     cobBanestes            : FBancoClass := TBancoBanestes.create(Self);       {021}
     cobSantander           : FBancoClass := TBancoSantander.create(Self);      {033,353,008}
     cobBanrisul            : FBancoClass := TBancoBanrisul.create(Self);       {041}
     cobBRB                 : FBancoClass := TBancoBRB.create(Self);            {070}
     cobUnicredRS           : FBancoClass := TBancoUnicredRS.Create(Self);      {091}
     cobBancoCECRED         : FBancoClass := TBancoCecred.Create(Self);         {085}
     cobCrediSIS            : FBancoClass := TBancoCrediSIS.Create(Self);       {097}
     cobUniprime            : FBancoClass := TBancoUniprime.create(Self);       {099}
     cobCaixaEconomica      : FBancoClass := TCaixaEconomica.create(Self);      {104}
     cobCaixaSicob          : FBancoClass := TCaixaEconomicaSICOB.create(Self); {104}
     cobUnicredES           : FBancoClass := TBancoUnicredES.create(Self);      {136}
     cobBradesco            : FBancoClass := TBancoBradesco.create(Self);       {237}
     cobItau                : FBancoClass := TBancoItau.Create(Self);           {341}
     cobBancoMercantil      : FBancoClass := TBancoMercantil.create(Self);      {389}
     cobSicred              : FBancoClass := TBancoSicredi.Create(Self);        {748}
     cobBancoob             : FBancoClass := TBancoob.create(Self);             {756}
     cobHSBC                : FBancoClass := TBancoHSBC.create(Self);           {399}
     cobBicBanco            : FBancoClass := TBancoBic.create(Self);            {237}
     cobBradescoSICOOB      : FBancoClass := TBancoBradescoSICOOB.create(Self); {237}
     cobBancoSafra          : FBancoClass := TBancoSafra.create(Self);          {422}
     cobSafraBradesco       : FBancoClass := TBancoSafraBradesco.Create(Self);  {422 + 237}
     cobBanese              : FBancoClass := TBancoBanese.Create(Self);         {047}
   else
     FBancoClass := TBancoClass.create(Self);
   end;

   FTipoCobranca := AValue;
end;

function TBanco.TipoOcorrenciaToDescricao( const TipoOcorrencia: TTipoOcorrencia
   ) : String;
begin
   Result:= BancoClass.TipoOcorrenciaToDescricao(TipoOCorrencia);
end;

function TBanco.CodOcorrenciaToTipo(const CodOcorrencia: Integer ) : TTipoOcorrencia;
begin
   Result:= BancoClass.CodOcorrenciaToTipo(CodOcorrencia);
end;

function TBanco.TipoOCorrenciaToCod (
   const TipoOcorrencia: TTipoOcorrencia ) : String;
begin
   Result:= BancoClass.TipoOCorrenciaToCod(TipoOcorrencia);
end;

function TBanco.CodMotivoRejeicaoToDescricao( const TipoOcorrencia:
   TTipoOcorrencia;CodMotivo: Integer) : String;
begin
  Result:= BancoClass.CodMotivoRejeicaoToDescricao(TipoOcorrencia,CodMotivo);
end;

function TBanco.CodOcorrenciaToTipoRemessa(const CodOcorrencia: Integer ) : TTipoOcorrencia;
begin
   Result:= FBancoClass.CodOcorrenciaToTipoRemessa(CodOcorrencia);
end;

function TBanco.TipoOcorrenciaToCodRemessa(const TipoOcorrencia: TTipoOcorrencia ) : String;
begin
   Result:= FBancoClass.TipoOcorrenciaToCodRemessa(TipoOcorrencia);
end;

function TBanco.CalcularDigitoVerificador ( const Titulo: TTitulo
   ) : String;
begin
   Result:=  BancoClass.CalcularDigitoVerificador(Titulo);
end;

function TBanco.CalcularTamMaximoNossoNumero(const Carteira: String; NossoNumero : String = ''; Convenio: String = ''): Integer;
begin
  Result:= BancoClass.CalcularTamMaximoNossoNumero(Carteira, NossoNumero, Convenio);
end;

function TBanco.MontarCampoCarteira(const Titulo: TTitulo): String;
begin
  Result:= BancoClass.MontarCampoCarteira(Titulo);
end;

function TBanco.MontarCampoNossoNumero ( const Titulo: TTitulo
   ) : String;
begin
   Result:= BancoClass.MontarCampoNossoNumero(Titulo);
end;

function TBanco.MontarCodigoBarras ( const Titulo: TTitulo) : String;
begin
   Result:= BancoClass.MontarCodigoBarras(Titulo);
end;

function TBanco.MontarLinhaDigitavel ( const CodigoBarras:String; Titulo : TTitulo) : String;
begin
   Result:= BancoClass.MontarLinhaDigitavel(CodigoBarras, Titulo);
end;

procedure TBanco.GerarRegistroHeader400(NumeroRemessa: Integer; ARemessa:TStringList);
begin
  BancoClass.GerarRegistroHeader400( NumeroRemessa, ARemessa );
end;

function TBanco.GerarRegistroHeader240(NumeroRemessa: Integer): String;
begin
  Result :=  BancoClass.GerarRegistroHeader240( NumeroRemessa );
end;

procedure TBanco.GerarRegistroTransacao400(Titulo: TTitulo; aRemessa: TStringList);
begin
  BancoClass.GerarRegistroTransacao400( Titulo, aRemessa );
end;

function TBanco.GerarRegistroTransacao240(Titulo: TTitulo): String;
begin
  Result := BancoClass.GerarRegistroTransacao240( Titulo );
end;

procedure TBanco.GerarRegistroTrailler400(ARemessa: TStringList);
begin
  BancoClass.GerarRegistroTrailler400( ARemessa );
end;

function TBanco.GerarRegistroTrailler240(ARemessa: TStringList): String;
begin
 Result :=  BancoClass.GerarRegistroTrailler240( ARemessa );
end;

procedure TBanco.LerRetorno400(ARetorno: TStringList);
begin
   BancoClass.LerRetorno400(ARetorno);
end;

procedure TBanco.LerRetorno240(ARetorno: TStringList);
begin
   BancoClass.LerRetorno240(ARetorno);
end;

function TBanco.CalcularNomeArquivoRemessa : String;
begin
  Result:= BancoClass.CalcularNomeArquivoRemessa ;
end;

function TBanco.ValidarDadosRetorno(const AAgencia, AContaCedente: String; const ACNPJCPF: String= '';
       const AValidaCodCedente: Boolean= False ): Boolean;
begin
  Result:= BancoClass.ValidarDadosRetorno(AAgencia, AContaCedente, ACNPJCPF, AValidaCodCedente) ;
end;

function TBanco.MontarCampoCodigoCedente(
  const Titulo: TTitulo): String;
begin
  Result:= BancoClass.MontarCampoCodigoCedente(Titulo);
end;

{ TBancoClass }

constructor TBancoClass.create(AOwner: TBanco);
begin
   inherited create;

   FpAOwner                := AOwner;
   FpDigito                := 0;
   FpNome                  := 'Não definido';
   FpNumero                := 0;
   FpTamanhoMaximoNossoNum := 10;
   FpTamanhoAgencia        := 4;
   FpTamanhoConta          := 10;
   FpCodigosMoraAceitos    := '12';
   FpCodigosGeracaoAceitos := '0123456789';
   FpNumeroCorrespondente  := 0;
   FpLayoutVersaoArquivo   := 0;
   FpLayoutVersaoLote      := 0;
   FpModulo                := TCalcDigito.Create;
   FpOrientacoesBanco      := TStringList.Create;
end;

destructor TBancoClass.Destroy;
begin
   FpModulo.Free;
   FpOrientacoesBanco.Free;
   Inherited Destroy;
end;

procedure TBancoClass.GerarRegistroHeader400(NumeroRemessa: Integer;
  ARemessa: TStringList);
begin
  { Método implementado apenas para evitar Warnings de compilação (poderia ser abstrato)
    Você de Fazer "override" desse método em todas as classes Filhas de TBancoClass }
  ErroAbstract('GerarRemessa400');
end;

function TBancoClass.GerarRegistroHeader240 ( NumeroRemessa: Integer
   ) : String;
begin
  Result := '';
  ErroAbstract('GerarRemessa240');
end;

procedure TBancoClass.GerarRegistroTrailler400( ARemessa: TStringList);
begin
  { Método implementado apenas para evitar Warnings de compilação (poderia ser abstrato)
    Você de Fazer "override" desse método em todas as classes Filhas de TBancoClass }
end;

function TBancoClass.MontarCampoCodigoCedente(
  const Titulo: TTitulo): String;
begin
  Result := '';
end;

function TBancoClass.MontarCampoCarteira(const Titulo: TTitulo
  ): String;
begin
  Result := Titulo.Carteira;
end;

function TBancoClass.GerarRegistroTrailler240 ( ARemessa: TStringList
   ) : String;
begin
   Result:= '';
end;

procedure TBancoClass.LerRetorno400(ARetorno: TStringList);
begin
   ErroAbstract('LerRetorno400');
end;

procedure TBancoClass.LerRetorno240(ARetorno: TStringList);
begin
   ErroAbstract('LerRetorno240');
end;

procedure TBancoClass.GerarRegistroTransacao400(  Titulo: TTitulo; aRemessa: TStringList);
begin
  { Método implementado apenas para evitar Warnings de compilação (poderia ser abstrato)
    Você de Fazer "override" desse método em todas as classes Filhas de TBancoClass }
end;

function TBancoClass.GerarRegistroTransacao240 ( Titulo: TTitulo
   ) : String;
begin
   Result:= '';
end;

function TBancoClass.CalcularDigitoVerificador(const Titulo :TTitulo ): String;
begin
   Result:= '';
end;

function TBancoClass.CalcularTamMaximoNossoNumero(
  const Carteira: String; NossoNumero : String = ''; Convenio: String = ''): Integer;
begin
  Result := Banco.TamanhoMaximoNossoNum;
end;

function TBancoClass.TipoOcorrenciaToDescricao(
  const TipoOcorrencia : TTipoOcorrencia) : String ;
begin
  Result := '';
end ;

function TBancoClass.CodOcorrenciaToTipo(const CodOcorrencia : Integer
  ) : TTipoOcorrencia ;
begin
  Result := toRemessaRegistrar;
end ;

function TBancoClass.TipoOCorrenciaToCod(
  const TipoOcorrencia : TTipoOcorrencia) : String ;
begin
  Result := '';
end ;

function TBancoClass.CodMotivoRejeicaoToDescricao(
  const TipoOcorrencia : TTipoOcorrencia ; CodMotivo : Integer) : String ;
begin
  Result := '';
end ;

function TBancoClass.CodMotivoRejeicaoToDescricao(
const TipoOcorrencia: TTipoOcorrencia;CodMotivo: String): String;
begin
  Result := '';
end;

function TBancoClass.CodOcorrenciaToTipoRemessa(const CodOcorrencia : Integer
  ) : TTipoOcorrencia ;
begin
  Result := toRemessaRegistrar;
end ;

function TBancoClass.TipoOcorrenciaToCodRemessa(const TipoOcorrencia : TTipoOcorrencia
  ) : String ;
begin
  Result := '01';
end ;

{
 Function TBancoClass.GetNumero: Integer;
begin
   Result:= Banco.Numero;
end;
}
procedure TBancoClass.ErroAbstract(NomeProcedure: String);
begin
   raise Exception.Create(Format(Str('Função %s não implementada '+
                                         ' para o banco %s') + sLineBreak +
                                         'Ajude no desenvolvimento do ECF. '+ sLineBreak+
                                         'Acesse nosso Forum em: http://.sf.net/',[NomeProcedure,Nome])) ;
end;

function TBancoClass.GetLocalPagamento: String;
begin
  Result := Format(Str(CInstrucaoPagamento), [fpNome] );
end;

function TBancoClass.CalcularFatorVencimento(const DataVencimento: TDateTime
  ): String;
begin
   {** Padrão para vencimentos até 21/02/2025 **}
   //Result := IntToStrZero( Max(Trunc(DataVencimento - EncodeDate(1997,10,07)),0),4 );

  {** Padrão com suporte a datas superiores a 21/02/2025
      http://www.abbc.org.br/images/content/manual%20operacional.pdf **}
   if DataVencimento = 0 then
      Result := '0000'
   else
      Result := IntToStrZero(Max((Trunc(DataVencimento) -
                                  Trunc(EncodeDate(2000,07,03))) mod 9000 + 1000, 0), 4);
end;

function TBancoClass.CalcularDigitoCodigoBarras (
   const CodigoBarras: String ) : String;
begin
   Modulo.CalculoPadrao;
   Modulo.Documento := CodigoBarras;
   Modulo.Calcular;

   if (Modulo.DigitoFinal = 0) or (Modulo.DigitoFinal > 9) then
      Result := '1'
   else
      Result := IntToStr(Modulo.DigitoFinal);
end;

function TBancoClass.CalcularNomeArquivoRemessa : String;
var
  Sequencia :Integer;
  NomeFixo, NomeArq: String;
begin
   Sequencia := 0;

   with Banco.Boleto do
   begin
      if NomeArqRemessa = '' then
       begin
         NomeFixo := DirArqRemessa + PathDelim + 'cb' + FormatDateTime( 'ddmm', Now );

         repeat
            Inc( Sequencia );
            NomeArq := NomeFixo + IntToStrZero( Sequencia, 2 ) + '.rem'
         until not FileExists( NomeArq ) ;

         Result := NomeArq;
       end
      else
         Result := DirArqRemessa + PathDelim + NomeArqRemessa ;
   end;
end;

function TBancoClass.ValidarDadosRetorno(const AAgencia, AContaCedente: String;
   const ACNPJCPF: String= ''; const AValidaCodCedente: Boolean= False ): Boolean;
begin
  Result:= True;
  With Banco.Boleto do
  begin
    if NaoEstaVazio(ACNPJCPF) then
      if (not LeCedenteRetorno) and (ACNPJCPF <> OnlyNumber(Cedente.CNPJCPF)) then
      begin
        Result:= False;
        raise Exception.CreateFmt(Str('CNPJ\CPF: %s do arquivo não corresponde aos dados do Cedente!')
              ,[ACNPJCPF]);
      end;

    if NaoEstaVazio(AContaCedente) then
      if not AValidaCodCedente then
      begin
        if (not LeCedenteRetorno) and ((AAgencia <> OnlyNumber(Cedente.Agencia)) or
               (AContaCedente <> RightStr(OnlyNumber( Cedente.Conta  ),Length(AContaCedente)))) then
        begin
          Result:= False;
          raise Exception.CreateFmt(Str('Agencia: %s \ Conta: %s do arquivo não correspondem aos dados do Cedente!')
                ,[AAgencia,AContaCedente]);
        end
      end
      else
      begin
        if (not LeCedenteRetorno) and ((StrToIntDef(AAgencia,0) <> StrToIntDef(OnlyNumber(Cedente.Agencia),0)) or
               (StrToIntDef(AContaCedente,0) <> StrToIntDef(OnlyNumber( Cedente.CodigoCedente),0))) then
        begin
          Result:= False;
          raise Exception.CreateFmt(Str('Agencia: %s \ Conta: %s do arquivo não correspondem aos dados do Cedente!')
                ,[AAgencia,AContaCedente]);
        end;
      end;

  end;

end;

function TBancoClass.MontarCodigoBarras ( const Titulo: TTitulo) : String;
begin
   Result:= '';
end;

function TBancoClass.MontarCampoNossoNumero ( const Titulo: TTitulo
   ) : String;
begin
   Result:= Titulo.NossoNumero;
end;

function TBancoClass.MontarLinhaDigitavel (const CodigoBarras: String;Titulo : TTitulo): String;
var
  Campo1, Campo2, Campo3, Campo4, Campo5: String;
begin
   FpModulo.FormulaDigito        := FrModulo10;
   FpModulo.MultiplicadorInicial := 1;
   FpModulo.MultiplicadorFinal   := 2;
   FpModulo.MultiplicadorAtual   := 2;


  {Campo 1(Código Banco,Tipo de Moeda,5 primeiro digitos do Campo Livre) }
   FpModulo.Documento := Copy(CodigoBarras,1,3)+'9'+Copy(CodigoBarras,20,5);
   FpModulo.Calcular;

   Campo1 := copy( FpModulo.Documento, 1, 5) + '.' +
             copy( FpModulo.Documento, 6, 4) +
             IntToStr( FpModulo.DigitoFinal );

  {Campo 2(6ª a 15ª posições do campo Livre)}
   FpModulo.Documento:= copy( CodigoBarras, 25, 10);
   FpModulo.Calcular;

   Campo2 := Copy( FpModulo.Documento, 1, 5) + '.' +
             Copy( FpModulo.Documento, 6, 5) +
             IntToStr( FpModulo.DigitoFinal );

  {Campo 3 (16ª a 25ª posições do campo Livre)}
   FpModulo.Documento:= copy( CodigoBarras, 35, 10);
   FpModulo.Calcular;

   Campo3 := Copy( FpModulo.Documento, 1, 5) + '.' +
             Copy( FpModulo.Documento, 6, 5) +
             IntToStr( FpModulo.DigitoFinal );

  {Campo 4 (Digito Verificador Nosso Numero)}
   Campo4 := Copy( CodigoBarras, 5, 1);

  {Campo 5 (Fator de Vencimento e Valor do Documento)}
   Campo5 := Copy( CodigoBarras, 6, 14);

   Result := Campo1+' '+Campo2+' '+Campo3+' '+Campo4+' '+Campo5;
end;

function TBoleto.GerarRemessa( NumeroRemessa : Integer; TipoCobranca:TTipoCobranca) : String;
var
   SLRemessa   : TStringList;
   ContTitulos : Integer;
   NomeArq     : String ;
begin
   FBanco.TipoCobranca := TipoCobranca;
   FCedente      := TCedente.Create;//(nil);

   Result:= '';
   if ListadeBoletos.Count < 1 then
      raise Exception.Create(Str('Lista de Boletos está vazia'));

   ChecarDadosObrigatorios;

   if not DirectoryExists( DirArqRemessa ) then
      ForceDirectories( DirArqRemessa );

   if not DirectoryExists( DirArqRemessa ) then
      raise Exception.Create( Str('Diretório inválido:' + sLineBreak + DirArqRemessa) );

   if ( NomeArqRemessa = '' ) then
      NomeArq := Banco.CalcularNomeArquivoRemessa
   else
      NomeArq := DirArqRemessa + PathDelim + NomeArqRemessa;

   SLRemessa := TStringList.Create;
   try
      if LayoutRemessa = c400 then
      begin
         Banco.GerarRegistroHeader400( NumeroRemessa, SLRemessa );

         For ContTitulos:= 0 to ListadeBoletos.Count-1 do
            Banco.GerarRegistroTransacao400( ListadeBoletos[ContTitulos], SLRemessa);

         Banco.GerarRegistroTrailler400( SLRemessa );

      end
      else
      begin
        SLRemessa.Add( Banco.GerarRegistroHeader240( NumeroRemessa ) );

         For ContTitulos:= 0 to ListadeBoletos.Count-1 do
             SLRemessa.Add( Banco.GerarRegistroTransacao240( ListadeBoletos[ContTitulos] ) );

         SLRemessa.Add( Banco.GerarRegistroTrailler240( SLRemessa ) );
      end;
      SLRemessa.SaveToFile( NomeArq );
      Result:= NomeArq;
   Finally
      SLRemessa.Free;
   end;
end;

function TBoleto.GerarRemessa( NumeroRemessa : Integer ) : String;
var
   SLRemessa   : TStringList;
   ContTitulos : Integer;
   NomeArq     : String ;
begin
   Result:= '';
   if ListadeBoletos.Count < 1 then
      raise Exception.Create(Str('Lista de Boletos está vazia'));

   ChecarDadosObrigatorios;

   if not DirectoryExists( DirArqRemessa ) then
      ForceDirectories( DirArqRemessa );

   if not DirectoryExists( DirArqRemessa ) then
      raise Exception.Create( Str('Diretório inválido:' + sLineBreak + DirArqRemessa) );

   if ( NomeArqRemessa = '' ) then
      NomeArq := Self.Banco.CalcularNomeArquivoRemessa
   else
      NomeArq := DirArqRemessa + PathDelim + NomeArqRemessa;

   SLRemessa := TStringList.Create;
   try
      if LayoutRemessa = c400 then
      begin
         Banco.GerarRegistroHeader400( NumeroRemessa, SLRemessa );

         For ContTitulos:= 0 to ListadeBoletos.Count-1 do
            Banco.GerarRegistroTransacao400( ListadeBoletos[ContTitulos], SLRemessa);

         Banco.GerarRegistroTrailler400( SLRemessa );

      end
      else
      begin
        SLRemessa.Add( Banco.GerarRegistroHeader240( NumeroRemessa ) );

         For ContTitulos:= 0 to ListadeBoletos.Count-1 do
             SLRemessa.Add( Banco.GerarRegistroTransacao240( ListadeBoletos[ContTitulos] ) );

         SLRemessa.Add( Banco.GerarRegistroTrailler240( SLRemessa ) );
      end;
      SLRemessa.SaveToFile( NomeArq );
      Result:= NomeArq;
   Finally
      SLRemessa.Free;
   end;
end;

procedure TBoleto.LerRetorno(AStream: TStream);
var
  SlRetorno: TStringList;
  NomeArq  , BancoRetorno: String;
begin
   SlRetorno:= TStringList.Create;
   try
     Self.ListadeBoletos.Clear;

     if not Assigned(AStream) then 
     begin
       if NomeArqRetorno = '' then
         raise Exception.Create(Str('NomeArqRetorno deve ser informado.'));

       if not FileExists(NomeArqRetorno) then
         NomeArq := IncludeTrailingPathDelimiter(fDirArqRetorno) + NomeArqRetorno
       else
         NomeArq := NomeArqRetorno;

       if not FilesExists( NomeArq ) then
         raise Exception.Create(Str('Arquivo não encontrado:'+sLineBreak+NomeArq));

       SlRetorno.LoadFromFile( NomeArq );
     end
     else
     begin
       AStream.Position := 0;
       SlRetorno.LoadFromStream(AStream);
     end;

     if SlRetorno.Count < 1 then
        raise exception.Create(Str('O Arquivo de Retorno:'+sLineBreak+
                                       NomeArq + sLineBreak+
                                       'está vazio.'+sLineBreak+
                                       ' Não há dados para processar'));

     case Length(SlRetorno.Strings[0]) of
        240 :
          begin
            if Copy(SlRetorno.Strings[0],143,1) <> '2' then
              Raise Exception.Create( Str( NomeArq + sLineBreak +
                'Não é um arquivo de Retorno de cobrança com layout CNAB240') );

            BancoRetorno  := Copy(SlRetorno.Strings[0],0,3);
            LayoutRemessa := c240 ;
          end;

        400 :
          begin
             if (Copy(SlRetorno.Strings[0],1,9) <> '02RETORNO')   then
               Raise Exception.Create( Str( NomeArq + sLineBreak +
                 'Não é um arquivo de Retorno de cobrança com layout CNAB400'));

             BancoRetorno  := Copy(SlRetorno.Strings[0],77,3);
             LayoutRemessa := c400 ;
          end;
        else
          raise Exception.Create( Str( NomeArq + sLineBreak+
            'Não é um arquivo de  Retorno de cobrança CNAB240 ou CNAB400'));
     end;

     if ( IntToStrZero(Banco.Numero, 3) <> BancoRetorno )
        and ( IntToStrZero(Banco.NumeroCorrespondente, 3) <> BancoRetorno )  then
       if LeCedenteRetorno then
         Banco.TipoCobranca := GetTipoCobranca( StrToInt(BancoRetorno))
       else
         raise Exception.Create( Str( 'Arquivo de retorno de banco diferente do Cedente'));

     if LayoutRemessa = c240 then
        Banco.LerRetorno240(SlRetorno)
     else
        Banco.LerRetorno400(SlRetorno);

   Finally
     SlRetorno.Free;
   end;
end;

procedure TBoleto.ChecarDadosObrigatorios;
begin
  if Cedente.Nome = '' then
    Raise Exception.Create(Str('Nome do cedente não informado'));
  if Cedente.Conta = '' then
    Raise Exception.Create(Str('Conta não informada'));
  if (Cedente.ContaDigito = '') and (not (Banco.TipoCobranca in [cobBanestes,cobBanese])) then
    Raise Exception.Create(Str('Dígito da conta não informado'));
  if Cedente.Agencia = '' then
    Raise Exception.Create(Str('Agência não informada'));
  if (Cedente.AgenciaDigito = '') and (not (Banco.TipoCobranca in [cobBanestes, cobBanese, cobBanrisul, cobItau, cobCaixaEconomica, cobCaixaSicob])) then
    Raise Exception.Create(Str('Dígito da agência não informado'));
end;

function TBoleto.GetOcorrenciasRemessa(): TOcorrenciasRemessa;
var I: Integer;
begin
  SetLength(Result, 47);

  For I:= 1 to 47 do
  begin
    Result[I-1].Tipo := TTipoOcorrencia(I-1);
    Result[I-1].descricao := cTipoOcorrenciaDecricao[I-1];
  end;
end;

function TBoleto.GetTipoCobranca(NumeroBanco: Integer): TTipoCobranca;
begin
  case NumeroBanco of
    001: Result := cobBancoDoBrasil;
    003: Result := cobBancoDaAmazonia;
    004: Result := cobBancoDoNordeste;
    008,033,353: Result := cobSantander;
    021: Result := cobBanestes;
    041: Result := cobBanrisul;
    070: Result := cobBRB;
    091: Result := cobUnicredRS;
    097: Result := cobCrediSIS;
    099: Result := cobUniprime;
    104: Result := cobCaixaEconomica;
    136: Result := cobUnicredES;
    237: Result := cobBradesco;
    341: Result := cobItau;
    389: Result := cobBancoMercantil;
    748: Result := cobSicred;
    756: Result := cobBancoob;
    399: Result := cobHSBC;
    422: Result := cobSafraBradesco;
    085: Result := cobBancoCECRED;
    047: Result := cobBanese;
  else
    raise Exception.Create('Erro ao configurar o tipo de cobrança.'+
      sLineBreak+'Número do Banco inválido: '+IntToStr(NumeroBanco));
  end;
end;

function TBoleto.LerArqIni(const AIniBoletos: String): Boolean;
var
  IniBoletos : TMemIniFile ;
  Titulo : TTitulo;
  wTipoInscricao, wRespEmissao, wLayoutBoleto: Integer;
  wNumeroBanco, wIndice, wCNAB: Integer;
  wLocalPagto, MemFormatada: String;
  Sessao, sFim: String;
  I: Integer;
begin
  Result   := False;

  IniBoletos := TMemIniFile.Create('');
  try
    LerIniArquivoOuString(AIniBoletos, IniBoletos);

    with Self.Cedente do
    begin
      //Cedente
      if IniBoletos.SectionExists('Cedente') then
      begin
        wTipoInscricao := IniBoletos.ReadInteger(CCedente,'TipoPessoa',2);
        try
           Cedente.TipoInscricao := TPessoa( wTipoInscricao ) ;
        except
           Cedente.TipoInscricao := pJuridica ;
        end ;

        Nome          := IniBoletos.ReadString(CCedente,'Nome',Nome);
        CNPJCPF       := IniBoletos.ReadString(CCedente,'CNPJCPF',CNPJCPF);
        Logradouro    := IniBoletos.ReadString(CCedente,'Logradouro',Logradouro);
        NumeroRes     := IniBoletos.ReadString(CCedente,'Numero',NumeroRes);
        Bairro        := IniBoletos.ReadString(CCedente,'Bairro',Bairro);
        Cidade        := IniBoletos.ReadString(CCedente,'Cidade',Cidade);
        CEP           := IniBoletos.ReadString(CCedente,'CEP',CEP);
        Complemento   := IniBoletos.ReadString(CCedente,'Complemento',Complemento);
        UF            := IniBoletos.ReadString(CCedente,'UF',UF);
        CodigoCedente := IniBoletos.ReadString(CCedente,'CodigoCedente',CodigoCedente);
        Modalidade    := IniBoletos.ReadString(CCedente,'MODALIDADE',Modalidade);
        CodigoTransmissao:= IniBoletos.ReadString(CCedente,'CODTRANSMISSAO',CodigoTransmissao);
        Convenio      := IniBoletos.ReadString(CCedente,'CONVENIO',Convenio);
        CaracTitulo  := TCaracTitulo(IniBoletos.ReadInteger(CCedente,'CaracTitulo',Integer(CaracTitulo) ));
        TipoCarteira := TTipoCarteira(IniBoletos.ReadInteger(CCedente,'TipoCarteira', Integer(TipoCarteira) ));
        TipoDocumento:= TTipoDocumento(IniBoletos.ReadInteger(CCedente,'TipoDocumento',Integer(TipoDocumento) ));

        wLayoutBoleto:= IniBoletos.ReadInteger(CCedente,'LAYOUTBOL', Integer(Self.BoletoFC.LayOut) );
        Self.BoletoFC.LayOut  := TBolLayOut(wLayoutBoleto);

        wRespEmissao := IniBoletos.ReadInteger(CCedente,'RespEmis', Integer(ResponEmissao) );
        try
          ResponEmissao := TResponEmissao( wRespEmissao );
        except
          ResponEmissao := tbCliEmite ;
        end ;

        Result   := True;
      end;

      //Banco
      if IniBoletos.SectionExists('Banco') then
      begin
        wNumeroBanco := IniBoletos.ReadInteger(CBanco,'Numero', 0 );
        wIndice  := IniBoletos.ReadInteger(CBanco,'Indice', 0 );
        wCNAB        := IniBoletos.ReadInteger(CBanco,'CNAB', Integer(LayoutRemessa) );

        if ( wCNAB = 0 ) then
           LayoutRemessa := c240
        else
           LayoutRemessa := c400;

        if ( wIndice > 0 ) then
          Banco.TipoCobranca:= TTipoCobranca(wIndice)
        else if ( wNumeroBanco > 0 ) then
          Banco.TipoCobranca := GetTipoCobranca(wNumeroBanco);

        if (trim(Banco.Nome) = 'Não definido') then
           raise exception.Create('Banco não definido ou não '+
                                  'implementado no Boleto!');

        Result := True;
      end;

      //Conta
      if IniBoletos.SectionExists('Conta') then
      begin
        Conta         := IniBoletos.ReadString(CConta,'Conta', Conta);
        ContaDigito   := IniBoletos.ReadString(CConta,'DigitoConta', ContaDigito);
        Agencia       := IniBoletos.ReadString(CConta,'Agencia', Agencia);
        AgenciaDigito := IniBoletos.ReadString(CConta,'DigitoAgencia', AgenciaDigito);
        DigitoVerificadorAgenciaConta := IniBoletos.ReadString(CConta,'DigitoVerificadorAgenciaConta',
                                      DigitoVerificadorAgenciaConta );

        Result := True;
      end;

    end;

    if (IniBoletos.SectionExists('Titulo')) or (IniBoletos.SectionExists('Titulo1')) then
    begin
      with Self do
      begin
        //Titulo
        if (trim(Banco.Nome) = 'Não definido') then
                raise exception.Create('Banco não definido ou não '+
                                       'implementado no Boleto!');

        I := 1 ;
        while true do
        begin
          Sessao := 'Titulo' + IntToStr(I);
          sFim   := IniBoletos.ReadString(Sessao,'NumeroDocumento','FIM');

          if (sFim = 'FIM') and (Sessao = 'Titulo1')  then
          begin
            Sessao := 'Titulo';
            sFim   := IniBoletos.ReadString(Sessao,'NumeroDocumento','FIM');
          end;

          if (sFim = 'FIM')  then
            break ;

          Titulo := CriarTituloNaLista;

          MemFormatada := IniBoletos.ReadString(Sessao,'Mensagem','') ;
          MemFormatada := StringReplace( MemFormatada,'|',sLineBreak, [rfReplaceAll] );
          with Titulo do
          begin
            Aceite        := TAceiteTitulo(IniBoletos.ReadInteger(Sessao,'Aceite',1));
            Sacado.Pessoa := TPessoa( IniBoletos.ReadInteger(Sessao,'Sacado.Pessoa',2) );
            Sacado.Pessoa := TPessoa( IniBoletos.ReadInteger(Sessao,'Sacado.Pessoa',2) );
            OcorrenciaOriginal.Tipo := TTipoOcorrencia(
                  IniBoletos.ReadInteger(Sessao,'OcorrenciaOriginal.TipoOcorrencia',0) ) ;
            TipoDiasProtesto := TTipoDiasIntrucao(IniBoletos.ReadInteger(Sessao,'TipoDiasProtesto',0));
            TipoImpressao := TTipoImpressao(IniBoletos.ReadInteger(Sessao,'TipoImpressao',1));
            TipoDesconto := TTipoDesconto(IniBoletos.ReadInteger(Sessao,'TipoDesconto',0));
            TipoDesconto2 := TTipoDesconto(IniBoletos.ReadInteger(Sessao,'TipoDesconto2',0));
            MultaValorFixo := IniBoletos.ReadBool(Sessao,'MultaValorFixo',False);

            wLocalPagto := IniBoletos.ReadString(Sessao,'LocalPagamento','');

            Vencimento          := StrToDateDef(Trim(IniBoletos.ReadString(Sessao,'Vencimento','')), now);
            DataDocumento       := StrToDateDef(Trim(IniBoletos.ReadString(Sessao,'DataDocumento','')),now);
            DataProcessamento   := StrToDateDef(Trim(IniBoletos.ReadString(Sessao,'DataProcessamento','')),now);
            DataAbatimento      := StrToDateDef(Trim(IniBoletos.ReadString(Sessao,'DataAbatimento','')),0);
            DataDesconto        := StrToDateDef(Trim(IniBoletos.ReadString(Sessao,'DataDesconto','')),0);
            DataMoraJuros       := StrToDateDef(Trim(IniBoletos.ReadString(Sessao,'DataMoraJuros','')),0);
  	    DataMulta           := StrToDateDef(Trim(IniBoletos.ReadString(Sessao,'DataMulta','')),0);
            DiasDeProtesto      := IniBoletos.ReadInteger(Sessao,'DiasDeProtesto',0);
            if (DiasDeProtesto = 0) then
              DataProtesto        := StrToDateDef(Trim(IniBoletos.ReadString(Sessao,'DataProtesto','')),0);
            DataBaixa           := StrToDateDef(Trim(IniBoletos.ReadString(Sessao,'DataBaixa','')),0);
            DataLimitePagto     := StrToDateDef(Trim(IniBoletos.ReadString(Sessao,'DataLimitePagto','')),0);
            LocalPagamento      := IfThen(Trim(wLocalPagto) <> '',wLocalPagto,LocalPagamento);
            NumeroDocumento     := IniBoletos.ReadString(Sessao,'NumeroDocumento',NumeroDocumento);
            EspecieDoc          := IniBoletos.ReadString(Sessao,'Especie',EspecieDoc);
            Carteira            := trim(IniBoletos.ReadString(Sessao,'Carteira',''));
            NossoNumero         := IniBoletos.ReadString(Sessao,'NossoNumero','');
            ValorDocumento      := IniBoletos.ReadFloat(Sessao,'ValorDocumento',ValorDocumento);
            Sacado.NomeSacado   := IniBoletos.ReadString(Sessao,'Sacado.NomeSacado','');
            Sacado.CNPJCPF      := OnlyNumber(IniBoletos.ReadString(Sessao,'Sacado.CNPJCPF',''));
            Sacado.Logradouro   := IniBoletos.ReadString(Sessao,'Sacado.Logradouro','');
            Sacado.Numero       := IniBoletos.ReadString(Sessao,'Sacado.Numero','');
            Sacado.Bairro       := IniBoletos.ReadString(Sessao,'Sacado.Bairro','');
            Sacado.Complemento  := IniBoletos.ReadString(Sessao,'Sacado.Complemento','');
            Sacado.Cidade       := IniBoletos.ReadString(Sessao,'Sacado.Cidade','');
            Sacado.UF           := IniBoletos.ReadString(Sessao,'Sacado.UF','');
            Sacado.CEP          := OnlyNumber(IniBoletos.ReadString(Sessao,'Sacado.CEP',''));
            Sacado.Email        := IniBoletos.ReadString(Sessao,'Sacado.Email',Sacado.Email);
            EspecieMod          := IniBoletos.ReadString(Sessao,'EspecieMod',EspecieMod);
            Mensagem.Text       := MemFormatada;
            Instrucao1          := PadLeft(IniBoletos.ReadString(Sessao,'Instrucao1',Instrucao1),2);
            Instrucao2          := PadLeft(IniBoletos.ReadString(Sessao,'Instrucao2',Instrucao2),2);
            TotalParcelas       := IniBoletos.ReadInteger(Sessao,'TotalParcelas',TotalParcelas);
            Parcela             := IniBoletos.ReadInteger(Sessao,'Parcela',Parcela);
            ValorAbatimento     := IniBoletos.ReadFloat(Sessao,'ValorAbatimento',ValorAbatimento);
            ValorDesconto       := IniBoletos.ReadFloat(Sessao,'ValorDesconto',ValorDesconto);
            ValorMoraJuros      := IniBoletos.ReadFloat(Sessao,'ValorMoraJuros',ValorMoraJuros);
            ValorIOF            := IniBoletos.ReadFloat(Sessao,'ValorIOF',ValorIOF);
            ValorOutrasDespesas := IniBoletos.ReadFloat(Sessao,'ValorOutrasDespesas',ValorOutrasDespesas);
            SeuNumero           := IniBoletos.ReadString(Sessao,'SeuNumero',SeuNumero);
            PercentualMulta     := IniBoletos.ReadFloat(Sessao,'PercentualMulta',PercentualMulta);
            CodigoMora          := IniBoletos.ReadString(Sessao,'CodigoMora','1');
            CodigoGeracao       := IniBoletos.ReadString(Sessao,'CodigoGeracao','2');
            Sacado.SacadoAvalista.NomeAvalista  := IniBoletos.ReadString(Sessao,'Sacado.SacadoAvalista.NomeAvalista','');
            Sacado.SacadoAvalista.CNPJCPF       := IniBoletos.ReadString(Sessao,'Sacado.SacadoAvalista.CNPJCPF','');
            Sacado.SacadoAvalista.Logradouro    := IniBoletos.ReadString(Sessao,'Sacado.SacadoAvalista.Logradouro','');
            Sacado.SacadoAvalista.Numero        := IniBoletos.ReadString(Sessao,'Sacado.SacadoAvalista.Numero','');
            Sacado.SacadoAvalista.Complemento   := IniBoletos.ReadString(Sessao,'Sacado.SacadoAvalista.Complemento','');
            Sacado.SacadoAvalista.Bairro        := IniBoletos.ReadString(Sessao,'Sacado.SacadoAvalista.Bairro','');
            Sacado.SacadoAvalista.Cidade        := IniBoletos.ReadString(Sessao,'Sacado.SacadoAvalista.Cidade','');
            Sacado.SacadoAvalista.UF            := IniBoletos.ReadString(Sessao,'Sacado.SacadoAvalista.UF','');
            Sacado.SacadoAvalista.CEP           := IniBoletos.ReadString(Sessao,'Sacado.SacadoAvalista.CEP','');
            Sacado.SacadoAvalista.Email         := IniBoletos.ReadString(Sessao,'Sacado.SacadoAvalista.Email','');
            Sacado.SacadoAvalista.Fone          := IniBoletos.ReadString(Sessao,'Sacado.SacadoAvalista.Fone','');
            Sacado.SacadoAvalista.InscricaoNr   := IniBoletos.ReadString(Sessao,'Sacado.SacadoAvalista.InscricaoNr','');
          end;

          inc(I);
          Result := True;
        end;
      end;
    end;

  Finally
    IniBoletos.free;
  end;

end;

procedure TBoleto.GravarArqIni(DirIniRetorno, NomeArquivo: String);
var
  IniRetorno: TMemIniFile;
  wSessao: String;
  I: Integer;
  J: Integer;
begin
  if Pos(PathDelim,DirIniRetorno) <> Length(DirIniRetorno) then
     DirIniRetorno:= DirIniRetorno + PathDelim;

  IniRetorno:= TMemIniFile.Create(DirIniRetorno + IfThen( EstaVazio(NomeArquivo), 'Retorno.ini', NomeArquivo ) );
  try
    with Self do
    begin
       IniRetorno.WriteString(CCedente,'Nome',Cedente.Nome);
       IniRetorno.WriteString(CCedente,'CNPJCPF',Cedente.CNPJCPF);
       IniRetorno.WriteString(CCedente,'CodigoCedente',Cedente. CodigoCedente);
       IniRetorno.WriteString(CCedente,'MODALIDADE',Cedente.Modalidade);
       IniRetorno.WriteString(CCedente,'CODTRANSMISSAO',Cedente.CodigoTransmissao);
       IniRetorno.WriteString(CCedente,'CONVENIO',Cedente.Convenio);

       IniRetorno.WriteInteger(CBanco,'Numero',Banco.Numero);
       IniRetorno.WriteInteger(CBanco,'Indice',Integer(Banco.TipoCobranca));

       IniRetorno.WriteString(CConta,'Conta',Cedente.Conta);
       IniRetorno.WriteString(CConta,'DigitoConta',Cedente.ContaDigito);
       IniRetorno.WriteString(CConta,'Agencia',Cedente.Agencia);
       IniRetorno.WriteString(CConta,'DigitoAgencia',Cedente.AgenciaDigito);
       IniRetorno.WriteString(CConta,'DigitoVerificadorAgenciaConta',Cedente.DigitoVerificadorAgenciaConta);

       For I:= 0 to ListadeBoletos.Count - 1 do
       begin
         wSessao:= 'Titulo'+ IntToStr(I+1);
         IniRetorno.WriteString(wSessao,'Sacado.Nome', ListadeBoletos[I].Sacado.NomeSacado);
         IniRetorno.WriteString(wSessao,'Sacado.CNPJCPF', ListadeBoletos[I].Sacado.CNPJCPF);
         IniRetorno.WriteString(wSessao,'Vencimento',DateToStr(ListadeBoletos[I].Vencimento));
         IniRetorno.WriteString(wSessao,'DataDocumento',DateToStr(ListadeBoletos[I].DataDocumento));
         IniRetorno.WriteString(wSessao,'NumeroDocumento',ListadeBoletos[I].NumeroDocumento);
         IniRetorno.WriteString(wSessao,'DataProcessamento',DateToStr(ListadeBoletos[I].DataProcessamento));
         IniRetorno.WriteString(wSessao,'NossoNumero',ListadeBoletos[I].NossoNumero);
         IniRetorno.WriteString(wSessao,'Carteira',ListadeBoletos[I].Carteira);
         IniRetorno.WriteFloat(wSessao,'ValorDocumento',ListadeBoletos[I].ValorDocumento);
         IniRetorno.WriteString(wSessao,'DataOcorrencia',DateToStr(ListadeBoletos[I].DataOcorrencia));
         IniRetorno.WriteString(wSessao,'DataCredito',DateToStr(ListadeBoletos[I].DataCredito));
         IniRetorno.WriteString(wSessao,'DataBaixa',DateToStr(ListadeBoletos[I].DataBaixa));
         IniRetorno.WriteString(wSessao,'DataMoraJuros',DateToStr(ListadeBoletos[I].DataMoraJuros));
         IniRetorno.WriteFloat(wSessao,'ValorDespesaCobranca',ListadeBoletos[I].ValorDespesaCobranca);
         IniRetorno.WriteFloat(wSessao,'ValorAbatimento',ListadeBoletos[I].ValorAbatimento);
         IniRetorno.WriteFloat(wSessao,'ValorDesconto',ListadeBoletos[I].ValorDesconto);
         IniRetorno.WriteFloat(wSessao,'ValorMoraJuros',ListadeBoletos[I].ValorMoraJuros);
         IniRetorno.WriteFloat(wSessao,'ValorIOF',ListadeBoletos[I].ValorIOF);
         IniRetorno.WriteFloat(wSessao,'ValorOutrasDespesas',ListadeBoletos[I].ValorOutrasDespesas);
         IniRetorno.WriteFloat(wSessao,'ValorOutrosCreditos',ListadeBoletos[I].ValorOutrosCreditos);
         IniRetorno.WriteFloat(wSessao,'ValorRecebido',ListadeBoletos[I].ValorRecebido);
         IniRetorno.WriteString(wSessao,'SeuNumero',ListadeBoletos[I].SeuNumero);
         IniRetorno.WriteString(wSessao,'CodTipoOcorrencia',
                                GetEnumName( TypeInfo(TTipoOcorrencia),
                                             Integer(ListadeBoletos[I].OcorrenciaOriginal.Tipo)));
         IniRetorno.WriteString(wSessao,'DescricaoTipoOcorrencia',ListadeBoletos[I].OcorrenciaOriginal.Descricao);

         For J:= 0 to ListadeBoletos[I].DescricaoMotivoRejeicaoComando.Count-1 do
            IniRetorno.WriteString(wSessao,'MotivoRejeicao' + IntToStr(I+1),
                                   ListadeBoletos[I].DescricaoMotivoRejeicaoComando[J]);
       end;

    end;

  Finally
    IniRetorno.Free;
  end;

end;

{ TBoletoFCClass }

constructor TBoletoFCClass.Create;
begin
   inherited Create;

   FpAbout           := 'BoletoFCClass' ;
   FBoleto       := nil;
   FLayOut           := lPadrao;
   FNumCopias        := 1;
   FMostrarPreview   := True;
   FMostrarSetup     := True;
   FMostrarProgresso := True;
   FFiltro           := FiNenhum;
   FNomeArquivo      := '' ;
   FPrinterName      := '' ;
end;

function TBoletoFCClass.TituloRelatorio: String;
begin
  Result := 'Boleto - '+Boleto.Banco.Nome+
            ' Ag:'+Boleto.Cedente.Agencia+'-'+Boleto.Cedente.AgenciaDigito+
            ' Conta:'+Boleto.Cedente.Conta+'-'+Boleto.Cedente.ContaDigito;
end;

procedure TBoletoFCClass.CarregaLogo(const PictureLogo : TPicture; const NumeroBanco: Integer ) ;
begin
  if Assigned( FOnObterLogo ) then
     FOnObterLogo( PictureLogo, NumeroBanco)
  else
   begin
     if FileExists( ArquivoLogo ) then
        PictureLogo.LoadFromFile( ArquivoLogo );
   end ;
end ;

procedure TBoletoFCClass.SetBoleto ( const Value: TBoleto ) ;
  Var OldValue : TBoleto ;
begin
  if Value <> FBoleto then
  begin
     OldValue    := FBoleto ;   // Usa outra variavel para evitar Loop Infinito
     FBoleto := Value;          // na remoção da associação dos componentes

     if Assigned(OldValue) then
        if Assigned(OldValue.BoletoFC) then
           OldValue.BoletoFC := nil ;

     if Value <> nil then
     begin
        Value.BoletoFC := self ;
     end ;
  end ;

end;

procedure TBoletoFCClass.SetDirLogo(const AValue: String);
begin
  FDirLogo := AValue;//PathWithoutDelim( AValue );
end;

function TBoletoFCClass.GetArqLogo: String;
begin
   Result := DirLogo + PathDelim + IntToStrZero( Boleto.Banco.Numero, 3)+'.bmp';
end;

function TBoletoFCClass.GetAbout: String;
begin
  Result := FpAbout ;
end;

function TBoletoFCClass.GetDirLogo: String;
begin
//  if FDirLogo = '' then
//        FDirLogo := ExtractFilePath( ParamStr(0) ) + 'Logos' ;

  Result := FDirLogo ;
end;

function TBoletoFCClass.GetNomeArquivo: String;
var
  wPath: String;
begin
   wPath  := ExtractFilePath(fNomeArquivo);
   Result := '';

   if wPath = '' then
         Result := ExtractFilePath(ParamStr(0)) ;

   Result := trim(Result + FNomeArquivo);
end;

procedure TBoletoFCClass.SetAbout(const AValue: String);
begin
  {}
end;

procedure TBoletoFCClass.SetNumCopias ( AValue: Integer ) ;
begin
  FNumCopias := max( 1, Avalue);
end;

procedure TBoletoFCClass.Imprimir;
begin
   if not Assigned(fBoleto) then
      raise Exception.Create(Str('Componente não está associado a Boleto'));

   if FBoleto.ListadeBoletos.Count < 1 then
      raise Exception.Create(Str('Lista de Boletos está vazia'));
end;

procedure TBoletoFCClass.GerarPDF;
var
   FiltroAntigo         : TBoletoFCFiltro;
   MostrarPreviewAntigo : Boolean;
   MostrarSetupAntigo   : Boolean;
   PrinterNameAntigo    : String;
begin
   if NomeArquivo = '' then
      raise Exception.Create( Str('NomeArquivo não especificado')) ;

   if ExtractFileName(NomeArquivo) = '' then
     NomeArquivo := PathWithDelim(NomeArquivo) + 'boleto.pdf';

   FiltroAntigo         := Filtro;
   MostrarPreviewAntigo := MostrarPreview;
   MostrarSetupAntigo   := MostrarSetup;
   PrinterNameAntigo    := PrinterName;
   try
     Filtro         := FiPDF;
     MostrarPreview := False;
     MostrarSetup   := False;
     PrinterName    := '';
     Imprimir;
   Finally
     Filtro         := FiltroAntigo;
     MostrarPreview := MostrarPreviewAntigo;
     MostrarSetup   := MostrarSetupAntigo;
     PrinterName    := PrinterNameAntigo;
   end;
end;

procedure TBoletoFCClass.GerarHTML;
var
   FiltroAntigo         : TBoletoFCFiltro;
   MostrarPreviewAntigo : Boolean;
   MostrarSetupAntigo   : Boolean;
   PrinterNameAntigo    : String;
begin
   if NomeArquivo = '' then
      raise Exception.Create( Str('NomeArquivo não especificado')) ;

   FiltroAntigo         := Filtro;
   MostrarPreviewAntigo := MostrarPreview;
   MostrarSetupAntigo   := MostrarSetup;
   PrinterNameAntigo    := PrinterName;
   try
     Filtro         := FiHTML;
     MostrarPreview := False;
     MostrarSetup   := False;
     PrinterName    := '';
     Imprimir;
   Finally
     Filtro         := FiltroAntigo;
     MostrarPreview := MostrarPreviewAntigo;
     MostrarSetup   := MostrarSetupAntigo;
     PrinterName    := PrinterNameAntigo;
   end;
end;

procedure TBoletoFCClass.GerarJPG;
var
   FiltroAntigo         : TBoletoFCFiltro;
   MostrarPreviewAntigo : Boolean;
   MostrarSetupAntigo   : Boolean;
   PrinterNameAntigo    : String;
begin
   if NomeArquivo = '' then
      raise Exception.Create( Str('NomeArquivo não especificado')) ;

   FiltroAntigo         := Filtro;
   MostrarPreviewAntigo := MostrarPreview;
   MostrarSetupAntigo   := MostrarSetup;
   PrinterNameAntigo    := PrinterName;
   try
     Filtro         := FiJPG;
     MostrarPreview := False;
     MostrarSetup   := False;
     PrinterName    := '';
     Imprimir;
   Finally
     Filtro         := FiltroAntigo;
     MostrarPreview := MostrarPreviewAntigo;
     MostrarSetup   := MostrarSetupAntigo;
     PrinterName    := PrinterNameAntigo;
   end;
end;

{ TOcorrencia }

function TOcorrencia.GetCodigoBanco: String;
begin
   Result:= FpAowner.Boleto.Banco.TipoOCorrenciaToCod(Tipo);
end;

function TOcorrencia.GetDescricao: String;
begin
   //if Tipo <> 0 then
      Result:= FpAowner.Boleto.Banco.TipoOcorrenciaToDescricao(Tipo)
   //else
   //   Result:= '';
end;

constructor TOcorrencia.Create(AOwner: TTitulo);
begin
   FTipo := toRemessaRegistrar;
   FpAOwner:= AOwner;
end;

initialization


end.

