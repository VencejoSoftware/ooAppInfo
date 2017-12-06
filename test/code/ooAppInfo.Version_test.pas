{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit ooAppInfo.Version_test;

interface

uses
  SysUtils,
  ooAppInfo.Version,
{$IFDEF FPC}
  fpcunit, testregistry
{$ELSE}
  TestFramework
{$ENDIF};

type
  TAppVersionTest = class(TTestCase)
  published
    procedure MajorIs1;
    procedure MinorIs2;
    procedure ReleaseIs3;
    procedure BuildIs4;
    procedure AsStringZero;
  end;

implementation

procedure TAppVersionTest.AsStringZero;
begin
  CheckEquals('1.2.3.4', TAppVersion.New.AsString);
end;

procedure TAppVersionTest.BuildIs4;
begin
  CheckEquals(4, TAppVersion.New.Build);
end;

procedure TAppVersionTest.MajorIs1;
begin
  CheckEquals(1, TAppVersion.New.Major);
end;

procedure TAppVersionTest.MinorIs2;
begin
  CheckEquals(2, TAppVersion.New.Minor);
end;

procedure TAppVersionTest.ReleaseIs3;
begin
  CheckEquals(3, TAppVersion.New.Release);
end;

initialization

RegisterTest(TAppVersionTest {$IFNDEF FPC}.Suite {$ENDIF});

end.
