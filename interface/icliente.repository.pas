unit icliente.repository;

interface

uses cliente.model, Data.DB;

type
  IClienteRepository = interface
    ['{ACAED3AD-F7E1-4BDD-AF6C-91537F93E548}']
    procedure PreencherGrid(APesquisa, ACampo: string);
    procedure PreencherComboCliente;
    procedure CarregarCampos(FCliente: TCliente; ACodigo: Integer);
    function Inserir(FCliente: TCliente; out sErro: string): Boolean;
    function Alterar(FCliente: TCliente; ACodigo: Integer; out sErro: string): Boolean;
    function Excluir(ACodigo: Integer; out sErro : string): Boolean;
    function GetDataSource: TDataSource;
    procedure CriarTabelas;
    procedure CriarCamposTabelas;

  end;

implementation

end.