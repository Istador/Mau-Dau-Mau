library MauDauMau;
{
  author:     Robin Christopher Ladiges
  website:    http://blackpinguin.de/
  project:    Mau Dau Mau
  binary:     MauDauMau.dll
  unit:       MauDauMau
  file:       MauDauMau.dpr
  filepath:   .\dll\
  year:       2008/2009
  desc:       This file is a dll witch offers a few functions to other
              applications. So I or other can use this functions in applications
              without worry about how they work, only worry about the results.

  license:    creative commons by-nc-sa 3.0 germany
   look out license.txt in this folder
   human-readable summary : http://creativecommons.org/licenses/by-nc-sa/3.0/de/
}

uses
  SysUtils,
  Classes;

{$R *.res}



{
Die part funktion liefert einen Teil eines Strings zurück
part(zeichen, index, text)
   zeichen -> das zur trennung von abschnitten festgelegte Zeichen
   index -> der wievielte abschnitt zurückgegeben werden soll.
   text -> der string aus dem ein abschnitt ausgegeben werden soll

part('#',0,'2#abcd;acdef;agf;#abc;def;ghi;jkl;#');  -> '2'  // z.B. um mitzuteilen wieviele abschnitte der text hat, zwecks schrittweise abarbeitung in schleifen
part('#',1,'2#abcd;acdef;agf;#abc;def;ghi;jkl;#');  -> 'abcd;acdef;agf;'
part('#',2,'2#abcd;acdef;agf;#abc;def;ghi;jkl;#');  -> 'abc;def;ghi;jkl;'
part(';',0,'abc;def;ghi;jkl;');  -> 'abc'
part(';',2,'abc;def;ghi;jkl;');  -> 'ghi'
}
function partpchar(zeichen: char; index: integer; text: PChar) : PChar; stdcall;
var
 i:integer; //schleifenvariable
begin
 result:=text; //zugriff auf text -> programmcrash deshalb arbeit mit result
 for i := 0 to index do // geht nach und nach alle abschnitte durch
  if i = index then // wenn wir beim gesuchten index-abschnitt sind
   result:=PChar(Copy(result,1,Pos(zeichen,result)-1)) //schneide hinter dem zeichen ab
  else // wenn nicht der gesuchte abschnitt : schneide vordersten abschnitt ab.
   result:=PChar(Copy(result,(Pos(zeichen,result)+1),
                 (length(result)-Pos(zeichen,result))));
   //dadurch ist z.B. sichergestellt, dass sollte der index einen abschnitt
   //verlangen der aufgrund von zuwenigen abschnitten nicht existiert, ein
   //leerer string zurückgegeben wird := ''
end;



{
Nach Cards.dll Standard

suit=farbe der karte
face=wert der karte
card=suit+face*4

--suit--
Kreuz=0
Karo=1
Herz=2
Pik=3

--face--
Ass=0
zwei=1
drei=2
vier=3
fünf=4
sechs=5
sieben=6
acht=7
neun=8
zehn=9
bube=10
dame=11
könig=12
}
// die funktion liefert die zahl der farbe der übergebenen karte zurück.
function farbe(card : word) : integer; stdcall;
var
 vwert: integer;
begin
 for vwert := 0 to 13 do
  if card = vwert*4+0 then begin result:=0; break; end //kreuz
  else if card = vwert*4+1 then begin result:=1; break; end //karo
  else if card = vwert*4+2 then begin result:=2; break; end //herz
  else if card = vwert*4+3 then begin result:=3; break; end //pik
  else result:=-1; // -1 fals die farbe sich nicht berechnen lässt
end;

// die funktion liefert die zahl des wertes der übergebenen karte zurück.
function wert(card : word) : integer; stdcall;
var
 vfarbe:integer;
begin
 for vfarbe := 0 to 3 do
  if card = 0*4+vfarbe then begin result:=0; break; end //ass
  else if card = 1*4+vfarbe then begin result:=1; break; end //zwei
  else if card = 2*4+vfarbe then begin result:=2; break; end //drei
  else if card = 3*4+vfarbe then begin result:=3; break; end //vier
  else if card = 4*4+vfarbe then begin result:=4; break; end //fünf
  else if card = 5*4+vfarbe then begin result:=5; break; end //sechs
  else if card = 6*4+vfarbe then begin result:=6; break; end //sieben
  else if card = 7*4+vfarbe then begin result:=7; break; end //acht
  else if card = 8*4+vfarbe then begin result:=8; break; end //neun
  else if card = 9*4+vfarbe then begin result:=9; break; end //zehn
  else if card = 10*4+vfarbe then begin result:=10; break; end //bube
  else if card = 11*4+vfarbe then begin result:=11; break; end //dame
  else if card = 12*4+vfarbe then begin result:=12; break; end //könig
  else result:=-1; // -1 fals der wert sich nicht berechnen lässt
end;


//die funktionen/variablen auf die von außerhalb der dll zugegriffen werden kann
exports partpchar, farbe, wert;



begin
end.
