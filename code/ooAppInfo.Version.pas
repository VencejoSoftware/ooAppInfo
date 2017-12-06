{$REGION 'documentation'}
{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
{
  Application version info
  @created(08/04/2016)
  @author Vencejo Software <www.vencejosoft.com>
}
{$ENDREGION}
unit ooAppInfo.Version;

interface

uses
  Windows,
  SysUtils;

type
{$REGION 'documentation'}
{
  @abstract(Application version info)
  Call operation system APIs to get application version
  @member(Major Major version <@bold(0).0.0.0>)
  @member(Minor Minor version <0.@bold(0).0.0>)
  @member(Release Release version <0.0.@bold(0).0>)
  @member(Build Build version <0.0.0.@bold(0)>)
  @member(AsString Convert @classname object to string)
}
{$ENDREGION}
  IAppVersion = interface
    ['{0EF0A612-7F55-4FFA-95F4-62680A2879A2}']
    function Major: Byte;
    function Minor: Byte;
    function Release: Byte;
    function Build: Byte;
    function AsString: String;
  end;
{$REGION 'documentation'}
{
  @abstract(Implementation of @link(IAppVersion))
  @member(Major @seealso(IAppVersion.Major))
  @member(Minor @seealso(IAppVersion.Minor))
  @member(Release @seealso(IAppVersion.Release))
  @member(Build @seealso(IAppVersion.Build))
  @member(AsString @seealso(IAppVersion.AsString))
  @member(
    Create Object constructor
      @param(FileName Binary file name to get version)
    )
  @member(New Create a new @classname as interface)
}
{$ENDREGION}

  TAppVersion = class sealed(TInterfacedObject, IAppVersion)
  strict private
    _Major: Byte;
    _Minor: Byte;
    _Release: Byte;
    _Build: Byte;
  private
    procedure GetBuildInfo(const FileName: String; var V1, V2, V3, V4: Byte);
  public
    function Major: Byte;
    function Minor: Byte;
    function Release: Byte;
    function Build: Byte;
    function AsString: String;
    constructor Create(const FileName: String);
    class function New: IAppVersion;
  end;

implementation

function TAppVersion.Build: Byte;
begin
  Result := _Build;
end;

function TAppVersion.Major: Byte;
begin
  Result := _Major;
end;

function TAppVersion.Minor: Byte;
begin
  Result := _Minor;
end;

function TAppVersion.Release: Byte;
begin
  Result := _Release;
end;

function TAppVersion.AsString: String;
begin
  Result := Format('%d.%d.%d.%d', [Major, Minor, Release, Build]);
end;

procedure TAppVersion.GetBuildInfo(const FileName: String; var V1, V2, V3, V4: Byte);
var
  VerInfoSize, VerValueSize, Dummy: DWORD;
  VerInfo: Pointer;
  VerValue: PVSFixedFileInfo;
begin
  VerInfoSize := GetFileVersionInfoSize(PChar(FileName), Dummy);
  if VerInfoSize > 0 then
  begin
    GetMem(VerInfo, VerInfoSize);
    try
      if GetFileVersionInfo(PChar(FileName), 0, VerInfoSize, VerInfo) then
      begin
        VerQueryValue(VerInfo, '\', Pointer(VerValue), VerValueSize);
        with VerValue^ do
        begin
          V1 := dwFileVersionMS shr 16;
          V2 := dwFileVersionMS and $FFFF;
          V3 := dwFileVersionLS shr 16;
          V4 := dwFileVersionLS and $FFFF;
        end;
      end;
    finally
      FreeMem(VerInfo, VerInfoSize);
    end;
  end;
end;

constructor TAppVersion.Create(const FileName: String);
begin
  GetBuildInfo(FileName, _Major, _Minor, _Release, _Build);
end;

class function TAppVersion.New: IAppVersion;
begin
  Result := TAppVersion.Create(ParamStr(0));
end;

end.
