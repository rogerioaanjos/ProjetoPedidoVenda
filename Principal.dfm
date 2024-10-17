object frmPrincipal: TfrmPrincipal
  Left = 0
  Top = 0
  Caption = 'Pedido de Venda'
  ClientHeight = 572
  ClientWidth = 621
  Color = clMenuBar
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 13
  object PnlPedido: TPanel
    Left = 8
    Top = 122
    Width = 607
    Height = 101
    ParentBackground = False
    TabOrder = 2
    object LblCodigoProduto: TLabel
      Left = 26
      Top = 12
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
    object LblQuantidade: TLabel
      Left = 50
      Top = 39
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
      Left = 39
      Top = 66
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
    object LblDescricaoProduto: TLabel
      Left = 272
      Top = 15
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
    object EdtCodigoProduto: TEdit
      Left = 135
      Top = 12
      Width = 121
      Height = 21
      NumbersOnly = True
      TabOrder = 0
      OnExit = EdtCodigoProdutoExit
    end
    object EdtQuantidade: TEdit
      Left = 135
      Top = 39
      Width = 121
      Height = 21
      NumbersOnly = True
      TabOrder = 1
    end
    object EdtValorUnitario: TEdit
      Left = 135
      Top = 66
      Width = 121
      Height = 21
      TabOrder = 2
      OnExit = EdtValorUnitarioExit
    end
  end
  object BtnInserirItem: TButton
    Left = 399
    Top = 8
    Width = 105
    Height = 37
    Caption = 'Inserir Produto'
    TabOrder = 0
    OnClick = BtnInserirItemClick
  end
  object BtnGravarPedido: TButton
    Left = 510
    Top = 8
    Width = 105
    Height = 37
    Caption = 'Gravar Pedido'
    TabOrder = 1
    OnClick = BtnGravarPedidoClick
  end
  object BtnFechar: TButton
    Left = 510
    Top = 527
    Width = 105
    Height = 35
    Caption = 'Fechar'
    TabOrder = 3
    OnClick = BtnFecharClick
  end
  object Panel1: TPanel
    Left = 8
    Top = 51
    Width = 607
    Height = 65
    ParentBackground = False
    TabOrder = 4
    object LblCodigoClienteP: TLabel
      Left = 34
      Top = 20
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
      Left = 272
      Top = 25
      Width = 73
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
      Left = 135
      Top = 22
      Width = 121
      Height = 21
      NumbersOnly = True
      TabOrder = 0
      OnExit = EdtCodigoClienteExit
    end
  end
  object GrbItensVenda: TGroupBox
    Left = 8
    Top = 229
    Width = 607
    Height = 287
    Caption = 'Itens do Pedido'
    TabOrder = 5
    object LblTotal: TLabel
      Left = 12
      Top = 240
      Width = 581
      Height = 29
      Alignment = taRightJustify
      Caption = 'Total do Pedido: R$ 0,00'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -24
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
  object FDMTPedido: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 160
    Top = 306
    object FDMTPedidocodigo_produto: TIntegerField
      FieldName = 'codigo_produto'
    end
    object FDMTPedidodescricao: TStringField
      FieldName = 'descricao'
      Size = 150
    end
    object FDMTPedidoquantidade: TIntegerField
      FieldName = 'quantidade'
    end
    object FDMTPedidovalor_unitario: TCurrencyField
      FieldName = 'valor_unitario'
    end
    object FDMTPedidovalor_total: TCurrencyField
      FieldName = 'valor_total'
    end
  end
  object DsPedido: TDataSource
    DataSet = FDMTPedido
    Left = 160
    Top = 370
  end
  object FDMTCliente: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 272
    Top = 306
    object FDMTClientecodigo: TIntegerField
      FieldName = 'codigo'
    end
    object FDMTClientenome: TStringField
      FieldName = 'nome'
      Size = 150
    end
  end
end
