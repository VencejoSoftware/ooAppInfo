program DemoConsole;
{$APPTYPE CONSOLE}

uses
  Windows,
  SysUtils,
  ooAppInfo.Parameter,
  ooAppInfo;

begin
{$WARN SYMBOL_PLATFORM OFF}
  ReportMemoryLeaksOnShutdown := (DebugHook <> 0);
{$WARN SYMBOL_PLATFORM ON}
  try
    with AppInfoDefined('Application to test', [TAppParameter.New('config', 'Config file path', '-config:"file path"',
        True)]) do
    begin
      if InvalidParameters then
        Writeln(Usage)
      else
        Writeln(Parameter(0).Value);
    end;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;

end.
