unit TemporaTypes;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Dialogs, Controls, IniFiles, TemporaConfig;

const
  TemporaCurrentVersionOnly = '0.1.0';
  {$IFDEF CPU64}
    TemporaProcessorInfo = ' (64-bit)';
  {$ELSE}
    TemporaProcessorInfo = ' (32-bit)';
  {$ENDIF}
  TemporaCurrentVersion : String=TemporaCurrentVersionOnly + TemporaProcessorInfo;

type
  TTemporaCustomInstance = class;
  TTemporaInstanceEvent = procedure(AInstance : TTemporaCustomInstance) of object;

  TTemporaCustomInstance = class(TInterfacedObject,IConfigProvider)
  protected
    FRestartQuery: boolean;
    function QueryInterface({$IFDEF FPC_HAS_CONSTREF}constref{$ELSE}const{$ENDIF} IID: TGUID; out Obj): HResult; {$IF (not defined(WINDOWS)) AND (FPC_FULLVERSION>=20501)}cdecl{$ELSE}stdcall{$IFEND};
    function _AddRef: Integer; {$IF (not defined(WINDOWS)) AND (FPC_FULLVERSION>=20501)}cdecl{$ELSE}stdcall{$IFEND};
    function _Release: Integer; {$IF (not defined(WINDOWS)) AND (FPC_FULLVERSION>=20501)}cdecl{$ELSE}stdcall{$IFEND};

    function GetConfig: TTemporaConfig; virtual; abstract;

    function GetFullscreen: boolean; virtual; abstract;
    procedure SetFullscreen(AValue: boolean); virtual; abstract;
  public
    Title, AboutText: string;
    constructor Create; virtual; abstract;
    constructor Create(AEmbedded: boolean); virtual; abstract;
    procedure Show; virtual; abstract;
    procedure Hide; virtual; abstract;
    procedure Run; virtual; abstract;
    procedure SaveMainWindowPosition; virtual; abstract;
    procedure RestoreMainWindowPosition; virtual; abstract;
    procedure UseConfig(ini: TInifile); virtual; abstract;
    property Config: TTemporaConfig read GetConfig;
  end;

implementation

{ Interface gateway }
function TTemporaCustomInstance.QueryInterface({$IFDEF FPC_HAS_CONSTREF}constref{$ELSE}const{$ENDIF} IID: TGUID; out Obj): HResult; {$IF (not defined(WINDOWS)) AND (FPC_FULLVERSION>=20501)}cdecl{$ELSE}stdcall{$IFEND};
begin
  if GetInterface(iid, obj) then
    Result := S_OK
  else
    Result := longint(E_NOINTERFACE);
end;

{ There is no automatic reference counting, but it is compulsory to define these functions }
function TTemporaCustomInstance._AddRef: Integer; {$IF (not defined(WINDOWS)) AND (FPC_FULLVERSION>=20501)}cdecl{$ELSE}stdcall{$IFEND};
begin
  result := 0;
end;

function TTemporaCustomInstance._Release: Integer; {$IF (not defined(WINDOWS)) AND (FPC_FULLVERSION>=20501)}cdecl{$ELSE}stdcall{$IFEND};
begin
  result := 0;
end;

end.

