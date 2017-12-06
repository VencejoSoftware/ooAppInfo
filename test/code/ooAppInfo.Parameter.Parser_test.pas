{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit ooAppInfo.Parameter.Parser_test;

interface

uses
  SysUtils,
  ooAppInfo.Parameter.Parser,
{$IFDEF FPC}
  fpcunit, testregistry
{$ELSE}
  TestFramework
{$ENDIF};

type
  TAppParameterParserTest = class(TTestCase)
  published
    procedure OnlyNameSlash;
    procedure OnlyNameDash;
    procedure ValueFromDoublePoint;
    procedure ValueFromEqual;
  end;

implementation

procedure TAppParameterParserTest.OnlyNameDash;
begin
  CheckEquals('param1', TAppParameterParser.New('-param1').Parse.Name);
end;

procedure TAppParameterParserTest.OnlyNameSlash;
begin
  CheckEquals('param1', TAppParameterParser.New('/param1').Parse.Name);
end;

procedure TAppParameterParserTest.ValueFromDoublePoint;
begin
  CheckEquals('123', TAppParameterParser.New('-param1:123').Parse.Value);
end;

procedure TAppParameterParserTest.ValueFromEqual;
begin
  CheckEquals('123', TAppParameterParser.New('-param1=123').Parse.Value);
end;

initialization

RegisterTest(TAppParameterParserTest {$IFNDEF FPC}.Suite {$ENDIF});

end.
