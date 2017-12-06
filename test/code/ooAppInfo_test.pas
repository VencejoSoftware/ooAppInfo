{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit ooAppInfo_test;

interface

uses
  SysUtils,
  ooAppInfo, ooAppInfo.Parameter,
{$IFDEF FPC}
  fpcunit, testregistry
{$ELSE}
  TestFramework
{$ENDIF};

type
  TAppParameterArray = array of IAppParameter;

  TAppInfoTest = class(TTestCase)
  private
    function NewParameters: TAppParameterArray;
  published
    procedure DescriptionIsTestApp;
    procedure CommandIsTestAppParams;
    procedure PathIsAppPath;
    procedure FileNameOfThisTest;
    procedure ParameterCountEqual5;
    procedure ParameterOneIsTest;
    procedure IsInvalidParameterFour;
    procedure UsageText;
    procedure VersionIs1234;
  end;

implementation

function TAppInfoTest.NewParameters: TAppParameterArray;
begin
  SetLength(Result, 5);
  Result[0] := TAppParameter.New('a', 'The A parameter description', '-a:test');
  Result[1] := TAppParameter.New('b', 'The B parameter', '-b:1234');
  Result[2] := TAppParameter.New('c', 'C cc', '-c:nones');
  Result[3] := TAppParameter.New('onlytext', 'without value', '-onlytext');
  Result[4] := TAppParameter.New('req', 'Required', '-req 123', True);
end;

procedure TAppInfoTest.CommandIsTestAppParams;
begin
{$WARN SYMBOL_PLATFORM OFF}
{$IFDEF MSWINDOWS}
  CheckEquals(CmdLine, AppInfoDefined('Application to test', NewParameters).Command);
{$ENDIF MSWINDOWS}
{$WARN SYMBOL_PLATFORM ON}
end;

procedure TAppInfoTest.IsInvalidParameterFour;
var
  AppInfo: IAppInfo;
begin
  AppInfo := AppInfoDefined('Application to test', NewParameters);
  CheckTrue(AppInfo.InvalidParameters);
  AppInfo.Parameter(4).UpdateValue('aaaa');
  CheckFalse(AppInfo.InvalidParameters);
end;

procedure TAppInfoTest.ParameterCountEqual5;
begin
  CheckEquals(5, AppInfoDefined('Application to test', NewParameters).ParameterCount);
end;

procedure TAppInfoTest.ParameterOneIsTest;
var
  AppInfo: IAppInfo;
begin
  AppInfo := AppInfoDefined('Application to test', NewParameters);
  AppInfo.Parameter(0).UpdateValue('test');
  CheckEquals('test', AppInfo.Parameter(0).Value);
end;

procedure TAppInfoTest.UsageText;
begin
  CheckEquals(360, Pos('test.exe [-a:test] [-b:1234] [-c:nones] [-onlytext] -req 123',
      AppInfoDefined('Application to test', NewParameters).Usage));
end;

procedure TAppInfoTest.PathIsAppPath;
begin
  CheckEquals(ExtractFilePath(ParamStr(0)), TAppInfo.New(EmptyStr, []).Path);
end;

procedure TAppInfoTest.DescriptionIsTestApp;
begin
  CheckEquals('Something in description', TAppInfo.New('Something in description', []).Description);
end;

procedure TAppInfoTest.FileNameOfThisTest;
begin
  CheckEquals(ExtractFileName(ParamStr(0)), TAppInfo.New(EmptyStr, []).FileName);
end;

procedure TAppInfoTest.VersionIs1234;
begin
  CheckEquals('1.2.3.4', TAppInfo.New(EmptyStr, []).Version.AsString);
end;

initialization

RegisterTest(TAppInfoTest {$IFNDEF FPC}.Suite {$ENDIF});

end.
