unit UClientCards;
{
  author:     Robin Christopher Ladiges
  website:    http://blackpinguin.de/
  project:    Mau Dau Mau
  binary:     MauDauMau.exe
  unit:       UClientCards
  file:       UClientCards.pas
  filepath:   .\executable\units\
  year:       2008/2009
  desc:       This file handles the TClientCards class, the class represent
              a card abstract with all properties and events a card have

  license:    creative commons by-nc-sa 3.0 germany
   look out license.txt in root folder
   human-readable summary : http://creativecommons.org/licenses/by-nc-sa/3.0/de/
}


interface
uses classes, ExtCtrls, Controls, Graphics, SysUtils, comctrls;

{
difinition wo sich eine karte befindet

#  | 0    | 1    | 2    | 3    | 4     position
---|------|------|------|------|------
-1 | n/a  | inv  | inv  | inv  | inv
---|------|------|------|------|------
 0 | deck | off* | off* | off* | off*
---|------|------|------|------|------
 1 | hand | off  | off  | off  | off
---|------|------|------|------|------
 2 | hand | off  | off  | off  | off
---|------|------|------|------|------
 3 | hand | off  | off  | off  | off
---|------|------|------|------|------
 4 | hand | off  | off  | off  | off

p   n/a  = kommt nie vor. undefiniert
l   inv  = invisible | indikator für die unsichtbaren offenen karten
a          ansonsten nicht relevant
y   deck = karte die gezogen werden kann, und von der nieman weiß wo im Stapel
e          sie sich befindet
r   hand = karte die sich auf der Hand eines Spielers befindet.
           (player-1 sagt welchem)
    off  = offene karte. Karte die jeder Spieler sehen kann. Position sagt in
           welcher reihenfolge sie gespielt wurden. position 4 ist die obere
           karte. position wird bei jeder weiteren karte die gespielt wird um 1
           verringert bis er 0 ist. Dann kann die Karte wieder gezogen werden.
    off* = erste offene karte einer runde. Die niemandem gehört

}



// difinitionen welche methoden und variablen die Klasse "TClientCards" hat
type TClientCards = class(TImage)  // TClientCards ist eine Klasse
                                   //(und ist kind des TImage Objektes)
   public //von außen aufrufbare/beeinflussbare/lesbare methoden/variablen
   card : integer; //card = farbe + wert*4
   side : 0..1; // 0 oder 1  |  0=vorderseite | 1= rückseite
   position : 0..4;  // s.o.
   player : -1..4;    // s.o.
   constructor create(AOwner: TComponent; card,side,width,height : integer);
               reintroduce; //erstellung der Karte
   procedure imagerefresh; //karte (neu) zeichnen mithilfe der cards.dll
   procedure DblClick(Sender: TObject);reintroduce; //Doppelklick auf karte
   //event: wenn maustaste gedrückt wurde während man über der Karte ist.
   procedure MouseDown(Sender: TObject; Button: TMouseButton;
                       Shift: TShiftState; X, Y: Integer);reintroduce;
   // wenn auf der Karte ein Drag Objekt (eine Karte) fallengelassen wird.
   procedure DragDrop(Sender, Source: TObject; X, Y: Integer);reintroduce;
   // wenn die maus die ein Drag Objekt hält sich über die karte bewegt
   procedure DragOver(Sender, Source: TObject; X, Y: Integer;
                      State: TDragState; var Accept: Boolean);reintroduce;
   end;

//sorgt dafür das alle Karten die erstellt werden teil des clCards Array sind
function card_create(card,side: Integer) : TClientCards;

//Array um alle Karten aufzufangen zur weiteren bearbeitung (mit schleifen)
var clCards : Array of TClientCards;



implementation
uses FMainform, UClient, Udll, ULanguage;



constructor TClientCards.Create(AOwner: TComponent;
                                card,side,width,height: Integer);
begin
 inherited Create(AOwner); //Create Code des parents der Klasse (TImage)
 //zuordnung der beim aufruf übergebenen werte zu den variablen des Objekts
 self.card:=card;
 self.side:=side;
 self.Parent:=Form1;  //Das TImage Objekt wird auf Form1 angezeigt
 self.Visible:=false; //erstma unsichtbar, um Mögliche darstellungsfehler
                      //aufgrund von nicht schnell genug positionierten/bemalten
                      //karten zu vermeiden
 self.Width:=width; //breite
 self.Height:=height; //höhe
 //Damit beim Drag&Drop der Mauscursor nicht angezeigt wird, sondern nur die karte.
 self.DragCursor:=crNone;
 //Ereignisse des TImage auf die Funktionen der TClientCards Klasse leiten
 self.OnDblClick:=self.DblClick;
 self.OnDragDrop:=self.DragDrop;
 self.OnMouseDown:=self.MouseDown;
 self.OnDragOver:=self.DragOver;
 //damit die farbe des 1. Pixel links oben unsichtbar wird
 //(ansonsten beim TImage Objekt weiße Ecken)
 self.Transparent:=true;
 self.Canvas.Brush.Color:=clLime; //füllfarbe beim zeichnen mit canvas
 self.Canvas.Pen.Color:=clLime; //pinselfarbe beim zeichnen mit canvas
 self.imagerefresh; //funktionsaufruf zum zeichnen der Karte
end;


procedure TClientCards.imagerefresh;
begin
 self.Repaint;
 //das ganze image wird clLime angemalt, danach kommt die karte drauf. da beim
 //zeichnen aus der cards.dll die ecken nicht bemalt werden, ist diese farbe
 //unsichtbar, und somit auch die ecken der karten.
 self.Canvas.Rectangle(0,0,self.Width,self.Height);
 //cdtDraw (aus cards.dll) wird ein Canvas.Handle übergeben auf der die dll
 //zeichnen darf. zusätzlich wird übergeben bei welcher position auf dem
 //canvas.handle er zeichnen soll (0|0) und welche karte und wierum.
 cdtDraw(self.Canvas.Handle,0,0,self.card,self.side,0);
 self.Refresh;
end;


procedure TClientCards.DblClick(Sender: TObject);
begin
 if client.game.canplay then  //wenn ich dran bin
  begin
   //wenn es eine eigene handkarte ist
   if (self.player = 1) and (self.position = 0) then
    client.send_text('card;'+inttostr(self.card)+';');
   // wenn es eine deck karte ist
   if (self.player = 0) and (self.position = 0) then
    client.send_text('draw;');
   //wenn es eine offene karte ist
   if (self.position <> 0) then
    client.send_text('out;');
  end
 else
  begin
   Form1.StatusBar1.Panels[1].Bevel:=pbLowered;
   Form1.StatusBar1.Panels[1].Text:=lang.Mainform.SB_1_5;
  end;
end;


procedure TClientCards.MouseDown(Sender: TObject; Button: TMouseButton;
                                 Shift: TShiftState; X, Y: Integer);
begin
 if (Sender is TClientCards) and (self.player = 1) and (self.position = 0) then
  begin
   //wenn es die eigene Karte ist | verhindern, dass andere als die eigene
   //(z.B. die offenen karten) verschoben werden können
   self.BeginDrag(false,5);
   //Beginnt das Draggen sobald die maus während des drückens 5 pixel bewegt
   //wurde. Kommt leider zu fehlern wenn man innerhlab dieser 5 pixel mit der
   //maus über eine andere karte kommt. dann wird die andere karte aufgenommen.
  end
end;


procedure TClientCards.DragDrop(Sender, Source: TObject; X, Y: Integer);
var
 i : integer;
 temp : boolean;
begin
 {
  Source ist die Quelle, die Karte die ich verschiebe | entspricht sender
  Sender ist das Objekt auf der die maus gerade zeigt.
     (da das bild beim dragen unter die maus bewegt wird, ist es
     meistens = source; wäre es nciht so könnte es z.B. die form sein. Zum
     sichergehen das es zu keinen fehlern kommt sollte man sender mit
     berücksichtigen)
  X enhält die relativen x-koordinaten der Maus zu Sender
  Y enhält die relativen y-koordinaten der Maus zu Sender
 }
 temp:=true; //initialisieren
 if (self.player = 1) and (self.position = 0) then
  begin //wenn es die eigene Karte ist | verhindern, dass andere als die eigene
        //(z.B. die offenen karten) verschoben werden können
//hier wird es komplex:  die positionsangaben X und Y des Ereignisaufrufs sind
//relativ zu dem objekt auf dem das Image abgelegt wird. wenn also der sender
//eine Karte ist, muss ich sicherstellen, dass die self.left und self.right
//werte relativ zu derem parent und nicht zu dem objekt auf dem ich sie ablege
//platziert wird. also muss ich die Positionsdaten des Objekt unter des zu
//verschiebenden Objektes aufaddieren, um das Objekt richtig zu positionieren.
//wenn das untere objekt nun die form ist, sind die X und Y werte korrekt zu der
//position wo wir die karte haben wollen.
//wenn das untere objekt nun eine karte ist, wurden die X und Y Werte angepasst
//an die koordinaten die die karte auf der form einnehmen soll
   if Sender is TClientCards then
    begin
     X :=X+ TClientCards(Sender).Left;
     Y :=Y+ TClientCards(Sender).Top;
    end;
   //hälfte weil der mauscursor in der mitte der Karte liegt
   self.Left := X-(self.Width div 2);
   self.Top := Y-(self.Height div 2);
   for i := 0 to high(clCards) do // alle karten durchlaufen
    begin
     if (clCards[i].position <> 0) and (clCards[i].Visible) then
      begin //wenn es eine offene karte ist, und sie sichtbar ist
      //nachfolgender if mit jedemenge "and" und "or" überprüft ob eine der
      //ecken der karte self (die karte die wir ablegen) auf der karte
      //clCards[i] (die offene karte ) liegt
       if
        (
         (self.Top >= clCards[i].Top)
         and (self.Top <= clCards[i].Top+clCards[i].Height)
         and (self.Left >= clCards[i].Left)
         and (self.Left <= clCards[i].Left+clCards[i].Width)
        )
       or
        (
         (self.Top >= clCards[i].Top)
         and (self.Top <= clCards[i].Top+clCards[i].Height)
         and (self.Left+self.Width >= clCards[i].Left)
         and (self.Left+self.Width <= clCards[i].Left+clCards[i].Width)
        )
       or
        (
         (self.Top + self.Height >= clCards[i].Top)
         and (self.Top + self.Height <= clCards[i].Top+clCards[i].Height)
         and (self.Left >= clCards[i].Left)
         and (self.Left <= clCards[i].Left+clCards[i].Width)
        )
       or
        (
         (self.Top + self.Height >= clCards[i].Top)
         and (self.Top + self.Height <= clCards[i].Top+clCards[i].Height)
         and (self.Left+self.Width >= clCards[i].Left)
         and (self.Left+self.Width <= clCards[i].Left+clCards[i].Width)
        )
       then
        begin //also, wenn die karte auf einer offenen karte abgelegt wird.
         temp:=false; //sagt das ich auf einer offenen karte bin
         if client.game.canplay then //wenn ich dran bin
          begin
           self.BringToFront; // damit die Karte ganz oben über allen anderen
                              // Objekten angezeigt wird.
           client.send_text('card;'+inttostr(self.card)+';')
          end
         else
          begin
           //wenn ich nicht an der reihe bin, und die karte auf einer offenen
           //karte abgelegt wird
           client.game.Form.Player0.position; //karte zurück zu den anderen
           Form1.StatusBar1.Panels[1].Bevel:=pbLowered;
           Form1.StatusBar1.Panels[1].Text:=lang.Mainform.SB_1_5;
          end;
         break; //schleifenabbruch, um das weitere durchgehen aller karten zu
                //unterbinden (und den doppeltem aufrufen dieses abschnitts wenn
                //die karte auf 2 oder mehr offenen karten liegt)
        end;
      end;
    end;
   //wenn die karte nicht auf einer offenen karte abgelegt wird
   if temp then client.game.Form.Player0.position; //karte zurück zu den anderen
  end;
end;


procedure TClientCards.DragOver(Sender, Source: TObject; X, Y: Integer;
                                State: TDragState; var Accept: Boolean);
begin
 if Source is TClientCards then
  begin
   Accept := true; // erlaube das ablegen der karte
   if (self.player = 1) and (self.position = 0) then
    begin //wenn es die eigene Karte ist | verhindern, dass andere als die
          //eigene (z.B. die offenen karten) verschoben werden können
     //siehe "hier wird es komplex" in TClientCards.DragDrop. Die grundlagen zur
     //positionierung sind die gleichen wie beim ablegen einer karte
     if Sender is TClientCards then
      begin
       X :=X+TClientCards(Sender).Left;
       Y :=Y+TClientCards(Sender).Top;
      end;
     self.Left := X-(self.Width div 2); // siehe TClientCards.DragDrop
     self.Top := Y-(self.Height div 2); // siehe TClientCards.DragDrop
     self.BringToFront; // damit die Karte ganz oben über allen anderen Objekten
                        //angezeigt wird.
    end;
  end;
end;


function card_create(card,side: Integer) : TClientCards;
begin
 // dynamisches clCards Array um 1 platz erhöhen
 SetLength(clCards, (length(clCards)+1));
 // den neuen platz mit einer neuen Karte füllen
 clCards[high(clCards)]:=TClientCards.Create(Form1,card,side,c_width,c_height);
 // die neue karte zurückgeben zur evtl. weiteren verarbeitung in der procedure
 // die diese funktion aufruft.
 result:=clCards[high(clCards)];
end;














end.
