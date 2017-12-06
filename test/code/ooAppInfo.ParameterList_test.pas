{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit ooAppInfo.ParameterList_test;

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
  TAppParameterListTest = class(TTestCase)
  published
    procedure IndexOfName4;
    procedure ExistsName9;
    procedure AddIndex3;
    procedure AddIndexRepeat;
  end;

implementation

procedure TAppParameterListTest.AddIndex3;
var
  AppParamList: TAppParamList;
begin
  AppParamList := TAppParamList.Create;
  try
    AppParamList.Add(TAppParameter.New('TestParam1', 'Parameter for test', '-TestParam:2', True));
    AppParamList.Add(TAppParameter.New('TestParam2', 'Parameter for test', '-TestParam:2', True));
    CheckEquals(2, AppParamList.Add(TAppParameter.New('TestParam3', 'Parameter for test', '-TestParam:2', True)));
  finally
    AppParamList.Free;
  end;
end;

procedure TAppParameterListTest.AddIndexRepeat;
var
  AppParamList: TAppParamList;
begin
  AppParamList := TAppParamList.Create;
  try
    AppParamList.Add(MockParameter);
    AppParamList.Add(MockParameter);
    CheckEquals(0, AppParamList.Add(MockParameter));
  finally
    AppParamList.Free;
  end;
end;

procedure TAppParameterListTest.ExistsName9;
var
  AppParamList: TAppParamList;
begin
  AppParamList := TAppParamList.Create;
  try
    FillList(AppParamList);
    CheckTrue(AppParamList.Exists('TestParam9'));
  finally
    AppParamList.Free;
  end;
end;

procedure TAppParameterListTest.IndexOfName4;
var
  AppParamList: TAppParamList;
begin
  AppParamList := TAppParamList.Create;
  try
    FillList(AppParamList);
    CheckEquals(4, AppParamList.IndexOf('TestParam4'));
  finally
    AppParamList.Free;
  end;
end;

initialization

RegisterTest(TAppParameterListTest {$IFNDEF FPC}.Suite {$ENDIF});

end.
