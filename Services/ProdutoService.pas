unit ProdutoService;

interface

uses
  System.Generics.Collections, Data.DB, FireDAC.Comp.Client, FireDAC.Stan.Param,
  FireDAC.Dapt, FireDAC.Stan.Option, SysUtils, ProdutoModel;

type
  TProdutoService = class
  public
    function AdicionarProduto(ProdutoModel: TProdutoModel): Integer;
    function EditarProduto(ProdutoModel: TProdutoModel): Boolean;
    function ExcluirProduto(CodigoProduto: Integer): Boolean;
    function ObterProdutos: TList<TProdutoModel>;
    function BuscarProdutoPorCodigo(CodigoProduto: Integer): TProdutoModel;
  end;

implementation

uses
  Conexao;

{ TProdutoService }

function TProdutoService.AdicionarProduto(ProdutoModel: TProdutoModel): Integer;
var
  Query: TFDQuery;
begin
  Result := -1;
  Query := TFDQuery.Create(nil);
  try
    DmConexao.VerificarConexao;

    Query.Connection := DmConexao.FDConexao;
    Query.SQL.Text := 'INSERT INTO produtos (descricao, preco_venda) VALUES (:descricao, :preco_venda)';
    Query.ParamByName('descricao').AsString := ProdutoModel.Descricao;
    Query.ParamByName('preco_venda').AsFloat := ProdutoModel.PrecoVenda;
    Query.ExecSQL;

    Query.SQL.Text := 'SELECT LAST_INSERT_ID() AS codigo';
    Query.Open;

    if not Query.IsEmpty then
      Result := Query.FieldByName('codigo').AsInteger;
  finally
    Query.Free;
  end;
end;


function TProdutoService.EditarProduto(ProdutoModel: TProdutoModel): Boolean;
var
  Query: TFDQuery;
begin
  Result := False;
  Query := TFDQuery.Create(nil);

  try
    try
      DmConexao.VerificarConexao;

      Query.Connection := DmConexao.FDConexao;
      Query.SQL.Text := 'UPDATE produtos SET descricao = :descricao, preco_venda = :preco_venda WHERE codigo = :codigo';
      Query.ParamByName('descricao').AsString := ProdutoModel.Descricao;
      Query.ParamByName('preco_venda').AsFloat := ProdutoModel.PrecoVenda;
      Query.ParamByName('codigo').AsInteger := ProdutoModel.Codigo;
      Query.ExecSQL;
      Result := True;
    except
      on E: Exception do
      begin
        raise Exception.CreateFmt('Erro ao editar produto: %s', [E.Message]);
      end;
    end;
  finally
    Query.Free;
  end;
end;

function TProdutoService.ExcluirProduto(CodigoProduto: Integer): Boolean;
var
  Query: TFDQuery;
begin
  Result := False;
  Query := TFDQuery.Create(nil);

  try
    try
      DmConexao.VerificarConexao;

      Query.Connection := DmConexao.FDConexao;
      Query.SQL.Text := 'DELETE FROM produtos WHERE codigo = :codigo';
      Query.ParamByName('codigo').AsInteger := CodigoProduto;
      Query.ExecSQL;
      Result := True;
    except
      on E: Exception do
      begin
        raise Exception.CreateFmt('Erro ao excluir produto: %s', [E.Message]);
      end;
    end;
  finally
    Query.Free;
  end;
end;

function TProdutoService.ObterProdutos: TList<TProdutoModel>;
var
  Query: TFDQuery;
  ProdutoModel: TProdutoModel;
begin
  Result := TList<TProdutoModel>.Create;
  Query := TFDQuery.Create(nil);

  try
    try
      DmConexao.VerificarConexao;

      Query.Connection := DmConexao.FDConexao;
      Query.SQL.Text := 'SELECT codigo, descricao, preco_venda FROM produtos';
      Query.Open;

      while not Query.Eof do
      begin
        ProdutoModel := TProdutoModel.Create;
        try
          ProdutoModel.Codigo := Query.FieldByName('codigo').AsInteger;
          ProdutoModel.Descricao := Query.FieldByName('descricao').AsString;
          ProdutoModel.PrecoVenda := Query.FieldByName('preco_venda').AsFloat;
          Result.Add(ProdutoModel);
        except
          ProdutoModel.Free;
          raise;
        end;

        Query.Next;
      end;

    except
      on E: Exception do
      begin
        Result.Free;
        raise Exception.CreateFmt('Erro ao obter produtos: %s', [E.Message]);
      end;
    end;
  finally
    Query.Free;
  end;
end;

function TProdutoService.BuscarProdutoPorCodigo(CodigoProduto: Integer): TProdutoModel;
var
  Query: TFDQuery;
begin
  Result := nil;
  Query := TFDQuery.Create(nil);

  try
    try
      DmConexao.VerificarConexao;

      Query.Connection := DmConexao.FDConexao;

      Query.SQL.Text := 'SELECT codigo, descricao, preco_venda FROM produtos WHERE codigo = :codigo';
      Query.ParamByName('codigo').AsInteger := CodigoProduto;
      Query.Open;

      if not Query.IsEmpty then
      begin
        Result := TProdutoModel.Create;

        Result.Codigo := Query.FieldByName('codigo').AsInteger;
        Result.Descricao := Query.FieldByName('descricao').AsString;
        Result.PrecoVenda := Query.FieldByName('preco_venda').AsFloat;
      end;
    except
      on E: Exception do
      begin
        raise Exception.CreateFmt('Erro ao buscar produto por código: %s', [E.Message]);
      end;
    end;
  finally
    Query.Free;
  end;
end;

end.
