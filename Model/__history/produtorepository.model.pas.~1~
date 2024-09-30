unit produtorepository.model;

interface

uses produto.model, conexao.model, System.SysUtils, FireDAC.Comp.Client, FireDAC.Stan.Param;

type
  TProdutoRepository = class
  public
    procedure PreencherGrid(TblProdutos: TFDQuery; sPesquisa, sCampo: string);
    procedure CarregarCampos(QryProdutos: TFDQuery; FProduto: TProduto; iCodigo: Integer);
    function Inserir(QryProdutos: TFDQuery; FProduto: TProduto; Transacao: TFDTransaction; out sErro: string): Boolean;
    function Alterar(QryProdutos: TFDQuery; FProduto: TProduto; Transacao: TFDTransaction; iCodigo: Integer; out sErro: string): Boolean;
    function Excluir(QryProdutos: TFDQuery; Transacao: TFDTransaction; iCodigo: Integer; out sErro : string): Boolean;
    function RetornaValorUnitario(QryTemp: TFDQuery; iCodigo: integer): Double;

  end;

implementation

{ TProdutoRepository }


procedure TProdutoRepository.PreencherGrid(TblProdutos: TFDQuery; sPesquisa, sCampo: string);
begin
  with TblProdutos do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select prd.cod_produto, ');
    SQL.Add('prd.des_nomeproduto, ');
    SQL.Add('prd.des_descricao, ');
    SQL.Add('prd.val_preco ');
    SQL.Add('from tab_produto prd');
    SQL.Add('where ' + sCampo + ' like :pNOME');
    SQL.Add('order by ' + sCampo);
    ParamByName('PNOME').AsString := sPesquisa;
    Open();
  end;
end;

procedure TProdutoRepository.CarregarCampos(QryProdutos: TFDQuery; FProduto: TProduto; iCodigo: Integer);
begin
  with QryProdutos do
  begin
    SQL.Clear;
    SQL.Add('select prd.cod_produto');
    SQL.Add(',prd.des_nomeproduto');
    SQL.Add(',prd.des_descricao');
    SQL.Add(',prd.val_preco');
    SQL.Add('from tab_produto prd');
    SQL.Add('where cod_produto = :cod_produto');
    ParamByName('cod_produto').AsInteger := iCodigo;
    Open;

    FProduto.Cod_Produto := FieldByName('COD_PRODUTO').AsInteger;
    FProduto.Des_NomeProduto := FieldByName('DES_NOMEPRODUTO').AsString;
    FProduto.Des_Descricao := FieldByName('DES_DESCRICAO').AsString;
    FProduto.Val_Preco := FieldByName('VAL_PRECO').AsFloat;
  end;
end;

function TProdutoRepository.Inserir(QryProdutos: TFDQuery; FProduto: TProduto; Transacao: TFDTransaction; out sErro: string): Boolean;
begin
  with QryProdutos, FProduto do
  begin
    Close;
    SQL.Clear;
    SQL.Add('insert into tab_produto(');
    SQL.Add('des_nomeproduto, ');
    SQL.Add('des_descricao, ');
    SQL.Add('val_preco) ');
    SQL.Add('values (:des_nomeproduto, ');
    SQL.Add(':des_descricao, ');
    SQL.Add(':val_preco)');

    ParamByName('DES_NOMEPRODUTO').AsString := Des_NomeProduto;
    ParamByName('DES_DESCRICAO').AsString := Des_Descricao;
    ParamByName('VAL_PRECO').AsFloat := Val_Preco;


    // Inicia Transação
    if not Transacao.Connection.Connected then
      Transacao.Connection.Open();

    try
      Prepared := True;
      Transacao.StartTransaction;
      ExecSQL;
      Transacao.Commit;
      Result := True;
    except
      on E: Exception do
      begin
        Transacao.Rollback;
        sErro := 'Ocorreu um erro ao inserir um novo produto!' + sLineBreak + E.Message;
        Result := False;
        raise;
      end;
    end;
  end;
end;

function TProdutoRepository.Alterar(QryProdutos: TFDQuery; FProduto: TProduto; Transacao: TFDTransaction; iCodigo: Integer; out sErro: string): Boolean;
begin
  with QryProdutos, FProduto do
  begin
    Result := False;
    Close;
    SQL.Clear;
    SQL.Add('update tab_produto set ');
    Sql.Add('des_nomeproduto = :des_nomeproduto ');
    SQL.Add(',des_descricao = :des_descricao');
    SQL.Add(',val_preco = :val_preco');
    SQL.Add('where cod_produto = :cod_produto');

    ParamByName('DES_NOMEPRODUTO').AsString := Des_NomeProduto;
    ParamByName('DES_DESCRICAO').AsString := Des_Descricao;
    ParamByName('VAL_PRECO').AsFloat := Val_Preco;
    ParamByName('COD_PRODUTO').AsInteger := iCodigo;

    // Inicia Transação
    if not Transacao.Connection.Connected then
      Transacao.Connection.Open();

    try
      Prepared := True;
      Transacao.StartTransaction;
      ExecSQL;
      Transacao.Commit;
      Result := True;
    except
      on E: Exception do
      begin
        Transacao.Rollback;
        sErro := 'Ocorreu um erro ao alterar os dados do produto!' + sLineBreak + E.Message;
        Result := False;
        raise;
      end;
    end;
  end;
end;

function TProdutoRepository.Excluir(QryProdutos: TFDQuery; Transacao: TFDTransaction; iCodigo: Integer; out sErro: string): Boolean;
begin
  with QryProdutos do
  begin
    Close;
    SQL.Clear;
    SQL.Text := 'delete from tab_produto where cod_produto = :cod_produto';
    ParamByName('COD_PRODUTO').AsInteger := iCodigo;

    // Inicia Transação
    //DMConexao.FDConnection.StartTransaction;

    try
      Prepared := True;
      ExecSQL();
      Result := True;
      //DMConexao.FDConnection.Commit;
    except on E: Exception do
      begin
        sErro := 'Ocorreu um erro ao excluir o produto !' + sLineBreak + E.Message;
        Result := False;
        //DMConexao.FDConnection.Rollback;
        raise;
      end;
    end;
  end;
end;

function TProdutoRepository.RetornaValorUnitario(QryTemp: TFDQuery; iCodigo: integer): Double;
begin
  Result := 0;
  with QryTemp do
  begin
    SQL.Clear;
    SQL.Add('select cod_produto, ');
    SQL.Add('val_preco');
    SQL.Add('from tab_produto');
    SQL.Add('where cod_produto = :cod_produto');
    ParamByName('COD_PRODUTO').AsInteger := iCodigo;
    Open;
    Result := FieldByName('val_preco').AsFloat
  end;
end;

end.
