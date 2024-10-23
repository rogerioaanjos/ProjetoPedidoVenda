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
  Vcl.DBCtrls, Vcl.ComCtrls, Vcl.ToolWin;

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
    FDMTItensPedido: TFDMemTable;
    FDMTItensPedidocodigo_produto: TIntegerField;
    FDMTItensPedidoquantidade: TIntegerField;
    FDMTItensPedidovalor_unitario: TCurrencyField;
    FDMTItensPedidovalor_total: TCurrencyField;
    DsPedido: TDataSource;
    FDMTItensPedidodescricao: TStringField;
    BtnFechar: TButton;
    LblDescricaoProduto: TLabel;
    LblCodigoClienteP: TLabel;
    LblNomeCliente: TLabel;
    EdtCodigoCliente: TEdit;
    FDMTCliente: TFDMemTable;
    FDMTClientecodigo: TIntegerField;
    FDMTClientenome: TStringField;
    GrbItensVenda: TGroupBox;
    LblTotal: TLabel;
    DBGrdItensVenda: TDBGrid;
    LblCodigoPedido: TLabel;
    EdtNumeroPedido: TEdit;
    BtnCarregarPedido: TButton;
    BtnCancelarPedido: TButton;
    StatusBar1: TStatusBar;
    GrbBusca: TGroupBox;
    GrbBuscaCliente: TGroupBox;
    GrbItens: TGroupBox;
    PnlBotoes: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure BtnInserirItemClick(Sender: TObject);
    procedure BtnGravarPedidoClick(Sender: TObject);
    procedure DBGrdItensVendaKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormDestroy(Sender: TObject);
    procedure EdtCodigoProdutoExit(Sender: TObject);
    procedure EdtCodigoClienteExit(Sender: TObject);
    procedure BtnFecharClick(Sender: TObject);
    procedure BtnCarregarPedidoClick(Sender: TObject);
    procedure BtnCancelarPedidoClick(Sender: TObject);
    procedure EdtNumeroPedidoChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FClienteController: TClienteController;
    FProdutoController: TProdutoController;
    FPedidoController: TPedidoController;

    FPedidoService: TPedidoService;
    FPedidoProdutoService: TPedidoProdutoService;
    FTotalPedido: Currency;
    FClienteNome: string;
    procedure AtualizarTotalPedido;
    procedure InserirOuAtualizarProdutoGrid(CodigoProduto: Integer; Descricao: string; Quantidade: Integer; ValorUnitario: Currency);
    procedure EditarProdutoSelecionado;
    procedure RemoverProdutoSelecionado;
    function ObterDadosProduto(CodigoProduto: Integer): TProdutoModel;
    function ObterDadosCliente(CodigoCliente: Integer): string;
    procedure AtualizarDadosProduto(CodigoProduto: Integer);
    procedure AtualizarCliente(CodigoCliente: Integer);
    procedure InserirCliente;
    procedure AtualizarClienteNoBanco(Codigo: Integer; Nome: string);
  public
    property ClienteNome: string read FClienteNome write FClienteNome;
    function ValidarCampos: Boolean;
    procedure Inicializar;
    function PreencherPedidoModel: TPedidoModel;
    function PreencherListaProdutos: TList<TPedidoProdutoModel>;
    function ValidarDadosPedido(PedidoModel: TPedidoModel; ListaProdutos: TList<TPedidoProdutoModel>): Boolean;
    procedure CarregarPedido;
    procedure CarregarProdutosPedido(ListaProdutos: TList<TPedidoProdutoModel>);
    procedure CancelarPedido;
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

    FDMTItensPedido.Active := True;
    FDMTCliente.Active := True;

    AtualizarTotalPedido;

    LblDescricaoProduto.Caption := '';
    LblNomeCliente.Caption := '';

    EdtValorUnitario.Text := FormatCurr('#,##0.00', StrToCurrDef(EdtValorUnitario.Text, 0));
  except
    on E: Exception do
    begin
      ShowMessage('Erro ao inicializar os componentes: ' + E.Message);
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

procedure TfrmPrincipal.FormShow(Sender: TObject);
begin
  if EdtCodigoCliente.CanFocus then
    EdtCodigoCliente.SetFocus;
end;

procedure TfrmPrincipal.BtnInserirItemClick(Sender: TObject);
var
  CodigoProduto, Quantidade: Integer;
  ValorUnitario: Currency;
  DescricaoProduto: string;
  Produto: TProdutoModel;
begin
  try
    if not ValidarCampos then
      Exit;

    CodigoProduto := StrToInt(EdtCodigoProduto.Text);
    Quantidade := StrToInt(EdtQuantidade.Text);

    Produto := ObterDadosProduto(CodigoProduto);

    if Assigned(Produto) then
    begin
      if not Utils.ValidarValorUnitario(EdtValorUnitario, 'Valor Unitário', ValorUnitario) then
        Exit;
      InserirOuAtualizarProdutoGrid(CodigoProduto, Produto.Descricao, Quantidade, Produto.PrecoVenda);
      BtnInserirItem.Caption := 'Inserir Produto';
    end
    else
    begin
      ShowMessage('Não é possível inserir o ítem, produto não encontrado.');
      if EdtCodigoProduto.CanFocus then
        EdtCodigoProduto.SetFocus;
    end;
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

    FDMTItensPedido.First;

    while not FDMTItensPedido.Eof do
    begin
      TotalValor := TotalValor + FDMTItensPedido.FieldByName('valor_total').AsCurrency;
      FDMTItensPedido.Next;
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
    FDMTItensPedido.First;

    while not FDMTItensPedido.Eof do
    begin
      PedidoProduto := TPedidoProdutoModel.Create;
      PedidoProduto.ProdutoModel.Codigo := FDMTItensPedido.FieldByName('codigo_produto').AsInteger;
      PedidoProduto.Quantidade := FDMTItensPedido.FieldByName('quantidade').AsInteger;
      PedidoProduto.ProdutoModel.Descricao := FDMTItensPedido.FieldByName('descricao').AsString;
      PedidoProduto.ValorUnitario := FDMTItensPedido.FieldByName('valor_unitario').AsCurrency;
      PedidoProduto.ValorTotal := FDMTItensPedido.FieldByName('valor_total').AsCurrency;

      Result.Add(PedidoProduto);
      FDMTItensPedido.Next;
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

    if FDMTItensPedido.State in [dsEdit] then
    begin
      FDMTItensPedido.Edit;
      FDMTItensPedido.FieldByName('quantidade').AsInteger := Quantidade;
      FDMTItensPedido.FieldByName('valor_unitario').AsCurrency := ValorUnitario;
      FDMTItensPedido.FieldByName('valor_total').AsCurrency := ValorTotal;
      FDMTItensPedido.Post;
    end
    else
    begin
      FDMTItensPedido.Append;
      FDMTItensPedido.FieldByName('codigo_produto').AsInteger := CodigoProduto;
      FDMTItensPedido.FieldByName('descricao').AsString := Descricao;
      FDMTItensPedido.FieldByName('quantidade').AsInteger := Quantidade;
      FDMTItensPedido.FieldByName('valor_unitario').AsCurrency := ValorUnitario;
      FDMTItensPedido.FieldByName('valor_total').AsCurrency := ValorTotal;
      FDMTItensPedido.Post;
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
  FDMTItensPedido.First;

  while not FDMTItensPedido.Eof do
  begin
    FTotalPedido := FTotalPedido + FDMTItensPedido.FieldByName('valor_total').AsCurrency;
    FDMTItensPedido.Next;
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
      if FDMTItensPedido.State in [dsEdit, dsInsert] then
      begin
        FDMTItensPedido.Cancel;
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
    if FDMTItensPedido.IsEmpty or (FDMTItensPedido.RecNo = 0) then
      Exit;

    FDMTItensPedido.Edit;

    CodigoProduto := FDMTItensPedido.FieldByName('codigo_produto').AsInteger;
    Quantidade := FDMTItensPedido.FieldByName('quantidade').AsInteger;
    ValorUnitario := FDMTItensPedido.FieldByName('valor_unitario').AsCurrency;

    EdtCodigoProduto.Text := IntToStr(CodigoProduto);
    EdtQuantidade.Text := IntToStr(Quantidade);
    EdtValorUnitario.Text := FormatCurr('#,##0.00', ValorUnitario);

    BtnInserirItem.Caption := 'Atualizar Produto';
  except
    on E: Exception do
    begin
      ShowMessage('Erro ao editar produto: ' + E.Message);
      if FDMTItensPedido.State in [dsEdit, dsInsert] then
        FDMTItensPedido.Cancel;
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
    AtualizarDadosProduto(StrToInt(EdtCodigoProduto.Text));
end;

procedure TfrmPrincipal.EdtNumeroPedidoChange(Sender: TObject);
begin
  BtnCarregarPedido.Enabled := EdtNumeroPedido.Text <> '';
  BtnCancelarPedido.Enabled := EdtNumeroPedido.Text <> '';
end;

procedure TfrmPrincipal.RemoverProdutoSelecionado;
var
  NomeProduto: string;
begin
  if DBGrdItensVenda.DataSource.DataSet.IsEmpty or (FDMTItensPedido.RecNo = 0) then
  begin
    ShowMessage('Nenhum produto selecionado para remoção.');
    Exit;
  end;

  NomeProduto := FDMTItensPedido.FieldByName('descricao').AsString;

  try
    if MessageDlg('Deseja realmente remover o produto ' + sLineBreak + '"' + NomeProduto + '"?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      FDMTItensPedido.Delete;
      AtualizarTotalPedido;
    end;
  except
    on E: Exception do
    begin
      ShowMessage('Erro ao remover produto: ' + E.Message);
    end;
  end;
end;

procedure TfrmPrincipal.BtnCancelarPedidoClick(Sender: TObject);
begin
   CancelarPedido;
end;

procedure TfrmPrincipal.BtnCarregarPedidoClick(Sender: TObject);
var
  NumeroPedido: Integer;
  PedidoModel: TPedidoModel;
  ListaProdutos: TList<TPedidoProdutoModel>;
begin
  ListaProdutos := TList<TPedidoProdutoModel>.Create;
  try
    if not TryStrToInt(EdtNumeroPedido.Text, NumeroPedido) then
    begin
      ShowMessage('Por favor, insira um número de pedido válido.');
      Exit;
    end;
    try
      PedidoModel := FPedidoController.LocalizarPedido(NumeroPedido);
      if Assigned(PedidoModel) then
      begin
        ListaProdutos := FPedidoProdutoService.ObterPedidoProdutosPorPedido(NumeroPedido);
        CarregarProdutosPedido(ListaProdutos);
        ShowMessage('Pedido carregado com sucesso!');
      end
      else
        ShowMessage('Pedido não encontrado.');
    except
      on E: Exception do
        ShowMessage('Erro ao carregar o pedido: ' + E.Message);
    end;
  finally
    ListaProdutos.Free;
  end;
end;

procedure TfrmPrincipal.BtnFecharClick(Sender: TObject);
var
  Result: Integer;
begin
  Result := MessageDlg('Você realmente deseja sair do sistema?', mtConfirmation, [mbYes, mbNo], 0);
  if Result = mrYes then
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

function TfrmPrincipal.ObterDadosProduto(CodigoProduto: Integer): TProdutoModel;
var
  Produto: TProdutoModel;
begin
  try
    Produto := FProdutoController.BuscarProdutoPorCodigo(CodigoProduto);

    if not Assigned(Produto) then
    begin
      Result := nil;
    end
    else
    begin
      Result := Produto;
    end;
  except
    on E: Exception do
    begin
      ShowMessage('Erro ao buscar os dados do produto ' + E.Message);
      Result := nil;
    end;
  end;
end;

function TfrmPrincipal.ObterDadosCliente(CodigoCliente: Integer): string;
var
  Cliente: TClienteModel;
begin
  Result := '';

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

procedure TfrmPrincipal.AtualizarDadosProduto(CodigoProduto: Integer);
var
  Produto: TProdutoModel;
begin
  try
    Produto := ObterDadosProduto(CodigoProduto);

    if Assigned(Produto) then
    begin
      LblDescricaoProduto.Caption := Produto.Descricao;
      EdtValorUnitario.Text := FormatCurr('#,##0.00', Produto.PrecoVenda);

      Utils.AtualizarCorLabel(LblDescricaoProduto, Produto.Descricao);
    end
    else
    begin
      LblDescricaoProduto.Caption := MSG_PRODUTO_NAO_ENCONTRADO;
      EdtValorUnitario.Text := '0,00';

      Utils.AtualizarCorLabel(LblDescricaoProduto, '');
    end;
  except
    on E: Exception do
    begin
      ShowMessage('Erro ao buscar os dados do produto: ' + E.Message);

      EdtValorUnitario.Text := '0,00';
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

  Cliente.Free;
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
    if EdtCodigoCliente.CanFocus then
      EdtCodigoCliente.SetFocus;

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

procedure TfrmPrincipal.CarregarPedido;
var
  NumeroPedido: Integer;
  PedidoModel: TPedidoModel;
  ListaProdutos: TList<TPedidoProdutoModel>;
begin
  if not TryStrToInt(EdtNumeroPedido.Text, NumeroPedido) then
  begin
    ShowMessage('Por favor, insira um número de pedido válido.');
    Exit;
  end;

  try
    PedidoModel := FPedidoController.LocalizarPedido(NumeroPedido);

    if Assigned(PedidoModel) then
    begin
      AtualizarCliente(PedidoModel.ClienteModel.Codigo);

      ObterDadosCliente(PedidoModel.ClienteModel.Codigo);

      if ClienteNome <> MSG_CLIENTE_NAO_ENCONTRADO then
      begin
        LblNomeCliente.Caption := ClienteNome;
        Utils.AtualizarCorLabel(LblNomeCliente, ClienteNome);
      end
      else
      begin
        LblNomeCliente.Caption := MSG_CLIENTE_NAO_ENCONTRADO;
        Utils.AtualizarCorLabel(LblNomeCliente, '');
      end;

      CarregarProdutosPedido(ListaProdutos);

      ShowMessage('Pedido carregado com sucesso!');
    end
    else
      ShowMessage('Pedido não encontrado.');

  except
    on E: Exception do
      ShowMessage('Erro ao carregar o pedido: ' + E.Message);
  end;
end;

procedure TfrmPrincipal.CarregarProdutosPedido(ListaProdutos: TList<TPedidoProdutoModel>);
var
  i: Integer;
begin
  FDMTItensPedido.EmptyDataSet;

  for i := 0 to ListaProdutos.Count - 1 do
  begin
    FDMTItensPedido.Append;
    FDMTItensPedido.FieldByName('codigo_produto').AsInteger := ListaProdutos[i].ProdutoModel.Codigo;
    FDMTItensPedido.FieldByName('descricao').AsString := ListaProdutos[i].ProdutoModel.Descricao;
    FDMTItensPedido.FieldByName('quantidade').AsInteger := ListaProdutos[i].Quantidade;
    FDMTItensPedido.FieldByName('valor_unitario').AsCurrency := ListaProdutos[i].ValorUnitario;
    FDMTItensPedido.FieldByName('valor_total').AsFloat := ListaProdutos[i].ValorTotal;
    FDMTItensPedido.Post;
  end;
end;

procedure TfrmPrincipal.CancelarPedido;
var
  NumeroPedido: Integer;
begin
  if not TryStrToInt(EdtNumeroPedido.Text, NumeroPedido) then
  begin
    ShowMessage('Por favor, insira um número de pedido válido.');
    Exit;
  end;

  if MessageDlg('Tem certeza que deseja cancelar o pedido ' + IntToStr(NumeroPedido) + '?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    try
      FPedidoController.CancelarPedido(NumeroPedido);
      ShowMessage('Pedido cancelado com sucesso!');
    except
      on E: Exception do
        ShowMessage('Erro ao cancelar o pedido: ' + E.Message);
    end;
  end;
end;

end.
