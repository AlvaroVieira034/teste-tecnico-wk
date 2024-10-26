unit ivenda.service;

interface

uses venda.model, Data.DB, FireDAC.Comp.Client;

type
  IVendaService = interface
    ['{5DD9E2B4-ACD0-4DBD-AEE2-1E6CA9F33D43}']
    procedure PreencherGridVendas(APesquisa, ACampo: string);
    procedure PreencherCamposForm(FVenda: TVenda; ACodigo: Integer);

  end;

implementation

end.
