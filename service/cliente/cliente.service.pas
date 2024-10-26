unit cliente.service;

interface

uses icliente.service, cliente.model, conexao.service, System.SysUtils, FireDAC.Comp.Client, FireDAC.Stan.Param,
     Data.DB;

type
  TClienteService = class(TInterfacedObject, IClienteService)
  private
    TblClientes: TFDQuery;
    QryTemp: TFDQuery;
    DsClientes: TDataSource;

  public
    constructor Create;
    destructor Destroy; override;
    procedure PreencherGridClientes(APesquisa, ACampo: string);
    procedure PreencherComboClientes;
    procedure PreencherCamposForm(FCliente: TCliente; ACodigo: Integer);
    procedure CriarTabelas;
    function GetDataSource: TDataSource;
    function VerificaClienteUtilizado(ACodigo: Integer): Boolean;

  end;

implementation

{ TClienteService }

constructor TClienteService.Create;
begin
  CriarTabelas();
end;

destructor TClienteService.Destroy;
begin
  TblClientes.Free;
  QryTemp.Free;
  DsClientes.Free;
  inherited;
end;

procedure TClienteService.PreencherGridClientes(APesquisa, ACampo: string);
begin
  with TblClientes do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select cli.cod_cliente,  ');
    SQL.Add('cli.des_nomecliente, ');
    SQL.Add('cli.des_cpfcnpj, ');
    SQL.Add('cli.dta_nascimento, ');
    SQL.Add('cli.des_cep, ');
    SQL.Add('cli.des_endereco, ');
    SQL.Add('cli.des_complemento, ');
    SQL.Add('cli.des_bairro, ');
    SQL.Add('cli.des_cidade, ');
    SQL.Add('cli.des_uf ');
    SQL.Add('from tab_cliente cli');
    SQL.Add('where ' + ACampo + ' like :pNOME');
    SQL.Add('order by ' + ACampo);
    ParamByName('PNOME').AsString := APesquisa;
    Open();
  end;
end;

procedure TClienteService.PreencherComboClientes;
begin
  with TblClientes do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from tab_cliente order by des_nomecliente ');
    Open();
  end;
end;

procedure TClienteService.PreencherCamposForm(FCliente: TCliente; ACodigo: Integer);
begin
  with TblClientes do
  begin
    SQL.Clear;
    SQL.Add('select cli.cod_cliente,  ');
    SQL.Add('cli.des_nomecliente, ');
    SQL.Add('cli.des_cpfcnpj, ');
    SQL.Add('cli.dta_nascimento, ');
    SQL.Add('cli.des_cep, ');
    SQL.Add('cli.des_endereco, ');
    SQL.Add('cli.des_complemento, ');
    SQL.Add('cli.des_bairro, ');
    SQL.Add('cli.des_cidade, ');
    SQL.Add('cli.des_uf ');
    SQL.Add('from tab_cliente cli');
    SQL.Add('where cod_cliente = :cod_cliente');
    ParamByName('cod_cliente').AsInteger := ACodigo;
    Open;

    FCliente.Cod_Cliente := FieldByName('COD_CLIENTE').AsInteger;
    FCliente.Des_NomeCliente := FieldByName('DES_NOMECLIENTE').AsString;
    FCliente.Des_CpfCnpj := FieldByName('DES_CPFCNPJ').AsString;
    FCliente.Dta_Nascimento := FieldByName('DTA_NASCIMENTO').AsDateTime;
    FCliente.Des_Cep := FieldByName('DES_CEP').AsString;
    FCliente.Des_Endereco := FieldByName('DES_ENDERECO').AsString;
    FCliente.Des_Complemento := FieldByName('DES_COMPLEMENTO').AsString;
    FCliente.Des_Bairro := FieldByName('DES_BAIRRO').AsString;
    FCliente.Des_Cidade := FieldByName('DES_CIDADE').AsString;
    FCliente.Des_UF := FieldByName('DES_UF').AsString;
  end;
end;

procedure TClienteService.CriarTabelas;
begin
  TblClientes := TConexao.GetInstance.Connection.CriarQuery;
  QryTemp := TConexao.GetInstance.Connection.CriarQuery;
  DsClientes := TConexao.GetInstance.Connection.CriarDataSource;
  DsClientes.DataSet := TblClientes;
end;

function TClienteService.GetDataSource: TDataSource;
begin
  Result := DsClientes;
end;


function TClienteService.VerificaClienteUtilizado(ACodigo: Integer): Boolean;
begin
  with QryTemp do
  begin
    SQL.Clear;
    SQL.Add('select cod_cliente ');
    SQL.Add('from tab_venda');
    SQL.Add('where cod_cliente = :cod_cliente');
    ParamByName('COD_CLIENTE').AsInteger := ACodigo;
    Open;
    Result := not QryTemp.Eof;
  end;
end;


end.
