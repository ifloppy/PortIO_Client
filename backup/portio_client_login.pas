unit PortIO_Client_login;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls, LCLIntf;

type

  { TFormLogin }

  TFormLogin = class(TForm)
    btnLogin: TButton;
    btnGetToken: TButton;
    ckbAutoLogin: TCheckBox;
    inputToken: TLabeledEdit;
    procedure btnGetTokenClick(Sender: TObject);
    procedure btnLoginClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  FormLogin: TFormLogin;

implementation

uses pioc_common;
{$R *.lfm}

{ TFormLogin }

procedure TFormLogin.btnGetTokenClick(Sender: TObject);
begin
  if MessageDlg('这将会打开浏览器并访问用户仪表盘，可点击“获取新密钥”获取Token。是否继续？', mtConfirmation, mbYesNo, 0, mbYes) = mrYes then OpenURL(urlDashboard);

end;

procedure TFormLogin.btnLoginClick(Sender: TObject);

begin
  piocAuthLoad(inputToken.Text);
  if GetUserInfo() then begin
    if(inputToken.Text <> ConfigFile.ReadString('auth', 'token', '')) then ConfigFile.WriteString('auth', 'token', inputToken.Text);
    ConfigFile.WriteBool('auth', 'autoLogin', ckbAutoLogin.Checked);
    Close;
  end else
  begin
    ShowMessage('登录失败，状态:'+HTTPClient.ResponseStatusText);
  end;
end;

procedure TFormLogin.FormActivate(Sender: TObject);
begin
  if ckbAutoLogin.Checked then btnLoginClick(Self);
end;

procedure TFormLogin.FormCreate(Sender: TObject);
begin
  inputToken.Caption:=ConfigFile.ReadString('auth', 'token', '');
  ckbAutoLogin.Checked:=ConfigFile.ReadBool('auth', 'autoLogin', false);
end;



end.
