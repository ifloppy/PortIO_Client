unit pioc_client_stats;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, StrUtils;

type

  { TFormStats }

  TFormStats = class(TForm)
    btnRefreshData: TButton;
    ListBox: TListBox;
    procedure btnRefreshDataClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

implementation

uses pioc_common, portio_client_main;

{$R *.lfm}

{ TFormStats }

procedure TFormStats.FormCreate(Sender: TObject);
begin
  ListBox.AddItem(Utf8ToAnsi('用户名:')+UserDataJSON.Strings['name'],nil);
  ListBox.AddItem(Utf8ToAnsi('邮箱:')+UserDataJSON.Strings['email'],nil);
  ListBox.AddItem(Utf8ToAnsi('剩余流量:')+UserDataJSON.Strings['traffic'],nil);
  ListBox.AddItem(Utf8ToAnsi('注册时间:')+UserDataJSON.Strings['created_at'],nil);
  ListBox.AddItem(Utf8ToAnsi('用户ID:')+UserDataJSON.Strings['id'],nil);
end;

procedure TFormStats.btnRefreshDataClick(Sender: TObject);
begin
  if not GetUserInfo() then begin
    ShowMessage('数据更新失败');
    exit;
  end;
  ListBox.Clear;
  FormCreate(Self);
  FormMain.RefreshUserInfo();
end;

end.

