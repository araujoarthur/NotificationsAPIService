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
  OnShow = FormShow
  TextHeight = 15
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 557
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    ShowCaption = False
    TabOrder = 0
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
    object scGPButton1: TscGPButton
      Left = 280
      Top = 10
      Width = 65
      Height = 25
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Droid Sans Mono'
      Font.Style = []
      ParentFont = False
      FluentUIOpaque = False
      TabOrder = 2
      OnClick = scGPButton1Click
      Animation = False
      Badge.Color = clRed
      Badge.ColorAlpha = 255
      Badge.Font.Charset = DEFAULT_CHARSET
      Badge.Font.Color = clWhite
      Badge.Font.Height = -11
      Badge.Font.Name = 'Tahoma'
      Badge.Font.Style = [fsBold]
      Badge.Visible = False
      Caption = 'Kill'
      CaptionCenterAlignment = True
      CanFocused = False
      CustomDropDown = False
      DrawTextMode = scdtmGDI
      Margin = -1
      Spacing = 1
      Layout = blGlyphLeft
      ImageIndex = -1
      ImageMargin = 0
      TransparentBackground = True
      Options.NormalColor = clFirebrick
      Options.HotColor = clBrown
      Options.PressedColor = clMaroon
      Options.FocusedColor = clNone
      Options.DisabledColor = clNone
      Options.NormalColor2 = clNone
      Options.HotColor2 = clNone
      Options.PressedColor2 = clNone
      Options.FocusedColor2 = clNone
      Options.DisabledColor2 = clNone
      Options.NormalColorAlpha = 255
      Options.HotColorAlpha = 255
      Options.PressedColorAlpha = 255
      Options.FocusedColorAlpha = 255
      Options.DisabledColorAlpha = 255
      Options.NormalColor2Alpha = 255
      Options.HotColor2Alpha = 255
      Options.PressedColor2Alpha = 255
      Options.FocusedColor2Alpha = 255
      Options.DisabledColor2Alpha = 255
      Options.FrameNormalColor = clNone
      Options.FrameHotColor = clRed
      Options.FramePressedColor = clNone
      Options.FrameFocusedColor = clNone
      Options.FrameDisabledColor = clNone
      Options.FrameWidth = 3
      Options.FrameNormalColorAlpha = 255
      Options.FrameHotColorAlpha = 255
      Options.FramePressedColorAlpha = 255
      Options.FrameFocusedColorAlpha = 255
      Options.FrameDisabledColorAlpha = 255
      Options.FontNormalColor = clWhite
      Options.FontHotColor = clOldlace
      Options.FontPressedColor = clOldlace
      Options.FontFocusedColor = clNone
      Options.FontDisabledColor = clNone
      Options.ShapeFillGradientAngle = 90
      Options.ShapeFillGradientPressedAngle = -90
      Options.ShapeFillGradientColorOffset = 25
      Options.ShapeCornerRadius = 10
      Options.ShapeStyle = scgpRect
      Options.ShapeStyleLineSize = 0
      Options.ArrowSize = 9
      Options.ArrowAreaSize = 0
      Options.ArrowType = scgpatDefault
      Options.ArrowThickness = 2
      Options.ArrowThicknessScaled = False
      Options.ArrowNormalColor = clNone
      Options.ArrowHotColor = clNone
      Options.ArrowPressedColor = clNone
      Options.ArrowFocusedColor = clNone
      Options.ArrowDisabledColor = clNone
      Options.ArrowNormalColorAlpha = 200
      Options.ArrowHotColorAlpha = 255
      Options.ArrowPressedColorAlpha = 255
      Options.ArrowFocusedColorAlpha = 200
      Options.ArrowDisabledColorAlpha = 125
      Options.StyleColors = True
      Options.PressedHotColors = False
      HotImageIndex = -1
      FluentLightEffect = False
      FocusedImageIndex = -1
      PressedImageIndex = -1
      UseGalleryMenuImage = False
      UseGalleryMenuCaption = False
      ScaleMarginAndSpacing = False
      WidthWithCaption = 0
      WidthWithoutCaption = 0
      SplitButton = False
      RepeatClick = False
      RepeatClickInterval = 100
      GlowEffect.Enabled = False
      GlowEffect.Color = clHighlight
      GlowEffect.AlphaValue = 255
      GlowEffect.GlowSize = 7
      GlowEffect.Offset = 0
      GlowEffect.Intensive = True
      GlowEffect.StyleColors = True
      GlowEffect.HotColor = clNone
      GlowEffect.PressedColor = clNone
      GlowEffect.FocusedColor = clNone
      GlowEffect.PressedGlowSize = 7
      GlowEffect.PressedAlphaValue = 255
      GlowEffect.States = [scsHot, scsPressed, scsFocused]
      ImageGlow = True
      ShowGalleryMenuFromTop = False
      ShowGalleryMenuFromRight = False
      ShowMenuArrow = True
      ShowFocusRect = True
      Down = False
      GroupIndex = 0
      AllowAllUp = False
      ToggleMode = False
    end
  end
  object richLog: TRichEdit
    Left = 0
    Top = 41
    Width = 557
    Height = 240
    TabStop = False
    Align = alClient
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Droid Sans Mono'
    Font.Style = []
    ParentFont = False
    PopupMenu = pmLog
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 1
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
    Left = 392
    Top = 8
  end
  object scStyledForm1: TscStyledForm
    FluentUIBackground = scfuibNone
    FluentUIAcrylicColor = clBtnFace
    FluentUIAcrylicColorAlpha = 100
    FluentUIBorder = True
    FluentUIInactiveAcrylicColorOpaque = False
    DWMClientRoundedCornersType = scDWMRoundedCornersDefault
    DWMClientShadow = False
    DWMClientShadowHitTest = False
    DropDownForm = False
    DropDownAnimation = False
    DropDownBorderColor = clBtnShadow
    StylesMenuSorted = False
    ShowStylesMenu = False
    StylesMenuCaption = 'Styles'
    ClientWidth = 0
    ClientHeight = 0
    ShowHints = True
    Buttons = <>
    ButtonFont.Charset = DEFAULT_CHARSET
    ButtonFont.Color = clWindowText
    ButtonFont.Height = -12
    ButtonFont.Name = 'Segoe UI'
    ButtonFont.Style = []
    CaptionFont.Charset = DEFAULT_CHARSET
    CaptionFont.Color = clWindowText
    CaptionFont.Height = -12
    CaptionFont.Name = 'Segoe UI'
    CaptionFont.Style = []
    CaptionAlignment = taLeftJustify
    InActiveClientColor = clWindow
    InActiveClientColorAlpha = 100
    InActiveClientBlurAmount = 5
    Tabs = <>
    TabFont.Charset = DEFAULT_CHARSET
    TabFont.Color = clWindowText
    TabFont.Height = -12
    TabFont.Name = 'Segoe UI'
    TabFont.Style = []
    ShowButtons = True
    ShowTabs = True
    TabIndex = 0
    TabsPosition = sctpLeft
    ShowInactiveTab = True
    CaptionWallpaperIndex = -1
    CaptionWallpaperInActiveIndex = -1
    CaptionWallpaperLeftMargin = 1
    CaptionWallpaperTopMargin = 1
    CaptionWallpaperRightMargin = 1
    CaptionWallpaperBottomMargin = 1
    Left = 520
    Top = 64
  end
  object pmLog: TPopupMenu
    Left = 272
    Top = 160
    object RESVIEWLOGPROPERTIES1: TMenuItem
      Caption = 'RES_VIEW_LOG_PROPERTIES'
      OnClick = RESVIEWLOGPROPERTIES1Click
    end
  end
end
