object frmAppSettings: TfrmAppSettings
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = 'Settings'
  ClientHeight = 664
  ClientWidth = 329
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Padding.Left = 10
  Padding.Right = 10
  Padding.Bottom = 15
  Menu = MainMenu1
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  TextHeight = 15
  object gbGeneral: TGroupBox
    AlignWithMargins = True
    Left = 10
    Top = 5
    Width = 309
    Height = 193
    Margins.Left = 0
    Margins.Top = 5
    Margins.Right = 0
    Margins.Bottom = 10
    Align = alTop
    Caption = 'Configura'#231#245'es Gerais'
    Color = clMoneyGreen
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Segoe UI Black'
    Font.Style = [fsBold]
    ParentBackground = False
    ParentColor = False
    ParentFont = False
    ShowFrame = False
    TabOrder = 0
    object cbSSL: TCheckBox
      AlignWithMargins = True
      Left = 17
      Top = 64
      Width = 275
      Height = 17
      Margins.Left = 15
      Margins.Top = 4
      Margins.Right = 15
      Align = alTop
      Alignment = taLeftJustify
      Caption = 'Use SSL'
      Color = clMedGray
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      TabOrder = 1
      OnClick = cbSSLClick
    end
    object Panel1: TPanel
      Left = 2
      Top = 19
      Width = 305
      Height = 41
      Align = alTop
      BevelOuter = bvNone
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      ShowCaption = False
      TabOrder = 0
      object lblGeneralPort: TLabel
        AlignWithMargins = True
        Left = 15
        Top = 3
        Width = 24
        Height = 35
        Margins.Left = 15
        Align = alLeft
        Alignment = taCenter
        Caption = 'Port'
        Layout = tlCenter
        ExplicitHeight = 15
      end
      object edtPort: TEdit
        AlignWithMargins = True
        Left = 243
        Top = 10
        Width = 47
        Height = 21
        Margins.Left = 10
        Margins.Top = 10
        Margins.Right = 15
        Margins.Bottom = 10
        Align = alRight
        Alignment = taCenter
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI Semibold'
        Font.Style = [fsBold]
        NumbersOnly = True
        ParentFont = False
        TabOrder = 0
        ExplicitHeight = 23
      end
    end
    object Panel8: TPanel
      Left = 2
      Top = 84
      Width = 305
      Height = 41
      Align = alTop
      BevelOuter = bvNone
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      ShowCaption = False
      TabOrder = 2
      object lblMinLogLevel: TLabel
        AlignWithMargins = True
        Left = 15
        Top = 3
        Width = 109
        Height = 35
        Margins.Left = 15
        Align = alLeft
        Alignment = taCenter
        Caption = 'Minimum Log Level'
        Layout = tlCenter
        ExplicitHeight = 15
      end
      object cbxMinimumLogLevel: TComboBox
        AlignWithMargins = True
        Left = 145
        Top = 10
        Width = 145
        Height = 23
        Margins.Top = 10
        Margins.Right = 15
        Margins.Bottom = 0
        Align = alRight
        TabOrder = 0
      end
    end
    object Panel11: TPanel
      Left = 2
      Top = 125
      Width = 305
      Height = 41
      Align = alTop
      BevelOuter = bvNone
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      ShowCaption = False
      TabOrder = 3
      object lbl_MAX_CONCURRENT_CON: TLabel
        AlignWithMargins = True
        Left = 15
        Top = 3
        Width = 150
        Height = 35
        Margins.Left = 15
        Align = alLeft
        Alignment = taCenter
        Caption = 'MAX_CONCURRENT_CONN'
        Layout = tlCenter
        ExplicitHeight = 15
      end
      object edtMaxConcurrentConnections: TEdit
        AlignWithMargins = True
        Left = 243
        Top = 10
        Width = 47
        Height = 21
        Margins.Left = 10
        Margins.Top = 10
        Margins.Right = 15
        Margins.Bottom = 10
        Align = alRight
        Alignment = taCenter
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI Semibold'
        Font.Style = [fsBold]
        NumbersOnly = True
        ParentFont = False
        TabOrder = 0
        ExplicitHeight = 23
      end
    end
    object cbStartRunning: TCheckBox
      AlignWithMargins = True
      Left = 17
      Top = 170
      Width = 275
      Height = 17
      Margins.Left = 15
      Margins.Top = 4
      Margins.Right = 15
      Align = alTop
      Alignment = taLeftJustify
      Caption = 'RES_START_RUNNING'
      Color = clMedGray
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      TabOrder = 4
      OnClick = cbSSLClick
    end
  end
  object gbDatabase: TGroupBox
    AlignWithMargins = True
    Left = 10
    Top = 213
    Width = 309
    Height = 228
    Margins.Left = 0
    Margins.Top = 5
    Margins.Right = 0
    Margins.Bottom = 10
    Align = alTop
    Caption = 'Configura'#231#245'es do Banco de Dados'
    Color = clMoneyGreen
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Segoe UI Black'
    Font.Style = [fsBold]
    ParentBackground = False
    ParentColor = False
    ParentFont = False
    ShowFrame = False
    TabOrder = 1
    object Panel2: TPanel
      Left = 2
      Top = 101
      Width = 305
      Height = 41
      Align = alTop
      BevelOuter = bvNone
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      ShowCaption = False
      TabOrder = 0
      object lblDBPassword: TLabel
        AlignWithMargins = True
        Left = 15
        Top = 3
        Width = 52
        Height = 35
        Margins.Left = 15
        Align = alLeft
        Alignment = taCenter
        Caption = 'Password'
        Layout = tlCenter
        ExplicitHeight = 15
      end
      object edtDBPass: TEdit
        AlignWithMargins = True
        Left = 191
        Top = 10
        Width = 99
        Height = 21
        Margins.Left = 10
        Margins.Top = 10
        Margins.Right = 15
        Margins.Bottom = 10
        Align = alRight
        Alignment = taCenter
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI Semibold'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        ExplicitHeight = 23
      end
    end
    object Panel3: TPanel
      Left = 2
      Top = 19
      Width = 305
      Height = 41
      Align = alTop
      BevelOuter = bvNone
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      ShowCaption = False
      TabOrder = 1
      object lblDatabaseFile: TLabel
        AlignWithMargins = True
        Left = 15
        Top = 3
        Width = 51
        Height = 35
        Margins.Left = 15
        Align = alLeft
        Alignment = taCenter
        Caption = 'Database'
        Layout = tlCenter
        ExplicitHeight = 15
      end
      object edtDatabaseFile: TEdit
        AlignWithMargins = True
        Left = 151
        Top = 10
        Width = 139
        Height = 21
        Margins.Left = 10
        Margins.Top = 10
        Margins.Right = 15
        Margins.Bottom = 10
        Align = alRight
        Alignment = taCenter
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI Semibold'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        ExplicitHeight = 23
      end
    end
    object Panel4: TPanel
      Left = 2
      Top = 60
      Width = 305
      Height = 41
      Align = alTop
      BevelOuter = bvNone
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      ShowCaption = False
      TabOrder = 2
      object lblDBUser: TLabel
        AlignWithMargins = True
        Left = 15
        Top = 3
        Width = 57
        Height = 35
        Margins.Left = 15
        Align = alLeft
        Alignment = taCenter
        Caption = 'Username'
        Layout = tlCenter
        ExplicitHeight = 15
      end
      object edtDBUser: TEdit
        AlignWithMargins = True
        Left = 191
        Top = 10
        Width = 99
        Height = 21
        Margins.Left = 10
        Margins.Top = 10
        Margins.Right = 15
        Margins.Bottom = 10
        Align = alRight
        Alignment = taCenter
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI Semibold'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        ExplicitHeight = 23
      end
    end
    object Panel5: TPanel
      Left = 2
      Top = 142
      Width = 305
      Height = 41
      Align = alTop
      BevelOuter = bvNone
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      ShowCaption = False
      TabOrder = 3
      object lblDBHost: TLabel
        AlignWithMargins = True
        Left = 15
        Top = 3
        Width = 26
        Height = 35
        Margins.Left = 15
        Align = alLeft
        Alignment = taCenter
        Caption = 'Host'
        Layout = tlCenter
        ExplicitHeight = 15
      end
      object edtHost: TEdit
        AlignWithMargins = True
        Left = 191
        Top = 10
        Width = 99
        Height = 21
        Margins.Left = 10
        Margins.Top = 10
        Margins.Right = 15
        Margins.Bottom = 10
        Align = alRight
        Alignment = taCenter
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI Semibold'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        ExplicitHeight = 23
      end
    end
    object Panel6: TPanel
      Left = 2
      Top = 183
      Width = 305
      Height = 41
      Align = alTop
      BevelOuter = bvNone
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      ShowCaption = False
      TabOrder = 4
      object lblDBPort: TLabel
        AlignWithMargins = True
        Left = 15
        Top = 3
        Width = 24
        Height = 35
        Margins.Left = 15
        Align = alLeft
        Alignment = taCenter
        Caption = 'Port'
        Layout = tlCenter
        ExplicitHeight = 15
      end
      object edtDBPort: TEdit
        AlignWithMargins = True
        Left = 243
        Top = 10
        Width = 47
        Height = 21
        Margins.Left = 10
        Margins.Top = 10
        Margins.Right = 15
        Margins.Bottom = 10
        Align = alRight
        Alignment = taCenter
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI Semibold'
        Font.Style = [fsBold]
        NumbersOnly = True
        ParentFont = False
        TabOrder = 0
        ExplicitHeight = 23
      end
    end
  end
  object gbSSL: TGroupBox
    AlignWithMargins = True
    Left = 10
    Top = 456
    Width = 309
    Height = 145
    Margins.Left = 0
    Margins.Top = 5
    Margins.Right = 0
    Margins.Bottom = 10
    Align = alTop
    Caption = 'Configura'#231#245'es de SSL'
    Color = clMoneyGreen
    Enabled = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Segoe UI Black'
    Font.Style = [fsBold]
    ParentBackground = False
    ParentColor = False
    ParentFont = False
    ShowFrame = False
    TabOrder = 2
    object Panel7: TPanel
      Left = 2
      Top = 60
      Width = 305
      Height = 41
      Align = alTop
      BevelOuter = bvNone
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      ShowCaption = False
      TabOrder = 0
      object lblRootCertPath: TLabel
        AlignWithMargins = True
        Left = 15
        Top = 3
        Width = 89
        Height = 35
        Margins.Left = 15
        Align = alLeft
        Alignment = taCenter
        Caption = 'Root Certificate'
        Layout = tlCenter
        ExplicitHeight = 15
      end
      object edtRootCertificatePath: TEdit
        AlignWithMargins = True
        Left = 122
        Top = 10
        Width = 134
        Height = 21
        Margins.Left = 10
        Margins.Top = 10
        Margins.Right = 5
        Margins.Bottom = 10
        Align = alRight
        Alignment = taCenter
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI Semibold'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        ExplicitHeight = 23
      end
      object btnLoadFileRCrt: TButton
        AlignWithMargins = True
        Left = 261
        Top = 10
        Width = 29
        Height = 21
        Margins.Left = 0
        Margins.Top = 10
        Margins.Right = 15
        Margins.Bottom = 10
        Align = alRight
        Caption = '...'
        TabOrder = 1
        OnClick = btnLoadFileRCrtClick
      end
    end
    object Panel9: TPanel
      Left = 2
      Top = 19
      Width = 305
      Height = 41
      Align = alTop
      BevelOuter = bvNone
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      ShowCaption = False
      TabOrder = 1
      object lblCertPath: TLabel
        AlignWithMargins = True
        Left = 15
        Top = 3
        Width = 59
        Height = 35
        Margins.Left = 15
        Align = alLeft
        Alignment = taCenter
        Caption = 'Certificate'
        Layout = tlCenter
        ExplicitHeight = 15
      end
      object edtCertificatePath: TEdit
        AlignWithMargins = True
        Left = 122
        Top = 10
        Width = 134
        Height = 21
        Margins.Left = 10
        Margins.Top = 10
        Margins.Right = 5
        Margins.Bottom = 10
        Align = alRight
        Alignment = taCenter
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI Semibold'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        ExplicitHeight = 23
      end
      object btnLoadFileSCrt: TButton
        AlignWithMargins = True
        Left = 261
        Top = 10
        Width = 29
        Height = 21
        Margins.Left = 0
        Margins.Top = 10
        Margins.Right = 15
        Margins.Bottom = 10
        Align = alRight
        Caption = '...'
        TabOrder = 1
        OnClick = btnLoadFileSCrtClick
      end
    end
    object Panel10: TPanel
      Left = 2
      Top = 101
      Width = 305
      Height = 41
      Align = alTop
      BevelOuter = bvNone
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      ShowCaption = False
      TabOrder = 2
      object lblKeyFilePath: TLabel
        AlignWithMargins = True
        Left = 15
        Top = 3
        Width = 43
        Height = 35
        Margins.Left = 15
        Align = alLeft
        Alignment = taCenter
        Caption = 'Key File'
        Layout = tlCenter
        ExplicitHeight = 15
      end
      object edtKeyFile: TEdit
        AlignWithMargins = True
        Left = 122
        Top = 10
        Width = 134
        Height = 21
        Margins.Left = 10
        Margins.Top = 10
        Margins.Right = 5
        Margins.Bottom = 10
        Align = alRight
        Alignment = taCenter
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI Semibold'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        ExplicitHeight = 23
      end
      object btnLoadKeyFile: TButton
        AlignWithMargins = True
        Left = 261
        Top = 10
        Width = 29
        Height = 21
        Margins.Left = 0
        Margins.Top = 10
        Margins.Right = 15
        Margins.Bottom = 10
        Align = alRight
        Caption = '...'
        TabOrder = 1
        OnClick = btnLoadKeyFileClick
      end
    end
  end
  object btnSaveConfiguration: TButton
    Tag = 12332
    AlignWithMargins = True
    Left = 110
    Top = 621
    Width = 109
    Height = 25
    Margins.Left = 100
    Margins.Right = 100
    Align = alBottom
    Caption = 'Salvar'
    TabOrder = 3
    OnClick = btnSaveConfigurationClick
    ExplicitTop = 616
  end
  object MainMenu1: TMainMenu
    Left = 210
    Top = 21
    object CONFIGMMOPTIONS1: TMenuItem
      Caption = 'CONFIG_MM_OPTIONS'
      object VERIFYCONFIGPATH1: TMenuItem
        Caption = 'VERIFY_CONFIG_PATH'
        OnClick = VERIFYCONFIGPATH1Click
      end
    end
  end
end
