program TesteTecnicoWK;

uses
  Vcl.Forms,
  umain in 'View\umain.pas' {FrmMain},
  ucadastropadrao in 'View\ucadastropadrao.pas' {FrmCadastroPadrao},
  ucadproduto in 'View\ucadproduto.pas' {FrmCadProduto},
  ucadvenda in 'View\ucadvenda.pas' {FrmCadVenda},
  upesqvendas in 'View\upesqvendas.pas' {FrmPesquisaVendas},
  cliente.controller in 'controller\cliente.controller.pas',
  produto.controller in 'controller\produto.controller.pas',
  venda.controller in 'controller\venda.controller.pas',
  vendaitens.controller in 'controller\vendaitens.controller.pas',
  untFormat in 'util\lib\untFormat.pas',
  icliente.repository in 'interface\icliente.repository.pas',
  iproduto.repository in 'interface\iproduto.repository.pas',
  conexao.service in 'service\conexao\conexao.service.pas',
  connection.service in 'service\conexao\connection.service.pas',
  cep.service in 'service\cep\cep.service.pas',
  cliente.model in 'model\cliente.model.pas',
  produto.model in 'model\produto.model.pas',
  venda.model in 'model\venda.model.pas',
  vendaitens.model in 'model\vendaitens.model.pas',
  cliente.repository in 'repository\cliente.repository.pas',
  produto.repository in 'repository\produto.repository.pas',
  venda.repository in 'repository\venda.repository.pas',
  vendaitens.repository in 'repository\vendaitens.repository.pas',
  produto.service in 'service\produto\produto.service.pas',
  iproduto.service in 'interface\iproduto.service.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmMain, FrmMain);
  Application.Run;
end.
