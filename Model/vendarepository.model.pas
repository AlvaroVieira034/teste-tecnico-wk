unit vendarepository.model;

interface

uses venda.model, conexao.model, System.SysUtils, FireDAC.Comp.Client, FireDAC.Stan.Param;

type
  TVendaRepository = class
  public
    procedure PreencherGrid(TblVendas: TFDQuery; APesquisa, ACampo: string);
    procedure CarregarCampos(QryVendas: TFDQuery; FVenda: TVenda; ACodigo: Integer);
    function Inserir(QryVendas: TFDQuery; FVenda: TVenda; Transacao: TFDTransaction; out sErro: string): Boolean;
    function Alterar(QryVendas: TFDQuery; FVenda: TVenda; Transacao: TFDTransaction; ACodigo: Integer; out sErro: string): Boolean;
    function Excluir(QryVendas: TFDQuery; Transacao: TFDTransaction; ACodigo: Integer; out sErro : string): Boolean;

  end;

implementation

{ TVendaRepository }

procedure TVendaRepository.PreencherGrid(TblVendas: TFDQuery; APesquisa, ACampo: string);
begin
  with TblVendas do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select vda.cod_venda, ');
    SQL.Add('vda.dta_venda, ');
    SQL.Add('vda.cod_cliente, ');
    SQL.Add('cli.des_nomecliente as nomecliente, ');
    SQL.Add('vda.val_venda');
    SQL.Add('from tab_venda vda');
    SQL.Add('join tab_cliente cli on vda.cod_cliente = cli.cod_cliente ');
    SQL.Add('where ' + ACampo + ' like :pNOME');
    SQL.Add('order by ' + ACampo + ' desc');
    ParamByName('PNOME').AsString := APesquisa;
    Prepared := True;
    Open();
  end;
end;

procedure TVendaRepository.CarregarCampos(QryVendas: TFDQuery; FVenda: TVenda; ACodigo: Integer);
begin
  with QryVendas do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select vda.cod_venda, ');
    SQL.Add('vda.dta_venda, ');
    SQL.Add('vda.cod_cliente, ');
    SQL.Add('cli.des_nomecliente as des_cliente, ');
    SQL.Add('vda.val_venda');
    SQL.Add('from tab_venda vda');
    SQL.Add('join tab_cliente cli on vda.cod_cliente = cli.cod_cliente ');
    SQL.Add('where vda.cod_venda = :cod_venda');
    ParamByName('COD_VENDA').AsInteger := ACodigo;
    Open();

    if not QryVendas.Eof then
    begin
      with FVenda, QryVendas do
      begin
        Cod_Venda := FieldByName('COD_VENDA').AsInteger;
        Dta_Venda := FieldByName('DTA_VENDA').AsDateTime;
        Cod_Cliente := FieldByName('COD_CLIENTE').AsInteger;
        Des_Cliente := FieldByName('DES_CLIENTE').AsString;
        Val_Venda := FieldByName('VAL_VENDA').AsFloat;
      end;
    end;
  end;
end;

function TVendaRepository.Inserir(QryVendas: TFDQuery; FVenda: TVenda; Transacao: TFDTransaction; out sErro: string): Boolean;
var ultimoCod_Venda: Integer;
begin
  with QryVendas, FVenda do
  begin
    Close;
    SQL.Clear;
    SQL.Add('insert into tab_venda(');
    SQL.Add('dta_venda, ');
    SQL.Add('cod_cliente, ');
    SQL.Add('val_venda) ');
    SQL.Add('values (:dta_venda, ');
    SQL.Add(':cod_cliente, ');
    SQL.Add(':val_venda)');

    ParamByName('DTA_VENDA').AsDateTime := Dta_Venda;
    ParamByName('COD_CLIENTE').AsInteger := Cod_Cliente;
    ParamByName('VAL_VENDA').AsFloat := Val_Venda;

    try
      Prepared := True;
      ExecSQL;
      Result := True;

      QryVendas.Close;
      QryVendas.SQL.Text := 'SELECT MAX(COD_VENDA) AS ULTIMOID FROM TAB_VENDA ';
      QryVendas.Open;
      FVenda.Cod_Venda := QryVendas.FieldByName('ULTIMOID').AsInteger;

    except
      on E: Exception do
      begin
        sErro := 'Ocorreu um erro ao inserir uma nova venda!' + sLineBreak + E.Message;
        Result := False;
        raise;
      end;
    end;
  end;
end;

function TVendaRepository.Alterar(QryVendas: TFDQuery; FVenda: TVenda; Transacao: TFDTransaction; ACodigo: Integer; out sErro: string): Boolean;
begin
  with QryVendas, FVenda do
  begin
    Result := False;
    Close;
    SQL.Clear;
    SQL.Add('update tab_venda set ');
    SQL.Add('dta_venda = :dta_venda, ');
    SQL.Add('cod_cliente = :cod_cliente, ');
    SQL.Add('val_venda = :val_venda');
    SQL.Add('where cod_venda = :cod_venda');

    ParamByName('DTA_VENDA').AsDateTime := Dta_Venda;
    ParamByName('COD_CLIENTE').AsInteger := Cod_Cliente;
    ParamByName('VAL_VENDA').AsFloat := Val_Venda;
    ParamByName('COD_VENDA').AsInteger := ACodigo;

    try
      Prepared := True;
      ExecSQL;
      Result := True;
    except on E: Exception do
      begin
        sErro := 'Ocorreu um erro ao alterar os dados da venda!' + sLineBreak + E.Message;
        Result := False;
        raise;
      end;
    end;
    Result:= True;
  end;
end;

function TVendaRepository.Excluir(QryVendas: TFDQuery; Transacao: TFDTransaction; ACodigo: Integer; out sErro: string): Boolean;
begin
  with QryVendas do
  begin
    Close;
    SQL.Clear;
    SQL.Text := 'delete from tab_venda where cod_venda = :cod_venda';
    ParamByName('COD_VENDA').AsInteger := ACodigo;

    // Inicia Transa��o
    if not Transacao.Connection.Connected then
      Transacao.Connection.Open();

    try
      Prepared := True;
      Transacao.StartTransaction;
      ExecSQL;
      Transacao.Commit;
      Result := True;
    except on E: Exception do
      begin
        Transacao.Rollback;
        sErro := 'Ocorreu um erro ao excluir a venda !' + sLineBreak + E.Message;
        Result := False;
        raise;
      end;
    end;
  end;
end;


end.
