unit vendaitensrepository.model;

interface

uses vendaitens.model, conexao.model, System.SysUtils, FireDAC.Comp.Client, FireDAC.Stan.Param;

type
  TVendaItensRepository = class
  private

  public
    procedure Carregar(QryVendaItens: TFDQuery; FVendaItens: TVendaItens; ACodigo: Integer);
    function Inserir(QryVendaItens: TFDQuery; FVendaItens: TVendaItens; TransacaoItens: TFDTransaction; out sErro: string): Boolean;
    function Excluir(QryVendaItens: TFDQuery; TransacaoItens: TFDTransaction; ACodigo: Integer; out sErro: string): Boolean;

  end;

implementation

{ TVendasItensRepository }

procedure TVendaItensRepository.Carregar(QryVendaItens: TFDQuery; FVendaItens: TVendaItens; ACodigo: Integer);
begin
  with QryVendaItens, FVendaItens do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select vdi.id_venda, ');
    SQL.Add('vdi.cod_venda, ');
    SQL.Add('vdi.cod_produto, ');
    SQL.Add('prd.des_descricao, ');
    SQL.Add('vdi.val_quantidade,');
    SQL.Add('vdi.val_precounitario, ');
    SQL.Add('vdi.val_totalitem');
    SQL.Add('from tab_venda_item vdi');
    SQL.Add('join tab_produto prd on vdi.cod_produto = prd.cod_produto');
    SQL.Add('where vdi.cod_venda = :cod_venda');
    SQL.Add('order by vdi.id_venda');
    ParamByName('COD_VENDA').AsInteger := ACodigo;
    Open;
  end;
end;

function TVendaItensRepository.Inserir(QryVendaItens: TFDQuery; FVendaItens: TVendaItens; TransacaoItens: TFDTransaction; out sErro: string): Boolean;
begin
  with QryVendaItens, FVendaItens do
  begin
    Close;
    SQL.Clear;
    SQL.Add('insert into tab_venda_item( ');
    SQL.Add('cod_venda, ');
    SQL.Add('cod_produto, ');
    SQL.Add('val_precounitario, ');
    SQL.Add('val_quantidade, ');
    SQL.Add('val_totalitem) ');
    SQL.Add('values (:cod_venda, ');
    SQL.Add(':cod_produto, ');
    SQL.Add(':val_precounitario, ');
    SQL.Add(':val_quantidade, ');
    SQL.Add(':val_totalitem) ');

    ParamByName('COD_VENDA').AsInteger := Cod_Venda;
    ParamByName('COD_PRODUTO').AsInteger := Cod_Produto;
    ParamByName('VAL_PRECOUNITARIO').AsFloat := Val_PrecoUnitario;
    ParamByName('VAL_QUANTIDADE').AsInteger := Val_Quantidade;
    ParamByName('VAL_TOTALITEM').AsFloat := Val_TotalItem;

    try
      Prepared := True;
      ExecSQL;
      Result := True;
    except
      on E: Exception do
      begin
        sErro := 'Ocorreu um erro ao inserir um novo item da venda!' + sLineBreak + E.Message;
        Result := False;
        raise;
      end;
    end;
  end;
end;

function TVendaItensRepository.Excluir(QryVendaItens: TFDQuery; TransacaoItens: TFDTransaction; ACodigo: Integer; out sErro: string): Boolean;
begin
  with QryVendaItens do
  begin
    Close;
    SQL.Clear;
    SQL.Text := 'delete from tab_venda_item where cod_venda = :cod_venda';
    ParamByName('COD_VENDA').AsInteger := ACodigo;

    // Inicia Transa��o
    if not TransacaoItens.Connection.Connected then
      TransacaoItens.Connection.Open();

    try
      Prepared := True;
      TransacaoItens.StartTransaction;
      ExecSQL;
      TransacaoItens.Commit;
      Result := True;
    except on E: Exception do
      begin
        TransacaoItens.Rollback;
        sErro := 'Ocorreu um erro ao excluir os itens da venda !' + sLineBreak + E.Message;
        Result := False;
        raise;
      end;
    end;
  end;
end;

end.
