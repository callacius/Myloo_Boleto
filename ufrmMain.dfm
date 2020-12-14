object frmMain: TfrmMain
  Left = 288
  Top = 133
  Caption = 'Samples[Boleto]'
  ClientHeight = 813
  ClientWidth = 804
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 9
    Top = 305
    Width = 785
    Height = 63
    Caption = 'Informa'#231#245'es Sobre a Cobran'#231'a'
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 16
      Width = 177
      Height = 13
      Caption = 'Mensagem para Local de Pagamento'
    end
    object Label2: TLabel
      Left = 383
      Top = 16
      Width = 70
      Height = 13
      Caption = 'Esp'#233'cie Docto'
    end
    object Label3: TLabel
      Left = 463
      Top = 16
      Width = 74
      Height = 13
      Caption = 'Esp'#233'cie Moeda'
    end
    object Label4: TLabel
      Left = 544
      Top = 16
      Width = 30
      Height = 13
      Caption = 'Aceite'
    end
    object Label5: TLabel
      Left = 624
      Top = 16
      Width = 36
      Height = 13
      Caption = 'Carteira'
    end
    object Label6: TLabel
      Left = 672
      Top = 16
      Width = 70
      Height = 13
      Caption = 'Nosso N'#250'mero'
    end
    object edtLocalPag: TEdit
      Left = 8
      Top = 32
      Width = 369
      Height = 21
      TabOrder = 0
      Text = 'Pagar prefer'#234'ncialmente nas ag'#234'ncias do Bradesco'
    end
    object edtEspecieDoc: TEdit
      Left = 383
      Top = 32
      Width = 73
      Height = 21
      TabOrder = 1
      Text = 'DM'
    end
    object edtEspecieMod: TEdit
      Left = 463
      Top = 32
      Width = 76
      Height = 21
      TabOrder = 2
      Text = '$'
    end
    object cbxAceite: TComboBox
      Left = 544
      Top = 32
      Width = 73
      Height = 21
      TabOrder = 3
      Text = 'Sim'
      Items.Strings = (
        'Sim'
        'N'#227'o')
    end
    object edtCarteira: TEdit
      Left = 624
      Top = 32
      Width = 41
      Height = 21
      TabOrder = 4
      Text = '09'
    end
    object edtNossoNro: TEdit
      Left = 672
      Top = 32
      Width = 105
      Height = 21
      TabOrder = 5
      Text = '1'
    end
  end
  object GroupBox2: TGroupBox
    Left = 9
    Top = 374
    Width = 609
    Height = 105
    Caption = 'Acr'#233'scimos\Descontos'
    TabOrder = 1
    object Label7: TLabel
      Left = 8
      Top = 16
      Width = 78
      Height = 13
      Caption = 'ValorMora\Juros'
    end
    object Label8: TLabel
      Left = 162
      Top = 16
      Width = 73
      Height = 13
      Caption = 'Valor Desconto'
    end
    object Label9: TLabel
      Left = 316
      Top = 16
      Width = 80
      Height = 13
      Caption = 'Valor Abatimento'
    end
    object Label10: TLabel
      Left = 466
      Top = 16
      Width = 37
      Height = 13
      Caption = '% Multa'
    end
    object Label11: TLabel
      Left = 8
      Top = 56
      Width = 83
      Height = 13
      Caption = 'Data Multa_Juros'
    end
    object Label12: TLabel
      Left = 162
      Top = 56
      Width = 72
      Height = 13
      Caption = 'Data Desconto'
    end
    object Label13: TLabel
      Left = 316
      Top = 56
      Width = 79
      Height = 13
      Caption = 'Data Abatimento'
    end
    object Label14: TLabel
      Left = 466
      Top = 56
      Width = 65
      Height = 13
      Caption = 'Data Protesto'
    end
    object edtMoraJuros: TEdit
      Left = 8
      Top = 32
      Width = 135
      Height = 21
      TabOrder = 0
      Text = '5'
    end
    object edtValorDesconto: TEdit
      Left = 162
      Top = 32
      Width = 135
      Height = 21
      TabOrder = 1
      Text = '0'
    end
    object edtValorAbatimento: TEdit
      Left = 316
      Top = 32
      Width = 135
      Height = 21
      TabOrder = 2
      Text = '0'
    end
    object edtMulta: TEdit
      Left = 466
      Top = 32
      Width = 135
      Height = 21
      TabOrder = 3
      Text = '5'
    end
    object edtDataMora: TMaskEdit
      Left = 8
      Top = 72
      Width = 135
      Height = 21
      EditMask = '!99/99/00;1;_'
      MaxLength = 8
      TabOrder = 4
      Text = '  /  /  '
    end
    object edtDataDesconto: TMaskEdit
      Left = 162
      Top = 72
      Width = 135
      Height = 21
      EditMask = '!99/99/00;1;_'
      MaxLength = 8
      TabOrder = 5
      Text = '  /  /  '
    end
    object edtDataAbatimento: TMaskEdit
      Left = 316
      Top = 72
      Width = 135
      Height = 21
      EditMask = '!99/99/00;1;_'
      MaxLength = 8
      TabOrder = 6
      Text = '  /  /  '
    end
    object edtDataProtesto: TMaskEdit
      Left = 466
      Top = 72
      Width = 135
      Height = 21
      EditMask = '!99/99/00;1;_'
      MaxLength = 8
      TabOrder = 7
      Text = '  /  /  '
    end
  end
  object GroupBox3: TGroupBox
    Left = 9
    Top = 486
    Width = 609
    Height = 117
    Caption = 'Mensagens \ Instru'#231#245'es'
    TabOrder = 2
    object Label15: TLabel
      Left = 320
      Top = 16
      Width = 53
      Height = 13
      Caption = 'Instru'#231#227'o 1'
    end
    object Label16: TLabel
      Left = 464
      Top = 16
      Width = 53
      Height = 13
      Caption = 'Instru'#231#227'o 2'
    end
    object memMensagem: TMemo
      Left = 8
      Top = 16
      Width = 305
      Height = 90
      Lines.Strings = (
        '')
      TabOrder = 0
    end
    object edtInstrucoes1: TEdit
      Left = 320
      Top = 32
      Width = 137
      Height = 21
      TabOrder = 1
    end
    object edtInstrucoes2: TEdit
      Left = 464
      Top = 32
      Width = 137
      Height = 21
      TabOrder = 2
    end
    object Panel2: TPanel
      Left = 320
      Top = 64
      Width = 281
      Height = 41
      Caption = '* Informar o C'#243'digo do Instru'#231#227'o'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 3
    end
  end
  object GroupBox4: TGroupBox
    Left = 625
    Top = 374
    Width = 169
    Height = 229
    Caption = 'Informa'#231#245'es Sobre a Duplicata '
    TabOrder = 3
    object Label17: TLabel
      Left = 8
      Top = 16
      Width = 40
      Height = 13
      Caption = 'N'#250'mero '
    end
    object Label18: TLabel
      Left = 8
      Top = 58
      Width = 24
      Height = 13
      Caption = 'Valor'
    end
    object Label19: TLabel
      Left = 8
      Top = 99
      Width = 65
      Height = 13
      Caption = 'Data Emiss'#227'o'
    end
    object Label20: TLabel
      Left = 8
      Top = 141
      Width = 56
      Height = 13
      Caption = 'Vencimento'
    end
    object Label32: TLabel
      Left = 8
      Top = 182
      Width = 66
      Height = 13
      Caption = 'Carteira Envio'
    end
    object edtNumeroDoc: TEdit
      Left = 8
      Top = 32
      Width = 153
      Height = 21
      TabOrder = 0
      Text = '0000000001'
    end
    object edtValorDoc: TEdit
      Left = 8
      Top = 74
      Width = 153
      Height = 21
      TabOrder = 1
      Text = '10'
    end
    object edtDataDoc: TMaskEdit
      Left = 8
      Top = 116
      Width = 153
      Height = 21
      EditMask = '!99/99/00;1;_'
      MaxLength = 8
      TabOrder = 2
      Text = '  /  /  '
    end
    object edtVencimento: TMaskEdit
      Left = 8
      Top = 157
      Width = 153
      Height = 21
      EditMask = '!99/99/00;1;_'
      MaxLength = 8
      TabOrder = 3
      Text = '  /  /  '
    end
    object cbxCarteiraEnvio: TComboBox
      Left = 8
      Top = 197
      Width = 153
      Height = 21
      ItemIndex = 1
      TabOrder = 4
      Text = 'Banco'
      Items.Strings = (
        'Cedente'
        'Banco')
    end
  end
  object GroupBox5: TGroupBox
    Left = 9
    Top = 610
    Width = 786
    Height = 143
    Caption = 'Informa'#231#245'es do Sacado'
    TabOrder = 4
    object Label21: TLabel
      Left = 8
      Top = 16
      Width = 28
      Height = 13
      Caption = 'Nome'
    end
    object Label22: TLabel
      Left = 352
      Top = 16
      Width = 58
      Height = 13
      Caption = 'CPF / CNPJ'
    end
    object Label23: TLabel
      Left = 512
      Top = 16
      Width = 29
      Height = 13
      Caption = 'E-Mail'
    end
    object Label24: TLabel
      Left = 8
      Top = 56
      Width = 46
      Height = 13
      Caption = 'Endere'#231'o'
    end
    object Label25: TLabel
      Left = 328
      Top = 56
      Width = 37
      Height = 13
      Caption = 'N'#250'mero'
    end
    object Label26: TLabel
      Left = 400
      Top = 56
      Width = 64
      Height = 13
      Caption = 'Complemento'
    end
    object Label27: TLabel
      Left = 592
      Top = 56
      Width = 27
      Height = 13
      Caption = 'Bairro'
    end
    object Label28: TLabel
      Left = 8
      Top = 96
      Width = 33
      Height = 13
      Caption = 'Cidade'
    end
    object Label29: TLabel
      Left = 304
      Top = 96
      Width = 21
      Height = 13
      Caption = 'CEP'
    end
    object Label30: TLabel
      Left = 384
      Top = 96
      Width = 14
      Height = 13
      Caption = 'UF'
    end
    object Label31: TLabel
      Left = 424
      Top = 98
      Width = 34
      Height = 13
      Caption = 'LayOut'
      Color = clBtnFace
      ParentColor = False
    end
    object edtNome: TEdit
      Left = 8
      Top = 32
      Width = 337
      Height = 21
      TabOrder = 0
      Text = 'Joao Roberto Pirea'
    end
    object edtCPFCNPJ: TEdit
      Left = 352
      Top = 32
      Width = 153
      Height = 21
      TabOrder = 1
      Text = '87.854.233-78'
    end
    object edtEmail: TEdit
      Left = 512
      Top = 32
      Width = 265
      Height = 21
      TabOrder = 2
      Text = 'joao@gmail.com'
    end
    object edtEndereco: TEdit
      Left = 8
      Top = 72
      Width = 313
      Height = 21
      TabOrder = 3
      Text = 'Rua XI de Agosto'
    end
    object edtNumero: TEdit
      Left = 328
      Top = 72
      Width = 65
      Height = 21
      TabOrder = 4
      Text = '1000'
    end
    object edtComplemento: TEdit
      Left = 400
      Top = 72
      Width = 185
      Height = 21
      TabOrder = 5
    end
    object edtBairro: TEdit
      Left = 592
      Top = 72
      Width = 185
      Height = 21
      TabOrder = 6
      Text = 'Centro'
    end
    object edtCidade: TEdit
      Left = 8
      Top = 112
      Width = 289
      Height = 21
      TabOrder = 7
      Text = 'Tatui'
    end
    object edtCEP: TEdit
      Left = 304
      Top = 112
      Width = 73
      Height = 21
      TabOrder = 8
      Text = '18270-000'
    end
    object edtUF: TEdit
      Left = 384
      Top = 112
      Width = 33
      Height = 21
      TabOrder = 9
      Text = 'SP'
    end
    object cbxLayOut: TComboBox
      Left = 424
      Top = 112
      Width = 138
      Height = 21
      Style = csDropDownList
      TabOrder = 10
      OnChange = cbxLayOutChange
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 768
    Width = 804
    Height = 45
    Align = alBottom
    TabOrder = 5
    object Button1: TButton
      Left = 8
      Top = 10
      Width = 75
      Height = 25
      Caption = 'Gerar HTML'
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 104
      Top = 10
      Width = 75
      Height = 25
      Caption = 'Gerar PDF'
      TabOrder = 1
      OnClick = Button2Click
    end
    object Button3: TButton
      Left = 192
      Top = 10
      Width = 131
      Height = 25
      Caption = 'Zerar Lista de Boletos'
      TabOrder = 2
    end
    object Button4: TButton
      Left = 336
      Top = 10
      Width = 97
      Height = 25
      Caption = 'Incluir Boleto'
      TabOrder = 3
      OnClick = Button4Click
    end
    object Button5: TButton
      Left = 448
      Top = 10
      Width = 129
      Height = 25
      Caption = 'Incluir V'#225'rios Boletos'
      TabOrder = 4
      OnClick = Button5Click
    end
    object Button6: TButton
      Left = 583
      Top = 10
      Width = 97
      Height = 25
      Caption = 'Gerar Remessa'
      TabOrder = 5
      OnClick = Button6Click
    end
    object Button7: TButton
      Left = 704
      Top = 10
      Width = 89
      Height = 25
      Caption = 'Imprimir'
      TabOrder = 6
      OnClick = Button7Click
    end
  end
  object GroupBox6: TGroupBox
    Left = 9
    Top = 42
    Width = 786
    Height = 64
    Caption = 'Remessa'
    TabOrder = 6
    object Label52: TLabel
      Left = 8
      Top = 17
      Width = 85
      Height = 13
      Caption = 'Tipo de Cobran'#231'a'
    end
    object Label53: TLabel
      Left = 387
      Top = 17
      Width = 69
      Height = 13
      Caption = 'Path Remessa'
    end
    object Label54: TLabel
      Left = 242
      Top = 17
      Width = 97
      Height = 13
      Caption = 'Nome Arq. Remessa'
    end
    object Label55: TLabel
      Left = 359
      Top = 17
      Width = 12
      Height = 13
      Caption = 'N'#186
    end
    object Label56: TLabel
      Left = 177
      Top = 17
      Width = 32
      Height = 13
      Caption = 'Layout'
    end
    object cbxTpCob: TComboBox
      Left = 8
      Top = 33
      Width = 163
      Height = 21
      TabOrder = 0
      Items.Strings = (
        'cobNenhum'
        'cobBancoDoBrasil'
        'cobSantander'
        'cobCaixaEconomica'
        'cobCaixaSicob'
        'cobBradesco'
        'cobItau'
        'cobBancoMercantil'
        'cobSicred'
        'cobBancoob'
        'cobBanrisul'
        'cobBanestes'
        'cobHSBC'
        'cobBancoDoNordeste'
        'cobBRB'
        'cobBicBanco'
        'cobBradescoSICOOB'
        'cobBancoSafra'
        'cobSafraBradesco'
        'cobBancoCECRED'
        'cobBancoDaAmazonia'
        'cobBancoDoBrasilSICOOB'
        'cobUniprime'
        'cobUnicredRS'
        'cobBanese'
        'cobCrediSIS'
        'cobUnicredES')
    end
    object edtDirRemessa: TEdit
      Left = 387
      Top = 33
      Width = 355
      Height = 21
      TabOrder = 1
    end
    object Button8: TButton
      Left = 748
      Top = 32
      Width = 29
      Height = 22
      Caption = '...'
      TabOrder = 2
      OnClick = Button8Click
    end
    object edtNomeArqRemessa: TEdit
      Left = 240
      Top = 33
      Width = 113
      Height = 21
      TabOrder = 3
      Text = 'teste'
    end
    object edtNumRemessa: TEdit
      Left = 359
      Top = 33
      Width = 22
      Height = 21
      TabOrder = 4
      Text = '1'
    end
    object ComboBox1: TComboBox
      Left = 177
      Top = 33
      Width = 56
      Height = 21
      ItemIndex = 0
      TabOrder = 5
      Text = '400'
      Items.Strings = (
        '400'
        '240')
    end
  end
  object GroupBox7: TGroupBox
    Left = 9
    Top = 111
    Width = 785
    Height = 190
    Caption = 'Cedente'
    TabOrder = 7
    object Label33: TLabel
      Left = 8
      Top = 16
      Width = 82
      Height = 13
      Caption = 'Tipo de Inscri'#231#227'o'
    end
    object Label35: TLabel
      Left = 151
      Top = 16
      Width = 39
      Height = 13
      Caption = 'Ag'#234'ncia'
    end
    object Label42: TLabel
      Left = 209
      Top = 16
      Width = 27
      Height = 13
      Caption = 'Digito'
    end
    object Label43: TLabel
      Left = 246
      Top = 16
      Width = 28
      Height = 13
      Caption = 'Conta'
    end
    object Label44: TLabel
      Left = 388
      Top = 16
      Width = 27
      Height = 13
      Caption = 'Digito'
    end
    object Label45: TLabel
      Left = 604
      Top = 16
      Width = 57
      Height = 13
      Caption = 'TipoCarteira'
    end
    object Label46: TLabel
      Left = 686
      Top = 16
      Width = 70
      Height = 13
      Caption = 'Resp. Emissao'
    end
    object Label47: TLabel
      Left = 422
      Top = 16
      Width = 45
      Height = 13
      Caption = 'Conv'#234'nio'
    end
    object Label48: TLabel
      Left = 518
      Top = 16
      Width = 47
      Height = 13
      Caption = 'Tipo Doc.'
    end
    object Label34: TLabel
      Left = 8
      Top = 64
      Width = 28
      Height = 13
      Caption = 'Nome'
    end
    object Label36: TLabel
      Left = 352
      Top = 64
      Width = 58
      Height = 13
      Caption = 'CPF / CNPJ'
    end
    object Label38: TLabel
      Left = 8
      Top = 104
      Width = 46
      Height = 13
      Caption = 'Endere'#231'o'
    end
    object Label39: TLabel
      Left = 328
      Top = 104
      Width = 37
      Height = 13
      Caption = 'N'#250'mero'
    end
    object Label40: TLabel
      Left = 400
      Top = 104
      Width = 64
      Height = 13
      Caption = 'Complemento'
    end
    object Label41: TLabel
      Left = 592
      Top = 104
      Width = 27
      Height = 13
      Caption = 'Bairro'
    end
    object Label49: TLabel
      Left = 8
      Top = 144
      Width = 33
      Height = 13
      Caption = 'Cidade'
    end
    object Label50: TLabel
      Left = 304
      Top = 144
      Width = 21
      Height = 13
      Caption = 'CEP'
    end
    object Label51: TLabel
      Left = 384
      Top = 144
      Width = 14
      Height = 13
      Caption = 'UF'
    end
    object Label37: TLabel
      Left = 513
      Top = 64
      Width = 42
      Height = 13
      Caption = 'Telefone'
    end
    object edtAgencia: TEdit
      Left = 151
      Top = 35
      Width = 52
      Height = 21
      TabOrder = 0
      Text = '9999'
    end
    object edtConta: TEdit
      Left = 246
      Top = 35
      Width = 134
      Height = 21
      TabOrder = 1
      Text = '123345'
    end
    object cbxTipoInscrição: TComboBox
      Left = 8
      Top = 35
      Width = 135
      Height = 21
      ItemIndex = 0
      TabOrder = 2
      Text = 'Fisica'
      Items.Strings = (
        'Fisica'
        'Juridica'
        'Outras')
    end
    object edtDigAgencia: TEdit
      Left = 211
      Top = 35
      Width = 27
      Height = 21
      TabOrder = 3
    end
    object edtDigConta: TEdit
      Left = 388
      Top = 35
      Width = 27
      Height = 21
      TabOrder = 4
      Text = '1'
    end
    object cbxCarteira: TComboBox
      Left = 604
      Top = 35
      Width = 76
      Height = 21
      TabOrder = 5
      Text = 'Registrada'
      Items.Strings = (
        'Simples'
        'Registrada'
        'Eletronica')
    end
    object cbxRespEmissao: TComboBox
      Left = 686
      Top = 35
      Width = 91
      Height = 21
      TabOrder = 6
      Text = 'Banco Emite'
      Items.Strings = (
        'Cliente Emite'
        'Banco Emite'
        'Banco Reemite'
        'Banco NaoReemite')
    end
    object edtConvenio: TEdit
      Left = 422
      Top = 35
      Width = 89
      Height = 21
      TabOrder = 7
      Text = '12345'
    end
    object cbxTpDoc: TComboBox
      Left = 518
      Top = 35
      Width = 80
      Height = 21
      ItemIndex = 0
      TabOrder = 8
      Text = 'Tradicional'
      Items.Strings = (
        'Tradicional'
        'Escritural')
    end
    object edtCedenteNome: TEdit
      Left = 8
      Top = 80
      Width = 337
      Height = 21
      TabOrder = 9
      Text = 'Joao do teste'
    end
    object edtCedenteCPF: TEdit
      Left = 352
      Top = 80
      Width = 153
      Height = 21
      TabOrder = 10
      Text = '087.854.233-78'
    end
    object edtCedenteLogradouro: TEdit
      Left = 8
      Top = 120
      Width = 313
      Height = 21
      TabOrder = 11
      Text = 'Rua XI de Agosto'
    end
    object edtCedenteEndNum: TEdit
      Left = 328
      Top = 120
      Width = 65
      Height = 21
      TabOrder = 12
      Text = '1000'
    end
    object edtCedenteCompl: TEdit
      Left = 400
      Top = 120
      Width = 185
      Height = 21
      TabOrder = 13
    end
    object edtCedenteBairro: TEdit
      Left = 592
      Top = 120
      Width = 185
      Height = 21
      TabOrder = 14
      Text = 'Centro'
    end
    object edtCedenteCidade: TEdit
      Left = 8
      Top = 160
      Width = 289
      Height = 21
      TabOrder = 15
      Text = 'Tatui'
    end
    object edtCedenteCEP: TEdit
      Left = 304
      Top = 160
      Width = 73
      Height = 21
      TabOrder = 16
      Text = '18270-000'
    end
    object edtCedenteUF: TEdit
      Left = 384
      Top = 160
      Width = 33
      Height = 21
      TabOrder = 17
      Text = 'SP'
    end
    object edtCedenteTel: TEdit
      Left = 513
      Top = 80
      Width = 120
      Height = 21
      TabOrder = 18
    end
  end
  object pnlTitle: TPanel
    Left = 0
    Top = 0
    Width = 804
    Height = 40
    Align = alTop
    Caption = 'Myloo Boleto'
    Color = clHighlight
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentBackground = False
    ParentFont = False
    TabOrder = 8
  end
  object opdDirRemessa: TOpenDialog
    Left = 673
    Top = 50
  end
end
