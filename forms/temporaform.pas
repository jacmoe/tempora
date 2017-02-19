unit TemporaForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, dbf, eventlog, FileUtil, Forms, Controls, Graphics,
  Dialogs, ComCtrls, Menus, ActnList, StdCtrls, ExtCtrls, DbCtrls, DBGrids,
  StdActns, BCPanel, DTAnalogGauge, LazFileUtils, TemporaConfig, TemporaTypes;

const
  TemporaFilename = 'tempora.dbf';

type

  { TMainForm }

  TMainForm = class(TForm)
    Action1: TAction;
    ActionList1: TActionList;
    BCPanel1: TBCPanel;
    Button1: TButton;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    DTAnalogGauge1: TDTAnalogGauge;
    TemporaLog: TEventLog;
    FileExit1: TFileExit;
    ImageList1: TImageList;
    Label1: TLabel;
    MainMenu1: TMainMenu;
    MenuItemFile: TMenuItem;
    MenuItemFileExit: TMenuItem;
    PageControl1: TPageControl;
    PopupMenu1: TPopupMenu;
    TabSheetCollect: TTabSheet;
    TabSheetOrganize: TTabSheet;
    TabSheetProcess: TTabSheet;
    TabSheetPomodoro: TTabSheet;
    TabSheetReview: TTabSheet;
    Timer1: TTimer;
    procedure Button1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Timer1StartTimer(Sender: TObject);
    procedure Timer1StopTimer(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    TemporaDbf: TDbf;
    Config: TTemporaConfig;
    FTemporaInstance: TTemporaCustomInstance;
    initialized: boolean;
    procedure SetTemporaInstance(const AValue: TTemporaCustomInstance);
    procedure Init;
  public
    { public declarations }
    property TemporaInstance: TTemporaCustomInstance
      read FTemporaInstance write SetTemporaInstance;
  end;

var
  MainForm: TMainForm;
  Seconds : Integer;

implementation

{$R *.lfm}

{ TMainForm }

procedure TMainForm.SetTemporaInstance(const AValue: TTemporaCustomInstance);
begin
  if (FTemporaInstance = nil) and (AValue <> nil) then
  begin
    FTemporaInstance := AValue;
    Init;
  end;
end;

procedure TMainForm.Init;
begin
  initialized := False;
  Config := TemporaInstance.Config;

  initialized := True;

  TemporaLog.Log('Initialization complete.');

  //UpdateWindowCaption;
end;

procedure TMainForm.Button1Click(Sender: TObject);
begin
  Timer1.Enabled:= not Timer1.Enabled;
end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  TemporaInstance.SaveMainWindowPosition;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  TemporaDbf:=TDbf.Create(Self);
  TemporaDbf.TableName := TemporaFilename;
  if not FileExistsUTF8(TemporaFilename) then with TemporaDbf do begin
    TableLevel:=7;
    Exclusive:=True;
    FieldDefs.Add('ID', ftAutoInc, 0, True);
    FieldDefs.Add('CountryName', ftString, 25, True);
    FieldDefs.Add('Capital', ftString, 25, True);
    CreateTable;
    Open;
    Append;
    fields[1].AsString:='France';
    Fields[2].AsString:='Paris';
    Post;
    Append;
    fields[1].AsString:='Egypt';
    Fields[2].AsString:='Cairo';
    Post;
    Append;
    fields[1].AsString:='Indonesia';
    Fields[2].AsString:='Jakarta';
    Post;
    Append;
    fields[1].AsString:='Austria';
    Fields[2].AsString:='Vienna';
    Post;
    AddIndex('idxByID', 'ID', [ixPrimary,ixUnique]);
    AddIndex('idxByCountry', 'CountryName', [ixCaseInsensitive]);
    AddIndex('idxByCapital', 'Capital', [ixCaseInsensitive]);
  end;
  TemporaDbf.Open;
  DataSource1.DataSet := TemporaDbf;
  DBGrid1.DataSource := DataSource1;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  TemporaDbf.Close;
end;

procedure TMainForm.FormHide(Sender: TObject);
begin
  TemporaInstance.SaveMainWindowPosition;
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  TemporaInstance.RestoreMainWindowPosition;
end;

procedure TMainForm.Timer1StartTimer(Sender: TObject);
begin
  DTAnalogGauge1.NeedleSettings.CapColor := clBlack;
  DTAnalogGauge1.Position:= 0;
  Button1.Caption:= 'Stop Timer';
  Label1.Caption:= Format('%d minutes, %d seconds', [0, 0]);
  Seconds := 0;
end;

procedure TMainForm.Timer1StopTimer(Sender: TObject);
begin
  DTAnalogGauge1.NeedleSettings.CapColor := clBlack;
  DTAnalogGauge1.Position:= 0;
  Button1.Caption:= 'Start Timer';
  Label1.Caption:= Format('%d minutes, %d seconds', [0, 0]);
  Seconds := 0;
end;

procedure TMainForm.Timer1Timer(Sender: TObject);
var
  mins, secs : integer;
begin
  Seconds := Seconds + 1;
  mins := Seconds div 60;
  secs := Seconds mod 60;
  if mins = 1 then
    Label1.Caption:= Format('%d minute, %d seconds', [mins, secs])
  else
    Label1.Caption:= Format('%d minutes, %d seconds', [mins, secs]);
  if Seconds mod 2 = 0 then DTAnalogGauge1.NeedleSettings.CapColor:= clRed
  else DTAnalogGauge1.NeedleSettings.CapColor := clBlack;
  if Seconds mod 60 = 0 then
  begin
    DTAnalogGauge1.Position := DTAnalogGauge1.Position + 1;
    if DTAnalogGauge1.Position >= 25 then Timer1.Enabled:= False;
  end;
end;

end.

