program PedidoVenda;

uses
  Vcl.Forms,
  Principal in 'Principal.pas' {frmPrincipal},
  Conexao in 'DataModule\Conexao.pas' {DmConexao: TDataModule},
  ClienteModel in 'Model\ClienteModel.pas',
  ClienteService in 'Services\ClienteService.pas',
  ClienteController in 'Controller\ClienteController.pas',
  ProdutoModel in 'Model\ProdutoModel.pas',
  ProdutoService in 'Services\ProdutoService.pas',
  ProdutoController in 'Controller\ProdutoController.pas',
  PedidoModel in 'Model\PedidoModel.pas',
  PedidoProdutoModel in 'Model\PedidoProdutoModel.pas',
  PedidoService in 'Services\PedidoService.pas',
  PedidoProdutoService in 'Services\PedidoProdutoService.pas',
  PedidoController in 'Controller\PedidoController.pas',
  PedidoProdutoController in 'Controller\PedidoProdutoController.pas',
  Utils in 'Utils\Utils.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.CreateForm(TDmConexao, DmConexao);
  Application.Run;
end.