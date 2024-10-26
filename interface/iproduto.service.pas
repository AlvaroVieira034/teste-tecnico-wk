unit iproduto.service;

interface

uses produto.model, Data.DB;

type
  IProdutoService = interface
    ['{164910FA-5FC2-4B5C-B6D8-2E293AFF926C}']
    procedure PreencherGridProdutos(APesquisa, ACampo: string);
    procedure PreencherComboProdutos;
    procedure PreencherCamposForm(FProduto: TProduto; iCodigo: Integer);
    function GetValorUnitario(ACodigo: Integer): Double;
    function GetDataSource: TDataSource;
    procedure CriarTabelas;
    procedure CriarCamposTabelas;

  end;

implementation

end.
