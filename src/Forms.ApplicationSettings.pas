unit Forms.ApplicationSettings;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, System.IOUtils, Logging.Logger,
  Vcl.Menus;

resourcestring
  CERTIFICATE_FILE_FILTER = 'Todos os Arquivos (*.crt, *.pem)|*.CRT;*.PEM|Arquivos PEM (*.pem)|*.PEM|Arquivos de Certificado (*.crt)|*.CRT';
  KEY_FILE_FILTER = 'Todos os Arquivos (*.key, *.pem)|*.KEY;*.PEM|Arquivo de Chave Privada (*.key)|*.KEY|Arquivos PEM (*.pem)|*.PEM';
type
  TfrmAppSettings = class(TForm)
    gbGeneral: TGroupBox;
    cbSSL: TCheckBox;
    Panel1: TPanel;
    edtPort: TEdit;
    lblGeneralPort: TLabel;
    gbDatabase: TGroupBox;
    Panel2: TPanel;
    lblDBPassword: TLabel;
    edtDBPass: TEdit;
    Panel3: TPanel;
    lblDatabaseFile: TLabel;
    edtDatabaseFile: TEdit;
    Panel4: TPanel;
    lblDBUser: TLabel;
    edtDBUser: TEdit;
    Panel5: TPanel;
    lblDBHost: TLabel;
    edtHost: TEdit;
    Panel6: TPanel;
    lblDBPort: TLabel;
    edtDBPort: TEdit;
    gbSSL: TGroupBox;
    Panel7: TPanel;
    lblRootCertPath: TLabel;
    edtRootCertificatePath: TEdit;
    Panel9: TPanel;
    lblCertPath: TLabel;
    edtCertificatePath: TEdit;
    Panel10: TPanel;
    lblKeyFilePath: TLabel;
    edtKeyFile: TEdit;
    btnLoadKeyFile: TButton;
    btnLoadFileRCrt: TButton;
    btnLoadFileSCrt: TButton;
    btnSaveConfiguration: TButton;
    Panel8: TPanel;
    lblMinLogLevel: TLabel;
    cbxMinimumLogLevel: TComboBox;
    Panel11: TPanel;
    lbl_MAX_CONCURRENT_CON: TLabel;
    edtMaxConcurrentConnections: TEdit;
    cbStartRunning: TCheckBox;
    MainMenu1: TMainMenu;
    CONFIGMMOPTIONS1: TMenuItem;
    VERIFYCONFIGPATH1: TMenuItem;
    procedure btnLoadFileSCrtClick(Sender: TObject);
    procedure btnLoadFileRCrtClick(Sender: TObject);
    procedure btnLoadKeyFileClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbSSLClick(Sender: TObject);
    procedure btnSaveConfigurationClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure VERIFYCONFIGPATH1Click(Sender: TObject);
  private
    { Private declarations }
    procedure SetupLocalization();
    procedure PopulateSeveritiesCheckBox();
    function LoadFile(const AllowedExtensions: String; const ATitle: String = ''): String;
    procedure LoadCertificateFile(Target: TEdit);
    procedure LoadKeyFile(Target: TEdit);
  public
    { Public declarations }
  end;

var
  frmAppSettings: TfrmAppSettings;

implementation

uses Configuration, Localization.Resources;
{$R *.dfm}

{ TfrmAppSettings }

procedure TfrmAppSettings.btnLoadFileRCrtClick(Sender: TObject);
begin
  LoadCertificateFile(edtRootCertificatePath);
end;

procedure TfrmAppSettings.btnLoadFileSCrtClick(Sender: TObject);
begin
  LoadCertificateFile(edtCertificatePath);
end;

procedure TfrmAppSettings.btnLoadKeyFileClick(Sender: TObject);
begin
  LoadKeyFile(edtKeyFile);
end;

procedure TfrmAppSettings.btnSaveConfigurationClick(Sender: TObject);
begin
  ConfigurationData.Port := StrToInt(edtPort.Text);
  ConfigurationData.SSL := cbSSL.Checked;
  ConfigurationData.MinimumLogLevel := cbxMinimumLogLevel.ItemIndex;
  ConfigurationData.MaxConcurrentConnections := StrToInt(edtMaxConcurrentConnections.Text);
  ConfigurationData.StartRunning := cbStartRunning.Checked;

  ConfigurationData.DBParams.SetDatabase(edtDatabaseFile.Text);
  ConfigurationData.DBParams.SetUsername(edtDBUser.Text);
  ConfigurationData.DBParams.SetPassword(edtDBPass.Text);
  ConfigurationData.DBParams.SetHost(edtHost.Text);
  ConfigurationData.DBParams.SetPort(StrToInt(edtDBPort.Text));

  ConfigurationData.SSLConfig.SetCertificatePath(edtCertificatePath.Text);
  ConfigurationData.SSLConfig.SetRootCertificatePath(edtRootCertificatePath.Text);
  ConfigurationData.SSLConfig.SetCertificateKey(edtKeyFile.Text);

  ConfigurationData.Save();
  ModalResult := mrOK;
end;

procedure TfrmAppSettings.cbSSLClick(Sender: TObject);
begin
  gbSSL.Enabled := (TCheckBox(Sender)).Checked;
end;

procedure TfrmAppSettings.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if (ModalResult <> mrOk) and (MessageDlg(
  RES_DISCARD_CHAGNES_QUERY,
  mtConfirmation,
  [mbOk, mbCancel],
  0) = mrCancel) then CanClose := False;
end;

procedure TfrmAppSettings.FormCreate(Sender: TObject);
begin
  PopulateSeveritiesCheckBox();
  SetupLocalization();
  cbxMinimumLogLevel.ItemIndex := ConfigurationData.MinimumLogLevel;
  edtPort.Text := IntToStr(ConfigurationData.Port);
  cbSSL.Checked := ConfigurationData.SSL;
  gbSSL.Enabled := ConfigurationData.SSL;
  edtMaxConcurrentConnections.Text := IntToStr(ConfigurationData.MaxConcurrentConnections);
  cbStartRunning.Checked := ConfigurationData.StartRunning;

  edtCertificatePath.Text := ConfigurationData.SSLConfig.CertificatePath;
  edtRootCertificatePath.Text := ConfigurationData.SSLConfig.RootCertificatePath;
  edtKeyFile.Text := ConfigurationData.SSLConfig.CertificateKey;

  edtDatabaseFile.Text := ConfigurationData.DBParams.Database;
  edtHost.Text := ConfigurationData.DBParams.Host;
  edtDBUser.Text := ConfigurationData.DBParams.Username;
  edtDBPass.Text := ConfigurationData.DBParams.Password;
  edtDBPort.Text := IntToStr(ConfigurationData.DBParams.Port);

end;

procedure TfrmAppSettings.LoadCertificateFile(Target: TEdit);
begin
  try
    Target.Text := LoadFile(CERTIFICATE_FILE_FILTER, RES_OPEN + ' ' + RES_CERTIFICATE);
  except on E: Exception do
    raise E at ExceptAddr;
  end;
end;

function TfrmAppSettings.LoadFile(const AllowedExtensions: String; const ATitle: String = ''):String;
var
  OpenDialog: TOpenDialog;
begin

  OpenDialog := TOpenDialog.Create(Self);
  OpenDialog.Title := ATitle;
  OpenDialog.InitialDir := ExtractFilePath(Application.ExeName);
  OpenDialog.Filter := AllowedExtensions;
  try
    if OpenDialog.Execute then
    begin
      if FileExists(OpenDialog.FileName) then
      begin
        Result := OpenDialog.FileName;
      end else
      begin
        raise Exception.Create(RES_EXCEPTION_FILE_DOESNT_EXIST);
      end;
    end;
  finally
    OpenDialog.Free;
  end;
end;

procedure TfrmAppSettings.LoadKeyFile(Target: TEdit);
begin
  try
    Target.Text := LoadFile(KEY_FILE_FILTER, RES_OPEN + ' ' + RES_KEY_FILE);
  except on E: Exception do
    raise E at ExceptAddr;
  end;
end;

procedure TfrmAppSettings.PopulateSeveritiesCheckBox;
begin
  for var I := 0 to Length(LOG_LEVELS)-1 do
  begin
    cbxMinimumLogLevel.Items.Add(LOG_LEVELS[I])
  end;

end;

procedure TfrmAppSettings.SetupLocalization;
begin
  lblGeneralPort.Caption := RES_LABEL_PORT;
  lblDBPort.Caption := RES_LABEL_PORT;
  cbSSL.Caption := RES_USE_SSL_LABEL;
  lblMinLogLevel.Caption := RES_MINLOGLEVEL_LABEL;
  lblDatabaseFile.Caption := RES_DATABASE;
  lblDBUser.Caption := RES_USERNAME;
  lblDBPassword.Caption := RES_PASSWORD;
  lblDBHost.Caption := RES_HOST;
  lblCertPath.Caption := RES_CERTIFICATE;
  lblRootCertPath.Caption := RES_ROOT_CERTIFICATE;
  lblKeyFilePath.Caption := RES_KEY_FILE;
  Self.Caption := RES_SETTINGS;
  btnSaveConfiguration.Caption := RES_SAVE;
  lbl_MAX_CONCURRENT_CON.Caption := RES_MAX_CONCURRENT_CONNECTIONS;
  cbStartRunning.Caption := RES_START_RUNNING;
  CONFIGMMOPTIONS1.Caption := RES_MAINMENU_TOOLS_BUTTON;
  VERIFYCONFIGPATH1.Caption := RES_VERIFY_CONFIG_PATH;
end;

procedure TfrmAppSettings.VERIFYCONFIGPATH1Click(Sender: TObject);
begin
  ShowMessage(CONFIG_FILE_PATH);
end;

end.
