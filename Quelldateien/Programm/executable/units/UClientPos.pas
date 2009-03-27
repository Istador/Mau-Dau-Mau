unit UClientPos;
{
  author:     Robin Christopher Ladiges
  website:    http://blackpinguin.de/
  project:    Mau Dau Mau
  binary:     MauDauMau.exe
  unit:       UClientPos
  file:       UClientPos.pas
  filepath:   .\executable\units\
  year:       2008/2009
  desc:       This file handles the TClientPos class, the class that mainly
              handles the positions of the cards at the form. E.g. where which
              card, in ownership of a specific player, has to be.

  license:    creative commons by-nc-sa 3.0 germany
   look out license.txt in root folder
   human-readable summary : http://creativecommons.org/licenses/by-nc-sa/3.0/de/
}

interface
uses UClientCards, ExtCtrls, classes, Graphics, SysUtils;

type TClientPos = class
     cards : Array of TClientCards;
     procedure drop_card;
     procedure drop_allcards;
     procedure position;virtual;
     destructor Destroy;Override;
     end;
type TClientPosPlayer0 = class(TClientPos)
     procedure new_card(card : word);
     procedure drop_card(card : word);
     procedure sort;
     procedure position;Override;
     end;
type TClientPosPlayer1 = class(TClientPos)
     procedure new_card;
     procedure position;Override;
     end;
type TClientPosPlayer2 = class(TClientPos)
     procedure new_card;
     procedure position;Override;
     end;
type TClientPosPlayer3 = class(TClientPos)
     procedure new_card;
     procedure position;Override;
     end;
type TClientPosOpenCards = class(TClientPos)
     constructor create;
     procedure new_card(card, player : word);
     procedure drop_card;
     procedure position;Override;
     end;
type TClientPosDeck = class(TCLientPos)
     constructor create;
     procedure drop_card;
     procedure position;Override;
     end;
type TClientPosTocken = class(TImage)
     public
     tockenplayer : integer;
     constructor create(AOwner: TComponent);reintroduce;
     procedure sett(player : integer);
     procedure position;
     end;

implementation
uses FMainform, Udll, UIni;



procedure TClientPos.drop_card;
begin
 if length(self.cards) <> 0 then
  begin
   if assigned(self.cards[high(self.cards)]) then
    FreeAndNil(self.cards[high(self.cards)]);
   SetLength(self.cards, (length(self.cards)-1));
   self.position;
  end;
end;


procedure TClientPos.drop_allcards;
var
 i: integer;
begin
 if length(self.cards) <> 0 then
  begin
   for i := high(self.cards) downto 0 do
    if assigned(self.cards[i]) then FreeAndNil(self.cards[i]);
   SetLength(self.cards, 0);
   self.position;
  end;
end;


procedure TClientPos.position;
begin
end;


destructor TClientPos.Destroy;
var
 i: Integer;
begin
 if assigned(self.cards) then
  for i := high(self.cards) downto low(self.cards) do
   FreeAndNil(self.cards[i]);
 setlength(self.cards,0);
 inherited;
end;


procedure TClientPosPlayer0.new_card(card : word);
begin
 SetLength(self.cards, (length(self.cards)+1));
 self.cards[high(self.cards)]:=card_create(card,0);
 self.cards[high(self.cards)].position := 0;
 self.cards[high(self.cards)].player:=1;
 self.sort;
 self.position;
end;

procedure TClientPosPlayer0.drop_card(card : word);
var
 i: integer;
 j: Integer;
begin
 if length(self.cards) <> 0 then
  for i := 0 to high(self.cards) do
   if self.cards[i].card = card then
    begin
     for j := i to high(self.cards)-1 do
      begin
       self.cards[j].card:=self.cards[j+1].card;
       self.cards[j].imagerefresh;
      end;
     if assigned(self.cards[high(self.cards)]) then
      self.cards[high(self.cards)].Destroy;
     SetLength(self.cards, (length(self.cards)-1));
     self.sort;
     self.position;
     break;
    end;
end;

procedure TClientPosPlayer0.sort;
var
 i,j: Integer;
 temp: TClientCards;
begin
 //0=garnicht; 1=nach Farbe; 2=nach Wert
 if config.client.sortorder <> 0 then
  for i := 0 to high(self.cards) do
   for j := i+1 to high(self.cards) do
    begin
     if config.client.sortorder = 1 then
      begin
       if (farbe(self.cards[i].card) > farbe(self.cards[j].card))
       or ((farbe(self.cards[i].card) = farbe(self.cards[j].card))
       and (wert(self.cards[i].card) > wert(self.cards[j].card)))
       then
        begin
         temp:=self.cards[i];
         self.cards[i]:=self.cards[j];
         self.cards[j]:=temp;
        end;
      end
     else if config.client.sortorder = 2 then
      begin
       if (wert(self.cards[i].card) > wert(self.cards[j].card))
       or ((wert(self.cards[i].card) = wert(self.cards[j].card))
       and (farbe(self.cards[i].card) > farbe(self.cards[j].card)))
       then
        begin
         temp:=self.cards[i];
         self.cards[i]:=self.cards[j];
         self.cards[j]:=temp;
        end;
      end;
    end;
end;


procedure TClientPosPlayer0.position;
var
 i: integer;
begin
 if length(self.cards) <> 0 then
  for i := 0 to high(self.cards) do
   begin
    self.cards[i].Left:=(((Form1.ClientWidth-Form1.m_chat.Width) div 2)
                        -(high(self.cards)*15+c_width)div 2 +i*15);
    self.cards[i].Top:=(Form1.ClientHeight-29-c_height);
    self.cards[i].BringToFront;
    self.cards[i].Visible:=true;
   end;
end;


procedure TClientPosPlayer1.new_card;
begin
 SetLength(self.cards, (length(self.cards)+1));
 self.cards[high(self.cards)]:=card_create(config.client.background,1);
 self.cards[high(self.cards)].position := 0;
 self.cards[high(self.cards)].player:=2;
 self.position;
end;


procedure TClientPosPlayer1.position;
var i : integer;
begin
 if length(self.cards) <> 0 then
  for i := 0 to high(self.cards) do
   begin
    self.cards[i].Left:=10;
    self.cards[i].Top:=(Form1.ClientHeight-Form1.StatusBar1.Height) div 2
                       - ((high(self.cards)*15+c_height)div 2)+i*15;
    self.cards[i].Visible:=true;
   end;
end;


procedure TClientPosPlayer2.new_card;
begin
 SetLength(self.cards, (length(self.cards)+1));
 self.cards[high(self.cards)]:=card_create(config.client.background,1);
 self.cards[high(self.cards)].position := 0;
 self.cards[high(self.cards)].player:=3;
 self.position;
end;

procedure TClientPosPlayer2.position;
var
 i : integer;
begin
 if length(self.cards) <> 0 then
  for i := 0 to high(self.cards) do
   begin
    self.cards[i].Left:=((Form1.ClientWidth div 2)+(high(self.cards)*15 div 2)
                        -(c_width div 2) -i*15);
    self.cards[i].Top:=10;
    self.cards[i].Visible:=true;
   end;
end;


procedure TClientPosPlayer3.new_card;
begin
 SetLength(self.cards, (length(self.cards)+1));
 self.cards[high(self.cards)]:=card_create(config.client.background,1);
 self.cards[high(self.cards)].position := 0;
 self.cards[high(self.cards)].player:=4;
 self.position;
end;


procedure TClientPosPlayer3.position;
var
 i : integer;
begin
 if length(self.cards) <> 0 then
  for i := 0 to high(self.cards) do
   begin
    self.cards[i].Left:=(Form1.ClientWidth-10-c_width);
    self.cards[i].Top:=(((Form1.ClientHeight-Form1.StatusBar1.Height
                       -Form1.m_chat.Height-Form1.ed_chat.Height) div 2)
                       +(high(self.cards)*15 div 2)-(c_height div 2)-i*15);
    self.cards[i].Visible:=true;
   end;
end;


constructor TClientPosOpenCards.create;
var
 i: Integer;
begin
 SetLength(self.cards, 4);
 for i := 0 to high(self.cards) do
  begin
   self.cards[i]:=card_create(0,0);
   self.cards[i].position := i+1;
   self.cards[i].player:=-1;
  end;
 self.position;
end;


procedure TClientPosOpenCards.drop_card;
begin
end;


procedure TClientPosOpenCards.new_card(card : word; player: word);
var
 i: Integer;
 tempcard, tempplayer: word;
begin
 if self.cards[0].visible then
  begin
   if self.cards[1].visible then
    begin
     if self.cards[2].visible then
      begin
       if self.cards[3].visible then
        begin
         for i := -3 to 0 do
          begin
           tempcard:=self.cards[i*-1].card;
           tempplayer:=self.cards[i*-1].player;
           self.cards[i*-1].card := card;
           self.cards[i*-1].player := player;
           card:=tempcard;
           player:=tempplayer;
           self.cards[i*-1].imagerefresh;
          end;
        end
       else
        begin
         self.cards[3].card := card;
         self.cards[3].player := player;
         self.cards[3].imagerefresh;
        end;
      end
     else
      begin
       self.cards[2].card := card;
       self.cards[2].player := player;
       self.cards[2].imagerefresh;
      end;
    end
   else
    begin
     self.cards[1].card := card;
     self.cards[1].player := player;
     self.cards[1].imagerefresh;
    end;
  end
 else
  begin
   self.cards[0].card := card;
   self.cards[0].player := player;
   self.cards[0].imagerefresh;
  end;
 self.position;
end;


procedure TClientPosOpenCards.position;
var
 i : integer;
begin
 if length(self.cards) <> 0 then
  for i := 0 to high(self.cards) do
   begin
    if self.cards[i].player = -1 then self.cards[i].Visible:=false
    else self.cards[i].Visible:=true;
    self.cards[i].Left:=10+((Form1.ClientWidth div 2)+i*10);
    self.cards[i].Top:=(Form1.ClientHeight div 2)-(high(self.cards)*10 div 2)
                       -((c_height-high(self.cards))div 2)+(i*10)-19;
  end;
end;


procedure TClientPosDeck.drop_card;
begin
end;


constructor TClientPosDeck.create;
var
 i: Integer;
begin
 SetLength(self.cards, 5);
 for i := 0 to high(self.cards) do
  begin
   self.cards[i]:=card_create(config.client.background,1);
   self.cards[i].position := 0;
   self.cards[i].player:=0;
  end;
 self.position;
end;


procedure TClientPosDeck.position;
var
 i: integer;
begin
 if length(self.cards) <> 0 then
  for i := 0 to high(self.cards) do
   begin
    self.cards[i].Left:=((Form1.ClientWidth div 2)-10-c_width-high(self.cards)*3
                        +i*3);
    self.cards[i].Top:=(Form1.ClientHeight div 2)-(high(self.cards)*10 div 2)
                       -((c_height-high(self.cards)*3)div 2)+(i*3)-19;
    self.cards[i].Visible:=true;
   end;
end;


constructor TClientPosTocken.create(AOwner: TComponent);
begin
 inherited Create(AOwner);
 self.Parent:=Form1;
 self.Left:=0;
 self.Top:=0;
 self.Width:=25;
 self.Height:=25;
 self.Visible:=false;
 self.Transparent:=true;
 self.Canvas.Brush.Color:=clWhite;
 self.Canvas.Pen.Color:=clWhite;
 self.Canvas.Rectangle(0,0,self.Width,self.Height);
 self.Canvas.Brush.Color:=clLime;
 self.Canvas.Pen.Color:=clBlack;
 self.Canvas.Ellipse(0,0,self.Width,self.Height);
 self.sett(-1);
end;


procedure TClientPosTocken.sett(player: integer);
begin
 self.tockenplayer := player;
 self.position;
end;


procedure TClientPosTocken.position;
begin
 if self.tockenplayer = -1 then self.Visible:=false;
 if self.tockenplayer = 0 then
  begin
   self.Left:=(((Form1.ClientWidth-Form1.m_chat.Width) div 2)-(self.Width div 2));
   self.Top:=(Form1.ClientHeight-20-c_height-self.Height)-19;
   self.Visible:=true;
  end;
 if self.tockenplayer = 1 then
  begin
   self.Left:=20+c_width;
   self.Top:=((Form1.ClientHeight div 2)-(self.Height div 2))-19;
   self.Visible:=true;
  end;
 if self.tockenplayer = 2 then
  begin
   self.Left:=((Form1.ClientWidth div 2)-(self.Width div 2));
   self.Top:=20+c_height;
   self.Visible:=true;
  end;
 if self.tockenplayer = 3 then
  begin
   self.Left:=(Form1.ClientWidth-20-c_width-self.Width);
   self.Top:=(((Form1.ClientHeight-Form1.m_chat.Height-Form1.ed_chat.Height)div 2)
             -(self.Height div 2))-19;
   self.Visible:=true;
  end;
 self.BringToFront;
end;



end.
