program NotificationsAPIProject;

{$R 'resources.res' 'src\resources.rc'}

uses
  Vcl.Forms,
  Forms.Main in 'src\Forms.Main.pas' {frmMain},
  Server in 'src\Server.pas',
  Configuration in 'src\Configuration.pas',
  Forms.ApplicationSettings in 'src\Forms.ApplicationSettings.pas' {frmAppSettings},
  Localization.Resources in 'src\Localization.Resources.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Servi�o de Notifica��es';
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
