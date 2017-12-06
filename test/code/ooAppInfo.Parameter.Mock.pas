{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit ooAppInfo.Parameter.Mock;

interface

uses
  SysUtils,
  ooAppInfo.Parameter;

function MockParameter: IAppParameter;

procedure FillList(var AppParamList: TAppParamList);

implementation

function MockParameter: IAppParameter;
begin
  Result := TAppParameter.New('TestParam', 'Parameter for test', '-TestParam:2', True);
end;

procedure FillList(var AppParamList: TAppParamList);
var
  i: Integer;
begin
  AppParamList.Clear;
  for i := 0 to 10 do
    AppParamList.Add(TAppParameter.New('TestParam' + IntToStr(i), 'Parameter for test', '-TestParam:2', True));
end;

end.
