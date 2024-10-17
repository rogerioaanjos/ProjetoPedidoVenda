object DmConexao: TDmConexao
  Height = 480
  Width = 640
  object FDConexao: TFDConnection
    ConnectionName = 'ConexaoMySQL'
    Params.Strings = (
      'Database=pedidoVenda'
      'User_Name=root'
      'Password=roger10'
      'Server=localhost'
      'DriverID=MySQL')
    LoginPrompt = False
    Left = 32
    Top = 32
  end
  object FDPhysMySQLDriverLink: TFDPhysMySQLDriverLink
    VendorLib = 
      'D:\02 - Projetos DEV\Delphi\Projeto WkTechnology\Win32\Debug\lib' +
      'mysql.dll'
    Left = 152
    Top = 32
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'Forms'
    Left = 288
    Top = 32
  end
end
