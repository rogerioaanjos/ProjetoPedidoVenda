unit PedidoProdutoService;

interface

uses
  System.Generics.Collections, Data.DB, FireDAC.Comp.Client, FireDAC.Stan.Param,
  FireDAC.Dapt, FireDAC.Stan.Option, SysUtils, PedidoProdutoModel, Conexao;

type
  TPedidoProdutoService = class
  public
    function AdicionarPedidoProduto(PedidoProdutoModel: TPedidoProdutoModel): Boolean;
    function EditarPedidoProduto(PedidoProdutoModel: TPedidoProdutoModel): Boolean;
    function ExcluirPedidoProduto(IdPedidoProduto: Integer): Boolean;
    function ObterPedidoProdutosPorPedido(NumeroPedido: Integer): TList<TPedidoProdutoModel>;
    function ExcluirProdutosPorNumeroPedido(NumeroPedido: Integer): Boolean;
  end;

implementation

{ TPedidoProdutoService }

function TPedidoProdutoService.AdicionarPedidoProduto(PedidoProdutoModel: TPedidoProdutoModel): Boolean;
var
  Query: TFDQuery;
begin
  Result := False;
  Query := TFDQuery.Create(nil);

  try
    try
      DmConexao.VerificarConexao;

      Query.Connection := DmConexao.FDConexao;
      Query.SQL.Text := 'INSERT INTO pedido_produtos (numero_pedido, codigo_produto, quantidade, valor_unitario, valor_total) '+
                        ' VALUES (:numero_pedido, :codigo_produto, :quantidade, :valor_unitario, :valor_total)';
      Query.ParamByName('numero_pedido').AsInteger := PedidoProdutoModel.PedidoModel.NumeroPedido;
      Query.ParamByName('codigo_produto').AsInteger := PedidoProdutoModel.ProdutoModel.Codigo;
      Query.ParamByName('quantidade').AsInteger := PedidoProdutoModel.Quantidade;
      Query.ParamByName('valor_unitario').AsCurrency := PedidoProdutoModel.ValorUnitario;
      Query.ParamByName('valor_total').AsCurrency := PedidoProdutoModel.ValorTotal;
      Query.ExecSQL;

      Result := True;
    except
      on E: Exception do
      begin
        raise Exception.CreateFmt('Erro ao adicionar produto ao pedido: %s', [E.Message]);
      end;
    end;
  finally
    Query.Free;
  end;
end;

function TPedidoProdutoService.EditarPedidoProduto(PedidoProdutoModel: TPedidoProdutoModel): Boolean;
var
  Query: TFDQuery;
begin
  Result := False;
  Query := TFDQuery.Create(nil);

  try
    try
      DmConexao.VerificarConexao;

      Query.Connection := DmConexao.FDConexao;
      Query.SQL.Text := 'UPDATE pedido_produtos SET quantidade = :quantidade, valor_unitario = :valor_unitario, valor_total = :valor_total '+
                        ' WHERE id_pedido_produto = :id_pedido_produto';
      Query.ParamByName('quantidade').AsInteger := PedidoProdutoModel.Quantidade;
      Query.ParamByName('valor_unitario').AsCurrency := PedidoProdutoModel.ValorUnitario;
      Query.ParamByName('valor_total').AsCurrency := PedidoProdutoModel.ValorTotal;
      Query.ParamByName('id_pedido_produto').AsInteger := PedidoProdutoModel.IdPedidoProduto;
      Query.ExecSQL;
      Result := True;
    except
      on E: Exception do
      begin
        raise Exception.CreateFmt('Erro ao editar produto do pedido: %s', [E.Message]);
      end;
    end;
  finally
    Query.Free;
  end;
end;

function TPedidoProdutoService.ExcluirPedidoProduto(IdPedidoProduto: Integer): Boolean;
var
  Query: TFDQuery;
begin
  Result := False;
  Query := TFDQuery.Create(nil);

  try
    try
      DmConexao.VerificarConexao;

      Query.Connection := DmConexao.FDConexao;
      Query.SQL.Text := 'DELETE FROM pedido_produtos WHERE id_pedido_produto = :id_pedido_produto';
      Query.ParamByName('id_pedido_produto').AsInteger := IdPedidoProduto;
      Query.ExecSQL;
      Result := True;
    except
      on E: Exception do
      begin
        raise Exception.CreateFmt('Erro ao excluir produto do pedido: %s', [E.Message]);
      end;
    end;
  finally
    Query.Free;
  end;
end;

function TPedidoProdutoService.ObterPedidoProdutosPorPedido(NumeroPedido: Integer): TList<TPedidoProdutoModel>;
var
  Query: TFDQuery;
  PedidoProdutoModel: TPedidoProdutoModel;
begin
  Result := TList<TPedidoProdutoModel>.Create;

  Query := TFDQuery.Create(nil);

  try
    try
      DmConexao.VerificarConexao;

      Query.Connection := DmConexao.FDConexao;
      Query.SQL.Text := 'SELECT pp.id_pedido_produto, pp.numero_pedido, pp.codigo_produto, pp.quantidade, ' +
                        'pp.valor_unitario, pp.valor_total, p.descricao ' +
                        'FROM pedido_produtos pp ' +
                        'INNER JOIN produtos p ON pp.codigo_produto = p.codigo ' +
                        'WHERE pp.numero_pedido = :numero_pedido';
      Query.ParamByName('numero_pedido').AsInteger := NumeroPedido;
      Query.Open;

      while not Query.Eof do
      begin
        PedidoProdutoModel := TPedidoProdutoModel.Create;
        try
          PedidoProdutoModel.IdPedidoProduto := Query.FieldByName('id_pedido_produto').AsInteger;
          PedidoProdutoModel.PedidoModel.NumeroPedido := Query.FieldByName('numero_pedido').AsInteger;
          PedidoProdutoModel.ProdutoModel.Codigo := Query.FieldByName('codigo_produto').AsInteger;
          PedidoProdutoModel.ProdutoModel.Descricao := Query.FieldByName('descricao').AsString;
          PedidoProdutoModel.Quantidade := Query.FieldByName('quantidade').AsInteger;
          PedidoProdutoModel.ValorUnitario := Query.FieldByName('valor_unitario').AsCurrency;
          PedidoProdutoModel.ValorTotal := Query.FieldByName('valor_total').AsCurrency;

          Result.Add(PedidoProdutoModel);
        except
          PedidoProdutoModel.Free;
          raise;
        end;

        Query.Next;
      end;

    except
      on E: Exception do
      begin
        Result.Free;
        raise Exception.CreateFmt('Erro ao obter produtos do pedido: %s', [E.Message]);
      end;
    end;
  finally
    Query.Free;
  end;
end;

function TPedidoProdutoService.ExcluirProdutosPorNumeroPedido(NumeroPedido: Integer): Boolean;
var
  Query: TFDQuery;
begin
  Result := False;
  Query := TFDQuery.Create(nil);

  try
    try
      DmConexao.VerificarConexao;

      Query.Connection := DmConexao.FDConexao;
      Query.SQL.Text := 'DELETE FROM pedido_produtos WHERE numero_pedido = :numero_pedido';
      Query.ParamByName('numero_pedido').AsInteger := NumeroPedido;
      Query.ExecSQL;
      Result := True;
    except
      on E: Exception do
      begin
        raise Exception.CreateFmt('Erro ao excluir produtos do pedido: %s', [E.Message]);
      end;
    end;
  finally
    Query.Free;
  end;
end;

end.
