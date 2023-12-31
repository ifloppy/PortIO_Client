program PortIO_Client;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  {$IFDEF HASAMIGA}
  athreads,
  {$ENDIF}
  Interfaces, // this includes the CT adLCL widgetset
  Forms, PortIO_Client_login, pioc_common, portio_client_main,
portio_client_listtunnel, pioc_client_stats
  { you can add units after this };

{$R *.res}

begin

  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
  piocCommonInit();
  FormLogin:=TFormLogin.Create(nil);
  FormLogin.ShowModal;
  if UserDataJSON = nil then begin
    piocCommonShutdown();
    FormLogin.Free;
    Halt();
  end;
  FormLogin.Free;

  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.

