object frmMain: TfrmMain
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Servi'#231'o de Notifica'#231#245'es de Marketplaces'
  ClientHeight = 281
  ClientWidth = 557
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Menu = MainMenu1
  OnCreate = FormCreate
  TextHeight = 15
  object memoLog: TMemo
    Left = 0
    Top = 41
    Width = 557
    Height = 240
    Align = alClient
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 557
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    ShowCaption = False
    TabOrder = 1
    object lblUptime: TLabel
      Left = 554
      Top = 0
      Width = 3
      Height = 41
      Align = alRight
      Alignment = taCenter
      Layout = tlCenter
      ExplicitHeight = 15
    end
    object btnStartServer: TButton
      Left = 0
      Top = 10
      Width = 109
      Height = 25
      Caption = 'Iniciar Servidor'
      TabOrder = 0
      OnClick = btnStartServerClick
    end
    object btnStopServer: TButton
      Left = 115
      Top = 10
      Width = 94
      Height = 25
      Caption = 'Parar Servidor'
      Enabled = False
      TabOrder = 1
      OnClick = btnStopServerClick
    end
  end
  object conn: TFDConnection
    Params.Strings = (
      'Protocol='
      'DriverID=FB'
      'User_Name=sysdba'
      'Password=masterkey')
    Left = 520
    Top = 8
  end
  object MainMenu1: TMainMenu
    Left = 464
    Top = 8
    object ools1: TMenuItem
      Caption = 'Tools'
      object ests1: TMenuItem
        Caption = 'Tests'
        object DatabaseFiretest1: TMenuItem
          Caption = 'Database Firetest'
          OnClick = DatabaseFiretest1Click
        end
        object SSLStartTest1: TMenuItem
          Caption = 'SSL Start Test'
          OnClick = SSLStartTest1Click
        end
      end
      object Settings1: TMenuItem
        Caption = 'Settings'
        OnClick = Settings1Click
      end
      object RefreshSettings1: TMenuItem
        Caption = 'Refresh Settings'
        OnClick = RefreshSettings1Click
      end
    end
  end
  object TrayIcon1: TTrayIcon
    Left = 336
    Top = 136
  end
end
