unit portio_client_listtunnel;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ComCtrls,
  portio_client_newtunnel, fpjson, pioc_common;

type

  { TFormListTunnel }

  TFormListTunnel = class(TForm)
    btnCreate: TButton;
    btnRemoveSel: TButton;
    btnRefresh: TButton;
    lstTunnel: TListView;
    procedure btnCreateClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure btnRemoveSelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lstTunnelClick(Sender: TObject);
  private

  public

  end;

var
  FormListTunnel: TFormListTunnel;

implementation

{$R *.frm}

{ TFormListTunnel }

procedure TFormListTunnel.btnCreateClick(Sender: TObject);
begin
  FormNewTunnel:=TFormNewTunnel.Create(self);
  FormNewTunnel.ShowModal;
  FormNewTunnel.Free;
end;

procedure TFormListTunnel.btnRefreshClick(Sender: TObject);
var
  respJSON: TJSONArray;
  resp: TStringStream;
  i: UInt8;
  newItem: TListItem;
begin
  lstTunnel.Clear;
  resp:=TStringStream.Create();
  HTTPClient.HTTPMethod('GET', urlBase+'/tunnels', resp, [200]);
  respJSON := GetJSON(resp.DataString) as TJSONArray;
  resp.Free;
  if respJSON.Count = 0 then begin
    ShowMessage('没有找到你创建的隧道');
  end else begin
    for i := 0 to Pred(respJSON.Count) do begin
        newItem:=lstTunnel.Items.Add;
        newItem.Caption:=(respJSON.Objects[i].Strings['id']);
        newItem.SubItems.Add(respJSON.Objects[i].Strings['name']);
        newItem.SubItems.Add(respJSON.Objects[i].Strings['protocol']);
        newItem.SubItems.Add(respJSON.Objects[i].Objects['server'].Strings['server_address']+':'+respJSON.Objects[i].Strings['remote_port']);
    end;

  end;



  respJSON.Free;
end;

procedure TFormListTunnel.btnRemoveSelClick(Sender: TObject);
var
  resp: TStringStream;
  respJSON: TJSONObject;
begin
  resp := TStringStream.Create();
  HTTPClient.HTTPMethod('DELETE', urlBase+'/tunnels/'+lstTunnel.Selected.Caption, resp, [404, 200]);
  if HTTPClient.ResponseStatusCode = 200 then begin
    ShowMessage('删除成功');
    lstTunnel.Selected.Delete;
    btnRemoveSel.Visible:=false;
  end else begin
      respJSON:=GetJSON(resp.DataString) as TJSONObject;
      MessageDlg('删除失败:'+HTTPClient.ResponseStatusText, respJSON.Strings['message'], mtError, [mbOK], 0);
      respJSON.Free;
  end;

  resp.Free;
end;

procedure TFormListTunnel.FormCreate(Sender: TObject);
begin
  btnRefreshClick(self);
end;

procedure TFormListTunnel.lstTunnelClick(Sender: TObject);
begin
  if lstTunnel.SelCount = 1 then btnRemoveSel.Visible:=true else btnRemoveSel.Visible:=false;
end;

end.

