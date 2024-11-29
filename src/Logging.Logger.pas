unit Logging.Logger;

interface

uses System.StrUtils, System.DateUtils, SysUtils, System.UITypes, Vcl.ComCtrls, Vcl.StdCtrls,
Localization.Resources, NAPI.Utils;

type
  TPossibleTarget = (ptUnknown, ptMemo, ptRich);

  TLoggingTarget = record
    Target: TCustomMemo;
    TargetType: TPossibleTarget;
    procedure RegisterTarget(ATarget: TCustomMemo; ATargetType: TPossibleTarget);
    procedure RegisterTargetAsMemo(ATarget: TMemo);
    procedure RegisterTargetAsRichEdit(ATarget: TRichEdit);
  end;

  TLogClass = (
    lclUninportant,
    lclRequestReceived,
    lclInformation,
    lclWarning,
    lclError,
    lclUnknown
  );

  TLogFlag = (
    lfDefault,
    lfRequestReceived,
    lfRequestError,
    lfDBError,
    lfApplicationError,
    lfThreadError,
    lfWarning,
    lfRequiresAttention
  );

  TLogSeverity = record
    Level: integer;
    LogClass: TLogClass;
    Color: TColor;
    Flags: array of TLogFlag;
  end;

  TLogSeverities = record
  private
    class function GetUninportant(): TLogSeverity; static;
    class function GetRequestReceived(): TLogSeverity; static;
    class function GetInformation(): TLogSeverity; static;
    class function GetWarning(): TLogSeverity; static;
    class function GetError(): TLogSeverity; static;
    class function GetUnknown: TLogSeverity; static;

  public
    class property Uninportant: TLogSeverity read GetUninportant;
    class property RequestReceived: TLogSeverity read GetRequestReceived;
    class property Information: TLogSeverity read GetInformation;
    class property Warning: TLogSeverity read GetWarning;
    class property Error: TLogSeverity read GetError;
    class property Unknown: TLogSeverity read GetUnknown;
  end;

  TLogger = class
  private
    FActive: Boolean;
    FTarget: TLoggingTarget;
    FMinimumLogLevel: Integer;
    procedure WriteLogToTarget(ASeverity: TLogSeverity; AText: String);
    procedure WriteLogToDisk(ASeverity: TLogSeverity; AText: String);
    procedure _WriteLog(ASeverity: TLogSeverity; AText: String; AWriteToDisk: Boolean = True);
    procedure SetActiveProp(T: Boolean);
    constructor Create();
  public
    property Active: Boolean read FActive write SetActiveProp;
    property Target: TLoggingTarget read FTarget;
    property MinimumLevel: Integer read FMinimumLogLevel write FMinimumLogLevel;
    procedure OutputProperties;
  end;

  const LOG_LEVELS: array of String = [
    'Uninportant (0)',
    'Request Received (1)',
    'Information (2)',
    'Warning (3)',
    'Error (4)',
    'Unknown (5)'
  ];

  const
    lsUNKNOWN = 100;
    lsUNINPORTANT = lsUNKNOWN + 1;
    lsREQUESTRECEIVED = lsUNINPORTANT + 1;
    lsINFORMATION = lsREQUESTRECEIVED + 1;
    lsWARNING = lsINFORMATION + 1;
    lsERROR = lsWARNING + 1;

    // Deprecated ls consts
    lsREQUESTBODY = 0; // Deprec
    lsQUERYBODY = 1;   // Deprec
    lsREQUEST = 2;     // Deprec
    //lsINFORMATION = 3; // Deprec
    //lsWARNING = 4;     // Deprec
    //lsERROR = 5;       // Deprec

  procedure WriteLog(ASeverity: TLogSeverity; AText: String; AWriteToDisk: Boolean = True);



  var
    ApplicationLogger: TLogger;

implementation

uses
  Configuration, Vcl.Dialogs;

{ Orphan Procedure }
procedure WriteLog(ASeverity: TLogSeverity; AText: String;
  AWriteToDisk: Boolean);
begin
  //if ASeverity.Level = lsERROR then ShowMessage(AText);
  if Assigned(ApplicationLogger) then
    ApplicationLogger._WriteLog(ASeverity, AText, AWriteToDisk);
end;

{ TLogSeverities }

class function TLogSeverities.GetError: TLogSeverity;
begin
  Result.Level := lsERROR;
  Result.LogClass := TLogClass.lclError;
  Result.Color := TColorPicker.logError;
  Result.Flags := nil;
end;

class function TLogSeverities.GetInformation: TLogSeverity;
begin
  Result.Level := lsINFORMATION;
  Result.LogClass := TLogClass.lclInformation;
  Result.Color := TColorPicker.logInformation;
  Result.Flags := nil;
end;

class function TLogSeverities.GetRequestReceived: TLogSeverity;
begin
  Result.Level := lsREQUESTRECEIVED;
  Result.LogClass := TLogClass.lclRequestReceived;
  Result.Color := TColorPicker.logRequestReceived;
  Result.Flags := nil;
end;

class function TLogSeverities.GetUninportant: TLogSeverity;
begin
  Result.Level := lsUNINPORTANT;
  Result.LogClass := TLogClass.lclUninportant;
  Result.Color := TColorPicker.logUninportant;
  Result.Flags := nil;
end;

class function TLogSeverities.GetUnknown: TLogSeverity;
begin
  Result.Level := lsUNKNOWN;
  Result.LogClass := TLogClass.lclWarning;
  Result.Color := TColorPicker.logWarning;
  Result.Flags := [lfRequiresAttention];
end;

class function TLogSeverities.GetWarning: TLogSeverity;
begin
  Result.Level := lsWARNING;
  Result.LogClass := TLogClass.lclWarning;
  Result.Color := TColorPicker.logWarning;
  Result.Flags := nil;
end;

{ TLogger }

constructor TLogger.Create;
begin
  FActive := False;
  FTarget.Target := nil;
  FTarget.TargetType := ptUnknown;
end;

procedure TLogger.OutputProperties;
begin
  if FTarget.Target <> nil then
  begin
    var Props := '''
    Logger Information:
      Active: %s
      Target Of Type: %s
      Minimum Log Level: %s
    ''';

    var TargetOfType: string;
    if FTarget.TargetType = ptMemo then
      TargetOfType := 'Memo'
    else if FTarget.TargetType = ptRich then
      TargetOfType := 'RichEdit'
    else
      TargetOfType := 'Unknown';

    _WriteLog(TLogSeverities.Unknown, Format(Props, [BoolToStr(FActive, True), TargetOfType, IntToStr(FMinimumLogLevel)]));
  end;
end;

procedure TLogger.SetActiveProp(T: Boolean);
begin
  if (T = True) and (FTarget.Target <> nil) then
    FActive := T
  else
    FActive := False;
end;

procedure TLogger._WriteLog(ASeverity: TLogSeverity; AText: String; AWriteToDisk: Boolean);
begin
  if (FActive) and (ASeverity.Level >= FMinimumLogLevel) then
  begin
    if AWriteToDisk then
      WriteLogToDisk(ASeverity, AText);

    WriteLogToTarget(ASeverity, AText);
  end;
end;

procedure TLogger.WriteLogToDisk(ASeverity: TLogSeverity; AText: String);
begin
  // Must synchronize to avoid file race conditions
end;

procedure TLogger.WriteLogToTarget(ASeverity: TLogSeverity; AText: String);
begin
  var DateNow: TDateTime := Now();

  if FTarget.TargetType = ptMemo then  // Writes on Memo
  begin
    var MemoTarget := TMemo(FTarget.Target);
    var SeverityString: String := '';
    if ASeverity.Level > lsREQUESTBODY then
    begin
      for var I := 1 to ASeverity.Level - 100 do
      begin
        SeverityString := SeverityString + '!';
      end;
    end else begin
      SeverityString := 'Body';
    end;
    MemoTarget.Lines.Add(Format(RES_LOG_STRING, [SeverityString, DateNow.ToString, AText])+sLineBreak);
  end

  else if FTarget.TargetType = ptRich then  // Writes on RichEdit
  begin
    var RichMemo := TRichEdit(FTarget.Target);
    RichMemo.SelAttributes.Color := ASeverity.Color;
    RichMemo.Lines.Add(AText+sLineBreak);
  end;
end;

{ TLoggingTarget }

procedure TLoggingTarget.RegisterTarget(ATarget: TCustomMemo;
  ATargetType: TPossibleTarget);
begin
  Target := ATarget;
  TargetType := ATargetType;
end;

procedure TLoggingTarget.RegisterTargetAsMemo(ATarget: TMemo);
begin
  RegisterTarget(ATarget, ptMemo);
end;

procedure TLoggingTarget.RegisterTargetAsRichEdit(ATarget: TRichEdit);
begin
  RegisterTarget(ATarget, ptRich);
end;

initialization

ApplicationLogger := TLogger.Create;

end.
