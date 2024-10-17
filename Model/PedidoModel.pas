unit PedidoModel;

interface

uses
  System.SysUtils, ClienteModel;

type
  TPedidoModel = class;

  TPedidoModelShowMessageEvent = procedure(Sender: TPedidoModel; const Msg: string) of object;

  TPedidoModel = class
  private
    FNumeroPedido: Integer;
    FDataEmissao: TDateTime;
    FClienteModel: TClienteModel;
    FValorTotal: Currency;
    FOnShowMessage: TPedidoModelShowMessageEvent;

    procedure ValidarCampoObrigatorio(const Valor: Variant; const NomeCampo: string);
    procedure ValidarCampoObrigatorioDecimal(const Valor: Currency; const NomeCampo: string);
    function ValidarCamposObrigatorios: Boolean;
    function CampoPreenchido(const Valor: string): Boolean;
    procedure DoShowMessage(const Msg: string);
  public
    property NumeroPedido: Integer read FNumeroPedido write FNumeroPedido;
    property DataEmissao: TDateTime read FDataEmissao write FDataEmissao;
    property ClienteModel: TClienteModel read FClienteModel write FClienteModel;
    property ValorTotal: Currency read FValorTotal write FValorTotal;
    property OnShowMessage: TPedidoModelShowMessageEvent read FOnShowMessage write FOnShowMessage;

    constructor Create;
    destructor Destroy; override;

    procedure VerificarCamposObrigatorios;
  end;

implementation

{ TPedidoModel }

constructor TPedidoModel.Create;
begin
  FClienteModel := TClienteModel.Create;
end;

destructor TPedidoModel.Destroy;
begin
  FClienteModel.Free;
  inherited;
end;

procedure TPedidoModel.ValidarCampoObrigatorio(const Valor: Variant; const NomeCampo: string);
begin
  if not CampoPreenchido(Valor) then
    raise Exception.CreateFmt('O campo "%s" é obrigatório e deve ser preenchido.', [NomeCampo]);
end;

procedure TPedidoModel.ValidarCampoObrigatorioDecimal(const Valor: Currency; const NomeCampo: string);
begin
  if Valor <= 0 then
    raise Exception.CreateFmt('O campo "%s" deve ser maior que zero.', [NomeCampo]);
end;

function TPedidoModel.ValidarCamposObrigatorios: Boolean;
begin
  ValidarCampoObrigatorio(FDataEmissao, 'Data de Emissão');
  ValidarCampoObrigatorio(FClienteModel.Nome, 'Cliente');
  ValidarCampoObrigatorioDecimal(FValorTotal, 'Valor Total');

  Result := True;
end;

function TPedidoModel.CampoPreenchido(const Valor: string): Boolean;
begin
  Result := not Valor.Trim.IsEmpty;
end;

procedure TPedidoModel.DoShowMessage(const Msg: string);
begin
  if Assigned(FOnShowMessage) then
    FOnShowMessage(Self, Msg);
end;

procedure TPedidoModel.VerificarCamposObrigatorios;
begin
  if not ValidarCamposObrigatorios then
    raise Exception.Create('Campos obrigatórios não preenchidos.');
end;

end.
