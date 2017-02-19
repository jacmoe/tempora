unit TemporaUtils;

{$mode objfpc}

interface

uses
  Classes, SysUtils;

type
  arrayOfString = array of string;

function RectToStr(rect: TRect): string;
function StrToRect(str: string): TRect;
function SimpleParseFuncParam(str: string): arrayOfString;

implementation

function SimpleParseFuncParam(str: string): arrayOfString;
var
  idxOpen, start, cur: integer;
begin
  Result := nil;
  idxOpen := pos('(', str);
  if idxOpen = 0 then
    exit;
  start := idxOpen + 1;
  cur := start;
  while cur <= length(str) do
  begin
    if str[cur] in [',', ')'] then
    begin
      setlength(Result, length(Result) + 1);
      Result[high(Result)] := copy(str, start, cur - start);
      start := cur + 1;
    end;
    Inc(cur);
  end;
  if start <= length(str) then
  begin
    setlength(Result, length(Result) + 1);
    Result[high(Result)] := copy(str, start, length(str) - start + 1);
  end;
end;

function RectToStr(rect: TRect): string;
begin
  Result := 'Rect(' + IntToStr(rect.left) + ',' + IntToStr(rect.Top) + ',' +
    IntToStr(rect.Right) + ',' + IntToStr(rect.Bottom) + ')';
end;

{$hints off}
{$notes off}
function StrToRect(str: string): TRect;
var
  param: arrayOfString;
  errPos: integer;
begin
  if lowercase(copy(str, 1, 5)) = 'rect(' then
  begin
    param := SimpleParseFuncParam(str);
    if length(param) = 4 then
    begin
      val(param[0], Result.left, errPos);
      val(param[1], Result.top, errPos);
      val(param[2], Result.right, errPos);
      val(param[3], Result.bottom, errPos);
      exit;
    end;
  end;
  fillchar(Result, sizeof(Result), 0);
end;

{$notes on}
{$hints on}


end.
