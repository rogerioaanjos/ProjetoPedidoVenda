unit ClienteController;

interface

uses
  ClienteModel, ClienteService, System.Generics.Collections, FireDAC.Comp.Client, SysUtils, Conexao;

type
  TClienteController = class
  private
    FClienteService: TClienteService;
  public
    constructor Create;
    destructor Destroy; override;
    procedure AdicionarCliente(ClienteModel: TClienteModel);
    procedure EditarCliente(ClienteModel: TClienteModel);
    procedure ExcluirCliente(CodigoCliente: Integer);
    function ObterClientes: TList<TClienteModel>;
    function BuscarClientePorCodigo(CodigoCliente: Integer): TClienteModel;
  end;

implementation

{ TClienteController }

constructor TClienteController.Create;
begin
  FClienteService := TClienteService.Create;
end;

destructor TClienteController.Destroy;
begin
  FClienteService.Free;
  inherited;
end;

procedure TClienteController.AdicionarCliente(ClienteModel: TClienteModel);
begin
  if not DmConexao.FDConexao.InTransaction then
    DmConexao.FDConexao.StartTransaction;

  try
    FClienteService.AdicionarCliente(ClienteModel);
    DmConexao.FDConexao.Commit;
  except
    on E: Exception do
    begin
      DmConexao.FDConexao.Rollback;
      raise Exception.CreateFmt('Erro ao adicionar cliente: %s', [E.Message]);
    end;
  end;
end;

procedure TClienteController.EditarCliente(ClienteModel: TClienteModel);
begin
  if not DmConexao.FDConexao.InTransaction then
    DmConexao.FDConexao.StartTransaction;

  try
    FClienteService.EditarCliente(ClienteModel);
    DmConexao.FDConexao.Commit;
  except
    on E: Exception do
    begin
      DmConexao.FDConexao.Rollback;
      raise Exception.CreateFmt('Erro ao editar cliente: %s', [E.Message]);
    end;
  end;
end;

procedure TClienteController.ExcluirCliente(CodigoCliente: Integer);
begin
  if not DmConexao.FDConexao.InTransaction then
    DmConexao.FDConexao.StartTransaction;

  try
    FClienteService.ExcluirCliente(CodigoCliente);
    DmConexao.FDConexao.Commit;
  except
    on E: Exception do
    begin
      DmConexao.FDConexao.Rollback;
      raise Exception.CreateFmt('Erro ao excluir cliente: %s', [E.Message]);
    end;
  end;
end;

function TClienteController.ObterClientes: TList<TClienteModel>;
begin
  Result := FClienteService.ObterClientes;
end;

function TClienteController.BuscarClientePorCodigo(CodigoCliente: Integer): TClienteModel;
begin
  Result := FClienteService.BuscarClientePorCodigo(CodigoCliente);
end;

end.
