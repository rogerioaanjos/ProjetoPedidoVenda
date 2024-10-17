unit Conexao;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Comp.Client, FireDAC.VCLUI.Wait,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.MySQL, FireDAC.Phys.MySQLDef, FireDAC.Comp.UI,
  Data.DB, Vcl.Dialogs, System.IniFiles;

type
  TDmConexao = class(TDataModule)
    FDConexao: TFDConnection;
    FDPhysMySQLDriverLink: TFDPhysMySQLDriverLink;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
  private
    procedure CarregarParametrosIni;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Conectar;
    procedure VerificarConexao;
  end;

var
  DmConexao: TDmConexao;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TDmConexao }

constructor TDmConexao.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  CarregarParametrosIni;
  Conectar;
end;

destructor TDmConexao.Destroy;
begin
  if FDConexao.Connected then
    FDConexao.Connected := False;
  inherited;
end;

procedure TDmConexao.CarregarParametrosIni;
var
  IniFile: TIniFile;
  IniPath: string;
begin
  IniPath := ExtractFilePath(ParamStr(0)) + 'dbconfig.ini';

  if not FileExists(IniPath) then
    raise Exception.Create('Arquivo de configuração não encontrado: ' + IniPath);

  IniFile := TIniFile.Create(IniPath);
  try
    FDConexao.Params.Values['Server'] := IniFile.ReadString('Conexao', 'Server', '');
    FDConexao.Params.Values['Port'] := IntToStr(IniFile.ReadInteger('Conexao', 'Port', 3306));
    FDConexao.Params.Values['Database'] := IniFile.ReadString('Conexao', 'Database', '');
    FDConexao.Params.Values['User_Name'] := IniFile.ReadString('Conexao', 'Username', '');
    FDConexao.Params.Values['Password'] := IniFile.ReadString('Conexao', 'Password', '');
    FDConexao.Params.Values['VendorLib'] := ExtractFilePath(ParamStr(0)) + 'libmysql.dll';
    FDConexao.Params.Values['DriverID'] := 'MySQL';

    if not FileExists(FDConexao.Params.Values['VendorLib']) then
      raise Exception.Create('Biblioteca MySQL não encontrada: ' + FDConexao.Params.Values['VendorLib']);
  finally
    IniFile.Free;
  end;
end;

procedure TDmConexao.Conectar;
begin
  try
    FDConexao.Connected := True;
  except
    on E: Exception do
      raise Exception.Create('Erro ao conectar ao banco de dados: ' + E.Message);
  end;
end;

procedure TDmConexao.VerificarConexao;
begin
  try
    if not FDConexao.Connected then
      FDConexao.Connected := True;
  except
    on E: Exception do
    begin
      raise Exception.CreateFmt('Falha ao conectar ao banco de dados: %s', [E.Message]);
    end;
  end;
end;

end.
