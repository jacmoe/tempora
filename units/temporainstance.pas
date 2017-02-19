unit TemporaInstance;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Controls, TemporaTypes, IniFiles, TemporaConfig, TemporaForm;

type
  TTemporaInstance = class(TTemporaCustomInstance)
  private
    function GetMainFormVisible: boolean;
  protected
    MainForm: TMainForm;
    FFullscreen: boolean;
    FConfig: TTemporaConfig;
    FInFormsNeeded: boolean;
    procedure Init(AEmbedded: boolean);
    function GetFullscreen: boolean; override;
    procedure SetFullscreen(AValue: boolean); override;
    function GetConfig: TTemporaConfig; override;
    procedure FormsNeeded;
  public
    constructor Create; override;
    constructor Create(AEmbedded: boolean); override;
    property MainFormVisible: boolean read GetMainFormVisible;
    procedure Show; override;
    procedure Hide; override;
    procedure Run; override;
    procedure SaveMainWindowPosition; override;
    procedure RestoreMainWindowPosition; override;
    procedure UseConfig(ini: TInifile); override;

  end;


implementation

uses
  LCLType, Types, Forms, Dialogs, FileUtil, LCLIntf;

procedure TTemporaInstance.Init(AEmbedded: boolean);
begin
  Title := 'Tempora ' + TemporaCurrentVersion;
end;

constructor TTemporaInstance.Create;
begin
  Init(False);
end;

constructor TTemporaInstance.Create(AEmbedded: boolean);
begin
  Init(AEmbedded);
end;

procedure TTemporaInstance.UseConfig(ini: TInifile);
begin
  FreeAndNil(FConfig);
  FConfig := TTemporaConfig.Create(ini, TemporaCurrentVersionOnly);
end;

function TTemporaInstance.GetConfig: TTemporaConfig;
begin
  Result := FConfig;
end;

procedure TTemporaInstance.Show;
begin
  //EmbeddedResult := mrNone;
  FormsNeeded;
  MainForm.Show;
end;

procedure TTemporaInstance.Hide;
begin
  if MainFormVisible then
    MainForm.Hide;
end;

procedure TTemporaInstance.Run;
begin
  if not MainFormVisible then
    Show;
  repeat
    application.ProcessMessages;
    Sleep(10);
  until not MainFormVisible;
end;

procedure TTemporaInstance.FormsNeeded;
begin
  if (MainForm <> nil) or FInFormsNeeded then
    exit;

  FInFormsNeeded := True;
  Application.CreateForm(TMainForm, MainForm);
  MainForm.TemporaInstance := self;

  FInFormsNeeded := False;
end;

function TTemporaInstance.GetMainFormVisible: boolean;
begin
  if MainForm <> nil then
    Result := MainForm.Visible
  else
    Result := False;
end;

function TTemporaInstance.GetFullscreen: boolean;
begin
  Result := FFullscreen;
end;

procedure TTemporaInstance.SetFullscreen(AValue: boolean);
begin
  if (AValue = FFullscreen) or not MainFormVisible or
    (MainForm.WindowState = wsMinimized) then
    exit;
  FFullscreen := AValue;
  if AValue then
  begin
    SaveMainWindowPosition;
    MainForm.BorderStyle := bsNone;
    MainForm.WindowState := wsFullScreen;
  end
  else
  begin
    MainForm.BorderStyle := bsSizeable;
    MainForm.WindowState := wsNormal;
    RestoreMainWindowPosition;
  end;
end;

procedure TTemporaInstance.SaveMainWindowPosition;
var
  r: TRect;
begin
  if MainForm.WindowState = wsMinimized then
    exit;
  if MainForm.WindowState = wsMaximized then
    Config.SetDefaultMainWindowMaximized(True)
  else
  if MainForm.WindowState = wsNormal then
  begin
    r.left := MainForm.Left;
    r.top := MainForm.Top;
    r.right := r.left + MainForm.ClientWidth;
    r.Bottom := r.top + MainForm.ClientHeight;
    Config.SetDefaultMainWindowPosition(r);
  end;
end;

procedure TTemporaInstance.RestoreMainWindowPosition;
var
  r: TRect;
begin
  if not MainFormVisible then
    exit;
  if Config.DefaultMainWindowMaximized then
    MainForm.WindowState := wsMaximized
  else
  begin
    r := Config.DefaultMainWindowPosition;
    if (r.right > r.left) and (r.bottom > r.top) then
    begin
      MainForm.Position := poDesigned;
      MainForm.Left := r.Left;
      MainForm.Top := r.Top;
      MainForm.ClientWidth := r.right - r.left;
      MainForm.ClientHeight := r.bottom - r.top;
    end;
  end;
end;

end.
