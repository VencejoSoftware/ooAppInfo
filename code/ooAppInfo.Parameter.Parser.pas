{$REGION 'documentation'}
{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
{
  Application parameter parser
  @created(08/04/2016)
  @author Vencejo Software <www.vencejosoft.com>
}
{$ENDREGION}
unit ooAppInfo.Parameter.Parser;

interface

uses
  SysUtils,
  ooAppInfo.Parameter;

type
{$REGION 'documentation'}
{
  @abstract(Application parameter parser)
  Take a string and parse it converting to an @link(IAppParameter) object
  @member(
    Parse Execute parser
    @returns(@link(IAppParameter) if can parse the text, nil if cannot)
  )
}
{$ENDREGION}
  IAppParameterParser = interface
    ['{C42CB532-03BC-436E-954D-00051ABF0F48}']
    function Parse: IAppParameter;
  end;
{$REGION 'documentation'}
{
  @abstract(Implementation of @link(IAppParameterParser))
  @member(
    Parse Divide a string in items, converting parsed items into a new @link(IAppParameter) object
    @seealso(IAppParameterParser.Parse)
  )
  @member(
    Create Object constructor
    @param(Text raw string to parse)
  )
  @member(
    New Create a new @classname as interface
    @param(Text raw string to parse)
  )
}
{$ENDREGION}

  TAppParameterParser = class(TInterfacedObject, IAppParameterParser)
  strict private
    _Text: string;
  private
    function IsParamBegin(const C: Char): boolean;
    function IsValueBegin(const C: Char): boolean;
    function ParseName: string;
    function ParseValue: string;
  public
    function Parse: IAppParameter;
    constructor Create(const Text: string);
    class function New(const Text: string): IAppParameterParser;
  end;

implementation

function TAppParameterParser.IsParamBegin(const C: Char): boolean;
begin
  Result := CharInSet(C, ['-', '/']);
end;

function TAppParameterParser.IsValueBegin(const C: Char): boolean;
begin
  Result := CharInSet(C, [':', '=']);
end;

function TAppParameterParser.ParseName: string;
var
  C: Char;
begin
  Result := EmptyStr;
  for C in _Text do
  begin
    if not IsParamBegin(C) then
    begin
      if IsValueBegin(C) then
        Break;
      Result := Result + C;
    end;
  end;
end;

function TAppParameterParser.ParseValue: string;
var
  C: Char;
  ValuePresent: boolean;
begin
  Result := EmptyStr;
  ValuePresent := False;
  for C in _Text do
  begin
    if not IsParamBegin(C) then
    begin
      if ValuePresent then
        Result := Result + C;
      ValuePresent := ValuePresent or IsValueBegin(C);
    end;
  end;
end;

function TAppParameterParser.Parse: IAppParameter;
begin
  Result := TAppParameter.New(ParseName, EmptyStr, EmptyStr, False);
  Result.UpdateValue(ParseValue);
end;

constructor TAppParameterParser.Create(const Text: string);
begin
  _Text := Text;
end;

class function TAppParameterParser.New(const Text: string): IAppParameterParser;
begin
  Result := TAppParameterParser.Create(Text);
end;

end.
