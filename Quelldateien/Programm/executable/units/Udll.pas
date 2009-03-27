unit Udll;
{
  author:     Robin Christopher Ladiges
  website:    http://blackpinguin.de/
  project:    Mau Dau Mau
  binary:     MauDauMau.exe
  unit:       Udll
  file:       Udll.pas
  filepath:   .\executable\units\
  year:       2008/2009
  desc:       This file handles the inclution of DLL's.
              'maudaumau.dll' and 'cards.dll'

  license:    creative commons by-nc-sa 3.0 germany
   look out license.txt in root folder
   human-readable summary : http://creativecommons.org/licenses/by-nc-sa/3.0/de/
}

interface
uses Windows, Classes;

//Unit implementation. umsetzung pchar<>string
function part(zeichen: char; index: integer; text: string) : string;

//MauDauMau.dll
function partpchar(zeichen: char; index: integer; text: PChar) : PChar; stdcall;
         external 'MauDauMau.dll';
function farbe(card:word):integer; stdcall; external 'MauDauMau.dll';
function wert(card:word):integer; stdcall; external 'MauDauMau.dll';

//cards.dll
function cdtInit(var width,height:integer):boolean; stdcall;
         external 'cards.dll';
procedure cdtTerm; stdcall; external 'cards.dll';
function cdtDraw(hdc:HDC; x,y,card,typ:integer; color:DWORD):boolean; stdcall;
         external 'cards.dll';
function cdtDrawExt(hdc:HDC; x,y,width,height,card,typ:integer; color:DWORD)
         :boolean; stdcall; external 'cards.dll';
//typ == 0  -> vorderseite 1-> rückseite
//suit == Kreuz=0; Karo=1; Herz=2; Pik=3
//face == Ass=0;  zwei=1; drei=2; vier=3; fünf=4; sechs=5; sieben=6; acht=7;
//        neun=8; zehn=9; Bube=10; Dame=11; König=12;
//card ==  suit + face * 4

implementation

function part(zeichen: char; index: integer; text: string) : string;
begin
 //man soll dlls keine strings übergeben laut Borland.
 //führt zu exceptions, deshalb diese umsetzung
 result:=String(partpchar(zeichen,index,PChar(text)));
end;


end.
