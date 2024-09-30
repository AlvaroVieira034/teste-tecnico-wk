unit produto.controller;

interface

uses umain, produto.model, produtorepository.model, system.SysUtils, Vcl.Forms, FireDAC.Comp.Client;

type
  TCampoInvalido = (ciNome, ciDescricao, ciPreco, ciPrecoZero);
  TProdutoController = class

  private
    FProduto: TProduto;
    FProdutoRepo: TProdutoRepository;

  public
    constructor Create();
    destructor Destroy; override;
    procedure PreencherGrid(TblProdutos: TFDQuery; sPesquisa, sCampo: string);
    function CarregarCampos(QryProdutos: TFDQuery; FProduto: TProduto; iCodigo: Integer): Boolean;
    function Inserir(QryProdutos: TFDQuery; FProduto: TProduto; Transacao: TFDTransaction; var sErro: string): Boolean;
    function Alterar(QryProdutos: TFDQuery; FProduto: TProduto; Transacao: TFDTransaction; iCodigo: Integer; sErro: string): Boolean;
    function Excluir(QryProdutos: TFDQuery; Transacao: TFDTransaction; iCodigo: Integer; var sErro: string): Boolean;
    function ValidarDados(const ANome, ADescricao, APreco: string; out AErro: TCampoInvalido): Boolean;

  end;

implementation

//uses ;

{ TProdutoController }

constructor TProdutoController.Create();
begin
  FProduto := TProduto.Create();
  FProdutoRepo := TProdutoRepository.Create;
end;

destructor TProdutoController.Destroy;
begin
  FProduto.Free;
  FProdutoRepo.Free;
  inherited;
end;

procedure TProdutoController.PreencherGrid(TblProdutos: TFDQuery; sPesquisa, sCampo: string);
var lCampo, sErro: string;
begin
  if sCampo = 'Código' then
    lCampo := 'prd.cod_produto'
  else
  if sCampo = 'Nome' then
    lCampo := 'prd.des_nomeproduto'
  else
    lCampo := 'prd.des_descricao';

  FProdutoRepo.PreencherGrid(TblProdutos, sPesquisa, lCampo);
end;

function TProdutoController.CarregarCampos(QryProdutos: TFDQuery; FProduto: TProduto; iCodigo: Integer): Boolean;
var sErro: string;
begin
  try
    FProdutoRepo.CarregarCampos(QryProdutos, FProduto, iCodigo);
  except on E: Exception do
    begin
      sErro := 'Ocorreu um erro ao carregar o produto!' + sLineBreak + E.Message;
      Result := False;
      raise;
    end;
  end;
end;

function TProdutoController.Inserir(QryProdutos: TFDQuery; FProduto: TProduto; Transacao: TFDTransaction; var sErro: string): Boolean;
begin
  Result := FProdutoRepo.Inserir(QryProdutos, FProduto, Transacao, sErro);
end;

function TProdutoController.Alterar(QryProdutos: TFDQuery; FProduto: TProduto; Transacao: TFDTransaction; iCodigo: Integer; sErro: string): Boolean;
begin
  Result := FProdutoRepo.Alterar(QryProdutos, FProduto, Transacao, iCodigo, sErro);
end;

function TProdutoController.Excluir(QryProdutos: TFDQuery; Transacao: TFDTransaction; iCodigo: Integer; var sErro: String): Boolean;
begin
  Result := FProdutoRepo.Excluir(QryProdutos, Transacao, iCodigo, sErro);
end;

function TProdutoController.ValidarDados(const ANome, ADescricao, APreco: string; out AErro: TCampoInvalido): Boolean;
begin
  Result := True;

  if ANome = EmptyStr then
  begin
    AErro := ciNome;
    Result := False;
    Exit;
  end;

  if ADescricao = EmptyStr then
  begin
    AErro := ciDescricao;
    Result := False;
    Exit;
  end;

  if APreco = EmptyStr then
  begin
    AErro := ciPreco;
    Result := False;
    Exit;
  end;

  if APreco = '0.00' then
  begin
    AErro := ciPrecoZero;
    Result := False;
    Exit;
  end;
end;

end.
