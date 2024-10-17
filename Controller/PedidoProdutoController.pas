unit PedidoProdutoController;

interface

uses
  System.Generics.Collections, PedidoProdutoService, PedidoProdutoModel, SysUtils,
  FireDAC.Comp.Client, Conexao;

type
  TPedidoProdutoController = class
  private
    FPedidoProdutoService: TPedidoProdutoService;
  public
    constructor Create;
    destructor Destroy; override;

    function CriarProduto(PedidoProdutoModel: TPedidoProdutoModel): Boolean;
    function AtualizarProduto(PedidoProdutoModel: TPedidoProdutoModel): Boolean;
    function RemoverProduto(IdPedidoProduto: Integer): Boolean;
    function ListarProdutosPorPedido(NumeroPedido: Integer): TList<TPedidoProdutoModel>;
  end;

implementation

{ TPedidoProdutoController }

constructor TPedidoProdutoController.Create;
begin
  FPedidoProdutoService := TPedidoProdutoService.Create;
end;

destructor TPedidoProdutoController.Destroy;
begin
  FPedidoProdutoService.Free;
  inherited;
end;

function TPedidoProdutoController.CriarProduto(PedidoProdutoModel: TPedidoProdutoModel): Boolean;
begin
  Result := False;

  if not DmConexao.FDConexao.InTransaction then
    DmConexao.FDConexao.StartTransaction;

  try
    if FPedidoProdutoService.AdicionarPedidoProduto(PedidoProdutoModel) then
    begin
      DmConexao.FDConexao.Commit;
      Result := True;
    end;

  except
    on E: Exception do
    begin
      DmConexao.FDConexao.Rollback;
      raise Exception.CreateFmt('Erro ao criar produto: %s', [E.Message]);
    end;
  end;
end;

function TPedidoProdutoController.AtualizarProduto(PedidoProdutoModel: TPedidoProdutoModel): Boolean;
begin
  Result := False;

  if not DmConexao.FDConexao.InTransaction then
    DmConexao.FDConexao.StartTransaction;

  try
    if FPedidoProdutoService.EditarPedidoProduto(PedidoProdutoModel) then
    begin
      DmConexao.FDConexao.Commit;
      Result := True;
    end;

  except
    on E: Exception do
    begin
      DmConexao.FDConexao.Rollback;
      raise Exception.CreateFmt('Erro ao atualizar produto: %s', [E.Message]);
    end;
  end;
end;

function TPedidoProdutoController.RemoverProduto(IdPedidoProduto: Integer): Boolean;
begin
  Result := False;

  if not DmConexao.FDConexao.InTransaction then
    DmConexao.FDConexao.StartTransaction;

  try
    if FPedidoProdutoService.ExcluirPedidoProduto(IdPedidoProduto) then
    begin
      DmConexao.FDConexao.Commit;
      Result := True;
    end;

  except
    on E: Exception do
    begin
      DmConexao.FDConexao.Rollback;
      raise Exception.CreateFmt('Erro ao remover produto: %s', [E.Message]);
    end;
  end;
end;

function TPedidoProdutoController.ListarProdutosPorPedido(NumeroPedido: Integer): TList<TPedidoProdutoModel>;
begin
  Result := FPedidoProdutoService.ObterPedidoProdutosPorPedido(NumeroPedido);
end;

end.
