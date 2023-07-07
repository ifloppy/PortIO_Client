object FormNewTunnel: TFormNewTunnel
  Left = 86
  Height = 236
  Top = 86
  Width = 622
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = '新建隧道'
  ClientHeight = 236
  ClientWidth = 622
  DesignTimePPI = 120
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  LCLVersion = '8.1'
  object edt_tunnelName: TLabeledEdit
    Left = 8
    Height = 28
    Top = 32
    Width = 288
    EditLabel.Height = 20
    EditLabel.Width = 288
    EditLabel.Caption = '隧道名称'
    TabOrder = 0
    TextHint = '请输入想要创建的隧道的名称'
  end
  object cbx_server: TComboBox
    Left = 8
    Height = 28
    Top = 88
    Width = 288
    ItemHeight = 20
    ReadOnly = True
    Style = csDropDownList
    TabOrder = 1
  end
  object cbx_protocol: TComboBox
    Left = 8
    Height = 28
    Top = 144
    Width = 288
    ItemHeight = 20
    Items.Strings = (
      'http'
      'https'
      'tcp'
      'udp'
      'stcp'
      'sudp'
      'xtcp'
    )
    OnChange = cbx_protocolChange
    Style = csDropDownList
    TabOrder = 2
  end
  object Label1: TLabel
    Left = 8
    Height = 20
    Top = 64
    Width = 150
    Caption = '选择用于映射的服务器'
  end
  object Label2: TLabel
    Left = 8
    Height = 20
    Top = 123
    Width = 135
    Caption = '选择将要映射的协议'
  end
  object edt_domain: TLabeledEdit
    Left = 304
    Height = 28
    Top = 32
    Width = 312
    EditLabel.Height = 20
    EditLabel.Width = 312
    EditLabel.Caption = '域名(只对HTTP(S)隧道有效)'
    Enabled = False
    TabOrder = 3
  end
  object edt_portRemote: TLabeledEdit
    Left = 304
    Height = 28
    Top = 84
    Width = 312
    EditLabel.Height = 20
    EditLabel.Width = 312
    EditLabel.Caption = '外部端口(只对TCP/UDP隧道有效)'
    Enabled = False
    TabOrder = 4
  end
  object edt_sk: TLabeledEdit
    Left = 304
    Height = 28
    Top = 136
    Width = 312
    EditLabel.Height = 20
    EditLabel.Width = 312
    EditLabel.Caption = '访问密钥(只对STCP/SUDP/XTCP隧道有效)'
    Enabled = False
    TabOrder = 5
  end
  object edt_localAddress: TLabeledEdit
    Left = 8
    Height = 28
    Top = 200
    Width = 292
    EditLabel.Height = 20
    EditLabel.Width = 292
    EditLabel.Caption = '服务本地地址'
    TabOrder = 6
  end
  object btnCreate: TButton
    Left = 522
    Height = 31
    Top = 200
    Width = 94
    Caption = '创建'
    OnClick = btnCreateClick
    TabOrder = 7
  end
end
