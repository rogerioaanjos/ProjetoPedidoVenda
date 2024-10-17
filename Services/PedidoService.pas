unit PedidoService;

interface

uses
  System.Generics.Collections, Data.DB, FireDAC.Comp.Client, FireDAC.Stan.Param,
  FireDAC.Dapt, FireDAC.Stan.Option, SysUtils, PedidoModel, PedidoProdutoModel, Conexao;

type
  TPedidoService = class
  public
    function AdicionarPedido(PedidoModel: TPedidoModel): Integer;
    function EditarPedido(PedidoModel: TPedidoModel): Boolean;
    function ExcluirPedido(NumeroPedido: Integer): Boolean;
    function ObterPedidos: TList<TPedidoModel>;
    function BuscarPedidoPorNumero(NumeroPedido: Integer): TPedidoModel;
  end;

implementation

{ TPedidoService }

function TPedidoService.AdicionarPedido(PedidoModel: TPedidoModel): Integer;
var
  Query: TFDQuery;
begin
  Result := -1;
  Query := TFDQuery.Create(nil);

  try
    try
      DmConexao.VerificarConexao;

      Query.Connection := DmConexao.FDConexao;
      Query.SQL.Text := 'INSERT INTO pedidos (data_emissao, codigo_cliente, valor_total) ' +
                        'VALUES (:data_emissao, :codigo_cliente, :valor_total) ';
      Query.ParamByName('data_emissao').AsDateTime := PedidoModel.DataEmissao;
      Query.ParamByName('codigo_cliente').AsInteger := PedidoModel.ClienteModel.Codigo;
      Query.ParamByName('valor_total').AsCurrency := PedidoModel.ValorTotal;
      Query.ExecSQL;

      Query.SQL.Text := 'SELECT LAST_INSERT_ID() AS numero_pedido';
      Query.Open;
      if not Query.IsEmpty then
        Result := Query.FieldByName('numero_pedido').AsInteger;
    except
      on E: Exception do
      begin
        raise Exception.CreateFmt('Erro ao adicionar pedido: %s', [E.Message]);
      end;
    end;
  finally
    Query.Free;
  end;
end;


function TPedidoService.EditarPedido(PedidoModel: TPedidoModel): Boolean;
var
  Query: TFDQuery;
begin
  Result := False;
  Query := TFDQuery.Create(nil);

  try
    try
      DmConexao.VerificarConexao; // Verifica a conexão antes da operação

      Query.Connection := DmConexao.FDConexao;
      Query.SQL.Text := 'UPDATE pedidos SET data_emissao = :data_emissao, codigo_cliente = :codigo_cliente, valor_total = :valor_total WHERE numero_pedido = :numero_pedido';
      Query.ParamByName('data_emissao').AsDateTime := PedidoModel.DataEmissao;
      Query.ParamByName('codigo_cliente').AsInteger := PedidoModel.ClienteModel.Codigo;
      Query.ParamByName('valor_total').AsCurrency := PedidoModel.ValorTotal;
      Query.ParamByName('numero_pedido').AsInteger := PedidoModel.NumeroPedido;
      Query.ExecSQL;

      Result := True;
    except
      on E: Exception do
      begin
        raise Exception.CreateFmt('Erro ao editar pedido: %s', [E.Message]);
      end;
    end;
  finally
    Query.Free;
  end;
end;

function TPedidoService.ExcluirPedido(NumeroPedido: Integer): Boolean;
var
  Query: TFDQuery;
begin
  Result := False;
  Query := TFDQuery.Create(nil);

  try
    try
      DmConexao.VerificarConexao; // Verifica a conexão antes da operação

      Query.Connection := DmConexao.FDConexao;
      Query.SQL.Text := 'DELETE FROM pedidos WHERE numero_pedido = :numero_pedido';
      Query.ParamByName('numero_pedido').AsInteger := NumeroPedido;
      Query.ExecSQL;
      Result := True;
    except
      on E: Exception do
      begin
        raise Exception.CreateFmt('Erro ao excluir pedido: %s', [E.Message]);
      end;
    end;
  finally
    Query.Free;
  end;
end;

function TPedidoService.ObterPedidos: TList<TPedidoModel>;
var
  Query: TFDQuery;
  PedidoModel: TPedidoModel;
begin
  Result := TList<TPedidoModel>.Create;
  Query := TFDQuery.Create(nil);

  try
    try
      DmConexao.VerificarConexao; // Verifica a conexão antes da operação

      Query.Connection := DmConexao.FDConexao;
      Query.SQL.Text := 'SELECT numero_pedido, data_emissao, codigo_cliente, valor_total FROM pedidos';
      Query.Open;

      while not Query.Eof do
      begin
        PedidoModel := TPedidoModel.Create;
        try
          PedidoModel.NumeroPedido := Query.FieldByName('numero_pedido').AsInteger;
          PedidoModel.DataEmissao := Query.FieldByName('data_emissao').AsDateTime;
          PedidoModel.ClienteModel.Codigo := Query.FieldByName('codigo_cliente').AsInteger;
          PedidoModel.ValorTotal := Query.FieldByName('valor_total').AsCurrency;
          Result.Add(PedidoModel);
        except
          PedidoModel.Free;
          raise;
        end;

        Query.Next;
      end;

    except
      on E: Exception do
      begin
        Result.Free;
        raise Exception.CreateFmt('Erro ao obter pedidos: %s', [E.Message]);
      end;
    end;
  finally
    Query.Free;
  end;
end;

function TPedidoService.BuscarPedidoPorNumero(NumeroPedido: Integer): TPedidoModel;
var
  Query: TFDQuery;
begin
  Result := nil;
  Query := TFDQuery.Create(nil);

  try
    try
      DmConexao.VerificarConexao; // Verifica a conexão antes da operação

      Query.Connection := DmConexao.FDConexao;
      Query.SQL.Text := 'SELECT numero_pedido, data_emissao, codigo_cliente, valor_total FROM pedidos WHERE numero_pedido = :numero_pedido';
      Query.ParamByName('numero_pedido').AsInteger := NumeroPedido;
      Query.Open;

      if not Query.IsEmpty then
      begin
        Result := TPedidoModel.Create;

        Result.NumeroPedido := Query.FieldByName('numero_pedido').AsInteger;
        Result.DataEmissao := Query.FieldByName('data_emissao').AsDateTime;
        Result.ClienteModel.Codigo := Query.FieldByName('codigo_cliente').AsInteger;
        Result.ValorTotal := Query.FieldByName('valor_total').AsCurrency;
      end;
    except
      on E: Exception do
      begin
        raise Exception.CreateFmt('Erro ao buscar pedido por número: %s', [E.Message]);
      end;
    end;
  finally
    Query.Free;
  end;
end;

end.
