{$REGION 'documentation'}
{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
{
  Application information detail
  @created(08/04/2016)
  @author Vencejo Software <www.vencejosoft.com>
}
{$ENDREGION}
unit ooAppInfo;

interface

uses
  Classes, SysUtils,
  ooAppInfo.Parameter, ooAppInfo.Parameter.Parser,
  ooAppInfo.Version;

type
{$REGION 'documentation'}
{
  @abstract(Application information)
  Get all information detail from bianry file, includen execution parameters
  @member(Description Application description)
  @member(Command Executed command to run the application)
  @member(Path Folder path of application)
  @member(FileName Binary file name of application)
  @member(ParameterCount Number of parameters in command execution)
  @member(
    Parameter Get parameter item in list
    @param(Index The item index in list)
    @returns(@link(IAppParameter) object)
  )
  @member(InvalidParameters Check if any parameter is invalid)
  @member(
    Usage Command text description for an execution usage example.@br
    Some like:
    @longcode(
      DESCRIPTION:
        Application to test (v0.0.0.0)
      COMMAND:
        demo.exe
      PARAMETERS:
        NAME            REQUIRED  DESCRIPTION
        -a               False    The A parameter description.
        -b               False    The B parameter.
        -c               False    C cc.
        -onlytext        False    without value.
        -req             True     Required.
      EXAMPLE:
        demo.exe [-a:test] [-b:1234] [-c:nones] [-onlytext] -req 123
    )
  )
  @member(Version Application version object)
}
{$ENDREGION}
  IAppInfo = interface
    ['{22117E2D-C730-4610-BF12-E6B95C5B83FC}']
    function Description: String;
    function Command: String;
    function Path: String;
    function FileName: String;
    function ParameterCount: Integer;
    function Parameter(const Index: Integer): IAppParameter;
    function InvalidParameters: Boolean;
    function Usage: String;
    function Version: IAppVersion;
  end;
{$REGION 'documentation'}
{
  @abstract(Implementation of @link(IAppInfo))
  @member(Description @seealso(IAppInfo.Description))
  @member(Command @seealso(IAppInfo.Command))
  @member(Path @seealso(IAppInfo.Path))
  @member(FileName @seealso(IAppInfo.FileName))
  @member(ParameterCount @seealso(IAppInfo.ParameterCount))
  @member(Parameter @seealso(IAppInfo.Parameter))
  @member(InvalidParameters @seealso(IAppInfo.InvalidParameters))
  @member(Usage @seealso(IAppInfo.Usage))
  @member(Version @seealso(IAppInfo.Version))
  @member(
    Create Object constructor
    @param(Description Optional application description)
    @param(Parameters Array of execution command parameters)
  )
  @member(Destroy Object destructor to free parameter list)
  @member(
    New Create a new @classname as interface
    @param(Description Optional application description)
    @param(Parameters Array of execution command parameters)
  )
}
{$ENDREGION}

  TAppInfo = class(TInterfacedObject, IAppInfo)
  strict private
    _Description: String;
    _ParamList: TAppParamList;
    _AppVersion: IAppVersion;
  private
    procedure BuildParameters;
    function ParameterUsage: String;
    function ExampleUsage: String;
  public
    function Command: String;
    function Description: String;
    function Path: String;
    function FileName: String;
    function ParameterCount: Integer;
    function Parameter(const Index: Integer): IAppParameter;
    function InvalidParameters: Boolean;
    function Usage: String;
    function Version: IAppVersion;

    constructor Create(const Description: String; const Parameters: array of IAppParameter);
    destructor Destroy; override;

    class function New(const Description: String; const Parameters: array of IAppParameter): IAppInfo;
  end;
{$REGION 'documentation'}
{
  Create a new @link(IAppInfo) calling a simple function
  @param(Description Optional application description)
  @return(A new @link(IAppInfo) object)
}
{$ENDREGION}

function AppInfo(const Description: String = ''): IAppInfo;
{$REGION 'documentation'}
{
  Create a new @link(IAppInfo) calling a simple function with extended parameters
  @param(Description Optional application description)
  @param(Parameters Array of execution command parameters)
  @return(A new @link(IAppInfo) object)
}
{$ENDREGION}
function AppInfoDefined(const Description: String; const Parameters: array of IAppParameter): IAppInfo;

implementation

function TAppInfo.Description: String;
begin
  Result := _Description;
end;

function TAppInfo.FileName: String;
begin
  Result := ExtractFileName(ParamStr(0));
end;

function TAppInfo.Path: String;
begin
  Result := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)));
end;

function TAppInfo.Version: IAppVersion;
begin
  if not Assigned(_AppVersion) then
    _AppVersion := TAppVersion.New;
  Result := _AppVersion;
end;

function TAppInfo.Parameter(const Index: Integer): IAppParameter;
begin
  Result := _ParamList.Items[Index];
end;

function TAppInfo.ParameterCount: Integer;
begin
  Result := _ParamList.Count
end;

function TAppInfo.Command: String;
begin
{$WARN SYMBOL_PLATFORM OFF}
{$IFDEF MSWINDOWS}
  Result := CmdLine;
{$ELSE}
  Result := EmptyStr;
{$ENDIF MSWINDOWS}
{$WARN SYMBOL_PLATFORM ON}
end;

function TAppInfo.ParameterUsage: String;
var
  AppParameter: IAppParameter;
begin
  Result := EmptyStr;
  for AppParameter in _ParamList do
    if Length(AppParameter.Usage) > 0 then
      Result := Result + Format('  -%-15s %-8s %s.', [AppParameter.Name, BoolToStr(AppParameter.Required, True),
        AppParameter.Description]) + sLineBreak;
  Result := Trim(Result);
end;

function TAppInfo.ExampleUsage: String;
var
  AppParameter: IAppParameter;
begin
  Result := FileName;
  for AppParameter in _ParamList do
    if Length(AppParameter.Usage) > 0 then
    begin
      if AppParameter.Required then
        Result := Result + ' ' + AppParameter.Usage
      else
        Result := Result + ' [' + AppParameter.Usage + ']';
    end;
end;

function TAppInfo.Usage: String;
const
  rsUsage = //
    'DESCRIPTION: ' + sLineBreak + //
    '  %s (v%s)' + sLineBreak + //
    'COMMAND:' + sLineBreak + //
    '  %s' + sLineBreak + //
    'PARAMETERS:' + sLineBreak + //
    '  NAME            REQUIRED  DESCRIPTION' + sLineBreak + //
    '  %s' + sLineBreak + //
    'EXAMPLE:' + sLineBreak + //
    '  %s';
begin
  Result := Format(rsUsage, [Description, Version.AsString, FileName, ParameterUsage, ExampleUsage]);
end;

function TAppInfo.InvalidParameters: Boolean;
var
  AppParameter: IAppParameter;
begin
  Result := False;
  for AppParameter in _ParamList do
  begin
    Result := AppParameter.Required and (Length(AppParameter.Value) = 0);
    if Result then
      Break;
  end;
end;

procedure TAppInfo.BuildParameters;
var
  i: Integer;
begin
  for i := 1 to ParamCount do
    _ParamList.Add(TAppParameterParser.New(ParamStr(i)).Parse);
end;

constructor TAppInfo.Create(const Description: String; const Parameters: array of IAppParameter);
var
  AppParameter: IAppParameter;
begin
  _Description := Description;
  _ParamList := TAppParamList.Create;
  for AppParameter in Parameters do
    _ParamList.Add(AppParameter);
  BuildParameters;
end;

destructor TAppInfo.Destroy;
begin
  _ParamList.Free;
  inherited;
end;

class function TAppInfo.New(const Description: String; const Parameters: array of IAppParameter): IAppInfo;
begin
  Result := TAppInfo.Create(Description, Parameters);
end;

function AppInfo(const Description: String = ''): IAppInfo;
begin
  Result := TAppInfo.New(Description, []);
end;

function AppInfoDefined(const Description: String; const Parameters: array of IAppParameter): IAppInfo;
begin
  Result := TAppInfo.New(Description, Parameters);
end;

end.
