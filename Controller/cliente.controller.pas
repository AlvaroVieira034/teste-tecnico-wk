unit cliente.controller;

interface

uses cliente.model, clienterepository.model, conexao.model, System.SysUtils, FireDAC.Comp.Client, FireDAC.Stan.Param;

type
  TCampoInvalido = (ciData, ciCliente, ciValor, ciValorZero);
  TClienteController = class

  private
    FCliente: TCliente;
    FClienteRepo : TClienteRepository;

  public
    constructor Create();
    destructor Destroy; override;
    procedure PreencherGrid(TblClientes: TFDQuery; APesquisa, ACampo: string);
    procedure CarregarCampos(QryClientes: TFDQuery; FCliente: TCliente; ACodigo: Integer);
    function Inserir(QryClientes: TFDQuery; FCliente: TCliente; Transacao: TFDTransaction; out sErro: string): Boolean;
    function Alterar(QryClientes: TFDQuery; FCliente: TCliente; Transacao: TFDTransaction; ACodigo: Integer; out sErro: string): Boolean;
    function Excluir(QryClientes: TFDQuery; Transacao: TFDTransaction; ACodigo: Integer; out sErro : string): Boolean;



  end;


implementation

{ TClienteController }

constructor TClienteController.Create;
begin
  FCliente := TCliente.Create();
  FClienteRepo := TClienteRepository.Create();
end;

destructor TClienteController.Destroy;
begin
  FCliente.Free;
  FClienteRepo.Free;
  inherited;
end;

procedure TClienteController.PreencherGrid(TblClientes: TFDQuery; APesquisa, ACampo: string);
var LCampo, SErro: string;
    //ClienteRepo: TClienteRepository;
begin
  //ClienteRepo := TClienteRepository.Create;
  try
    if ACampo = 'Código' then
      LCampo := 'cli.cd_cliente';

    if ACampo = 'Nome' then
      LCampo := 'cli.des_nomecliente';

    if ACampo = 'Cidade' then
      LCampo := 'cli.des_cidade';

    if ACampo = '' then
      LCampo := 'cli.des_nomecliente';

    FClienteRepo.PreencherGrid(TblClientes, APesquisa, LCampo);
  except on E: Exception do
    begin
      SErro := 'Ocorreu um erro ao pesquisar a venda!' + sLineBreak + E.Message;
      raise;
    end;
  end;
end;

function TClienteController.Inserir(QryClientes: TFDQuery; FCliente: TCliente; Transacao: TFDTransaction; out sErro: string): Boolean;
begin

end;

procedure TClienteController.CarregarCampos(QryClientes: TFDQuery; FCliente: TCliente; ACodigo: Integer);
begin

end;

function TClienteController.Alterar(QryClientes: TFDQuery; FCliente: TCliente; Transacao: TFDTransaction; ACodigo: Integer; out sErro: string): Boolean;
begin

end;

function TClienteController.Excluir(QryClientes: TFDQuery;  Transacao: TFDTransaction; ACodigo: Integer; out sErro: string): Boolean;
begin

end;


end.
