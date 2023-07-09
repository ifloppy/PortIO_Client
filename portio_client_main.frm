object FormMain: TFormMain
  Left = 86
  Height = 311
  Top = 86
  Width = 485
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'PortIO Main'
  ClientHeight = 311
  ClientWidth = 485
  DesignTimePPI = 120
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  LCLVersion = '8.1'
  object PageControl1: TPageControl
    Left = 0
    Height = 311
    Top = 0
    Width = 486
    ActivePage = TabSheet2
    Anchors = [akTop, akLeft, akRight, akBottom]
    TabHeight = 40
    TabIndex = 1
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = '概览'
      ClientHeight = 253
      ClientWidth = 483
      object lblUserInfo: TLabel
        Left = 8
        Height = 20
        Top = 8
        Width = 150
        Caption = '用户信息应该展示在此'
      end
      object btnTunnels: TButton
        Left = 8
        Height = 31
        Top = 220
        Width = 94
        Anchors = [akLeft, akBottom]
        Caption = '隧道列表'
        OnClick = btnTunnelsClick
        TabOrder = 0
      end
      object btnSign: TButton
        Left = 112
        Height = 31
        Top = 219
        Width = 94
        Anchors = [akLeft, akBottom]
        Caption = '签到'
        OnClick = btnSignClick
        TabOrder = 1
      end
      object btnCharge: TButton
        Left = 216
        Height = 31
        Top = 219
        Width = 94
        Anchors = [akLeft, akBottom]
        Caption = '充值'
        OnClick = btnChargeClick
        TabOrder = 2
      end
      object btnNewTunnel: TButton
        Left = 320
        Height = 31
        Top = 219
        Width = 94
        Anchors = [akLeft, akBottom]
        Caption = '创建隧道'
        OnClick = btnNewTunnelClick
        TabOrder = 3
      end
      object ckbAutoStartWhenRunning: TCheckBox
        Left = 8
        Height = 24
        Top = 192
        Width = 276
        Anchors = [akLeft, akBottom]
        Caption = '在本程序每次启动时自动尝试启动映射'
        OnChange = ckbAutoStartWhenRunningChange
        TabOrder = 4
      end
      object btnSaveRunScript: TButton
        Left = 8
        Height = 31
        Hint = '将运行FRPC的脚本单独保存，而不需要运行本程序，可以减少系统线程和内存资源的占用'
        Top = 160
        Width = 94
        Anchors = [akLeft, akBottom]
        Caption = '保存到脚本'
        OnClick = btnSaveRunScriptClick
        ParentShowHint = False
        ShowHint = True
        TabOrder = 5
      end
    end
    object TabSheet2: TTabSheet
      Caption = '隧道'
      ClientHeight = 263
      ClientWidth = 478
      object edtTunnelID: TEdit
        Left = 8
        Height = 28
        Top = 8
        Width = 328
        Anchors = [akTop, akLeft, akRight]
        NumbersOnly = True
        OnChange = edtTunnelIDChange
        TabOrder = 0
        TextHint = '希望使用的隧道的ID（数字）'
      end
      object btnUseTunnel: TButton
        Left = 344
        Height = 31
        Hint = '将填写的隧道ID所对应的隧道的配置文件保存，供FRPC使用'
        Top = 8
        Width = 56
        Anchors = [akTop, akRight]
        Caption = '使用'
        Enabled = False
        OnClick = btnUseTunnelClick
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
      end
      object btnSwitch: TButton
        Left = 411
        Height = 31
        Hint = 'FRPC的开关'
        Top = 8
        Width = 54
        Anchors = [akTop, akRight]
        Caption = '启动'
        OnClick = btnSwitchClick
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
      end
      object outputLog: TMemo
        Left = 8
        Height = 198
        Top = 56
        Width = 458
        Anchors = [akTop, akLeft, akRight, akBottom]
        Lines.Strings = (
          '开始使用PortIO，请在网站上创建隧道，并将这条隧道的数字ID输入到本程序中，再点击使用。'
          '想要开始映射，请点击“启动”；停止映射请点击“停止”'
          '映射服务的日志将会被输出在这里。'
        )
        ReadOnly = True
        ScrollBars = ssAutoVertical
        TabOrder = 3
      end
    end
  end
  object processFRPC: TAsyncProcess
    Active = False
    Options = [poUsePipes, poNoConsole]
    Priority = ppNormal
    StartupOptions = []
    ShowWindow = swoNone
    WindowColumns = 0
    WindowHeight = 0
    WindowLeft = 0
    WindowRows = 0
    WindowTop = 0
    WindowWidth = 0
    FillAttribute = 0
    Left = 16
    Top = 240
  end
  object timerFRPCOutput: TTimer
    Enabled = False
    Interval = 2000
    OnTimer = timerFRPCOutputTimer
    Left = 80
    Top = 240
  end
end
