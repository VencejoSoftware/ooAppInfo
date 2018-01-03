{$REGION 'documentation'}
{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
{
  Execution command parameter
  @created(08/04/2016)
  @author Vencejo Software <www.vencejosoft.com>
}
{$ENDREGION}
unit ooAppInfo.Parameter;

interface

uses
  SysUtils,
  Generics.Collections;

type
{$REGION 'documentation'}
{
  @abstract(Execution command parameter)
  Object to manipulate execution command parameter
  @member(Name Parameter name)
  @member(Description Parameter description)
  @member(Usage Command usage example)
  @member(Required Indicates whether the parameter is required)
  @member(Value Parameter value)
  @member(UpdateValue Changes the parameter value)
}
{$ENDREGION}
  IAppParameter = interface
    ['{E8A683CD-3028-467A-A806-2175F236958F}']
    function Name: string;
    function Description: string;
    function Usage: string;
    function Required: boolean;
    function Value: string;

    procedure UpdateValue(const Value: string);
  end;

{$REGION 'documentation'}
{
  @abstract(List of @link(IAppParameter) objects)
  @member(
    IndexOf Get index of a parameter name in the list
    @param(Name Parameter name to find)
    @return(Integer If found retunr the index, -1 if not)
  )
  @member(
    Exists Checks if a parameter name exists in the list
    @param(Name Parameter name to find)
    @return(@true If exists, @false if not found)
  )
  @member(
    Add Append a @link(IAppParameter) to the list
    @param(AppParameter Object parameter)
    @return(Integer with the item index added)
  )
}
{$ENDREGION}
  TAppParamList = class(TList<IAppParameter>)
  public
    function IndexOf(const Name: string): integer;
    function Exists(const Name: string): boolean;
    function Add(const AppParameter: IAppParameter): integer; reintroduce;
  end;

{$REGION 'documentation'}
{
  @abstract(Implementation of @link(IAppParameter))
  @member(Name @seealso(IAppParameter.Name))
  @member(Description @seealso(IAppParameter.Description))
  @member(Usage @seealso(IAppParameter.Usage))
  @member(Required @seealso(IAppParameter.Required))
  @member(Value @seealso(IAppParameter.Value))
  @member(UpdateValue @seealso(IAppParameter.UpdateValue))
  @member(
    Create Object constructor
    @param(Name The parameter name)
    @param(Description Optional parameter description)
    @param(Usage Example of parameter usage)
    @param(Required If true then the parameter validate empty value)
  )
  @member(
    New Create a new @classname as interface
    @param(Name The parameter name)
    @param(Description Optional parameter description)
    @param(Usage Example of parameter usage)
    @param(Required If true then the parameter validate empty value)
  )
}
{$ENDREGION}

  TAppParameter = class(TInterfacedObject, IAppParameter)
  strict private
    _Name: string;
    _Description: string;
    _Usage: string;
    _Value: string;
    _Required: boolean;
  public
    function Name: string;
    function Description: string;
    function Usage: string;
    function Value: string;
    function Required: boolean;
    procedure UpdateValue(const Value: string);
    constructor Create(const Name, Description, Usage: string; const Required: boolean = False);
    class function New(const Name, Description, Usage: string; const Required: boolean = False): IAppParameter;
  end;

implementation

function TAppParamList.Add(const AppParameter: IAppParameter): integer;
begin
  Result := IndexOf(AppParameter.Name);
  if Result = -1 then
    Result := inherited Add(AppParameter)
  else
    Items[Result].UpdateValue(AppParameter.Value);
end;

function TAppParamList.Exists(const Name: string): boolean;
begin
  Result := IndexOf(Name) > -1;
end;

function TAppParamList.IndexOf(const Name: string): integer;
var
  i: integer;
begin
  Result := -1;
  for i := 0 to Pred(Count) do
  begin
    if Trim(Name) = Trim(Items[i].Name) then
    begin
      Result := i;
      Break;
    end;
  end;
end;

function TAppParameter.Name: string;
begin
  Result := _Name;
end;

function TAppParameter.Description: string;
begin
  Result := _Description;
end;

procedure TAppParameter.UpdateValue(const Value: string);
begin
  _Value := Value;
end;

function TAppParameter.Usage: string;
begin
  Result := _Usage;
end;

function TAppParameter.Value: string;
begin
  Result := _Value;
end;

function TAppParameter.Required: boolean;
begin
  Result := _Required;
end;

constructor TAppParameter.Create(const Name, Description, Usage: string; const Required: boolean = False);
begin
  _Name := Name;
  _Description := Description;
  _Usage := Usage;
  _Required := Required;
end;

class function TAppParameter.New(const Name, Description, Usage: string;
  const Required: boolean = False): IAppParameter;
begin
  Result := Create(Name, Description, Usage, Required);
end;

end.
