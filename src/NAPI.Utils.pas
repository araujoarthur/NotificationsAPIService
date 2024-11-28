unit NAPI.Utils;

interface

uses
  System.UITypes,
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

  UtilFactory = record
    // The user is responsible for freeing this.
    class function GetConnection(): TFDConnection; static;
  end;

implementation

end.
