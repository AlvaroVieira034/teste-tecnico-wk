unit produto.repository;

interface

uses iproduto.repository, produto.model, conexao.service, System.SysUtils, FireDAC.Comp.Client, FireDAC.Stan.Param,
     Data.DB;

type
  TProdutoRepository = class(TInterfacedObject, IProdutoRepository)
  private
    TblProdutos: TFDQuery;
    QryProdutos: TFDQuery;
    QryTemp: TFDQuery;
    DsProdutos: TDataSource;
    Transacao: TFDTransaction;

  public
    constructor Create;
    destructor Destroy; override;
    function Inserir(FProduto: TProduto; out sErro: string): Boolean;
    function Alterar(FProduto: TProduto; iCodigo: Integer; out sErro: string): Boolean;
    function Excluir(iCodigo: Integer; out sErro : string): Boolean;

  end;

implementation

{ TProdutoRepository }


constructor TProdutoRepository.Create;
begin
  inherited Create;
  Transacao := TConexao.GetInstance.Connection.CriarTransaction;
  QryProdutos := TConexao.GetInstance.Connection.CriarQuery;
  QryProdutos.Transaction := Transacao;
end;

destructor TProdutoRepository.Destroy;
begin
  QryProdutos.Free;
  inherited Destroy;
end;

function TProdutoRepository.Inserir(FProduto: TProduto; out sErro: string): Boolean;
begin
  with QryProdutos, FProduto do
  begin
    Close;
    SQL.Clear;
    SQL.Add('insert into tab_produto(');
    SQL.Add('des_descricao, ');
    SQL.Add('val_preco) ');
    SQL.Add('values (:des_descricao, ');
    SQL.Add(':val_preco)');

    ParamByName('DES_DESCRICAO').AsString := Des_Descricao;
    ParamByName('VAL_PRECO').AsFloat := Val_Preco;

    // Inicia Transa��o
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

function TProdutoRepository.Alterar(FProduto: TProduto; iCodigo: Integer; out sErro: string): Boolean;
begin
  with QryProdutos, FProduto do
  begin
    Result := False;
    Close;
    SQL.Clear;
    SQL.Add('update tab_produto set ');
    SQL.Add('des_descricao = :des_descricao, ');
    SQL.Add('val_preco = :val_preco');
    SQL.Add('where cod_produto = :cod_produto');

    ParamByName('DES_DESCRICAO').AsString := Des_Descricao;
    ParamByName('VAL_PRECO').AsFloat := Val_Preco;
    ParamByName('COD_PRODUTO').AsInteger := iCodigo;

    // Inicia Transa��o
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

function TProdutoRepository.Excluir(iCodigo: Integer; out sErro: string): Boolean;
begin
  with QryProdutos do
  begin
    Close;
    SQL.Clear;
    SQL.Text := 'delete from tab_produto where cod_produto = :cod_produto';
    ParamByName('COD_PRODUTO').AsInteger := iCodigo;

    // Inicia Transa��o
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
        sErro := 'Ocorreu um erro ao excluir o produto !' + sLineBreak + E.Message;
        Result := False;
        raise;
      end;
    end;
  end;
end;

end.
