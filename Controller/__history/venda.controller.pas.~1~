unit venda.controller;

interface

uses umain, venda.model, system.SysUtils, Vcl.Forms, FireDAC.Comp.Client;

type
  TVendaController = class

  private
    FVenda: TVenda;

  public
    constructor Create();
    destructor Destroy; override;
    procedure Pesquisar(TblVendas: TFDQuery; sNome, sFiltro: string);
    function Carregar(QryVendas: TFDQuery; FVenda: TVenda; iCodigo: Integer): Boolean;
    function Inserir(QryVendas: TFDQuery; FVenda: TVenda; var sErro: string): Boolean;
    function Alterar(QryVendas: TFDQuery; FVenda: TVenda; iCodigo: Integer; sErro: string): Boolean;
    function Excluir(QryVendas: TFDQuery; iCodigo: Integer; var sErro: string): Boolean;
    {function ValidarNome(const Nome: string): Boolean;
    function ValidarDescricao(const Descricao: string): Boolean;
    function ValidarPreco(const Preco: string): Boolean;}

  end;

implementation

{ TVendaController }

constructor TVendaController.Create;
begin
  FVenda := TVenda.Create();
end;

destructor TVendaController.Destroy;
begin
  FVenda.Free;
  inherited;
end;

procedure TVendaController.Pesquisar(TblVendas: TFDQuery; sNome, sFiltro: string);
var LCampoIndice, sErro: string;
begin
  try
    if sFiltro = 'Código' then
      LCampoIndice := 'prd.cod_produto'
    else
    if sFiltro = 'Nome' then
      LCampoIndice := 'prd.des_nomeproduto'
    else
      LCampoIndice := 'prd.des_descricao';

    FVenda.Pesquisar(TblVendas, sNome, LCampoIndice);
  except on E: Exception do
    begin
      sErro := 'Ocorreu um erro ao pesquisar a venda!' + sLineBreak + E.Message;
      raise;
    end;
  end;

end;

function TVendaController.Carregar(QryVendas: TFDQuery; FVenda: TVenda; iCodigo: Integer): Boolean;
var sErro: string;
begin
  try
    FVenda.Carregar(QryVendas, FVenda, iCodigo);
  except on E: Exception do
    begin
      sErro := 'Ocorreu um erro ao carregar a venda!' + sLineBreak + E.Message;
      Result := False;
      raise;
    end;
  end;
end;

function TVendaController.Inserir(QryVendas: TFDQuery; FVenda: TVenda; var sErro: string): Boolean;
begin
  try
    FVenda.Inserir(QryVendas, FVenda, sErro);
  except on E: Exception do
    begin
      sErro := 'Ocorreu um erro ao inserir a venda!' + sLineBreak + E.Message;
      Result := False;
      raise;
    end;
  end;
end;

function TVendaController.Alterar(QryVendas: TFDQuery; FVenda: TVenda; iCodigo: Integer; sErro: string): Boolean;
begin
  try
    FVenda.Alterar(QryVendas, FVenda, iCodigo, sErro);
  except on E: Exception do
    begin
      sErro := 'Ocorreu um erro ao alterar o produto!' + sLineBreak + E.Message;
      Result := False;
      raise;
    end;
  end;
end;

function TVendaController.Excluir(QryVendas: TFDQuery; iCodigo: Integer; var sErro: string): Boolean;
begin
  try
    FVenda.Excluir(QryVendas, iCodigo, sErro);
    Result := True;
  except on E: Exception do
    begin
      sErro := 'Ocorreu um erro ao excluir a venda!' + sLineBreak + E.Message;
      Result := False;
      raise;
    end;
  end;
end;


end.
