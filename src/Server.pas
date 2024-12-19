unit Server;


interface

uses Vcl.StdCtrls, DateUtils, SysUtils, System.Classes, System.JSON, System.SyncObjs, System.IOUtils,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client,
  FireDAC.Phys.FB, FireDAC.Phys.FBDef, Vcl.Menus, Vcl.ComCtrls, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet,
  Horse, Horse.Jhonson, IdSSLOpenSSL, Configuration, Logging.Logger, NAPI.Utils;

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
    FResourcesRegistered: Boolean;
    FStartedDate: TDateTime;
    FMinimumLogLevel: Integer;
    FLogger: TLogger;
    procedure MercadoLibreNotify(AReq: THorseRequest; ARes: THorseResponse; ANext: TProc);
    procedure RegisterMercadoLibreNotification(ABody: TMLNotification);
    procedure NotificationServices(AReq: THorseRequest; ARes: THorseResponse; ANext: TProc);
    function ExtensionFileExistsOnFolder(AExt: String): Boolean;
  public
    constructor Create();
    destructor Destroy(); override;
    procedure RegisterResources;
    function WithPort(APort: Integer): TAPINotificationServerState;
    function WithLog(AViewer: TLoggingTarget; ALevel: Integer): TAPINotificationServerState;
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

constructor TAPINotificationServerState.Create();
begin
  FPort := DEFAULT_SERVER_PORT;
  FStartedDate := 0;
  FMinimumLogLevel := DEFAULT_MIN_LOG_LEVEL;
  FResourcesRegistered := False;
  THorse.Use(Jhonson());
  THorse.KeepConnectionAlive := False;
  FLogger := ApplicationLogger;
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
  WriteLog(TLogSeverities.RequestReceived, Format(RES_MERCADOLIVRE_RECEIVED_NOTIFICATION, ['MercadoLivre'])); {LOGGING}
  ARes.Status(200).Send('ok'); {EARLY RESPONSE TO GAIN TIME}
  try
    LBody := AReq.Body<TJSONObject>;

    WriteLog(TLogSeverities.Uninportant, LBody.ToString()); {LOGGING}

    {FUNCTION BODY}
    BodyAdapter := TMLNotification.FromJSONObject(LBody);
    TThread.CreateAnonymousThread(
      procedure
      begin
        try
          RegisterMercadoLibreNotification(BodyAdapter);
        except
          on E: Exception do
            WriteLog(TLogSeverities.Error, Format('Thread Error: %s', [E.Message]));
        end;
      end
    ).Start;
  except on E: Exception do
    WriteLog(TLogSeverities.Error, E.Message);
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
  WriteLog(TLogSeverities.RequestReceived, Format(RES_MERCADOLIVRE_RECEIVED_NOTIFICATION, ['TestEndpoint']));
end;

function TAPINotificationServerState.IsServerRunning: Boolean;
begin
  Result := THorse.IsRunning;
end;

procedure TAPINotificationServerState.RegisterMercadoLibreNotification(
  ABody: TMLNotification);
var
  Query: TFDQuery;
  Connection: TFDConnection;
  DateFormatSettings: TFormatSettings;
begin
  DateFormatSettings.DateSeparator := '-';
  DateFormatSettings.TimeSeparator := ':'; // Set the time separator
  DateFormatSettings.ShortDateFormat := 'YYYY-MM-DD';
  DateFormatSettings.LongTimeFormat := 'HH:NN:SS'; // Include time format
  Query := TFDQuery.Create(nil);
  Connection := UtilFactory.GetConnection();
  try
    Query.Connection := Connection;
    Connection.StartTransaction();
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
      Connection.Commit;
      if Query.RowsAffected <> 0 then
        WriteLog(TLogSeverities.Information, 'Notification ['+ABody.ID_API+'] Inserted')
      else
        WriteLog(TLogSeverities.Unknown, 'Notification ['+ABody.ID_API+'] >NOT< Inserted')
    except on E: Exception do
    begin
      Connection.Rollback;
      WriteLog(TLogSeverities.Error, Format(RES_ERROR_ON_DATA_INSERT, [E.Message]));
    end
    end;
  finally
    Query.Free;
    Connection.Free;
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
  WriteLog(TLogSeverities.Information, RES_SERVER_STOPPED);
end;

procedure TAPINotificationServerState.StartServer;
begin
  THorse.Listen(FPort);
  FStartedDate := Now();
  WriteLog(TLogSeverities.Information, Format(RES_SERVER_STARTED,[THorse.Host, THorse.Port.ToString]));
end;

function TAPINotificationServerState.WithLog(AViewer: TLoggingTarget;
  ALevel: Integer): TAPINotificationServerState;
begin
  Result := Self;
  FLogger.Target.RegisterTarget(AViewer.Target, AViewer.TargetType);
  FLogger.Active := True;

  if FLogger.Active then
    WriteLog(TLogSeverities.Unknown, 'Logger Registered on ServerState', False)
  else
    raise Exception.Create('Logger Failed To Register');
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
  FLogger.MinimumLevel := ALogLevel;
  Result := Self;
end;

function TAPINotificationServerState.WithPort(
  APort: Integer): TAPINotificationServerState;
begin
  FPort := APort;
  WriteLog(TLogSeverities.Information, Format(RES_SERVER_PORT_SET, [IntToStr(APort)]));
  Result := Self;
end;

function TAPINotificationServerState.TryWithSSL: TAPINotificationServerState;
begin
  Result := Self;
  if ExtensionFileExistsOnFolder(SCERTIFICATE_EXT) then
  begin
    WriteLog(TLogSeverities.Information, RES_CERTIFICATE_FILE_FOUND);
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
       WriteLog(TLogSeverities.Information, RES_CERTIFICATE_LOADED_ACTIVE);
      except on E: Exception do
        WriteLog(TLogSeverities.Information, Format(RES_CERTIFICATE_LOAD_FAILED,[E.Message]));
      end;
    end else begin
       WriteLog(TLogSeverities.Warning, RES_KEY_FILE_NOT_FOUND);
    end;
  end else begin
    WriteLog(TLogSeverities.Warning, RES_CERTIFICATE_FILE_NOT_FOUND);
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
  Result.SENT := IncHour(Result.SENT, -3);
  DateString := '';
  AObj.TryGetValue('received', DateString);
  Result.RECEIVED := ISO8601ToDate(DateString);
  Result.RECEIVED := IncHour(Result.RECEIVED, -3);
end;

end.
