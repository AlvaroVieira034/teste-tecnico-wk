unit vendaitens.model;

interface

uses System.SysUtils, FireDAC.Comp.Client;

Type
  TVendaItens = class
  private
    FCod_Venda: Integer;
    FCod_Produto: Integer;
    FDes_Descricao: string;
    FVal_Quantidade: Integer;
    FVal_PrecoUnitario: Double;
    FVal_TotalItem: Double;
    procedure SetCod_Produto(const Value: Integer);

  public
    property Cod_Venda: Integer read FCod_Venda write FCod_Venda;
    property Cod_Produto: Integer read FCod_Produto write SetCod_Produto;
    property Des_Descricao: string read FDes_Descricao write FDes_Descricao;
    property Val_Quantidade: Integer read FVal_Quantidade write FVal_Quantidade;
    property Val_PrecoUnitario: Double read FVal_PrecoUnitario write FVal_PrecoUnitario;
    property Val_TotalItem: Double read FVal_TotalItem write FVal_TotalItem;

  end;

implementation

{ TVendaItens }

procedure TVendaItens.SetCod_Produto(const Value: Integer);
begin
  if Value = 0 then
    raise EArgumentException.Create('O campo ''C�digo do Produto'' precisa ser preenchido !');

  FCod_Produto := Value;
end;

end.
