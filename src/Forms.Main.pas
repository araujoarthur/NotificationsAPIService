unit Forms.Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.IOUtils, System.Variants, System.Classes, Vcl.Graphics,
  System.DateUtils,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Server,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client,
  FireDAC.Phys.FB, FireDAC.Phys.FBDef, Vcl.Menus, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet,
  Vcl.AppEvnts, Vcl.ComCtrls, Configuration;

type
  TTickThread = class;

  TfrmMain = class(TForm)
    btnStartServer: TButton;
    memoLog: TMemo;
    Panel1: TPanel;
    btnStopServer: TButton;
    lblUptime: TLabel;
    conn: TFDConnection;
    MainMenu1: TMainMenu;
    ools1: TMenuItem;
    DatabaseFiretest1: TMenuItem;
    TrayIcon1: TTrayIcon;
    SSLStartTest1: TMenuItem;
    Settings1: TMenuItem;
    ests1: TMenuItem;
    RefreshSettings1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure btnStartServerClick(Sender: TObject);
    procedure btnStopServerClick(Sender: TObject);
    procedure DatabaseFiretest1Click(Sender: TObject);
    procedure ApplicationEventsMinimize(Sender: TObject);
    procedure TrayIconDoubleClick(Sender: TObject);

    procedure SSLStartTest1Click(Sender: TObject);
    procedure Settings1Click(Sender: TObject);
    procedure RefreshSettings1Click(Sender: TObject);
  private
    FServerState: TAPINotificationServerState;
    FTickThread: TTickThread;
    FTrayIcon: TTrayIcon;
    FApplicationEvents: TApplicationEvents;
    procedure SetupTrayIcon;
    procedure SetupLocalization();
  public
    { Public declarations }
    procedure UpdateTickerTime(ANewTime: TDateTime);
    procedure UpdateBalloonTime(ANewTime: TDateTime);
  end;

  TTickThread = class(TThread)
  private
    FForm: TfrmMain;
    FServerState: TAPINotificationServerState;
    procedure Tick;
  protected
    procedure Execute; override;
  public
    constructor Create(AForm: TfrmMain; AServer: TAPINotificationServerState);
  end;

var
  frmMain: TfrmMain;

implementation

uses Forms.ApplicationSettings, Localization.Resources;
{$R *.dfm}

procedure TfrmMain.ApplicationEventsMinimize(Sender: TObject);
begin
  Hide();
  WindowState := wsMinimized;

  FTrayIcon.Visible := True;
  FTrayIcon.Animate := False;
  FTrayIcon.ShowBalloonHint;
end;

procedure TfrmMain.btnStartServerClick(Sender: TObject);
begin
  try
    FTickThread := TTickThread.Create(Self, FServerState);
    conn.Connected := True;
    FServerState.StartServer;
    FTickThread.Start;
    if FServerState.IsServerRunning() then
    begin
      btnStartServer.Enabled := False;
      btnStopServer.Enabled := True;
    end;
  except on E: Exception do
    memoLog.Lines.Add(Format(RES_LOG_STRING, [RES_APPLICATION_LOG, Now().ToString(), Format(RES_STARTUP_ERROR, [E.Message])]));
  end;
  

end;

procedure TfrmMain.btnStopServerClick(Sender: TObject);
begin
  FServerState.StopServer;
  try
    FTickThread.Terminate;
    FTickThread := nil;
  except on E: Exception do
    memoLog.Lines.Add(Format(RES_LOG_STRING, [RES_APPLICATION_LOG, Now().ToString(), Format(RES_THREAD_ERROR, [E.Message])]));
  end;
  
  if not FServerState.IsServerRunning() then
  begin
    conn.Connected := False;
    btnStartServer.Enabled := True;
    btnStopServer.Enabled := False;
  end;
end;

procedure TfrmMain.DatabaseFiretest1Click(Sender: TObject);
begin
  try
    conn.Connected := True;
    if conn.Connected then
    begin
      conn.Connected := False;
      memoLog.Lines.Add(Format(RES_LOG_STRING, [RES_APPLICATION_LOG, Now().ToString(), RES_DATABASE_FIRETEST_SUCCESSFUL]));
    end;

  except on E: Exception do
    memoLog.Lines.Add(Format(RES_LOG_STRING, [RES_APPLICATION_LOG, Now().ToString(), Format(RES_DATABASE_ERROR, [E.Message])]));
  end;


end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  SetupLocalization();
  ConfigurationData := TNSConfiguration.Create();
  ConfigurationData.LoadDBConfigIntoConnection(conn);
  SetupTrayIcon;
  FServerState := TAPINotificationServerState.Create(conn);
  FServerState.RegisterResources();
  FServerState.WithLoggingViewer(memoLog);
  FServerState.WithMinimumLogLevel(ConfigurationData.MinimumLogLevel);
  FServerState.WithPort(ConfigurationData.Port);

  if ConfigurationData.SSL then
    FServerState.TryWithSSL();
end;

procedure TfrmMain.RefreshSettings1Click(Sender: TObject);
begin
  if FServerState.IsServerRunning then
    raise Exception.Create(RES_EXCEPTION_REFRESH_SETTINGS_WITH_ACTIVE_SERVER);

  FServerState.WithPort(ConfigurationData.Port)
              .WithMinimumLogLevel(ConfigurationData.MinimumLogLevel);
  if ConfigurationData.SSL then
  begin
    FServerState.TryWithSSL;
  end else
  begin
    FServerState.DisableSSL;
  end;

  ConfigurationData.LoadDBConfigIntoConnection(conn);

end;

procedure TfrmMain.Settings1Click(Sender: TObject);
begin
  frmAppSettings := TfrmAppSettings.Create(self);
  try
    frmAppSettings.ShowModal();
  finally
    frmAppSettings.Free;
  end;
end;

procedure TfrmMain.SetupLocalization;
begin
  btnStartServer.Caption := RES_START_SERVER_BUTTON;
  btnStopServer.Caption := RES_STOP_SERVER_BUTTON;
  self.Caption := RES_MAINFORM_CAPTION;
  ools1.Caption := RES_MAINMENU_TOOLS_BUTTON;
  Settings1.Caption := RES_MAINMENU_SETTINGS_BUTTON;
  RefreshSettings1.Caption := RES_MAINMENU_REFRESHSETTINGS_BUTTON;
  ests1.Caption := RES_MAINMENU_TESTS_BUTTON;
  DatabaseFiretest1.Caption := RES_MAINMENU_DATABASEFIRETEST_BUTTON;
  SSLStartTest1.Caption := RES_MAINMENU_SSLSTARTTEST_BUTTON;
end;

procedure TfrmMain.SetupTrayIcon;
begin
  FTrayIcon := TTrayIcon.Create(Application);
  FTrayIcon.OnDblClick := TrayIconDoubleClick;
  FTrayIcon.Icons := TImageList.Create(FTrayIcon);
  var TrayIcon: TIcon := TIcon.Create;
  TrayIcon.LoadFromResourceName(HInstance, 'ICON44');
  FTrayIcon.Icons.AddIcon(TrayIcon);
  

  FtrayIcon.Hint := RES_TRAY_HINT;
  FTrayIcon.AnimateInterval := 200;
  
  FTrayIcon.BalloonHint := RES_TRAY_BALLON_HINT_HIDDEN;
  FTrayIcon.BalloonTitle := RES_TRAY_BALLON_TITLE;
  FTrayIcon.BalloonFlags := bfInfo;
  FTrayIcon.BalloonTimeout := 5000;
  
  {Application Events Setting Up}
  FApplicationEvents := TApplicationEvents.Create(Application);
  FApplicationEvents.OnMinimize := ApplicationEventsMinimize;
end;

procedure TfrmMain.SSLStartTest1Click(Sender: TObject);
begin
  if ConfigurationData.SSL then
    FServerState.TryWithSSL()
  else
    raise Exception.Create(RES_EXCEPTION_SSL_DISABLED);
end;

procedure TfrmMain.TrayIconDoubleClick(Sender: TObject);
begin
  FTrayIcon.Visible := False;
  Show();
  WindowState := wsNormal;
  Application.BringToFront();
end;

procedure TfrmMain.UpdateBalloonTime(ANewTime: TDateTime);
begin
  FTrayIcon.BalloonHint := 'Uptime: ' + FormatDateTime('hh:nn:ss', ANewTime);
end;

procedure TfrmMain.UpdateTickerTime(ANewTime: TDateTime);
begin
  lblUptime.Caption := FormatDateTime('hh:nn:ss', ANewTime);
end;

{ TTickThread }

constructor TTickThread.Create(AForm: TfrmMain; AServer: TAPINotificationServerState);
begin
  inherited Create(True);
  FForm := AForm;
  FServerState := AServer;
  FreeOnTerminate := True;
end;

procedure TTickThread.Execute;
begin
  while not Terminated do
  begin
    TThread.Synchronize(nil, Tick);
    Sleep(1000);
  end;
end;

procedure TTickThread.Tick;
begin
  var Elapsed: TDateTime := Now() - FServerState.StartedDate;
  FForm.UpdateTickerTime(Elapsed);
end;

end.
