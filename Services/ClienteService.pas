unit ClienteService;

interface

uses
  System.Generics.Collections, Data.DB, FireDAC.Comp.Client, FireDAC.Stan.Param,
  FireDAC.Dapt, FireDAC.Stan.Option, SysUtils, ClienteModel;

type
  TClienteService = class
  public
    function AdicionarCliente(ClienteModel: TClienteModel): Boolean;
    function EditarCliente(ClienteModel: TClienteModel): Boolean;
    function ExcluirCliente(CodigoCliente: Integer): Boolean;
    function ObterClientes: TList<TClienteModel>;
    function BuscarClientePorCodigo(CodigoCliente: Integer): TClienteModel;
  end;

implementation

uses
  Conexao;

{ TClienteService }

function TClienteService.AdicionarCliente(ClienteModel: TClienteModel): Boolean;
var
  Query: TFDQuery;
begin
  Result := False;
  Query := TFDQuery.Create(nil);

  try
    try
      DmConexao.VerificarConexao;

      Query.Connection := DmConexao.FDConexao;
      Query.SQL.Text := 'INSERT INTO clientes (nome, cidade, uf) VALUES (:nome, :cidade, :uf)';
      Query.ParamByName('nome').AsString := ClienteModel.Nome;
      Query.ParamByName('cidade').AsString := ClienteModel.Cidade;
      Query.ParamByName('uf').AsString := ClienteModel.UF;
      Query.ExecSQL;
      Result := True;
    except
      on E: Exception do
      begin
        raise Exception.CreateFmt('Erro ao adicionar cliente: %s', [E.Message]);
      end;
    end;
  finally
    Query.Free;
  end;
end;

function TClienteService.EditarCliente(ClienteModel: TClienteModel): Boolean;
var
  Query: TFDQuery;
begin
  Result := False;
  Query := TFDQuery.Create(nil);

  try
    try
      DmConexao.VerificarConexao;

      Query.Connection := DmConexao.FDConexao;
      Query.SQL.Text := 'UPDATE clientes SET nome = :nome, cidade = :cidade, uf = :uf WHERE codigo = :codigo';
      Query.ParamByName('nome').AsString := ClienteModel.Nome;
      Query.ParamByName('cidade').AsString := ClienteModel.Cidade;
      Query.ParamByName('uf').AsString := ClienteModel.UF;
      Query.ParamByName('codigo').AsInteger := ClienteModel.Codigo;
      Query.ExecSQL;
      Result := True;
    except
      on E: Exception do
      begin
        raise Exception.CreateFmt('Erro ao editar cliente: %s', [E.Message]);
      end;
    end;
  finally
    Query.Free;
  end;
end;

function TClienteService.ExcluirCliente(CodigoCliente: Integer): Boolean;
var
  Query: TFDQuery;
begin
  Result := False;
  Query := TFDQuery.Create(nil);

  try
    try
      DmConexao.VerificarConexao;

      Query.Connection := DmConexao.FDConexao;
      Query.SQL.Text := 'DELETE FROM clientes WHERE codigo = :codigo';
      Query.ParamByName('codigo').AsInteger := CodigoCliente;
      Query.ExecSQL;
      Result := True;
    except
      on E: Exception do
      begin
        raise Exception.CreateFmt('Erro ao excluir cliente: %s', [E.Message]);
      end;
    end;
  finally
    Query.Free;
  end;
end;

function TClienteService.ObterClientes: TList<TClienteModel>;
var
  Query: TFDQuery;
  ClienteModel: TClienteModel;
begin
  Result := TList<TClienteModel>.Create;
  Query := TFDQuery.Create(nil);

  try
    try
      DmConexao.VerificarConexao;

      Query.Connection := DmConexao.FDConexao;
      Query.SQL.Text := 'SELECT codigo, nome, cidade, uf FROM clientes';
      Query.Open;

      while not Query.Eof do
      begin
        ClienteModel := TClienteModel.Create;
        try
          ClienteModel.Codigo := Query.FieldByName('codigo').AsInteger;
          ClienteModel.Nome := Query.FieldByName('nome').AsString;
          ClienteModel.Cidade := Query.FieldByName('cidade').AsString;
          ClienteModel.UF := Query.FieldByName('uf').AsString;
          Result.Add(ClienteModel);
        except
          ClienteModel.Free;
          raise;
        end;

        Query.Next;
      end;

    except
      on E: Exception do
      begin
        Result.Free;
        raise Exception.CreateFmt('Erro ao obter clientes: %s', [E.Message]);
      end;
    end;
  finally
    Query.Free;
  end;
end;

function TClienteService.BuscarClientePorCodigo(CodigoCliente: Integer): TClienteModel;
var
  Query: TFDQuery;
begin
  Result := nil;
  Query := TFDQuery.Create(nil);

  try
    try
      DmConexao.VerificarConexao;

      Query.Connection := DmConexao.FDConexao;

      Query.SQL.Text := 'SELECT codigo, nome, cidade, uf FROM clientes WHERE codigo = :codigo';
      Query.ParamByName('codigo').AsInteger := CodigoCliente;
      Query.Open;

      if not Query.IsEmpty then
      begin
        Result := TClienteModel.Create;

        Result.Codigo := Query.FieldByName('codigo').AsInteger;
        Result.Nome := Query.FieldByName('nome').AsString;
        Result.Cidade := Query.FieldByName('cidade').AsString;
        Result.UF := Query.FieldByName('uf').AsString;
      end;
    except
      on E: Exception do
      begin
        raise Exception.CreateFmt('Erro ao buscar cliente por código: %s', [E.Message]);
      end;
    end;
  finally
    Query.Free;
  end;
end;

end.
