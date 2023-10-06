unit portio_client_newtunnel;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls, fpjson, pioc_common;

type

  { TFormNewTunnel }

  TFormNewTunnel = class(TForm)
    btnCreate: TButton;
    cbx_server: TComboBox;
    cbx_protocol: TComboBox;
    edt_tunnelName: TLabeledEdit;
    Label1: TLabel;
    Label2: TLabel;
    edt_domain: TLabeledEdit;
    edt_portRemote: TLabeledEdit;
    edt_sk: TLabeledEdit;
    edt_localAddress: TLabeledEdit;
    serverList: TStringList;
    procedure btnCreateClick(Sender: TObject);
    procedure cbx_protocolChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);

  private

  public

  end;

var
  FormNewTunnel: TFormNewTunnel;

implementation

{$R *.lfm}

{ TFormNewTunnel }

procedure TFormNewTunnel.btnCreateClick(Sender: TObject);
var
  TargetTunnelObject: TJSONObject;
  resp: TStringStream;
  respJson: TJSONObject;
begin
  if (edt_tunnelName.Text = '') or (edt_localAddress.Text = '') or (cbx_protocol.ItemIndex = -1) or (cbx_server.ItemIndex = -1) then begin
    ShowMessage('请先将信息填写完整');
    exit;
  end;

  TargetTunnelObject := TJSONObject.Create();
  TargetTunnelObject.Add('custom_domain', edt_domain.Text);
  TargetTunnelObject.Add('local_address', edt_localAddress.Text);
  TargetTunnelObject.Add('name', edt_tunnelName.Text);
  TargetTunnelObject.Add('protocol', cbx_protocol.Text);
  TargetTunnelObject.Add('remote_port', StrToInt(edt_portRemote.Text));

  //服务器选项
  TargetTunnelObject.Add('server_id', StrToInt(serverList.Values[cbx_server.Text]));

  TargetTunnelObject.Add('sk', edt_sk.Text);

  HTTPClient.RequestBody:=TStringStream.Create(TargetTunnelObject.AsJSON);
  resp:=TStringStream.Create();
  HTTPClient.HTTPMethod('POST', urlBase+'/tunnels', resp, [200,401,422,400]);
  HTTPClient.RequestBody.Free;
  HTTPClient.RequestBody:=nil;

  respJson:=GetJSON(resp.DataString) as TJSONObject;
  if HTTPClient.ResponseStatusCode = 200 then begin
    ShowMessage('创建成功');
  end else begin
    MessageDlg('创建失败', respJson.Strings['message'], mtError, [mbOK], 0);
  end;
  TargetTunnelObject.Free;
  resp.Free;
  respJson.Free;
end;

procedure TFormNewTunnel.cbx_protocolChange(Sender: TObject);
begin
  if (cbx_protocol.Text = 'http') or (cbx_protocol.Text = 'https') then begin
    edt_domain.Enabled:=true;
    edt_sk.Enabled:=false;
    edt_portRemote.Enabled:=false;
    exit;
  end;

  if (cbx_protocol.Text = 'tcp') or (cbx_protocol.Text = 'udp') then begin
    edt_domain.Enabled:=false;
    edt_sk.Enabled:=false;
    edt_portRemote.Enabled:=true;
    exit;
  end;

  edt_domain.Enabled:=false;
    edt_sk.Enabled:=true;
    edt_portRemote.Enabled:=false;
end;

procedure TFormNewTunnel.FormCreate(Sender: TObject);
var
  resJSON: TJSONArray;
  i: UInt8;
begin
  resJSON := GetJSON(HTTPClient.Get(urlBase+'/servers')) as TJSONArray;
  if not (resJSON.Count > 0) then begin
    ShowMessage('没有获取到可用的服务器');
    resJSON.Free;
    Close;
  end;

  serverList:=TStringList.Create;
  for i := 0 to Pred(resJSON.Count) do begin
    serverList.AddPair(resJSON.Objects[i].Strings['name'], resJSON.Objects[i].Strings['id']);
    cbx_server.Items.Add(resJSON.Objects[i].Strings['name']);
  end;

  resJSON.Free;

end;

procedure TFormNewTunnel.FormDestroy(Sender: TObject);
begin
  serverList.Free;
end;

end.

