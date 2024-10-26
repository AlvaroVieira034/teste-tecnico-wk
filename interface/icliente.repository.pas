unit icliente.repository;

interface

uses cliente.model, Data.DB, System.SysUtils;

type
  IClienteRepository = interface
    ['{ACAED3AD-F7E1-4BDD-AF6C-91537F93E548}']
    function Inserir(FCliente: TCliente; out sErro: string): Boolean;
    function Alterar(FCliente: TCliente; ACodigo: Integer; out sErro: string): Boolean;
    function Excluir(ACodigo: Integer; out sErro : string): Boolean;
    function ExecutarTransacao(AOperacao: TProc; var sErro: string): Boolean;

  end;

implementation

end.
