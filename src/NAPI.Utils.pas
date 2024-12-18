unit NAPI.Utils;

interface

uses
  Winapi.Messages,
  System.UITypes,
  System.SysUtils,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Error,
  FireDAC.UI.Intf,
  FireDAC.Phys.Intf,
  FireDAC.Stan.Def,
  FireDAC.Stan.Pool,
  FireDAC.Stan.Async,
  FireDAC.Phys,
  FireDAC.VCLUI.Wait,
  Data.DB,
  FireDAC.Comp.Client,
  FireDAC.Phys.FB,
  FireDAC.Phys.FBDef,
  FireDAC.Stan.Param,
  FireDAC.DatS,
  FireDAC.DApt.Intf,
  FireDAC.DApt,
  FireDAC.Comp.DataSet,
  VCL.ComCtrls,
  Configuration;

type

  TColorPicker = record
    const
      appGray = TColor($afafaf);
      logUninportant = appGray;
      logDarkGray = TColor($333333);
      logRequestReceived = TColor($1e8c3a);
      logInformation = TColor($ff5a1e);
      logWarning = TColor($00c9db);
      logUnknown = TColor($007fff);
      logError = TColor($0000bf);
  end;

  UtilFactory = record  // In a future not that far I will need to change this for a connection pool.
    // The user is responsible for freeing this.
    class function GetConnection(): TFDConnection; static;
    class procedure EnsureFolderExists(AFullPath: String); static;
    class procedure CustomAddLineREdit(AEdit: TRichEdit; ALine: String); static;
  end;

implementation

uses
  Forms.Main, IOUtils;
{ UtilFactory }

{
This is a workaround that creates an empty selection on the end of the text (first and second line)
Then add the received text to this selection, effectively appending to the TRichEdit. My intention here
is to avoid exceptions from TRichEdit that seems to be freezing the server application.
}
class procedure UtilFactory.CustomAddLineREdit(AEdit: TRichEdit; ALine: String);
begin

  AEdit.SelStart := AEdit.GetTextLen;
  AEdit.SelLength := 0;
  AEdit.SelText := ALine + #13#10#13#10;

  // Scrolls to the bottom of the log
  AEdit.SetFocus;
  AEdit.SelStart := AEdit.GetTExtLen;
  AEdit.Perform(EM_SCROLLCARET, 0, 0);
  if frmMain.Enabled then
    //frmMain.SetFocus;

end;

class procedure UtilFactory.EnsureFolderExists(AFullPath: String);
begin
  if not TDirectory.Exists(AFullPath) then
  begin
    TDirectory.CreateDirectory(AFullPath)
  end;
end;

class function UtilFactory.GetConnection: TFDConnection;
begin
  Result := TFDConnection.Create(frmMain);
  ConfigurationData.LoadDBConfigIntoConnection(Result);
end;

end.
