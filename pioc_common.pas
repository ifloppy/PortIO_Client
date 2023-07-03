unit pioc_common;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, fphttpclient, opensslsockets, openssl, jsonparser, fpjson, Forms, Dialogs, IniFiles;

const
  urlDashboard = 'https://muhanfrp.cn/';
  urlBase = 'https://muhanfrp.cn/api';
  {$IfDef Windows}
  frpcFileName = 'frpc.exe';
  {$Else}
  frpcFilename = 'frpc';
  {$EndIf}

var
  HTTPClient: TFPHTTPClient;
  UserDataJSON: TJSONObject;
  ConfigFile: TIniFile;

procedure piocCommonInit();
procedure piocCommonShutdown();
procedure piocAuthLoad(authToken: string);
function GetUserInfo(): boolean;

implementation

procedure piocCommonInit();
begin
  HTTPClient := TFPHTTPClient.Create(nil);
  HTTPClient.AddHeader('user-agent', 'ifloppy/portio client');
  HTTPClient.AddHeader('accept', 'application/json');
  HTTPClient.AddHeader('authorization', 'Bearer 0');
  InitSSLInterface;

  ConfigFile := TIniFile.Create('PortIO.ini');
end;

procedure piocCommonShutdown();
begin
  HTTPClient.Free;
  ConfigFile.Free;
  UserDataJSON.Free;
end;

procedure piocAuthLoad(authToken: string);
begin
  HTTPClient.RequestHeaders.Values['authorization'] := 'Bearer ' + authToken;
end;

function GetUserInfo(): boolean;
var
  resp: TStringStream;
begin
  resp := TStringStream.Create();
  HTTPClient.HTTPMethod('GET', urlBase + '/user', resp, [401, 403, 200]);
  if HTTPClient.ResponseStatusCode <> 200 then
  begin
    //ShowMessage('获取用户信息发生错误，返回的数据:'+LineEnding+resp.DataString);
    Result := False;
  end
  else
  begin
    UserDataJSON.Free;
    UserDataJSON := GetJSON(resp.DataString) as TJSONObject;
    Result := True;
  end;
  resp.Free;
end;

end.
