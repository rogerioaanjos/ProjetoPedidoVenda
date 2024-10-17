unit ProdutoModel;

interface

uses
  System.SysUtils;

type
  TProdutoModel = class;

  TProdutoModelShowMessageEvent = procedure(Sender: TProdutoModel; const Msg: string) of object;

  TProdutoModel = class
  private
    FCodigo: Integer;
    FDescricao: string;
    FPrecoVenda: Double;
    FOnShowMessage: TProdutoModelShowMessageEvent;

    procedure ValidarCampoObrigatorio(const Valor: string; const NomeCampo: string);
    procedure ValidarCampoObrigatorioDecimal(const Valor: Double; const NomeCampo: string);
    function ValidarCamposObrigatorios: Boolean;
    function CampoPreenchido(const Valor: string): Boolean;
    procedure DoShowMessage(const Msg: string);
  public
    property Codigo: Integer read FCodigo write FCodigo;
    property Descricao: string read FDescricao write FDescricao;
    property PrecoVenda: Double read FPrecoVenda write FPrecoVenda;
    property OnShowMessage: TProdutoModelShowMessageEvent read FOnShowMessage write FOnShowMessage;

    constructor Create;
    destructor Destroy; override;

    procedure VerificarCamposObrigatorios;
  end;

implementation

{ TProdutoModel }

constructor TProdutoModel.Create;
begin
  //
end;

destructor TProdutoModel.Destroy;
begin
  inherited;
end;

procedure TProdutoModel.ValidarCampoObrigatorio(const Valor: string; const NomeCampo: string);
begin
  if not CampoPreenchido(Valor) then
    raise Exception.CreateFmt('O campo "%s" é obrigatório e deve ser preenchido.', [NomeCampo]);
end;

procedure TProdutoModel.ValidarCampoObrigatorioDecimal(const Valor: Double; const NomeCampo: string);
begin
  if Valor <= 0 then
    raise Exception.CreateFmt('O campo "%s" deve ser maior que zero.', [NomeCampo]);
end;

function TProdutoModel.ValidarCamposObrigatorios: Boolean;
begin
  ValidarCampoObrigatorio(FDescricao, 'Descrição');
  ValidarCampoObrigatorioDecimal(FPrecoVenda, 'Preço de Venda');

  Result := True;
end;

function TProdutoModel.CampoPreenchido(const Valor: string): Boolean;
begin
  Result := not Valor.Trim.IsEmpty;
end;

procedure TProdutoModel.DoShowMessage(const Msg: string);
begin
  if Assigned(FOnShowMessage) then
    FOnShowMessage(Self, Msg);
end;

procedure TProdutoModel.VerificarCamposObrigatorios;
begin
  if not ValidarCamposObrigatorios then
    raise Exception.Create('Campos obrigatórios não preenchidos.');
end;

end.
