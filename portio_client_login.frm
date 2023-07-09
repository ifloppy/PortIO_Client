object FormLogin: TFormLogin
  Left = 172
  Height = 191
  Top = 171
  Width = 421
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsDialog
  Caption = '登录到PortIO'
  ClientHeight = 191
  ClientWidth = 421
  DesignTimePPI = 120
  OnActivate = FormActivate
  OnCreate = FormCreate
  LCLVersion = '8.1'
  object inputToken: TLabeledEdit
    Left = 16
    Height = 28
    Top = 31
    Width = 397
    Anchors = [akTop, akLeft, akRight]
    EditLabel.Height = 20
    EditLabel.Width = 397
    EditLabel.Caption = '登录Token'
    TabOrder = 0
    TextHint = '请将获取到的登录Token填写在此'
  end
  object btnLogin: TButton
    Left = 319
    Height = 31
    Top = 154
    Width = 94
    Anchors = [akRight, akBottom]
    Caption = '登录'
    OnClick = btnLoginClick
    TabOrder = 1
  end
  object btnGetToken: TButton
    Left = 8
    Height = 31
    Top = 154
    Width = 134
    Anchors = [akLeft, akBottom]
    Caption = '获取Token'
    OnClick = btnGetTokenClick
    TabOrder = 2
  end
  object ckbAutoLogin: TCheckBox
    Left = 152
    Height = 24
    Top = 161
    Width = 126
    Anchors = [akLeft, akBottom]
    Caption = '启动时自动登录'
    TabOrder = 3
  end
end
