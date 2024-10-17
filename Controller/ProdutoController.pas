unit ProdutoController;

interface

uses
  ProdutoModel, ProdutoService, System.Generics.Collections, FireDAC.Comp.Client, SysUtils, Conexao;

type
  TProdutoController = class
  private
    FProdutoService: TProdutoService;
  public
    constructor Create;
    destructor Destroy; override;
    procedure AdicionarProduto(ProdutoModel: TProdutoModel);
    procedure EditarProduto(ProdutoModel: TProdutoModel);
    procedure ExcluirProduto(CodigoProduto: Integer);
    function ObterProdutos: TList<TProdutoModel>;
    function BuscarProdutoPorCodigo(CodigoProduto: Integer): TProdutoModel;
  end;

implementation

{ TProdutoController }

constructor TProdutoController.Create;
begin
  FProdutoService := TProdutoService.Create;
end;

destructor TProdutoController.Destroy;
begin
  FProdutoService.Free;
  inherited;
end;

procedure TProdutoController.AdicionarProduto(ProdutoModel: TProdutoModel);
begin
  if not DmConexao.FDConexao.InTransaction then
    DmConexao.FDConexao.StartTransaction;

  try
    FProdutoService.AdicionarProduto(ProdutoModel);
    DmConexao.FDConexao.Commit;
  except
    on E: Exception do
    begin
      DmConexao.FDConexao.Rollback;
      raise Exception.CreateFmt('Erro ao adicionar produto: %s', [E.Message]);
    end;
  end;
end;

procedure TProdutoController.EditarProduto(ProdutoModel: TProdutoModel);
begin
  if not DmConexao.FDConexao.InTransaction then
    DmConexao.FDConexao.StartTransaction;

  try
    FProdutoService.EditarProduto(ProdutoModel);
    DmConexao.FDConexao.Commit;
  except
    on E: Exception do
    begin
      DmConexao.FDConexao.Rollback;
      raise Exception.CreateFmt('Erro ao editar produto: %s', [E.Message]);
    end;
  end;
end;

procedure TProdutoController.ExcluirProduto(CodigoProduto: Integer);
begin
  if not DmConexao.FDConexao.InTransaction then
    DmConexao.FDConexao.StartTransaction;

  try
    FProdutoService.ExcluirProduto(CodigoProduto);
    DmConexao.FDConexao.Commit;
  except
    on E: Exception do
    begin
      DmConexao.FDConexao.Rollback;
      raise Exception.CreateFmt('Erro ao excluir produto: %s', [E.Message]);
    end;
  end;
end;

function TProdutoController.ObterProdutos: TList<TProdutoModel>;
begin
  Result := FProdutoService.ObterProdutos;
end;

function TProdutoController.BuscarProdutoPorCodigo(CodigoProduto: Integer): TProdutoModel;
begin
  Result := FProdutoService.BuscarProdutoPorCodigo(CodigoProduto);
end;

end.
