unit ufrmMain;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  ExtCtrls,
  Mask,
  Myloo.Boleto,
  Myloo.Boleto.Utils;

type
  TfrmMain = class(TForm)
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    GroupBox5: TGroupBox;
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    edtLocalPag: TEdit;
    edtEspecieDoc: TEdit;
    edtEspecieMod: TEdit;
    cbxAceite: TComboBox;
    edtCarteira: TEdit;
    edtNossoNro: TEdit;
    edtMoraJuros: TEdit;
    edtValorDesconto: TEdit;
    edtValorAbatimento: TEdit;
    edtMulta: TEdit;
    edtDataMora: TMaskEdit;
    edtDataDesconto: TMaskEdit;
    edtDataAbatimento: TMaskEdit;
    edtDataProtesto: TMaskEdit;
    edtNumeroDoc: TEdit;
    edtValorDoc: TEdit;
    edtDataDoc: TMaskEdit;
    edtVencimento: TMaskEdit;
    memMensagem: TMemo;
    edtInstrucoes1: TEdit;
    edtInstrucoes2: TEdit;
    Panel2: TPanel;
    edtNome: TEdit;
    edtCPFCNPJ: TEdit;
    edtEmail: TEdit;
    edtEndereco: TEdit;
    edtNumero: TEdit;
    edtComplemento: TEdit;
    edtBairro: TEdit;
    edtCidade: TEdit;
    edtCEP: TEdit;
    Label30: TLabel;
    edtUF: TEdit;
    Label31: TLabel;
    cbxLayOut: TComboBox;
    cbxTpCob: TComboBox;
    GroupBox6: TGroupBox;
    Label32: TLabel;
    cbxCarteiraEnvio: TComboBox;
    GroupBox7: TGroupBox;
    Label33: TLabel;
    Label35: TLabel;
    edtAgencia: TEdit;
    edtConta: TEdit;
    cbxTipoInscrição: TComboBox;
    edtDigAgencia: TEdit;
    Label42: TLabel;
    Label43: TLabel;
    Label44: TLabel;
    edtDigConta: TEdit;
    cbxCarteira: TComboBox;
    Label45: TLabel;
    cbxRespEmissao: TComboBox;
    Label46: TLabel;
    edtConvenio: TEdit;
    Label47: TLabel;
    cbxTpDoc: TComboBox;
    Label48: TLabel;
    Label34: TLabel;
    edtCedenteNome: TEdit;
    Label36: TLabel;
    edtCedenteCPF: TEdit;
    Label38: TLabel;
    edtCedenteLogradouro: TEdit;
    Label39: TLabel;
    edtCedenteEndNum: TEdit;
    Label40: TLabel;
    edtCedenteCompl: TEdit;
    Label41: TLabel;
    edtCedenteBairro: TEdit;
    Label49: TLabel;
    edtCedenteCidade: TEdit;
    Label50: TLabel;
    edtCedenteCEP: TEdit;
    Label51: TLabel;
    edtCedenteUF: TEdit;
    edtCedenteTel: TEdit;
    Label37: TLabel;
    opdDirRemessa: TOpenDialog;
    edtDirRemessa: TEdit;
    Label52: TLabel;
    Label53: TLabel;
    Button8: TButton;
    edtNomeArqRemessa: TEdit;
    Label54: TLabel;
    edtNumRemessa: TEdit;
    Label55: TLabel;
    ComboBox1: TComboBox;
    Label56: TLabel;
    pnlTitle: TPanel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure cbxLayOutChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button8Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;
  Boleto: TBoleto;

implementation

Uses TypInfo, Myloo.Boleto.Report.FastReport;

{$R *.dfm}

procedure TfrmMain.Button1Click(Sender: TObject);
begin
  Boleto.BoletoFC.NomeArquivo := ExtractFilePath(Application.ExeName) + 'teste.html';
  Boleto.GerarHTMl;
end;

procedure TfrmMain.Button2Click(Sender: TObject);
begin
  Boleto.GerarPDF;
end;

procedure TfrmMain.Button4Click(Sender: TObject);
var
  Titulo: TTitulo;
begin
  Titulo := Boleto.CriarTituloNaLista;
  with Titulo do
  begin
    Vencimento := StrToDate(edtVencimento.Text);
    DataDocumento := StrToDate(edtDataDoc.Text);
    NumeroDocumento := edtNumeroDoc.Text;
    EspecieDoc := edtEspecieDoc.Text;
    if cbxAceite.ItemIndex = 0 then
      Aceite := atSim
    else
      Aceite := atNao;
    if cbxTpCob.ItemIndex = 1 then
      Boleto.Cedente.TipoCarteira := TTipoCarteira(cbxCarteira.ItemIndex);
    DataProcessamento := Now;
    Carteira := edtCarteira.Text;
    NossoNumero := edtNossoNro.Text;
    ValorDocumento := StrToCurr(edtValorDoc.Text);
    Sacado.NomeSacado := edtNome.Text;
    Sacado.CNPJCPF := OnlyNumber(edtCPFCNPJ.Text);
    Sacado.Logradouro := edtEndereco.Text;
    Sacado.Numero := edtNumero.Text;
    Sacado.Bairro := edtBairro.Text;
    Sacado.Cidade := edtCidade.Text;
    Sacado.UF := edtUF.Text;
    Sacado.CEP := OnlyNumber(edtCEP.Text);
    ValorAbatimento := StrToCurrDef(edtValorAbatimento.Text, 0);
    LocalPagamento := edtLocalPag.Text;
    ValorMoraJuros := StrToCurrDef(edtMoraJuros.Text, 0);
    ValorDesconto := StrToCurrDef(edtValorDesconto.Text, 0);
    ValorAbatimento := StrToCurrDef(edtValorAbatimento.Text, 0);
    DataMoraJuros := StrToDateDef(edtDataMora.Text, 0);
    DataDesconto := StrToDateDef(edtDataDesconto.Text, 0);
    DataAbatimento := StrToDateDef(edtDataAbatimento.Text, 0);
    DataProtesto := StrToDateDef(edtDataProtesto.Text, 0);
    PercentualMulta := StrToCurrDef(edtMulta.Text, 0);
    Mensagem.Text := memMensagem.Text;
    OcorrenciaOriginal.Tipo := toRemessaBaixar;
    Instrucao1 := PadRight(trim(edtInstrucoes1.Text), 2, '0');
    Instrucao2 := PadRight(trim(edtInstrucoes2.Text), 2, '0');
    if cbxCarteiraEnvio.ItemIndex > -1 then
      CarteiraEnvio := TCarteiraEnvio(cbxCarteiraEnvio.ItemIndex);
    // dm.ACBrBoleto.AdicionarMensagensPadroes(Titulo,Mensagem);
  end;
end;

procedure TfrmMain.Button5Click(Sender: TObject);
var
  Titulo: TTitulo;
  I: Integer;
  NrTitulos: Integer;
  NrTitulosStr: String;
  Convertido: Boolean;
begin
  NrTitulos := 10;
  NrTitulosStr := '10';
  Convertido := true;

  repeat
    InputQuery('ACBrBoleto', 'Número de Boletos a incluir', NrTitulosStr);
    try
      NrTitulos := StrToInt(NrTitulosStr);
    except
      Convertido := false;
    end;
  until Convertido;

  for I := 1 to NrTitulos do
  begin
    Titulo := Boleto.CriarTituloNaLista;

    with Titulo do
    begin
      LocalPagamento := 'Pagar preferêncialmente nas agências do Bradesco'; // MEnsagem exigida pelo bradesco
      Vencimento := IncMonth(EncodeDate(2010, 05, 10), I);
      DataDocumento := EncodeDate(2010, 04, 10);
      NumeroDocumento := PadRight(IntToStr(I), 6, '0');
      EspecieDoc := 'DM';
      Aceite := atSim;
      DataProcessamento := Now;
      NossoNumero := IntToStrZero(I, 8);
      Carteira := '09';
      ValorDocumento := 100.35 * (I + 0.5);
      Sacado.NomeSacado := 'Jose Luiz Pedroso';
      Sacado.CNPJCPF := '12345678901';
      Sacado.Logradouro := 'Rua da Consolacao';
      Sacado.Numero := '100';
      Sacado.Bairro := 'Vila Esperanca';
      Sacado.Cidade := 'Tatui';
      Sacado.UF := 'SP';
      Sacado.CEP := '18270000';
      ValorAbatimento := 10;
      DataAbatimento := Vencimento - 5;
      Instrucao1 := '00';
      Instrucao2 := '00';

      Boleto.AdicionarMensagensPadroes(Titulo, Mensagem);
    end;
  end;
end;

procedure TfrmMain.Button6Click(Sender: TObject);
begin
  Boleto.Banco.TipoCobranca := TTipoCobranca(cbxTpCob.ItemIndex);
  Boleto.Cedente.TipoInscricao := TPessoa(cbxTipoInscrição.ItemIndex);
  Boleto.Cedente.Agencia       := edtAgencia.Text;
  Boleto.Cedente.AgenciaDigito := edtDigAgencia.Text;
  Boleto.Cedente.Conta         := edtConta.Text;
  Boleto.Cedente.ContaDigito   := edtDigConta.Text;
  Boleto.Cedente.Convenio      := edtConvenio.Text;
  Boleto.Cedente.TipoDocumento := TTipoDocumento(cbxTpDoc.ItemIndex);
  Boleto.Cedente.TipoCarteira  := TTipoCarteira(cbxCarteira.ItemIndex);
  Boleto.Cedente.ResponEmissao := TResponEmissao(cbxRespEmissao.ItemIndex);
  Boleto.Cedente.Nome          := edtCedenteNome.Text;
  Boleto.Cedente.CNPJCPF       := OnlyNumber(edtCedenteCPF.Text);
  Boleto.Cedente.Logradouro    := edtCedenteLogradouro.Text;
  Boleto.Cedente.NumeroRes     := edtCedenteEndNum.Text;
  Boleto.Cedente.Bairro        := edtCedenteBairro.Text;
  Boleto.Cedente.Complemento   := edtCedenteCompl.Text;
  Boleto.Cedente.Cidade        := edtCedenteCidade.Text;
  Boleto.Cedente.CEP           := OnlyNumber(edtCedenteCEP.Text);
  Boleto.Cedente.UF            := edtCedenteUF.Text;
  Boleto.Cedente.Telefone      := OnlyNumber(edtCedenteTel.Text);
  Boleto.DirArqRemessa         := edtDirRemessa.Text;
  boleto.NomeArqRemessa        := edtNomeArqRemessa.Text;
  Boleto.GerarRemessa(StrToIntDef(edtNumRemessa.Text,1));
end;

procedure TfrmMain.Button7Click(Sender: TObject);
var
  BoletoFCFR : TBoletoFCFR;
begin
  BoletoFCFR := TBoletoFCFR.Create;
  BoletoFCFR.UseStream := True;
  BoletoFCFR.TpRelatorioStream := tpsBoleto;
//  BoletoFCFR.DirLogo := '..\..\..\Fontes\ACBrBoleto\Logos\Colorido';
//  BoletoFCFR.FastReportFile := 'report\Boleto.fr3';
  Boleto.BoletoFC := BoletoFCFR;
  Boleto.Imprimir;
end;

procedure TfrmMain.Button8Click(Sender: TObject);
begin
  opdDirRemessa.Execute();
  edtDirRemessa.Text := opdDirRemessa.FileName;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
var
  I: TBolLayOut;
begin
  Boleto:= TBoleto.Create(TTipoCobranca(0));
  edtDataDoc.Text := DateToStr(Now);
  edtVencimento.Text := DateToStr(IncMonth(StrToDate(edtDataDoc.Text), 1));
  edtDataMora.Text := DateToStr(StrToDate(edtVencimento.Text) + 1);

  cbxLayOut.Items.Clear;
  For I := Low(TBolLayOut) to High(TBolLayOut) do
    cbxLayOut.Items.Add(GetEnumName(TypeInfo(TBolLayOut), Integer(I)));
  cbxLayOut.ItemIndex := 0;
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  //dm := dmFast;
  edtDirRemessa.Text := Format('%s\Remessa',[ExtractFileDir(GetCurrentDir)]);
end;

procedure TfrmMain.Button3Click(Sender: TObject);
begin
  Boleto.ListadeBoletos.Clear;
end;

procedure TfrmMain.cbxLayOutChange(Sender: TObject);
begin
  Boleto.BoletoFC.LayOut := TBolLayOut(cbxLayOut.ItemIndex);
end;

end.
