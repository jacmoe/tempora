program tempora;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, dbflaz, TemporaForm, TemporaConfig, Inifiles,
  TemporaTypes, TemporaInstance;

{$R *.res}

type
  { TMyTemporaInstance }
  TMyTemporaInstance = class(TTemporaInstance);

var
  ActualConfig : TIniFile;
  TemporaApplication : TMyTemporaInstance;

begin
  ActualConfig := GetActualConfig;
  RequireDerivedFormResource:=True;
  Application.Initialize;

  TemporaApplication := TMyTemporaInstance.Create;
  TemporaApplication.UseConfig(ActualConfig);

  begin
    TemporaApplication.Show;
    Application.Run;
  end;

  TemporaApplication.Hide;

  TemporaApplication.Free;
end.

