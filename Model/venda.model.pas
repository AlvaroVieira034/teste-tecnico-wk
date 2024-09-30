unit venda.model;

interface

uses umain, System.SysUtils, FireDAC.Comp.Client;

Type
  TVenda = class
  private
    FCod_Venda: Integer;
    FDta_Venda: TDateTime;
    FCod_Cliente: Integer;
    FDes_Cliente: string;
    FVal_Venda: Double;
    procedure SetCod_Cliente(const Value: Integer);

  public
    property Cod_Venda: Integer read FCod_Venda write FCod_Venda;
    property Dta_Venda: TDateTime read FDta_Venda write FDta_Venda;
    property Cod_Cliente: Integer read FCod_Cliente write SetCod_Cliente;
    property Des_Cliente: string read FDes_Cliente write FDes_Cliente;
    property Val_Venda: Double read FVal_Venda write FVal_Venda;

  end;

implementation

{ TVenda }


procedure TVenda.SetCod_Cliente(const Value: Integer);
begin
  if Value = 0 then
    raise EArgumentException.Create('O campo ''c�digo do cliente'' precisa ser preenchido!');

  FCod_Cliente := Value;
end;


end.
