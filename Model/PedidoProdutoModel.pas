unit PedidoProdutoModel;

interface

uses
  System.SysUtils, ProdutoModel, PedidoModel;

type
  TPedidoProdutoModel = class;

  TPedidoProdutoModelShowMessageEvent = procedure(Sender: TPedidoProdutoModel; const Msg: string) of object;

  TPedidoProdutoModel = class
  private
    FIdPedidoProduto: Integer;
    FPedidoModel: TPedidoModel;
    FProdutoModel: TProdutoModel;
    FQuantidade: Integer;
    FValorUnitario: Currency;
    FValorTotal: Currency;
    FOnShowMessage: TPedidoProdutoModelShowMessageEvent;

    procedure ValidarCampoObrigatorio(const Valor: Variant; const NomeCampo: string);
    function ValidarCamposObrigatorios: Boolean;
    function CampoPreenchido(const Valor: string): Boolean;
    procedure DoShowMessage(const Msg: string);
  public
    property IdPedidoProduto: Integer read FIdPedidoProduto write FIdPedidoProduto;
    property PedidoModel: TPedidoModel read FPedidoModel write FPedidoModel;
    property ProdutoModel: TProdutoModel read FProdutoModel write FProdutoModel;
    property Quantidade: Integer read FQuantidade write FQuantidade;
    property ValorUnitario: Currency read FValorUnitario write FValorUnitario;
    property ValorTotal: Currency read FValorTotal write FValorTotal;
    property OnShowMessage: TPedidoProdutoModelShowMessageEvent read FOnShowMessage write FOnShowMessage;

    constructor Create;
    destructor Destroy; override;

    procedure VerificarCamposObrigatorios;
  end;

implementation

{ TPedidoProdutoModel }

constructor TPedidoProdutoModel.Create;
begin
  FPedidoModel := TPedidoModel.Create;
  FProdutoModel := TProdutoModel.Create;
end;

destructor TPedidoProdutoModel.Destroy;
begin
  FPedidoModel.Free;
  FProdutoModel.Free;
  inherited;
end;

procedure TPedidoProdutoModel.ValidarCampoObrigatorio(const Valor: Variant; const NomeCampo: string);
begin
  if not CampoPreenchido(Valor) then
    raise Exception.CreateFmt('O campo "%s" é obrigatório e deve ser preenchido.', [NomeCampo]);
end;

function TPedidoProdutoModel.ValidarCamposObrigatorios: Boolean;
begin
  ValidarCampoObrigatorio(FPedidoModel.NumeroPedido, 'Pedido');
  ValidarCampoObrigatorio(FProdutoModel.Descricao, 'Produto');
  ValidarCampoObrigatorio(FQuantidade, 'Quantidade');
  ValidarCampoObrigatorio(FValorUnitario, 'Valor Unitário');
  ValidarCampoObrigatorio(FValorTotal, 'Valor Total');

  Result := True;
end;

function TPedidoProdutoModel.CampoPreenchido(const Valor: string): Boolean;
begin
  Result := not Valor.Trim.IsEmpty;
end;

procedure TPedidoProdutoModel.DoShowMessage(const Msg: string);
begin
  if Assigned(FOnShowMessage) then
    FOnShowMessage(Self, Msg);
end;

procedure TPedidoProdutoModel.VerificarCamposObrigatorios;
begin
  if not ValidarCamposObrigatorios then
    DoShowMessage('Campos obrigatórios não preenchidos.');
end;

end.

