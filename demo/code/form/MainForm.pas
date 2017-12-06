{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit MainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,
  ooAppInfo.Parameter,
  ooAppInfo;

type
  TAppParameterArray = array of IAppParameter;

  TMainForm = class(TForm)
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
  private
    function NewParameters: TAppParameterArray;
  end;

var
  NewMainForm: TMainForm;

implementation

{$R *.dfm}

function TMainForm.NewParameters: TAppParameterArray;
begin
  SetLength(Result, 5);
  Result[0] := TAppParameter.New('a', 'The A parameter description', '-a:test');
  Result[1] := TAppParameter.New('b', 'The B parameter', '-b:1234');
  Result[2] := TAppParameter.New('c', 'C cc', '-c:nones');
  Result[3] := TAppParameter.New('onlytext', 'without value', '-onlytext');
  Result[4] := TAppParameter.New('req', 'Required', '-req 123', True);
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  with AppInfoDefined('Application to test', NewParameters) do
  begin
    Caption := Version.AsString;
    Memo1.Clear;
    Memo1.Lines.Append(Format('Command: %s', [Command]));
    Memo1.Lines.Append(Format('Description: %s', [Description]));
    Memo1.Lines.Append(Format('Path: %s', [Path]));
    Memo1.Lines.Append(Format('FileName: %s', [FileName]));
    Memo1.Lines.Append(Format('Is valid: %s', [BoolToStr( not InvalidParameters, True)]));
    Memo1.Lines.Append(Format('ParamCount: %d', [ParameterCount]));
    for i := 0 to Pred(ParameterCount) do
      Memo1.Lines.Append(Format('  Param Index: %d, name: "%s", value: "%s"', [i, Parameter(i).Name,
          Parameter(i).Value]));
    Memo1.Lines.Append(EmptyStr);
    Memo1.Lines.Append(Usage);
    Memo1.Lines.Append(EmptyStr);
  end;
end;

end.
