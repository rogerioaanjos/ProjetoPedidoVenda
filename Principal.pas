unit Principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Vcl.StdCtrls, FireDAC.Comp.Client, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Comp.DataSet, Vcl.ExtCtrls, System.Generics.Collections,
  ClienteModel, ClienteController, PedidoModel, PedidoController, PedidoService,
  ProdutoModel, ProdutoController, PedidoProdutoModel, PedidoProdutoService,
  Vcl.DBCtrls;

type
  TfrmPrincipal = class(TForm)
    BtnInserirItem: TButton;
    BtnGravarPedido: TButton;
    EdtCodigoProduto: TEdit;
    EdtQuantidade: TEdit;
    EdtValorUnitario: TEdit;
    LblCodigoProduto: TLabel;
    LblQuantidade: TLabel;
    LblValorUnitario: TLabel;
    FDMTPedido: TFDMemTable;
    FDMTPedidocodigo_produto: TIntegerField;
    FDMTPedidoquantidade: TIntegerField;
    FDMTPedidovalor_unitario: TCurrencyField;
    FDMTPedidovalor_total: TCurrencyField;
    DsPedido: TDataSource;
    FDMTPedidodescricao: TStringField;
    PnlPedido: TPanel;
    BtnFechar: TButton;
    LblDescricaoProduto: TLabel;
    Panel1: TPanel;
    LblCodigoClienteP: TLabel;
    LblNomeCliente: TLabel;
    EdtCodigoCliente: TEdit;
    FDMTCliente: TFDMemTable;
    FDMTClientecodigo: TIntegerField;
    FDMTClientenome: TStringField;
    GrbItensVenda: TGroupBox;
    LblTotal: TLabel;
    DBGrdItensVenda: TDBGrid;
    procedure FormCreate(Sender: TObject);
    procedure BtnInserirItemClick(Sender: TObject);
    procedure BtnGravarPedidoClick(Sender: TObject);
    procedure DBGrdItensVendaKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormDestroy(Sender: TObject);
    procedure EdtValorUnitarioExit(Sender: TObject);
    procedure EdtCodigoProdutoExit(Sender: TObject);
    procedure EdtCodigoClienteExit(Sender: TObject);
    procedure BtnFecharClick(Sender: TObject);
  private
    FClienteController: TClienteController;
    FProdutoController: TProdutoController;
    FPedidoController: TPedidoController;

    FPedidoService: TPedidoService;
    FPedidoProdutoService: TPedidoProdutoService;
    FTotalPedido: Currency;
    FDescricaoProduto: string;
    FClienteNome: string;
    procedure AtualizarTotalPedido;
    procedure InserirOuAtualizarProdutoGrid(CodigoProduto: Integer; Descricao: string; Quantidade: Integer; ValorUnitario: Currency);
    procedure EditarProdutoSelecionado;
    procedure RemoverProdutoSelecionado;
    function ObterDescricaoProduto(CodigoProduto: Integer): string;
    function ObterDadosCliente(CodigoCliente: Integer): string;
    procedure AtualizarDescricaoProduto(CodigoProduto: Integer);
    procedure AtualizarCliente(CodigoCliente: Integer);
    procedure InserirCliente;
    procedure AtualizarClienteNoBanco(Codigo: Integer; Nome: string);
  public
    property DescricaoProduto: string read FDescricaoProduto write FDescricaoProduto;
    property ClienteNome: string read FClienteNome write FClienteNome;
    function ValidarCampos: Boolean;
    procedure Inicializar;
    function PreencherPedidoModel: TPedidoModel;
    function PreencherListaProdutos: TList<TPedidoProdutoModel>;
    function ValidarDadosPedido(PedidoModel: TPedidoModel; ListaProdutos: TList<TPedidoProdutoModel>): Boolean;
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.dfm}

uses
  Conexao, Utils;

Const
  MSG_PRODUTO_NAO_ENCONTRADO = 'Produto não encontrado';
  MSG_CLIENTE_NAO_ENCONTRADO = 'Cliente não encontrado';

procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin
  try
    Inicializar;
  except
    on E: Exception do
    begin
      ShowMessage('Erro ao inicializar o formulário: ' + E.Message);
      Application.Terminate;
    end;
  end;
end;

procedure TfrmPrincipal.Inicializar;
begin
  try
    FCLienteController := TCLienteController.Create;
    FProdutoController := TProdutoController.Create;
    FPedidoController := TPedidoController.Create;

    FPedidoService := TPedidoService.Create;
    FPedidoProdutoService := TPedidoProdutoService.Create;

    FTotalPedido := 0;

    FDMTPedido.Active := True;
    FDMTCliente.Active := True;

    AtualizarTotalPedido;

    LblDescricaoProduto.Caption := '';
    LblNomeCliente.Caption := '';

    EdtValorUnitario.Text := FormatCurr('#,##0.00', StrToCurrDef(EdtValorUnitario.Text, 0));
  except
    on E: Exception do
    begin
      raise Exception.Create('Erro ao inicializar o formulário: ' + E.Message);
    end;
  end;
end;

procedure TfrmPrincipal.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FCLienteController);
  FreeAndNil(FProdutoController);
  FreeAndNil(FPedidoController);
  FreeAndNil(FPedidoService);
  FreeAndNil(FPedidoProdutoService);
  inherited;
end;

procedure TfrmPrincipal.BtnInserirItemClick(Sender: TObject);
var
  CodigoProduto, Quantidade: Integer;
  ValorUnitario: Currency;
  DescricaoProduto: string;
begin
  try
    if not ValidarCampos then
      Exit;

    CodigoProduto := StrToInt(EdtCodigoProduto.Text);
    Quantidade := StrToInt(EdtQuantidade.Text);

    if not Utils.ValidarValorUnitario(EdtValorUnitario, 'Valor Unitário', ValorUnitario) then
      Exit;

    DescricaoProduto := ObterDescricaoProduto(CodigoProduto);

    InserirOuAtualizarProdutoGrid(CodigoProduto, DescricaoProduto, Quantidade, ValorUnitario);
    BtnInserirItem.Caption := 'Inserir Produto';
  except
    on E: Exception do
    begin
      ShowMessage('Erro ao inserir item: ' + E.Message);
    end;
  end;
end;

function TfrmPrincipal.PreencherPedidoModel: TPedidoModel;
var
  TotalValor: Currency;
begin
  Result := TPedidoModel.Create;
  TotalValor := 0;

  try
    Result.ClienteModel.Codigo := FDMTCliente.FieldByName('codigo').AsInteger;
    Result.DataEmissao := Now;

    FDMTPedido.First;

    while not FDMTPedido.Eof do
    begin
      TotalValor := TotalValor + FDMTPedido.FieldByName('valor_total').AsCurrency;
      FDMTPedido.Next;
    end;

    Result.ValorTotal := TotalValor;

    if Result.ValorTotal <= 0 then
      raise Exception.Create('Valor total deve ser maior que zero.');
  except
    on E: Exception do
    begin
      Result.Free;
      raise Exception.Create('Erro ao preencher dados do pedido: ' + E.Message);
    end;
  end;
end;

function TfrmPrincipal.PreencherListaProdutos: TList<TPedidoProdutoModel>;
var
  PedidoProduto: TPedidoProdutoModel;
begin
  Result := TList<TPedidoProdutoModel>.Create;

  try
    FDMTPedido.First;

    while not FDMTPedido.Eof do
    begin
      PedidoProduto := TPedidoProdutoModel.Create;
      PedidoProduto.ProdutoModel.Codigo := FDMTPedido.FieldByName('codigo_produto').AsInteger;
      PedidoProduto.Quantidade := FDMTPedido.FieldByName('quantidade').AsInteger;
      PedidoProduto.ProdutoModel.Descricao := FDMTPedido.FieldByName('descricao').AsString;
      PedidoProduto.ValorUnitario := FDMTPedido.FieldByName('valor_unitario').AsCurrency;
      PedidoProduto.ValorTotal := FDMTPedido.FieldByName('valor_total').AsCurrency;

      Result.Add(PedidoProduto);
      FDMTPedido.Next;
    end;
  except
    on E: Exception do
    begin
      Result.Free;
      raise Exception.Create('Erro ao preencher lista de produtos: ' + E.Message);
    end;
  end;
end;

procedure TfrmPrincipal.InserirOuAtualizarProdutoGrid(CodigoProduto: Integer; Descricao: string; Quantidade: Integer; ValorUnitario: Currency);
var
  ValorTotal: Currency;
begin
  try
    ValorTotal := Quantidade * ValorUnitario;

    if FDMTPedido.State in [dsEdit] then
    begin
      FDMTPedido.Edit;
      FDMTPedido.FieldByName('quantidade').AsInteger := Quantidade;
      FDMTPedido.FieldByName('valor_unitario').AsCurrency := ValorUnitario;
      FDMTPedido.FieldByName('valor_total').AsCurrency := ValorTotal;
      FDMTPedido.Post;
    end
    else
    begin
      FDMTPedido.Append;
      FDMTPedido.FieldByName('codigo_produto').AsInteger := CodigoProduto;
      FDMTPedido.FieldByName('descricao').AsString := Descricao;
      FDMTPedido.FieldByName('quantidade').AsInteger := Quantidade;
      FDMTPedido.FieldByName('valor_unitario').AsCurrency := ValorUnitario;
      FDMTPedido.FieldByName('valor_total').AsCurrency := ValorTotal;
      FDMTPedido.Post;
    end;

    AtualizarTotalPedido;

    EdtCodigoProduto.Text := '';
    EdtQuantidade.Text := '';
    EdtValorUnitario.Text := '';

    if EdtCodigoProduto.CanFocus then
      EdtCodigoProduto.SetFocus;
  except
    on E: Exception do
    begin
      ShowMessage('Ocorreu um erro ao inserir ou atualizar o produto: ' + E.Message);
    end;
  end;
end;

procedure TfrmPrincipal.AtualizarTotalPedido;
begin
  FTotalPedido := 0;
  FDMTPedido.First;

  while not FDMTPedido.Eof do
  begin
    FTotalPedido := FTotalPedido + FDMTPedido.FieldByName('valor_total').AsCurrency;
    FDMTPedido.Next;
  end;

  LblTotal.Caption := 'Total do Pedido: R$ ' + FormatCurr('#,##0.00', FTotalPedido);
end;

procedure TfrmPrincipal.DBGrdItensVendaKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_RETURN:
      EditarProdutoSelecionado;
    VK_DELETE:
      RemoverProdutoSelecionado;
    VK_ESCAPE:
    begin
      if FDMTPedido.State in [dsEdit, dsInsert] then
      begin
        FDMTPedido.Cancel;
        EdtCodigoProduto.Text := '';
        EdtQuantidade.Text := '';
        EdtValorUnitario.Text := FormatCurr('#,##0.00', StrToCurrDef(EdtValorUnitario.Text, 0));
        DBGrdItensVenda.SetFocus;
      end;
    end;
  end;
end;

procedure TfrmPrincipal.EditarProdutoSelecionado;
var
  CodigoProduto, Quantidade: Integer;
  ValorUnitario: Currency;
begin
  try
    if FDMTPedido.IsEmpty or (FDMTPedido.RecNo = 0) then
      Exit;

    FDMTPedido.Edit;

    CodigoProduto := FDMTPedido.FieldByName('codigo_produto').AsInteger;
    Quantidade := FDMTPedido.FieldByName('quantidade').AsInteger;
    ValorUnitario := FDMTPedido.FieldByName('valor_unitario').AsCurrency;

    EdtCodigoProduto.Text := IntToStr(CodigoProduto);
    EdtQuantidade.Text := IntToStr(Quantidade);
    EdtValorUnitario.Text := FormatCurr('#,##0.00', ValorUnitario);

    BtnInserirItem.Caption := 'Atualizar Produto';
  except
    on E: Exception do
    begin
      ShowMessage('Erro ao editar produto: ' + E.Message);
      if FDMTPedido.State in [dsEdit, dsInsert] then
        FDMTPedido.Cancel;
    end;
  end;
end;

procedure TfrmPrincipal.EdtCodigoClienteExit(Sender: TObject);
begin
   if Length(EdtCodigoCliente.Text) > 0 then
    AtualizarCliente(StrToInt(EdtCodigoCliente.Text));
end;

procedure TfrmPrincipal.EdtCodigoProdutoExit(Sender: TObject);
begin
  if Length(EdtCodigoProduto.Text) > 0 then
    AtualizarDescricaoProduto(StrToInt(EdtCodigoProduto.Text));
end;

procedure TfrmPrincipal.EdtValorUnitarioExit(Sender: TObject);
begin
  EdtValorUnitario.Text := FormatCurr('#,##0.00', StrToCurrDef(EdtValorUnitario.Text, 0));
end;

procedure TfrmPrincipal.RemoverProdutoSelecionado;
var
  NomeProduto: string;
begin
  if DBGrdItensVenda.DataSource.DataSet.IsEmpty or (FDMTPedido.RecNo = 0) then
  begin
    ShowMessage('Nenhum produto selecionado para remoção.');
    Exit;
  end;

  NomeProduto := FDMTPedido.FieldByName('descricao').AsString;

  try
    if MessageDlg('Deseja realmente remover o produto ' + sLineBreak + '"' + NomeProduto + '"?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      FDMTPedido.Delete;
      AtualizarTotalPedido;
    end;
  except
    on E: Exception do
    begin
      ShowMessage('Erro ao remover produto: ' + E.Message);
    end;
  end;
end;

procedure TfrmPrincipal.BtnFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmPrincipal.BtnGravarPedidoClick(Sender: TObject);
var
  PedidoModel: TPedidoModel;
  ListaProdutos: TList<TPedidoProdutoModel>;
begin
  try
    PedidoModel := PreencherPedidoModel;
    ListaProdutos := PreencherListaProdutos;

    if not ValidarDadosPedido(PedidoModel, ListaProdutos) then
      Exit;

    if FPedidoController.CriarPedido(PedidoModel, ListaProdutos) then
    begin
      ShowMessage('Pedido gravado com sucesso!');
    end
    else
    begin
      ShowMessage('Falha ao gravar o pedido.');
    end;
  except
    on E: Exception do
    begin
      ShowMessage('Erro ao gravar o pedido: ' + E.Message);
    end;
  end;
end;

function TfrmPrincipal.ObterDescricaoProduto(CodigoProduto: Integer): string;
var
  Produto: TProdutoModel;
begin
  try
    Produto := FProdutoController.BuscarProdutoPorCodigo(CodigoProduto);

    if Assigned(Produto) then
    begin
      FDescricaoProduto := Produto.Descricao;
      Result := FDescricaoProduto;
    end
    else
    begin
      FDescricaoProduto := MSG_PRODUTO_NAO_ENCONTRADO;
      Result := FDescricaoProduto;
    end;
  except
    on E: Exception do
    begin
      ShowMessage('Erro ao buscar a descrição do produto: ' + E.Message);
      FDescricaoProduto := '';
      Result := '';
    end;
  end;
end;

function TfrmPrincipal.ObterDadosCliente(CodigoCliente: Integer): string;
var
  Cliente: TClienteModel;
begin
  try
    Cliente := FClienteController.BuscarClientePorCodigo(CodigoCliente);

    if Assigned(Cliente) then
    begin
      FClienteNome := Cliente.Nome;
      Result := FClienteNome;
    end
    else
    begin
      FClienteNome := MSG_CLIENTE_NAO_ENCONTRADO;
      Result := FClienteNome;
    end;
  except
    on E: Exception do
    begin
      ShowMessage('Erro ao buscar informações do cliente: ' + CodigoCliente.ToString + sLineBreak + E.Message);
      FClienteNome := '';
      Result := '';
    end;
  end;
end;

procedure TfrmPrincipal.AtualizarDescricaoProduto(CodigoProduto: Integer);
var
  Produto: TProdutoModel;
begin
  try
    ObterDescricaoProduto(CodigoProduto);

    if DescricaoProduto <> MSG_PRODUTO_NAO_ENCONTRADO then
    begin
      LblDescricaoProduto.Caption := DescricaoProduto;
      Utils.AtualizarCorLabel(LblDescricaoProduto, DescricaoProduto);
    end
    else
    begin
      LblDescricaoProduto.Caption := MSG_PRODUTO_NAO_ENCONTRADO;
      Utils.AtualizarCorLabel(LblDescricaoProduto, '');
    end;
  except
    on E: Exception do
    begin
      ShowMessage('Erro ao buscar a descrição do produto: ' + E.Message);
      LblDescricaoProduto.Caption := '';
      LblDescricaoProduto.Font.Color := clWindowText;
    end;
  end;
end;

procedure TfrmPrincipal.AtualizarCliente(CodigoCliente: Integer);
begin
  try
    ObterDadosCliente(CodigoCliente);

    if ClienteNome <> MSG_CLIENTE_NAO_ENCONTRADO then
    begin
      LblNomeCliente.Caption := ClienteNome;
      Utils.AtualizarCorLabel(LblNomeCliente, ClienteNome);

      if FDMTCliente.IsEmpty then
        InserirCliente
      else
        AtualizarClienteNoBanco(CodigoCliente, ClienteNome);
    end
    else
    begin
      LblNomeCliente.Caption := MSG_CLIENTE_NAO_ENCONTRADO;
      Utils.AtualizarCorLabel(LblNomeCliente, '');

      if not FDMTCliente.IsEmpty then
      begin
        FDMTCliente.Delete;
      end;
    end;
  except
    on E: Exception do
    begin
      ShowMessage('Erro ao buscar informações do cliente: ' + CodigoCliente.ToString + sLineBreak + E.Message);
      LblNomeCliente.Caption := '';
      LblNomeCliente.Font.Color := clWindowText;
    end;
  end;
end;

procedure TfrmPrincipal.InserirCliente;
var
  Cliente: TClienteModel;
begin
  Cliente := TClienteModel.Create;
  try
    Cliente.Codigo := StrToInt(EdtCodigoCliente.Text);
    Cliente.Nome := FClienteNome;

    FDMTCliente.Append;
    FDMTCliente.FieldByName('codigo').AsInteger := Cliente.Codigo;
    FDMTCliente.FieldByName('nome').AsString := Cliente.Nome;
    FDMTCliente.Post;
  except
    on E: Exception do
    begin
      ShowMessage('Erro ao inserir cliente: ' + E.Message);

      if FDMTCliente.State in [dsInsert] then
        FDMTCliente.Cancel;
    end;
  end;
end;

procedure TfrmPrincipal.AtualizarClienteNoBanco(Codigo: Integer; Nome: string);
begin
  try
    FDMTCliente.Edit;
    FDMTCliente.FieldByName('codigo').AsInteger := Codigo;
    FDMTCliente.FieldByName('nome').AsString := Nome;
    FDMTCliente.Post;
    ShowMessage('Cliente atualizado com sucesso!');
  except
    on E: Exception do
      ShowMessage('Erro ao atualizar cliente: ' + E.Message);
  end;
end;

function TfrmPrincipal.ValidarCampos: Boolean;
begin
  Result := True;

  if not Utils.ValidarCampoEdit(EdtCodigoProduto, 'Código do Produto') then
    Exit(False);

  if not Utils.ValidarCampoEdit(EdtQuantidade, 'Quantidade') then
    Exit(False);
end;

function TfrmPrincipal.ValidarDadosPedido(PedidoModel: TPedidoModel; ListaProdutos: TList<TPedidoProdutoModel>): Boolean;
begin
  Result := True;

  if PedidoModel.ClienteModel.Codigo = 0 then
  begin
    ShowMessage('Selecione um cliente válido.');
    Result := False;
    Exit;
  end;

  if ListaProdutos.Count = 0 then
  begin
    ShowMessage('Adicione pelo menos um produto ao pedido.');
    Result := False;
    Exit;
  end;

  if PedidoModel.ValorTotal <= 0 then
  begin
    ShowMessage('O valor total do pedido deve ser maior que zero.');
    Result := False;
    Exit;
  end;
end;

end.
