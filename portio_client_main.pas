unit portio_client_main;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ComCtrls,
  LCLIntf, AsyncProcess, ExtCtrls, fpjson, process, portio_client_newtunnel,
  portio_client_listtunnel;

type

  { TFormMain }

  TFormMain = class(TForm)
    btnSaveRunScript: TButton;
    ckbAutoStartWhenRunning: TCheckBox;
    processFRPC: TAsyncProcess;
    btnUseTunnel: TButton;
    btnSwitch: TButton;
    btnTunnels: TButton;
    btnSign: TButton;
    btnCharge: TButton;
    edtTunnelID: TEdit;
    lblUserInfo: TLabel;
    outputLog: TMemo;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    timerFRPCOutput: TTimer;
    procedure btnChargeClick(Sender: TObject);
    procedure btnSaveRunScriptClick(Sender: TObject);
    procedure btnSwitchClick(Sender: TObject);
    procedure btnUseTunnelClick(Sender: TObject);
    procedure btnSignClick(Sender: TObject);
    procedure btnTunnelsClick(Sender: TObject);
    procedure ckbAutoStartWhenRunningChange(Sender: TObject);
    procedure edtTunnelIDChange(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure timerFRPCOutputTimer(Sender: TObject);
    procedure WriteOutputLog(line: string);
    procedure frpcStart();
    procedure frpcStop();
  private

  public
    procedure useTunnel(NewTunnelID: string);
  end;

var
  FormMain: TFormMain;

implementation

uses pioc_common;

  {$R *.frm}

  { TFormMain }

procedure TFormMain.FormCreate(Sender: TObject);
begin
  lblUserInfo.Caption := '欢迎你，' + Utf8ToAnsi(UserDataJSON.Strings['name'] + LineEnding) + '剩余流量(GB):' + Utf8ToAnsi(IntToStr(UserDataJSON.Integers['traffic']) + LineEnding);
  edtTunnelID.Caption:=ConfigFile.ReadString('tunnel', 'id', '');
  processFRPC.Executable:=Application.Location+frpcFileName;
  processFRPC.CurrentDirectory:=GetCurrentDir;
  processFRPC.Parameters.Append('-c');
  processFRPC.Parameters.Append('frpc.ini');

  ckbAutoStartWhenRunning.Checked:=ConfigFile.ReadBool('tunnel', 'autoRun', false);
  if ConfigFile.ReadBool('tunnel', 'autoRun', false) then begin
    PageControl1.ActivePageIndex:=1;
    btnSwitchClick(Self);

  end;
end;

procedure TFormMain.timerFRPCOutputTimer(Sender: TObject);
var
  buffer: TStrings;
begin
  if processFRPC.Running then begin
    if processFRPC.Output.NumBytesAvailable > 0 then begin
      buffer := TStringList.Create();
      buffer.LoadFromStream(processFRPC.Output);
      WriteOutputLog(buffer.Text);
      buffer.Free
    end;
  end else begin
    WriteOutputLog('frpc已不在运行');
    frpcStop();
  end;
end;

procedure TFormMain.btnTunnelsClick(Sender: TObject);
begin
  //OpenURL(urlDashboard + 'tunnels');
  FormListTunnel:=TFormListTunnel.Create(self);
  FormListTunnel.ShowModal;
  FormListTunnel.Free;
end;

procedure TFormMain.ckbAutoStartWhenRunningChange(Sender: TObject);
begin
  ConfigFile.WriteBool('tunnel', 'autoRun', ckbAutoStartWhenRunning.Checked);
end;

procedure TFormMain.edtTunnelIDChange(Sender: TObject);
begin
  if Length(edtTunnelID.Caption) = 0 then
    btnUseTunnel.Enabled := False
  else
    btnUseTunnel.Enabled := True;
end;

procedure TFormMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if timerFRPCOutput.Enabled then begin
    ShowMessage('请先停止映射后再关闭本程序');
    CanClose:=false;
    exit;
  end;
  piocCommonShutdown();
  CanClose:= true;
end;

procedure TFormMain.btnSignClick(Sender: TObject);
begin
  OpenURL(urlDashboard + 'sign');
end;

procedure TFormMain.btnChargeClick(Sender: TObject);
begin
  OpenURL(urlDashboard + 'charge');
end;

procedure TFormMain.btnSaveRunScriptClick(Sender: TObject);
var
  savefile: TSaveDialog;
  savestream: TStrings;
begin
  savefile := TSaveDialog.Create(Self);
  savefile.Filter:='Windows 批处理|*.bat|Linux Shell Script|*.sh';
  if savefile.Execute then begin
    //成功
    if FileExists(savefile.FileName) then DeleteFile(savefile.FileName);
    savestream:=TStringList.Create;
    savestream.Text:=Application.Location+frpcFileName+' -c '+GetCurrentDir+PathDelim+'frpc.ini';
    savestream.SaveToFile(savefile.FileName);
    savestream.Free;
  end;
  savefile.Free;
end;

procedure TFormMain.btnSwitchClick(Sender: TObject);
begin
  if timerFRPCOutput.Enabled then begin
    frpcStop();
  end else begin
    frpcStart();
  end;

end;

procedure TFormMain.btnUseTunnelClick(Sender: TObject);
var
  tunnelInfoJson: TJSONObject;
  resp: TStringStream;
  configStr: string;
  configfilestream: TFileStream;
begin
  resp := TStringStream.Create();
  HTTPClient.HTTPMethod('GET', urlBase + '/tunnels/' + edtTunnelID.Caption, resp, [401, 403, 404, 200]);

  if HTTPClient.ResponseStatusCode <> 200 then
  begin
    WriteOutputLog('配置文件下载失败：' + HTTPClient.ResponseStatusText);
  end
  else
  begin
    tunnelInfoJson := GetJSON(resp.DataString) as TJSONObject;
    configStr := tunnelInfoJson.Objects['config'].Strings['server'] + #10 + tunnelInfoJson.Objects['config'].Strings['client'];
    configStr:=Utf8ToAnsi(configStr);
    if FileExists('frpc.ini') then DeleteFile('frpc.ini');
    configfilestream := TFileStream.Create('frpc.ini', fmCreate);
    configfilestream.Position:=0;
    configfilestream.Write(configStr[1], Length(configStr));

    ConfigFile.WriteInt64('tunnel', 'id', StrToInt(edtTunnelID.Caption));


    configfilestream.Free;
    tunnelInfoJson.Free;

    WriteOutputLog('配置文件已保存');
  end;

  resp.Free;



end;

procedure TFormMain.WriteOutputLog(line: string);
begin
  outputLog.Append(line);
end;

procedure TFormMain.frpcStart();
begin
  processFRPC.Execute;
  timerFRPCOutput.Enabled:=true;
  edtTunnelID.Enabled:=false;
  btnUseTunnel.Enabled:=false;
  btnSwitch.Caption:='停止';
  WriteOutputLog('FRPC已开始运行，进程ID：'+IntToStr(processFRPC.ProcessID));
end;

procedure TFormMain.frpcStop();
begin
  if processFRPC.Running then begin
    processFRPC.Terminate(0);
    WriteOutputLog('FRPC已停止，退出代码：'+IntToStr(processFRPC.ExitCode));
  end;

  timerFRPCOutput.Enabled:=false;
  edtTunnelID.Enabled:=true;
  btnUseTunnel.Enabled:=true;
  btnSwitch.Caption:='启动';

end;


procedure TFormMain.useTunnel(NewTunnelID: string);
begin
  frpcStop();
  edtTunnelID.Text:=NewTunnelID;
  btnUseTunnelClick(Self);
  PageControl1.ActivePageIndex:=1;
end;

end.
