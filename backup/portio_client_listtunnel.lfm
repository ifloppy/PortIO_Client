object FormListTunnel: TFormListTunnel
  Left = 0
  Height = 268
  Top = 0
  Width = 535
  Caption = '隧道列表'
  ClientHeight = 268
  ClientWidth = 535
  DesignTimePPI = 120
  OnCreate = FormCreate
  LCLVersion = '8.1'
  object btnCreate: TButton
    Left = 433
    Height = 31
    Top = 8
    Width = 94
    Anchors = [akTop, akRight]
    Caption = '新建隧道'
    OnClick = btnCreateClick
    TabOrder = 0
  end
  object btnRemoveSel: TButton
    Left = 433
    Height = 31
    Top = 48
    Width = 94
    Caption = '删除所选'
    OnClick = btnRemoveSelClick
    TabOrder = 1
    Visible = False
  end
  object lstTunnel: TListView
    Left = 8
    Height = 252
    Top = 8
    Width = 416
    Anchors = [akTop, akLeft, akRight, akBottom]
    AutoSortIndicator = True
    Columns = <    
      item
        Caption = 'ID'
      end    
      item
        AutoSize = True
        Caption = '隧道名称'
        Width = 80
      end    
      item
        Caption = '映射类型'
        Width = 80
      end    
      item
        AutoSize = True
        Caption = '远程地址'
        Width = 80
      end>
    ReadOnly = True
    RowSelect = True
    TabOrder = 2
    ViewStyle = vsReport
    OnClick = lstTunnelClick
  end
  object btnRefresh: TButton
    Left = 433
    Height = 31
    Top = 229
    Width = 94
    Caption = '刷新列表'
    OnClick = btnRefreshClick
    TabOrder = 3
  end
  object btnUseSel: TButton
    Left = 433
    Height = 31
    Top = 88
    Width = 94
    Caption = '使用所选'
    OnClick = btnUseSelClick
    TabOrder = 4
    Visible = False
  end
end
