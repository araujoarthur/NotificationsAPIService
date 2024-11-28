unit Server;


interface

uses Vcl.StdCtrls, DateUtils, SysUtils, System.JSON, System.IOUtils,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client,
  FireDAC.Phys.FB, FireDAC.Phys.FBDef, Vcl.Menus, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet,
  Horse, Horse.Jhonson, IdSSLOpenSSL, Configuration;

resourcestring
  SCERTIFICATE_EXT = '.crt';
  SKEY_EXT = '.key';

type



  TMLNotification = record
    ID_API: String;
    RESOURCE: String;
    USER_ID: Integer;
    TOPIC: String;
    APPLICATION_ID: String;
    ATTEMPTS: Integer;
    SENT: TDateTime;
    RECEIVED: TDateTime;
    class function FromJSONObject(AObj: TJSONObject): TMLNotification; static;
  end;

  TAPINotificationServerState = class
  private
    FPort: Integer;
    FLoggingViewer: TMemo;
    FResourcesRegistered: Boolean;
    FStartedDate: TDateTime;
    FMinimumLogLevel: Integer;
    FConnection: TFDConnection;
    procedure WriteLog(ASeverity: Integer; AText: string);
    procedure MercadoLibreNotify(AReq: THorseRequest; ARes: THorseResponse; ANext: TProc);
    procedure RegisterMercadoLibreNotification(ABody: TMLNotification);
    procedure NotificationServices(AReq: THorseRequest; ARes: THorseResponse; ANext: TProc);
    function ExtensionFileExistsOnFolder(AExt: String): Boolean;
  public
    constructor Create(AConn: TFDConnection);
    destructor Destroy(); override;
    procedure RegisterResources;
    function WithPort(APort: Integer): TAPINotificationServerState;
    function WithLoggingViewer(AMemo: TMemo): TAPINotificationServerState;
    function WithMinimumLogLevel(ALogLevel: Integer): TAPINotificationServerState;
    function WithMaximumConnections(AConns: Integer): TAPINotificationServerState;
    function TryWithSSL(): TAPINotificationServerState;
    function DisableSSL(): TAPINotificationServerState;
    procedure StartServer();
    procedure StopServer();
    function IsServerRunning: Boolean;
    property StartedDate: TDateTime read FStartedDate;
  end;

  const
    QUOTE_MARK = '''';


implementation

uses Localization.Resources;
{ TAPINotificationServerState }

function TAPINotificationServerState.ExtensionFileExistsOnFolder(AExt: String): Boolean;
begin
  Result := False;
  var FolderFiles := TDirectory.GetFiles('.\');
  for var I := 0 to Length(FolderFiles) - 1 do
  begin
    if TPath.GetExtension(FolderFiles[i]) = AExt then
    begin
      Result := True;
      break;
    end;
  end;
end;

constructor TAPINotificationServerState.Create(AConn: TFDConnection);
begin
  FPort := DEFAULT_SERVER_PORT;
  FLoggingViewer := nil;
  FStartedDate := 0;
  FMinimumLogLevel := DEFAULT_MIN_LOG_LEVEL;
  FResourcesRegistered := False;
  FConnection := AConn;
  THorse.Use(Jhonson());
  THorse.KeepConnectionAlive := False;
end;

destructor TAPINotificationServerState.Destroy;
begin
  if IsServerRunning() then
    THorse.StopListen;

  inherited;
end;

function TAPINotificationServerState.DisableSSL: TAPINotificationServerState;
begin
  THorse.IOHandleSSL.Active(False);
  Result := Self;
end;

// TO-DO: FIX THE ERROR HAPPENING ON FDCONNECTION. MAYBE BY LOOPING UNTIL THE INSERTION IS SUCCESSFUL, MAYBE
// MAKING THE FDCONNECTION POOLED.
procedure TAPINotificationServerState.MercadoLibreNotify(
  AReq: THorseRequest; ARes: THorseResponse; ANext: TProc);
var
  BodyAdapter: TMLNotification;
  LBody: TJSONObject;
begin
  ARes.Status(200).Send('ok'); {EARLY RESPONSE TO GAIN TIME}
  WriteLog(lsREQUEST, Format(RES_MERCADOLIVRE_RECEIVED_NOTIFICATION, ['MercadoLivre'])); {LOGGING}
  try
    LBody := AReq.Body<TJSONObject>;

    WriteLog(lsREQUESTBODY, LBody.ToString()); {LOGGING}

    {FUNCTION BODY}
    BodyAdapter := TMLNotification.FromJSONObject(LBody);
    RegisterMercadoLibreNotification(BodyAdapter);
  except on E: Exception do
    WriteLog(lsERROR, E.Message);
  end;

end;

procedure TAPINotificationServerState.NotificationServices(AReq: THorseRequest;
  ARes: THorseResponse; ANext: TProc);
var
  RBody: TJSONObject;
begin
  RBody := TJSONObject.Create();
  RBody.AddPair('Received', True);
  ARes.Send<TJSONObject>(RBody);
  WriteLog(lsREQUEST, Format(RES_MERCADOLIVRE_RECEIVED_NOTIFICATION, ['TestEndpoint']));
end;

function TAPINotificationServerState.IsServerRunning: Boolean;
begin
  Result := THorse.IsRunning;
end;

procedure TAPINotificationServerState.RegisterMercadoLibreNotification(
  ABody: TMLNotification);
var
  Query: TFDQuery;
  DateFormatSettings: TFormatSettings;
begin
  DateFormatSettings.DateSeparator :='-';
  DateFormatSettings.ShortDateFormat := 'YYYY-MM-DD';
  Query := TFDQuery.Create(nil);
  Query.Connection := FConnection;
  FConnection.StartTransaction();
  try
      Query.SQL.Text := 'INSERT INTO ML_NOTIFICACOES(ID_API, RESOURCE, USER_ID, TOPIC, APPLICATION_ID, ATTEMPTS, SENT, RECEIVED)VALUES('
    + QUOTE_MARK + ABody.ID_API + QUOTE_MARK + ','
    + QUOTE_MARK + ABody.Resource + QUOTE_MARK + ','
    + IntToStr(ABody.USER_ID) + ','
    + QUOTE_MARK + ABody.TOPIC + QUOTE_MARK + ','
    + QUOTE_MARK + ABody.APPLICATION_ID + QUOTE_MARK + ','
    + IntToStr(ABody.ATTEMPTS) + ','
    + QUOTE_MARK + DateTimeToStr(ABody.SENT, DateFormatSettings) + QUOTE_MARK + ','
    + QUOTE_MARK + DateTimeToStr(ABody.RECEIVED, DateFormatSettings) + QUOTE_MARK
    +')';

    try
      Query.ExecSQL();
      FConnection.Commit;
      if Query.RowsAffected <> 0 then
        WriteLog(lsINFORMATION, 'Notification ['+ABody.ID_API+'] Inserted')
      else
        WriteLog(lsWARNING, 'Notification ['+ABody.ID_API+'] >NOT< Inserted')
    except on E: Exception do
    begin
      FConnection.Rollback;
      WriteLog(lsERROR, Format(RES_ERROR_ON_DATA_INSERT, [E.Message]));
    end;
    end
  finally
    Query.Free;
  end;

end;

procedure TAPINotificationServerState.RegisterResources;
begin
  THorse.Get('/', NotificationServices);
  THorse.Post('/ml', MercadoLibreNotify);
end;

procedure TAPINotificationServerState.StopServer;
begin
  THorse.StopListen();
  WriteLog(lsINFORMATION, RES_SERVER_STOPPED);
end;

procedure TAPINotificationServerState.StartServer;
begin
  THorse.Listen(FPort);
  FStartedDate := Now();
  WriteLog(lsINFORMATION, Format(RES_SERVER_STARTED,[THorse.Host, THorse.Port.ToString]));
end;

function TAPINotificationServerState.WithLoggingViewer(
  AMemo: TMemo): TAPINotificationServerState;
begin
  FLoggingViewer := AMemo;
  WriteLog(lsINFORMATION, RES_LOGGING_VIEWER_SET);
  Result := Self;
end;

function TAPINotificationServerState.WithMaximumConnections(
  AConns: Integer): TAPINotificationServerState;
begin
  Result := Self;
  THorse.MaxConnections := AConns;
end;

function TAPINotificationServerState.WithMinimumLogLevel(
  ALogLevel: Integer): TAPINotificationServerState;
begin
  FMinimumLogLevel := ALogLevel;
  Result := Self;
end;

function TAPINotificationServerState.WithPort(
  APort: Integer): TAPINotificationServerState;
begin
  FPort := APort;
  WriteLog(lsINFORMATION, Format(RES_SERVER_PORT_SET, [IntToStr(APort)]));
  Result := Self;
end;

function TAPINotificationServerState.TryWithSSL: TAPINotificationServerState;
begin
  Result := Self;
  if ExtensionFileExistsOnFolder(SCERTIFICATE_EXT) then
  begin
    WriteLog(lsINFORMATION, RES_CERTIFICATE_FILE_FOUND);
    const CertificateFile = ConfigurationData.SSLConfig.CertificatePath;
    if ExtensionFileExistsOnFolder(SKEY_EXT) then
    begin
      const KeyFile = ConfigurationData.SSLConfig.CertificateKey;
      // Here it's guaranted that the SSL files exist.
      try
        THorse.IOHandleSSL
        .RootCertFile(ConfigurationData.SSLConfig.RootCertificatePath)
        .CertFile(CertificateFile)
        .KeyFile(KeyFile)
        .SSLVersions([sslvSSLv2, sslvSSLv23, sslvSSLv3, sslvTLSv1, sslvTLSv1_1, sslvTLSv1_2])
        .Active(True);
        WriteLog(lsINFORMATION, RES_CERTIFICATE_LOADED_ACTIVE);
      except on E: Exception do
        WriteLog(lsINFORMATION, Format(RES_CERTIFICATE_LOAD_FAILED,[E.Message]));
      end;
    end else begin
       WriteLog(lsWARNING, RES_KEY_FILE_NOT_FOUND);
    end;
  end else begin
    WriteLog(lsWARNING, RES_CERTIFICATE_FILE_NOT_FOUND);
  end;
end;

{
  Severity Levels Check on Consts Header.
}
procedure TAPINotificationServerState.WriteLog(ASeverity: Integer;
  AText: string);
begin
  if Assigned(FLoggingViewer) and (ASeverity >= FMinimumLogLevel) then
  begin
    var DateNow: TDateTime := Now();
    var SeverityString: String := '';
    if ASeverity > lsREQUESTBODY then
    begin
      for var I := 1 to ASeverity do
      begin
        SeverityString := SeverityString + '!';
      end;
    end else begin
      SeverityString := 'Body';
    end;

    FLoggingViewer.Lines.Add(Format(RES_LOG_STRING, [SeverityString, DateNow.ToString(), AText]));
  end;
end;

{ TMLNotification }

class function TMLNotification.FromJSONObject(
  AObj: TJSONObject): TMLNotification;
var
  DateString: String;
begin
  AObj.TryGetValue('_id', Result.ID_API);
  AObj.TryGetValue('resource', Result.RESOURCE);
  AObj.TryGetValue('user_id', Result.USER_ID);
  AObj.TryGetValue('topic', Result.TOPIC);
  AObj.TryGetValue('application_id', Result.APPLICATION_ID);
  AObj.TryGetValue('attempts', Result.ATTEMPTS);
  AObj.TryGetValue('sent', DateString);
  Result.SENT := ISO8601ToDate(DateString);
  DateString := '';
  AObj.TryGetValue('received', DateString);
  Result.Received := ISO8601ToDate(DateString);
end;

end.
