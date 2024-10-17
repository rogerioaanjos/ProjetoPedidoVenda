unit PedidoController;

interface

uses
  System.Generics.Collections, SysUtils, FireDAC.Comp.Client, FireDAC.Stan.Intf,
  FireDAC.Stan.Param, FireDAC.Phys.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.Stan.Def, FireDAC.VCLUI.Wait, FireDAC.Comp.DataSet, Conexao,
  PedidoProdutoService, PedidoService, PedidoModel, PedidoProdutoModel;

type
  TPedidoController = class
  private
    FPedidoService: TPedidoService;
    FPedidoProdutoService: TPedidoProdutoService;
  public
    constructor Create;
    destructor Destroy; override;

    function CriarPedido(PedidoModel: TPedidoModel; ListaProdutos: TList<TPedidoProdutoModel>): Boolean;
    function AtualizarPedido(PedidoModel: TPedidoModel; ListaProdutos: TList<TPedidoProdutoModel>): Boolean;
    function RemoverPedido(NumeroPedido: Integer): Boolean;
    function ListarPedidos: TList<TPedidoModel>;
    function LocalizarPedido(NumeroPedido: Integer): TPedidoModel;
    function CancelarPedido(NumeroPedido: Integer): Boolean;
  end;

implementation

{ TPedidoController }

constructor TPedidoController.Create;
begin
  FPedidoService := TPedidoService.Create;
  FPedidoProdutoService := TPedidoProdutoService.Create;
end;

destructor TPedidoController.Destroy;
begin
  FPedidoService.Free;
  FPedidoProdutoService.Free;
  inherited;
end;

function TPedidoController.CriarPedido(PedidoModel: TPedidoModel; ListaProdutos: TList<TPedidoProdutoModel>): Boolean;
var
  PedidoProdutoModel: TPedidoProdutoModel;
  NumeroPedido: Integer;
begin
  Result := False;

  if not DmConexao.FDConexao.InTransaction then
    DmConexao.FDConexao.StartTransaction;

  try
    NumeroPedido := FPedidoService.AdicionarPedido(PedidoModel);

    if NumeroPedido > 0 then
    begin
      for PedidoProdutoModel in ListaProdutos do
      begin
        PedidoProdutoModel.PedidoModel.NumeroPedido := NumeroPedido;

        if not FPedidoProdutoService.AdicionarPedidoProduto(PedidoProdutoModel) then
        begin
          raise Exception.Create('Erro ao adicionar produto: ' + PedidoProdutoModel.ProdutoModel.Descricao);
        end;
      end;

      DmConexao.FDConexao.Commit;
      Result := True;
    end;

  except
    on E: Exception do
    begin
      DmConexao.FDConexao.Rollback;
      raise Exception.CreateFmt('Erro ao criar pedido: %s', [E.Message]);
    end;
  end;
end;

function TPedidoController.AtualizarPedido(PedidoModel: TPedidoModel; ListaProdutos: TList<TPedidoProdutoModel>): Boolean;
var
  Produto: TPedidoProdutoModel;
begin
  Result := False;

  if not DmConexao.FDConexao.InTransaction then
    DmConexao.FDConexao.StartTransaction;

  try
    if FPedidoService.EditarPedido(PedidoModel) then
    begin
      for Produto in ListaProdutos do
      begin
        if not FPedidoProdutoService.EditarPedidoProduto(Produto) then
        begin
          raise Exception.Create('Erro ao atualizar produto: ' + Produto.ProdutoModel.Descricao);
        end;
      end;

      DmConexao.FDConexao.Commit;
      Result := True;
    end;

  except
    on E: Exception do
    begin
      DmConexao.FDConexao.Rollback;
      raise Exception.CreateFmt('Erro ao atualizar pedido: %s', [E.Message]);
    end;
  end;
end;

function TPedidoController.RemoverPedido(NumeroPedido: Integer): Boolean;
begin
  Result := False;

  if not DmConexao.FDConexao.InTransaction then
    DmConexao.FDConexao.StartTransaction;

  try
    if FPedidoService.ExcluirPedido(NumeroPedido) then
    begin
      DmConexao.FDConexao.Commit;
      Result := True;
    end;

  except
    on E: Exception do
    begin
      DmConexao.FDConexao.Rollback;
      raise Exception.CreateFmt('Erro ao remover pedido: %s', [E.Message]);
    end;
  end;
end;

function TPedidoController.ListarPedidos: TList<TPedidoModel>;
begin
  Result := FPedidoService.ObterPedidos;
end;

function TPedidoController.LocalizarPedido(NumeroPedido: Integer): TPedidoModel;
begin
  Result := FPedidoService.BuscarPedidoPorNumero(NumeroPedido);
end;

function TPedidoController.CancelarPedido(NumeroPedido: Integer): Boolean;
begin
  Result := False;

  if not DmConexao.FDConexao.InTransaction then
    DmConexao.FDConexao.StartTransaction;

  try
    if FPedidoProdutoService.ExcluirProdutosPorNumeroPedido(NumeroPedido) then
    begin
      if FPedidoService.ExcluirPedido(NumeroPedido) then
      begin
        DmConexao.FDConexao.Commit;
        Result := True;
      end;
    end;

  except
    on E: Exception do
    begin
      DmConexao.FDConexao.Rollback;
      raise Exception.CreateFmt('Erro ao cancelar pedido: %s', [E.Message]);
    end;
  end;
end;

end.
