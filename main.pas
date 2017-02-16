unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  Menus, ActnList, StdCtrls, ExtCtrls, DTAnalogClock, BCPanel, BCButton,
  DTAnalogGauge;

type

  { TMainForm }

  TMainForm = class(TForm)
    ActionList1: TActionList;
    BCPanel1: TBCPanel;
    Button1: TButton;
    DTAnalogGauge1: TDTAnalogGauge;
    Label1: TLabel;
    MainMenu1: TMainMenu;
    PageControl1: TPageControl;
    PopupMenu1: TPopupMenu;
    TabSheetCollect: TTabSheet;
    TabSheetOrganize: TTabSheet;
    TabSheetProcess: TTabSheet;
    TabSheetPomodoro: TTabSheet;
    TabSheetReview: TTabSheet;
    Timer1: TTimer;
    procedure Button1Click(Sender: TObject);
    procedure Timer1StartTimer(Sender: TObject);
    procedure Timer1StopTimer(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private

  public

  end;

var
  MainForm: TMainForm;
  Seconds : Integer;

implementation

{$R *.lfm}

{ TMainForm }

procedure TMainForm.Button1Click(Sender: TObject);
begin
  Timer1.Enabled:= not Timer1.Enabled;
end;

procedure TMainForm.Timer1StartTimer(Sender: TObject);
begin
  DTAnalogGauge1.NeedleSettings.CapColor := clBlack;
  DTAnalogGauge1.Position:= 0;
  Button1.Caption:= 'Stop Timer';
  Seconds := 0;
end;

procedure TMainForm.Timer1StopTimer(Sender: TObject);
begin
  DTAnalogGauge1.NeedleSettings.CapColor := clBlack;
  DTAnalogGauge1.Position:= 0;
  Button1.Caption:= 'Start Timer';
  Seconds := 0;
end;

procedure TMainForm.Timer1Timer(Sender: TObject);
begin
  Seconds := Seconds + 1;
  if Seconds mod 2 = 0 then DTAnalogGauge1.NeedleSettings.CapColor:= clRed
  else DTAnalogGauge1.NeedleSettings.CapColor := clBlack;
  if Seconds mod 60 = 0 then
  begin
    DTAnalogGauge1.Position := DTAnalogGauge1.Position + 1;
    if DTAnalogGauge1.Position >= 25 then Timer1.Enabled:= False;
  end;
end;

end.

