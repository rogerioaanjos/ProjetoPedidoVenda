object frmPrincipal: TfrmPrincipal
  Left = 0
  Top = 0
  Caption = 'Pedido de Venda'
  ClientHeight = 669
  ClientWidth = 622
  Color = clMenuBar
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  TextHeight = 13
  object GrbItensVenda: TGroupBox
    Left = 8
    Top = 286
    Width = 607
    Height = 280
    Caption = ' Itens do Pedido '
    TabOrder = 0
    object LblTotal: TLabel
      Left = 363
      Top = 240
      Width = 230
      Height = 25
      Alignment = taRightJustify
      Caption = 'Total do Pedido: R$ 0,00'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -21
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object DBGrdItensVenda: TDBGrid
      Left = 12
      Top = 29
      Width = 581
      Height = 200
      DataSource = DsPedido
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      OnKeyDown = DBGrdItensVendaKeyDown
      Columns = <
        item
          Expanded = False
          FieldName = 'codigo_produto'
          Width = 89
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'descricao'
          Width = 214
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'quantidade'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'valor_unitario'
          Width = 87
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'valor_total'
          Width = 91
          Visible = True
        end>
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 650
    Width = 622
    Height = 19
    Panels = <>
  end
  object GrbBusca: TGroupBox
    Left = 8
    Top = 8
    Width = 605
    Height = 66
    Caption = ' Buscar Pedido '
    TabOrder = 2
    object LblCodigoPedido: TLabel
      Left = 50
      Top = 28
      Width = 95
      Height = 18
      Alignment = taRightJustify
      Caption = 'C'#243'digo Pedido:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object BtnCancelarPedido: TButton
      Left = 386
      Top = 26
      Width = 97
      Height = 25
      Caption = 'Cancelar Pedido'
      Enabled = False
      TabOrder = 0
      OnClick = BtnCancelarPedidoClick
    end
    object BtnCarregarPedido: TButton
      Left = 283
      Top = 26
      Width = 97
      Height = 25
      Caption = 'Carregar Pedido'
      Enabled = False
      TabOrder = 1
      OnClick = BtnCarregarPedidoClick
    end
    object EdtNumeroPedido: TEdit
      Left = 151
      Top = 26
      Width = 121
      Height = 25
      NumbersOnly = True
      TabOrder = 2
      OnChange = EdtNumeroPedidoChange
    end
  end
  object GrbBuscaCliente: TGroupBox
    Left = 8
    Top = 80
    Width = 605
    Height = 73
    Caption = ' Buscar Cliente '
    TabOrder = 3
    object LblCodigoClienteP: TLabel
      Left = 50
      Top = 30
      Width = 95
      Height = 18
      Alignment = taRightJustify
      Caption = 'C'#243'digo Cliente:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object LblNomeCliente: TLabel
      Left = 280
      Top = 30
      Width = 158
      Height = 14
      Caption = 'Nome Cliente'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object EdtCodigoCliente: TEdit
      Left = 151
      Top = 27
      Width = 121
      Height = 25
      NumbersOnly = True
      TabOrder = 0
      OnExit = EdtCodigoClienteExit
    end
  end
  object GrbItens: TGroupBox
    Left = 8
    Top = 170
    Width = 605
    Height = 110
    Caption = 'GrbItens'
    TabOrder = 4
    object LblCodigoProduto: TLabel
      Left = 42
      Top = 23
      Width = 103
      Height = 18
      Alignment = taRightJustify
      Caption = 'C'#243'digo Produto:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object LblDescricaoProduto: TLabel
      Left = 288
      Top = 23
      Width = 110
      Height = 14
      Caption = 'LblDescricaoProduto'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object LblQuantidade: TLabel
      Left = 66
      Top = 50
      Width = 79
      Height = 18
      Alignment = taRightJustify
      Caption = 'Quantidade:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object LblValorUnitario: TLabel
      Left = 55
      Top = 75
      Width = 90
      Height = 18
      Alignment = taRightJustify
      Caption = 'Valor Unit'#225'rio:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object EdtCodigoProduto: TEdit
      Left = 151
      Top = 20
      Width = 121
      Height = 25
      NumbersOnly = True
      TabOrder = 0
      OnExit = EdtCodigoProdutoExit
    end
    object EdtQuantidade: TEdit
      Left = 151
      Top = 47
      Width = 121
      Height = 25
      NumbersOnly = True
      TabOrder = 1
    end
    object EdtValorUnitario: TEdit
      Left = 151
      Top = 74
      Width = 121
      Height = 25
      NumbersOnly = True
      TabOrder = 2
      OnExit = EdtValorUnitarioExit
    end
    object BtnInserirItem: TButton
      Left = 472
      Top = 42
      Width = 105
      Height = 31
      Caption = 'Inserir Produto'
      TabOrder = 3
      OnClick = BtnInserirItemClick
    end
  end
  object PnlBotoes: TPanel
    Left = 8
    Top = 575
    Width = 607
    Height = 67
    Color = clGradientInactiveCaption
    ParentBackground = False
    TabOrder = 5
    object BtnFechar: TButton
      Left = 488
      Top = 16
      Width = 105
      Height = 35
      Caption = 'Fechar'
      TabOrder = 0
      OnClick = BtnFecharClick
    end
    object BtnGravarPedido: TButton
      Left = 363
      Top = 16
      Width = 105
      Height = 35
      Caption = 'Gravar Pedido'
      TabOrder = 1
      OnClick = BtnGravarPedidoClick
    end
  end
  object FDMTItensPedido: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 158
    Top = 458
    object FDMTItensPedidocodigo_produto: TIntegerField
      FieldName = 'codigo_produto'
    end
    object FDMTItensPedidodescricao: TStringField
      FieldName = 'descricao'
      Size = 150
    end
    object FDMTItensPedidoquantidade: TIntegerField
      FieldName = 'quantidade'
    end
    object FDMTItensPedidovalor_unitario: TCurrencyField
      FieldName = 'valor_unitario'
    end
    object FDMTItensPedidovalor_total: TCurrencyField
      FieldName = 'valor_total'
    end
  end
  object DsPedido: TDataSource
    DataSet = FDMTItensPedido
    Left = 158
    Top = 522
  end
  object FDMTCliente: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 270
    Top = 458
    object FDMTClientecodigo: TIntegerField
      FieldName = 'codigo'
    end
    object FDMTClientenome: TStringField
      FieldName = 'nome'
      Size = 150
    end
  end
end
