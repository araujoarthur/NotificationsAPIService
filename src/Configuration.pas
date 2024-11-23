unit Configuration;

interface

uses System.IOUtils, System.IniFiles, FireDAC.Comp.Client, System.SysUtils;

type
  TNSDBConfig = record
    Database: String;
    Username: String;
    Host: String;
    Port: Integer;
    Password: String;
    procedure SetDatabase(ADatabase: String);
    procedure SetUsername(AUsername: String);
    procedure SetHost(AHost: String);
    procedure SetPort(APort: Integer);
    procedure SetPassword(APassword: String);
  end;

  TNSSSLConfig = record
    CertificatePath: String;
    RootCertificatePath: String;
    CertificateKey: String;
    procedure SetCertificatePath(APath: String);
    procedure SetRootCertificatePath(APath: String);
    procedure SetCertificateKey(APath: String);
  end;

  TNSConfiguration = class
  private
    FPort: Integer;
    FWithSSL: Boolean;
    FMinimumLogLevel: Integer;
    FDBConfig: TNSDBConfig;
    FSSLConfig: TNSSSLConfig;
  private
    function FileExistsOnFolder(AFileName: String): Boolean;
    procedure LoadFromFile(AFileName: String);
  public
    constructor Create();
    procedure Save();
    procedure LoadDBConfigIntoConnection(const AConn: TFDConnection);
    property Port: Integer read FPort write FPort;
    property SSL: Boolean read FWithSSL write FWithSSL;
    property SSLConfig: TNSSSLConfig read FSSLConfig write FSSLConfig;
    property DBParams: TNSDBConfig read FDBConfig write FDBConfig;
    property MinimumLogLevel: Integer read FMinimumLogLevel write FMinimumLogLevel;
  end;

const
  CONFIG_FILE_NAME = 'config.ini';
  CONFIG_FILE_PATH = '.\' + CONFIG_FILE_NAME;
  SSL_SECTION_NAME = 'SSL';
  DATABASE_SECTION_NAME = 'DATABASE';
  GENERAL_SECTION_NAME = 'GENERAL';

  DEFAULT_SERVER_PORT = 5000;
  DEFAULT_SSL_USAGE = False;

  DEFAULT_MIN_LOG_LEVEL = 0;
  DEFAULT_DB_USER = 'sysdba';
  DEFAULT_DB_PASS = 'masterkey';
  DEFAULT_DB_HOST = '127.0.0.1';
  DEFAULT_DB_PORT = -1;
  DEFAULT_DB_FILE = 'DB.FDB';

  DEFAULT_SSL_ROOTCERTNAME = '';
  DEFAULT_SSL_CERTNAME = '';
  DEFAULT_SSL_KEYNAME = '';

const
    lsREQUESTBODY = 0;
    lsQUERYBODY = 1;
    lsREQUEST = 2;
    lsINFORMATION = 3;
    lsWARNING = 4;
    lsERROR = 5;

    LOG_SEVERITIES : array [0..5] of string = (
    'REQUEST BODY (HTTP)',
    'QUERY BODY (SQL)',
    'ALERTA DE REQUISIÇÃO',
    'INFORMAÇÕES',
    'AVISOS',
    'ERROS'
    );

var
  ConfigurationData: TNSConfiguration;

implementation

uses VCL.Dialogs, Forms;
{ TNSConfiguration }

constructor TNSConfiguration.Create;
begin
  if FileExistsOnFolder(CONFIG_FILE_NAME) then
  begin
    LoadFromFile(CONFIG_FILE_PATH)
  end else
  begin
    var IniFile: TIniFile := TIniFile.Create(CONFIG_FILE_PATH);
    IniFile.WriteInteger(GENERAL_SECTION_NAME,'Port', DEFAULT_SERVER_PORT);
    IniFile.WriteBool(GENERAL_SECTION_NAME, 'SSL', DEFAULT_SSL_USAGE);

    IniFile.WriteInteger(GENERAL_SECTION_NAME, 'MinimumLogLevel', DEFAULT_MIN_LOG_LEVEL);
    IniFile.WriteString(DATABASE_SECTION_NAME, 'Username', DEFAULT_DB_USER);
    IniFile.WriteString(DATABASE_SECTION_NAME, 'Password', DEFAULT_DB_PASS);
    IniFile.WriteString(DATABASE_SECTION_NAME, 'Host', DEFAULT_DB_HOST);
    IniFile.WriteInteger(DATABASE_SECTION_NAME, 'Port', DEFAULT_DB_PORT);
    IniFile.WriteString(DATABASE_SECTION_NAME, 'Database', DEFAULT_DB_FILE);

    IniFile.WriteString(SSL_SECTION_NAME, 'RootCertificateFilePath', DEFAULT_SSL_ROOTCERTNAME);
    IniFile.WriteString(SSL_SECTION_NAME, 'CertificateFilePath', DEFAULT_SSL_CERTNAME);
    IniFile.WriteString(SSL_SECTION_NAME, 'KeyFilePath', DEFAULT_SSL_KEYNAME);

    IniFile.Free;

    ShowMessage('Settings File Created. Restart the Application');
    Application.Terminate;
  end;
end;

function TNSConfiguration.FileExistsOnFolder(AFileName: String): Boolean;
begin
  Result := False;
  var FolderFiles := TDirectory.GetFiles('.\');
  for var I := 0 to Length(FolderFiles) - 1 do
  begin
    if TPath.GetFileName(FolderFiles[I]) = AFileName then
    begin
      Result := True;
      break;
    end;
  end;
end;

procedure TNSConfiguration.LoadDBConfigIntoConnection(const AConn: TFDConnection);
begin
  AConn.Params.Clear;
  AConn.DriverName := 'FB';
  AConn.Params.Database := FDBConfig.Database;
  AConn.Params.Username := FDBConfig.Username;
  AConn.Params.Password := FDBConfig.Password;
  AConn.Params.Add('Protocol=TCPIP');
  AConn.Params.Add(Format('Server=%s', [FDBConfig.Host]));
  if FDBConfig.Port > 0 then
  begin
    AConn.Params.Add(Format('Port=%s', [FDBConfig.Port]));
  end;
end;

procedure TNSConfiguration.LoadFromFile(AFileName: String);
begin
  var IniFile: TIniFile := TIniFile.Create(CONFIG_FILE_PATH);
  FPort := IniFile.ReadInteger(GENERAL_SECTION_NAME,'Port', DEFAULT_SERVER_PORT);
  FWithSSL := IniFile.ReadBool(GENERAL_SECTION_NAME, 'SSL', DEFAULT_SSL_USAGE);
  FMinimumLogLevel := IniFile.ReadInteger(GENERAL_SECTION_NAME, 'MinimumLogLevel', DEFAULT_MIN_LOG_LEVEL);

  FDBConfig.Username := IniFile.ReadString(DATABASE_SECTION_NAME, 'Username',  '');
  FDBConfig.Password := IniFile.ReadString(DATABASE_SECTION_NAME, 'Password', DEFAULT_DB_PASS);
  FDBConfig.Host := IniFile.ReadString(DATABASE_SECTION_NAME, 'Host', DEFAULT_DB_HOST);
  FDBConfig.Port := IniFile.ReadInteger(DATABASE_SECTION_NAME, 'Port', DEFAULT_DB_PORT);
  FDBConfig.Database := IniFile.ReadString(DATABASE_SECTION_NAME, 'Database', DEFAULT_DB_FILE);

  FSSLConfig.RootCertificatePath := IniFile.ReadString(SSL_SECTION_NAME, 'RootCertificateFilePath', '');
  FSSLConfig.CertificatePath := IniFile.ReadString(SSL_SECTION_NAME, 'CertificateFilePath', '');
  FSSLConfig.CertificateKey := IniFile.ReadString(SSL_SECTION_NAME, 'KeyFilePath', '');

  IniFile.Free;
end;

procedure TNSConfiguration.Save;
begin
  var IniFile: TIniFile := TIniFile.Create(CONFIG_FILE_PATH);
  IniFile.WriteInteger(GENERAL_SECTION_NAME,'Port', FPort);
  IniFile.WriteBool(GENERAL_SECTION_NAME, 'SSL', FWithSSL);
  IniFile.WriteInteger(GENERAL_SECTION_NAME, 'MinimumLogLevel', FMinimumLogLevel);

  IniFile.WriteString(DATABASE_SECTION_NAME, 'Username', FDBConfig.Username);
  IniFile.WriteString(DATABASE_SECTION_NAME, 'Password', FDBConfig.Password);
  IniFile.WriteString(DATABASE_SECTION_NAME, 'Host', FDBConfig.Host);
  IniFile.WriteInteger(DATABASE_SECTION_NAME, 'Port', FDBConfig.Port);
  IniFile.WriteString(DATABASE_SECTION_NAME, 'Database', FDBConfig.Database);

  IniFile.WriteString(SSL_SECTION_NAME, 'RootCertificateFilePath', FSSLConfig.RootCertificatePath);
  IniFile.WriteString(SSL_SECTION_NAME, 'CertificateFilePath', FSSLConfig.CertificatePath);
  IniFile.WriteString(SSL_SECTION_NAME, 'KeyFilePath', FSSLConfig.CertificateKey);

  IniFile.Free;

  ShowMessage('Settings Saved. Restart to Take Effect');
end;

{ TNSDBConfig }

procedure TNSDBConfig.SetDatabase(ADatabase: String);
begin
  Database := ADatabase;
end;

procedure TNSDBConfig.SetHost(AHost: String);
begin
  Host := AHost;
end;

procedure TNSDBConfig.SetPassword(APassword: String);
begin
  Password := APassword;
end;

procedure TNSDBConfig.SetPort(APort: Integer);
begin
  Port := APort;
end;

procedure TNSDBConfig.SetUsername(AUsername: String);
begin
  Username := AUsername;
end;

{ TNSSSLConfig }

procedure TNSSSLConfig.SetCertificateKey(APath: String);
begin
  CertificateKey := APath;
end;

procedure TNSSSLConfig.SetCertificatePath(APath: String);
begin
  CertificatePath := APath;
end;

procedure TNSSSLConfig.SetRootCertificatePath(APath: String);
begin
  RootCertificatePath := APath;
end;

end.
