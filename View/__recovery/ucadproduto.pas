unit ucadproduto;

interface

{$REGION 'Uses'}
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UCadastroPadrao, Vcl.Buttons, Vcl.StdCtrls, Vcl.ExtCtrls,
  Data.DB, Vcl.Grids, Vcl.DBGrids, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.MSSQL, FireDAC.Phys.MSSQLDef, FireDAC.VCLUI.Wait, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  conexao.model, produto.model, produto.controller;

{$ENDREGION}

type
  TOperacao = (opInicio, opNovo, opEditar, opNavegar);
  TFrmCadProduto = class(TFrmCadastroPadrao)

{$REGION 'Componentes'}
    Label1: TLabel;
    Label2: TLabel;
    Label6: TLabel;
    EdtPrecoUnitario: TEdit;
    EdtCodProduto: TEdit;
    EdtDescricao: TEdit;
    DBGridProdutos: TDBGrid;
    PnlPesquisar: TPanel;
    Label4: TLabel;
    BtnPesquisar: TSpeedButton;
    EdtPesquisar: TEdit;
    CbxFiltro: TComboBox;

{$ENDREGION}

    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BtnInserirClick(Sender: TObject);
    procedure BtnAlterarClick(Sender: TObject);
    procedure BtnGravarClick(Sender: TObject);
    procedure BtnCancelarClick(Sender: TObject);
    procedure BtnSairClick(Sender: TObject);
    procedure DBGridProdutosDblClick(Sender: TObject);
    procedure BtnExcluirClick(Sender: TObject);
    procedure EdtPrecoUnitarioKeyPress(Sender: TObject; var Key: Char);
    procedure EdtPrecoUnitarioExit(Sender: TObject);
    procedure CbxFiltroClick(Sender: TObject);
    procedure BtnPesquisarClick(Sender: TObject);
    procedure DBGridProdutosKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);

  private
    ValoresOriginais: array of string;
    TblProdutos: TFDQuery;
    QryProdutos: TFDQuery;
    QryTemp: TFDQuery;
    DsProdutos: TDataSource;
    TransacaoProdutos: TFDTransaction;
    FProduto: TProduto;
    ProdutoController: TProdutoController;

    procedure PreencherGrid;
    procedure CarregarCampos;
    procedure Inserir;
    procedure Alterar;
    procedure Excluir;
    function ValidarDados: Boolean;
    procedure GravarDados;
    procedure LimpaCampos(AOperacao: TOperacao);
    procedure VerificaBotoes(AOperacao: TOperacao);
    procedure MostrarMensagemErro(AErro: TCampoInvalido);
    procedure CriarTabelas;
    procedure CriarCamposTabelas;

  public
    FOperacao: TOperacao;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

var
  FrmCadProduto: TFrmCadProduto;

implementation

{$R *.dfm}

uses untFormat;

constructor TFrmCadProduto.Create(AOwner: TComponent);
begin
  inherited;
  TransacaoProdutos := TFDTransaction.Create(nil);
  DsProdutos := TDataSource.Create(nil);
  TblProdutos := TFDQuery.Create(nil);
  QryProdutos := TFDQuery.Create(nil);
  QryTemp := TFDQuery.Create(nil);
end;

destructor TFrmCadProduto.Destroy;
begin
  DsProdutos.Free;
  TblProdutos.Free;
  QryProdutos.Free;
  QryTemp.Free;
  TransacaoProdutos.Free;
  inherited;
end;

procedure TFrmCadProduto.FormCreate(Sender: TObject);
var sCampo: string;
    StringField: TStringField;
    IntegerField: TIntegerField;
    DateField: TDateField;
    FloatField: TFloatField;
begin
  inherited;
  if TConexao.GetInstance.Connection.TestarConexao then
  begin
    TConexao.GetInstance.Connection.InciarTransacao;
    CriarTabelas();
    CriarCamposTabelas();
    FProduto := TProduto.Create;
    ProdutoController := TProdutoController.Create;
    FOperacao := opInicio;
    SetLength(ValoresOriginais, 3);
  end
  else
  begin
    ShowMessage('Não foi possível conectar ao banco de dados!');
    Close;
  end;
end;

procedure TFrmCadProduto.FormShow(Sender: TObject);
begin
  inherited;
  PreencherGrid();
  VerificaBotoes(FOperacao);
  if EdtPesquisar.CanFocus then
    EdtPesquisar.SetFocus;
end;

procedure TFrmCadProduto.PreencherGrid;
begin
  ProdutoController.PreencherGrid(TblProdutos, Trim(EdtPesquisar.Text) + '%', CbxFiltro.Text);
  LblTotRegistros.Caption := 'Produtos: ' + InttoStr(DsProdutos.DataSet.RecordCount);
end;

procedure TFrmCadProduto.CarregarCampos;
begin
  ProdutoController.CarregarCampos(QryProdutos, FProduto, DsProdutos.DataSet.FieldByName('COD_PRODUTO').AsInteger);
  with FProduto do
  begin
    EdtCodProduto.Text := IntToStr(Cod_Produto);
    EdtDescricao.Text := Des_Descricao;
    EdtPrecoUnitario.Text := FormatFloat('######0.00', Val_Preco);
  end;
  ValoresOriginais[0] := EdtCodProduto.Text;
  ValoresOriginais[1] := EdtDescricao.Text;
  ValoresOriginais[2] := EdtPrecoUnitario.Text;
end;

procedure TFrmCadProduto.CbxFiltroClick(Sender: TObject);
begin
  inherited;
  BtnPesquisar.Click;
end;

procedure TFrmCadProduto.Inserir;
var sErro: string;
begin
  with FProduto do
  begin
    Des_Descricao := EdtDescricao.Text;
    Val_Preco := StrToFloat(
    StringReplace(StringReplace(EdtPrecoUnitario.Text, '.', '', [rfReplaceAll]), ',', FormatSettings.DecimalSeparator, [rfReplaceAll]));
  end;

  if ProdutoController.Inserir(QryProdutos, FProduto, TransacaoProdutos, sErro) = false then
    raise Exception.Create(sErro)
  else
    MessageDlg('Produto incluido com sucesso !!', mtInformation, [mbOk], 0);
end;

procedure TFrmCadProduto.Alterar;
var sErro: String;
begin
  with FProduto do
  begin
    Des_Descricao := EdtDescricao.Text;
    Val_Preco := StrToFloat(
    StringReplace(StringReplace(EdtPrecoUnitario.Text, '.', '', [rfReplaceAll]), ',', FormatSettings.DecimalSeparator, [rfReplaceAll]));
  end;

  if ProdutoController.Alterar(QryProdutos, FProduto, TransacaoProdutos, StrToInt(EdtCodProduto.Text), sErro) = False then
    raise Exception.Create(sErro)
  else
    MessageDlg('Produto alterado com sucesso !!', mtInformation, [mbOK], 0);
end;

procedure TFrmCadProduto.EdtPrecoUnitarioExit(Sender: TObject);
var LValor: Double;
begin
  inherited;
  if TryStrToFloat(EdtPrecoUnitario.Text, LValor) then
    EdtPrecoUnitario.Text := FormatFloat('#,###,##0.00', LValor)
  else
  begin
    ShowMessage('Valor inválido!');
    EdtPrecoUnitario.SetFocus;
  end;
end;

procedure TFrmCadProduto.EdtPrecoUnitarioKeyPress(Sender: TObject;
  var Key: Char);
begin
  inherited;
  if not (key in ['0'..'9', ',', #08]) then
    key := #0;
end;

procedure TFrmCadProduto.Excluir;
var sErro : String;
begin
  if MessageDlg('Deseja realmente excluir o produto selecionado ?',mtConfirmation, [mbYes, mbNo],0) = IDYES then
    if ProdutoController.Excluir(QryProdutos, TransacaoProdutos, DsProdutos.DataSet.FieldByName('COD_PRODUTO').AsInteger, sErro) = False then
      raise Exception.Create(sErro);
end;

function TFrmCadProduto.ValidarDados: Boolean;
var lErro: TCampoInvalido;
begin
  Result := ProdutoController.ValidarDados(EdtDescricao.Text, EdtPrecoUnitario.Text, lErro);
  if not Result then
  begin
    MostrarMensagemErro(lErro);
    Exit(False);
  end;

  Result := True;
end;

procedure TFrmCadProduto.GravarDados;
begin
  case FOperacao of
    opNovo    : Inserir();
    opEditar  : Alterar();
  end;
  DsProdutos.DataSet.Refresh;
  FOperacao := opNavegar
end;

procedure TFrmCadProduto.LimpaCampos(AOperacao: TOperacao);
begin
  EdtCodProduto.Text := '';
  EdtDescricao.Text := '';
  EdtPrecoUnitario.Text := '0.00';
  GrbDados.Enabled := AOperacao in [opNovo, opEditar];
  DBGridProdutos.Enabled := AOperacao in [opInicio, opNavegar];
end;

procedure TFrmCadProduto.VerificaBotoes(AOperacao: TOperacao);
begin
  BtnInserir.Enabled := AOperacao in [opInicio, opNavegar];
  BtnAlterar.Enabled := AOperacao = opNavegar;
  BtnExcluir.Enabled := AOperacao = opNavegar;
  BtnSair.Enabled := AOperacao in [opInicio, opNavegar];
  BtnGravar.Enabled := AOperacao in [opNovo, opEditar];
  BtnCancelar.Enabled := AOperacao in [opNovo, opEditar];
  GrbDados.Enabled := AOperacao in [opNovo, opEditar];
  DBGridProdutos.Enabled := AOperacao in [opInicio, opNavegar];
  PnlPesquisar.Enabled := AOperacao in [opInicio, opNavegar];
end;

procedure TFrmCadProduto.MostrarMensagemErro(AErro: TCampoInvalido);
begin
  case AErro of
    ciDescricao:
      begin
        MessageDlg('A descrição do produto deve ser informada!', mtInformation, [mbOK], 0);
        EdtDescricao.SetFocus;
      end;
    ciPreco, ciPrecoZero:
      begin
        MessageDlg('O preço unitário deve ser maior que 0!', mtInformation, [mbOK], 0);
        EdtPrecoUnitario.SetFocus;
      end;
  end;
end;

procedure TFrmCadProduto.DBGridProdutosDblClick(Sender: TObject);
begin
  inherited;
  FOperacao := opNavegar;
  CarregarCampos;
  VerificaBotoes(FOperacao);
end;

procedure TFrmCadProduto.DBGridProdutosKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  inherited;
  if Key = VK_RETURN then
  begin
    CarregarCampos();
    VerificaBotoes(FOperacao);
    FOperacao := opEditar;
    BtnAlterar.Click;
    Key := 0;
  end;
end;

procedure TFrmCadProduto.BtnInserirClick(Sender: TObject);
begin
  inherited;
  FOperacao := opNovo;
  VerificaBotoes(FOperacao);
  LimpaCampos(FOperacao);
end;

procedure TFrmCadProduto.BtnPesquisarClick(Sender: TObject);
begin
  inherited;
  PreencherGrid();
end;

procedure TFrmCadProduto.BtnAlterarClick(Sender: TObject);
begin
  inherited;
  FOperacao := opEditar;
  VerificaBotoes(FOperacao);
  EdtDescricao.SetFocus;
end;

procedure TFrmCadProduto.BtnGravarClick(Sender: TObject); var lRetorno: string;
begin
  inherited;
  if not ValidarDados then
  begin
    Exit;
  end
  else
  begin
    GravarDados();
    FOperacao := opNavegar;
    VerificaBotoes(FOperacao);
    LimpaCampos(FOperacao);
  end;
end;

procedure TFrmCadProduto.BtnCancelarClick(Sender: TObject);
begin
  inherited;
  if FOperacao = opNovo then
  begin
    FOperacao := opInicio;
    LimpaCampos(FOperacao);
  end;

  if FOperacao = opEditar then
  begin
    FOperacao := opNavegar;
    EdtCodProduto.Text := ValoresOriginais[0];
    EdtDescricao.Text := ValoresOriginais[1];
    EdtPrecoUnitario.Text := ValoresOriginais[2];
  end;
  VerificaBotoes(FOperacao);
end;

procedure TFrmCadProduto.BtnExcluirClick(Sender: TObject);
begin
  inherited;
  Excluir();
  DsProdutos.DataSet.Refresh;
end;

procedure TFrmCadProduto.CriarCamposTabelas;
var
  FloatField: TFloatField;
  StringField: TStringField;
  DateField: TDateField;
  IntegerField: TIntegerField;
begin
  // Criando o campo COD_PRODUTO
  IntegerField := TIntegerField.Create(TblProdutos);
  IntegerField.FieldName := 'COD_PRODUTO';
  IntegerField.DataSet := TblProdutos;
  IntegerField.Name := 'TblProdutosCOD_PRODUTO';

  // Criando o campo NOME_PRODUTO
  StringField := TStringField.Create(TblProdutos);
  StringField.FieldName := 'DES_DESCRICAO';
  StringField.Size := 100;
  StringField.DataSet := TblProdutos;
  StringField.Name := 'TblProdutosDES_DESCRICAO';

  // Criando o campo VAL_PRECO
  FloatField := TFloatField.Create(TblProdutos);
  FloatField.FieldName := 'VAL_PRECO';
  FloatField.DataSet := TblProdutos;
  FloatField.Name := 'TblProdutosVAL_PRECO';
  FloatField.DisplayFormat := '#,###,##0.00';
end;

procedure TFrmCadProduto.CriarTabelas;
begin
  TransacaoProdutos := TConexao.GetInstance.Connection.CriarTransaction;
  TblProdutos := TConexao.GetInstance.Connection.CriarQuery;
  QryProdutos := TConexao.GetInstance.Connection.CriarQuery;
  QryProdutos.Transaction := TransacaoProdutos;
  DsProdutos := TConexao.GetInstance.Connection.CriarDataSource;
  DsProdutos.DataSet := TblProdutos;
  DBGridProdutos.DataSource := DsProdutos;
end;

procedure TFrmCadProduto.BtnSairClick(Sender: TObject);
begin
  inherited;
  Close;
end;

end.