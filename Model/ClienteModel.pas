unit ClienteModel;

interface

uses
  System.SysUtils;

type
  TClienteModel = class;

  TClienteModelShowMessageEvent = procedure(Sender: TClienteModel; const Msg: string) of object;

  TClienteModel = class
  private
    FCodigo: Integer;
    FNome: string;
    FCidade: string;
    FUF: string;
    FOnShowMessage: TClienteModelShowMessageEvent;

    procedure ValidarCampoObrigatorio(const Valor: string; const NomeCampo: string);
    function ValidarCamposObrigatorios: Boolean;
    function CampoPreenchido(const Valor: string): Boolean;
    procedure DoShowMessage(const Msg: string);
  public
    property Codigo: Integer read FCodigo write FCodigo;
    property Nome: string read FNome write FNome;
    property Cidade: string read FCidade write FCidade;
    property UF: string read FUF write FUF;
    property OnShowMessage: TClienteModelShowMessageEvent read FOnShowMessage write FOnShowMessage;

    constructor Create;
    destructor Destroy; override;

    procedure VerificarCamposObrigatorios;
  end;

implementation

{ TClienteModel }

constructor TClienteModel.Create;
begin
  //
end;

destructor TClienteModel.Destroy;
begin
  inherited;
end;

procedure TClienteModel.ValidarCampoObrigatorio(const Valor: string; const NomeCampo: string);
begin
  if not CampoPreenchido(Valor) then
    raise Exception.CreateFmt('O campo "%s" é obrigatório e deve ser preenchido.', [NomeCampo]);
end;

function TClienteModel.ValidarCamposObrigatorios: Boolean;
begin
  ValidarCampoObrigatorio(FNome, 'Nome');
  ValidarCampoObrigatorio(FCidade, 'Cidade');
  ValidarCampoObrigatorio(FUF, 'UF');

  Result := True;
end;

function TClienteModel.CampoPreenchido(const Valor: string): Boolean;
begin
  Result := not Valor.Trim.IsEmpty;
end;

procedure TClienteModel.DoShowMessage(const Msg: string);
begin
  if Assigned(FOnShowMessage) then
    FOnShowMessage(Self, Msg);
end;

procedure TClienteModel.VerificarCamposObrigatorios;
begin
  if not ValidarCamposObrigatorios then
    raise Exception.Create('Campos obrigatórios não preenchidos.');
end;

end.
