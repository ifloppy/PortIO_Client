object FormLogin: TFormLogin
  Left = 172
  Height = 277
  Top = 171
  Width = 428
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = '登录到PortIO'
  ClientHeight = 277
  ClientWidth = 428
  DesignTimePPI = 120
  OnActivate = FormActivate
  OnCreate = FormCreate
  LCLVersion = '8.1'
  object inputToken: TLabeledEdit
    Left = 16
    Height = 28
    Top = 31
    Width = 404
    EditLabel.Height = 20
    EditLabel.Width = 404
    EditLabel.Caption = '登录Token'
    TabOrder = 0
    TextHint = '请将获取到的登录Token填写在此'
  end
  object btnLogin: TButton
    Left = 326
    Height = 31
    Top = 64
    Width = 94
    Caption = '登录'
    OnClick = btnLoginClick
    TabOrder = 1
  end
  object btnGetToken: TButton
    Left = 16
    Height = 31
    Top = 64
    Width = 134
    Caption = '获取Token'
    OnClick = btnGetTokenClick
    TabOrder = 2
  end
  object ckbAutoLogin: TCheckBox
    Left = 160
    Height = 24
    Top = 71
    Width = 126
    Caption = '启动时自动登录'
    TabOrder = 3
  end
end
