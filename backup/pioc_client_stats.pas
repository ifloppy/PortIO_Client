unit pioc_client_stats;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, StrUtils;

type

  { TFormStats }

  TFormStats = class(TForm)
    btnRefreshData: TButton;
    btnRedeem: TButton;
    edtCode: TEdit;
    ListBox: TListBox;
    procedure btnRefreshDataClick(Sender: TObject);
    procedure btnRedeemClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

implementation

uses pioc_common, portio_client_main, fpjson;

{$R *.lfm}

{ TFormStats }

procedure TFormStats.FormCreate(Sender: TObject);
begin
  btnRefreshDataClick(Self);
end;

procedure TFormStats.btnRefreshDataClick(Sender: TObject);
begin
  if not GetUserInfo() then begin
    ShowMessage('数据更新失败');
    exit;
  end;
  ListBox.Clear;
  ListBox.AddItem(Utf8ToAnsi('用户名:')+UserDataJSON.Strings['name'],nil);
  ListBox.AddItem(Utf8ToAnsi('邮箱:')+UserDataJSON.Strings['email'],nil);
  ListBox.AddItem(Utf8ToAnsi('剩余流量:')+UserDataJSON.Strings['traffic'],nil);
  ListBox.AddItem(Utf8ToAnsi('注册时间:')+UserDataJSON.Strings['created_at'],nil);
  ListBox.AddItem(Utf8ToAnsi('用户ID:')+UserDataJSON.Strings['id'],nil);
  FormMain.RefreshUserInfo();
end;

procedure TFormStats.btnRedeemClick(Sender: TObject);
var
  req: TStringStream;
  res: string;
  resJSON: TJSONObject;
begin
  req:=TStringStream.Create('{"code":"'+edtCode.Text+'"}');
  HTTPClient.RequestBody:=req;
  try
    res:=HTTPClient.Post(urlBase+'/codes/use');
  except
    ShowMessage('发生错误，状态信息:'+HTTPClient.ResponseStatusText);
  end;
  req.Free;
  HTTPClient.RequestBody:=nil;
  resJSON:=GetJSON(res) as TJSONObject;
  ShowMessage(resJSON.Strings['message']);
  resJSON.Free;
  btnRefreshDataClick(Self);
end;

end.

