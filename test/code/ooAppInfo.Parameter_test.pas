{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit ooAppInfo.Parameter_test;

interface

uses
  SysUtils,
  ooAppInfo.Parameter,
  ooAppInfo.Parameter.Mock,
{$IFDEF FPC}
  fpcunit, testregistry
{$ELSE}
  TestFramework
{$ENDIF};

type
  TAppParameterTest = class(TTestCase)
  published
    procedure NameIsTestParam;
    procedure DescriptionIsParameterForTest;
    procedure UsageIsTestOne;
    procedure RequiredIsTrue;
    procedure UpdatedValueToTwo;
  end;

implementation

procedure TAppParameterTest.DescriptionIsParameterForTest;
begin
  CheckEquals('Parameter for test', MockParameter.Description);
end;

procedure TAppParameterTest.NameIsTestParam;
begin
  CheckEquals('TestParam', MockParameter.Name);
end;

procedure TAppParameterTest.RequiredIsTrue;
begin
  CheckTrue(MockParameter.Required);
end;

procedure TAppParameterTest.UpdatedValueToTwo;
var
  AppParameter: IAppParameter;
begin
  AppParameter := MockParameter;
  CheckEquals(EmptyStr, AppParameter.Value);
  AppParameter.UpdateValue('TWO');
  CheckEquals('TWO', AppParameter.Value);
end;

procedure TAppParameterTest.UsageIsTestOne;
begin
  CheckEquals('-TestParam:2', MockParameter.Usage);
end;

initialization

RegisterTest(TAppParameterTest {$IFNDEF FPC}.Suite {$ENDIF});

end.
