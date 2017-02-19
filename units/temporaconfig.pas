unit TemporaConfig;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, IniFiles;

type
  TTemporaConfig = class;

  IConfigProvider = interface
    function GetConfig: TTemporaConfig;
  end;

  { TTemporaConfig }

  TTemporaConfig = class
  private
    iniOptions: TIniFile;
    FVersion: string;
  public
    constructor Create(ini: TIniFile; AVersion: string);
    destructor Destroy; override;

    // window
    function DefaultScreenSize: TRect;
    function ScreenSizeChanged: boolean;
    procedure SetDefaultScreenSize(Value: TRect);
    function DefaultMainWindowMaximized: boolean;
    procedure SetDefaultMainWindowMaximized(Value: boolean);
    function DefaultMainWindowPosition: TRect;
    procedure SetDefaultMainWindowPosition(Value: TRect);
  end;

function GetActualConfig: TIniFile;

var
  ActualConfigDirUTF8: string;

implementation

uses Forms, TemporaUtils, LCLProc, LazFileUtils, LazUtf8;

function GetActualConfig: TIniFile;
var
  PortableConfig: TIniFile;
  AppDirSys: string;
  PortableConfigFilenameSys: string;
  ActualConfigFilenameSys: string;
  //i: integer;
begin
  ActualConfigFilenameSys := '';
  // check if a config file path is defined
  AppDirSys := ExtractFilePath(Application.ExeName);
  PortableConfigFilenameSys := AppDirSys + 'Tempora.cfg';
  if FileExists(PortableConfigFilenameSys) then
  begin
    PortableConfig := TIniFile.Create(PortableConfigFilenameSys);
    ActualConfigFilenameSys := PortableConfig.ReadString('General', 'ConfigFile', '');
    if ActualConfigFilenameSys <> '' then
    begin
      ActualConfigFilenameSys := ExpandFileName(AppDirSys + ActualConfigFilenameSys);
    end;
    PortableConfig.Free;
  end;
  // Otherwise, use default path
  if ActualConfigFilenameSys = '' then
  begin
    CreateDir(GetAppConfigDir(False));
    ActualConfigFilenameSys := GetAppConfigFile(False, True);
  end;
  Result := TIniFile.Create(ActualConfigFilenameSys, True);
  ActualConfigDirUTF8 := SysToUTF8(ExtractFilePath(ActualConfigFilenameSys));
end;

{ TTemporaConfig }

function TTemporaConfig.DefaultScreenSize: TRect;
begin
  Result := StrToRect(iniOptions.ReadString('Window', 'ScreenSize', ''));
end;

function TTemporaConfig.ScreenSizeChanged: boolean;
var
  currentScreenSize, previousScreenSize: TRect;
begin
  currentScreenSize := Rect(0, 0, screen.Width, screen.Height);
  previousScreenSize := DefaultScreenSize;
  if not CompareRect(@previousScreenSize, @currentScreenSize.Left) then
  begin
    SetDefaultScreenSize(currentScreenSize);
    Result := True;
  end
  else
  begin
    Result := False;
  end;
end;

procedure TTemporaConfig.SetDefaultScreenSize(Value: TRect);
begin
  iniOptions.WriteString('Window', 'ScreenSize', RectToStr(Value));
end;

function TTemporaConfig.DefaultMainWindowMaximized: boolean;
begin
  Result := iniOptions.ReadBool('Window', 'MainWindowMaximized', False);
end;

procedure TTemporaConfig.SetDefaultMainWindowMaximized(Value: boolean);
begin
  iniOptions.WriteBool('Window', 'MainWindowMaximized', Value);
end;

function TTemporaConfig.DefaultMainWindowPosition: TRect;
begin
  Result := StrToRect(iniOptions.ReadString('Window', 'MainWindowPosition', ''));
end;

procedure TTemporaConfig.SetDefaultMainWindowPosition(Value: TRect);
begin
  iniOptions.WriteString('Window', 'MainWindowPosition', RectToStr(Value));
  SetDefaultMainWindowMaximized(False);
end;

constructor TTemporaConfig.Create(ini: TIniFile; AVersion: string);
begin
  FVersion := AVersion;
  iniOptions := ini;
end;

destructor TTemporaConfig.Destroy;
begin
  iniOptions.Free;
end;

end.
