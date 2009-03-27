unit UServerGame;
{
  author:     Robin Christopher Ladiges
  website:    http://blackpinguin.de/
  project:    Mau Dau Mau
  binary:     MauDauMau.exe
  unit:       UServerGame
  file:       UServerGame.pas
  filepath:   .\executable\units\
  year:       2008/2009
  desc:       This file handles the TServerGame class, this class takes care of
              the rules and take some random decisions (like drawing a card).

  license:    creative commons by-nc-sa 3.0 germany
   look out license.txt in this folder
   human-readable summary : http://creativecommons.org/licenses/by-nc-sa/3.0/de/
}

interface
uses UServerCards, SysUtils, UIni, UScktComp;

type TServerGame = class
     player : Array [0..3] of TCustomWinSocket;
     current_player : integer;
     current_farbe : integer;
     cards : Array[0..51] of TServerCards;
     ziehen : 0..16;
     out : 0..1;
     rules : TIniRules; // werden beim create ausm TServer kopiert.
     constructor create(current_player : word; player0, player1, player2,
                        player3 : TCustomWinSocket);
     destructor Destroy; Override;
     function gcard(card:word) : TServerCards;
     function last_card : TServerCards;
     function player_position(socket : TCustomWinSocket):integer;
     function player_cardammount(playerposition : integer):integer;
     function nextplayer:string;
     procedure playerleft(socket : TCustomWinSocket);
     procedure wincheck;
     function play_out(socket : TCustomWinSocket):boolean;
     function play_draw(socket : TCustomWinSocket) : boolean;
     function play_wunsch(socket : TCustomWinSocket; vfarbe : integer):boolean;
     function play_card(socket : TCustomWinSocket; card : TServerCards):boolean;
     procedure play_card_ok(card : TServerCards);

     end;

implementation
uses Udll, UServer;



constructor TServerGame.create(current_player : word; player0, player1, player2,
                               player3 : TCustomWinSocket);
var
 i: integer;
begin
 self.current_player:=current_player;
 self.player[0] :=player0;
 self.player[1] :=player1;
 self.player[2] :=player2;
 self.player[3] :=player3;
 with self.rules do
  begin
   seven_use:=config.server.seven_use;
   seven_take:=config.server.seven_take;
   eight_use:=config.server.eight_use;
   nine_use:=config.server.nine_use;
   nine_win:=config.server.nine_win;
   bube_use:=config.server.bube_use;
   bube_bube:=config.server.bube_bube;
  end;
 self.ziehen := 0;
 self.out := 0;
 for i := 0 to 51  do
  self.cards[i]:=TServerCards.create(i,0,0);
 server.send_one(self.player[self.current_player],'cardammount;');
 server.send;
end;


destructor TServerGame.Destroy;
var
 i: Integer;
begin
 server.current_player:=self.current_player;
 server.send_all('endgame;');
 for i := high(player) downto 0 do self.player[i]:=nil;
 for i := high(cards) downto 0 do FreeAndNil(self.cards[i]);
 server.game:=nil;
 inherited;
end;


function TServerGame.gcard(card: Word):TServerCards;
var
 i: integer;
begin
 result:=nil;
 for i := low(self.cards) to high(self.cards) do
  if self.cards[i].card = card then
   begin
    result:=self.cards[i];
    break;
   end;
end;


function TServerGame.last_card:TServerCards;
var
 i: integer;
begin
 result:=nil;
 for i := low(self.cards) to high(self.cards) do
  if self.cards[i].position = 4 then
   begin
    result:=self.cards[i];
    break;
   end;
end;


function TServerGame.player_position(socket: TCustomWinSocket):Integer;
var
 i: Integer;
begin
 result:=-2;
 for i := 0 to high(self.player) do
  if socket = self.player[i] then
   begin
    result:=i;
    break;
   end;
end;


function TServerGame.player_cardammount(playerposition : integer):integer;
var
 i: Integer;
begin
 result:=0;
 for i := 0 to high(self.cards) do
  if(self.cards[i].player-1=playerposition)and(self.cards[i].position=0) then
   inc(result);
end;


function TServerGame.nextplayer;
begin
 if self.player[self.current_player] = self.player[0] then
  begin
   if assigned(self.player[1]) then self.current_player:=1
   else if assigned(self.player[2]) then self.current_player:=2
   else if assigned(self.player[3]) then self.current_player:=3
   else self.current_player:=0;
  end
 else if self.player[self.current_player] = self.player[1] then
  begin
   if assigned(self.player[2]) then self.current_player:=2
   else if assigned(self.player[3]) then self.current_player:=3
   else if assigned(self.player[0]) then self.current_player:=0
   else self.current_player:=1;
  end
 else if self.player[self.current_player] = self.player[2] then
  begin
   if assigned(self.player[3]) then self.current_player:=3
   else if assigned(self.player[0]) then self.current_player:=0
   else if assigned(self.player[1]) then self.current_player:=1
   else self.current_player:=2;
  end
 else if self.player[self.current_player] = self.player[3] then
  begin
   if assigned(self.player[0]) then self.current_player:=0
   else if assigned(self.player[1]) then self.current_player:=1
   else if assigned(self.player[2]) then self.current_player:=2
   else self.current_player:=3;
  end;
 if self.last_card <> nil then
  result:='turn;'+inttostr(self.current_player)+';'+inttostr(self.ziehen)+';'
          +inttostr(self.out)+';'
 else result:='';
end;


procedure TServerGame.playerleft(socket: TCustomWinSocket);
var
 i: Integer;
begin
 for i := 0 to high(self.cards) do
  if (self.cards[i].position=0)
  and ((self.cards[i].player-1) = self.player_position(socket))
  then
   begin
    self.cards[i].position := 0;
    self.cards[i].player := 0;
   end;
 for i := 0 to 3 do
  if assigned(server.player[i])
  and (server.player[i].RL_username=socket.RL_username) then
   begin //ausgeben wenn der spieler auf server bleibt, nicht bei disconnect
    server.send_all('gameleft;'+inttostr(self.player_position(socket))+';');
    break;
   end;
 if self.player[self.current_player]=socket then
  server.send_all(self.nextplayer);
 if self.player[0] = socket then self.player[0]:=nil
 else if self.player[1] = socket then self.player[1]:=nil
 else if self.player[2] = socket then self.player[2]:=nil
 else if self.player[3] = socket then self.player[3]:=nil;
 self.wincheck;
end;


procedure TServerGame.wincheck;
var
 temp: integer;
begin
 temp:=0;
 if assigned(self.player[0]) then inc(temp);
 if assigned(self.player[1]) then inc(temp);
 if assigned(self.player[2]) then inc(temp);
 if assigned(self.player[3]) then inc(temp);
 if self.player_cardammount(self.current_player) = 1 then
  begin
   //letzte karte
   server.send_all('win;'+inttostr(self.current_player)+';-1;');
   if (wert(self.last_card.card) <> 8 ) or (not self.rules.nine_use) then
    server.send_all(self.nextplayer);
  end
 else if self.player_cardammount(self.current_player) = 0 then
  begin
   //gewonnen
   if temp>1 then server.send_all('win;'+inttostr(self.current_player)+';'
                                  +inttostr(temp-1)+';');
   //currentplayer aus game entfernen
   self.player[self.current_player]:=nil;
   if temp = 2 then
    begin
     self.nextplayer;
     server.send_all('win;'+inttostr(self.current_player)+';0;');
     server.send_all('turn;-1;0;0;');
     self.Free;
    end
   else
    begin
     if (wert(self.last_card.card) <> 8 ) or (not self.rules.nine_use) then
      server.send_all(self.nextplayer);
    end;
  end
 else if (wert(self.last_card.card) <> 8 ) or (not self.rules.nine_use) then
  server.send_all(self.nextplayer);
 if temp = 1 then
  begin
   server.send_all('win;'+inttostr(self.current_player)+';1;');
   server.send_all('turn;-1;0;0;');
   self.Free;
  end;
end;


function TServerGame.play_out(socket: TCustomWinSocket):boolean;
begin
 result:=false;
 if self.rules.eight_use and (socket = self.player[self.current_player]) then
  begin
   if self.out = 1 then
    begin
     self.out:=0;
     //nächster spieler
     server.send_all('out;'+inttostr(self.current_player)+';');
     server.send_all(self.nextplayer);
     result:=true;
    end
   else
    begin
     //kann nicht keine 8
     server.send_one(socket,'wrong;4;');
     result:=false;
    end;
  end;
end;


function TServerGame.play_draw(socket: TCustomWinSocket) : boolean;
var
 i,temp: Integer;
begin
 result:=false;
 temp:=0;
 if self.ziehen = 0 then self.ziehen:=1;
 for i := low(self.cards) to high(self.cards) do
  if (self.cards[i].position = 0) and (self.cards[i].player = 0) then
   temp:=temp+1;
 if temp >= self.ziehen then
  begin
   if self.out = 0 then
    begin
     if socket = self.player[self.current_player] then
      begin
       server.send_all('draw;'+inttostr(self.current_player)+';'
                       +inttostr(self.ziehen)+';');
       for i := 1 to self.ziehen do
        begin
         temp:=-1;
         while temp = -1 do
          begin
           temp:=random(52);
           if (self.cards[temp].position=0)and(self.cards[temp].player=0) then
            begin
             self.cards[temp].position:=0;
             self.cards[temp].player:=self.player_position(socket)+1;
             server.send_one(socket,'yourcard;'+inttostr(self.cards[temp].card)
                             +';');
             result:=true;
             break;
            end
           else temp:=-1;
          end;
        end;
      end
     else if socket = nil then
      begin
       temp:=-1;
       while temp = -1 do
        begin
         temp:=random(52);
         if (self.cards[temp].position = 0) and (self.cards[temp].player = 0) then
          begin
           self.cards[temp].position:=4;
           self.cards[temp].player:=0;
           self.current_farbe:=farbe(self.cards[temp].card);
           server.send_all('card;0;'+inttostr(self.cards[temp].card)+';');
           result:=true;
           break;
          end
         else temp:=-1;
        end;
      end;
    end
   else
    begin
     //wenn eine 8 gespielt wurde
     server.send_one(socket,'wrong;2;');
     result:=false;
    end;
  end
 else
  begin
   //nicht genug karten spiel abbruch
   result:=false;
  end;
 self.ziehen := 0;
end;


function TServerGame.play_wunsch(socket: TCustomWinSocket; vfarbe: Integer)
         :boolean;
begin
 result:=false;
 if socket = self.player[self.current_player] then
  if vfarbe <> current_farbe then
   begin
    result:=true;
    current_farbe:=vfarbe;
    server.send_all('uwunsch;'+inttostr(self.current_player)+';'
                    +inttostr(vfarbe)+';');
    self.wincheck;
   end
  else
   begin
    //mitteilen das die farbe falsch ist.
    server.send_one(socket,'wunsch;'+inttostr(current_farbe)+';');
   end;
end;


function TServerGame.play_card(socket: TCustomWinSocket; card: TServerCards)
         :boolean;
begin
 result:=false;
 if socket = self.player[self.current_player] then
  begin
   if (wert(card.card) = 6) and (self.rules.seven_use) and (self.out=0) then   //7
    begin
     if self.ziehen = 0 then
      begin
       if (current_farbe = farbe(card.card))
       or (wert(self.last_card.card) = wert(card.card))
       then
        begin
         self.ziehen := self.rules.seven_take;
         // sieben spielen
         self.play_card_ok(card);
         result:=true;
        end
       else result:=false; //kann nicht spielen, karte passt nicht
      end
     else if wert(self.last_card.card) = 6 then
      begin
       self.ziehen:=self.ziehen+self.rules.seven_take;
       //sieben spielen
       self.play_card_ok(card);
       result:=true;
      end;
    end
   else if (wert(card.card)=7)and(self.rules.eight_use)and(self.ziehen=0)then
    begin //8
     if (current_farbe = farbe(card.card))
     or (wert(self.last_card.card) = wert(card.card))
     then
      begin
       self.out:=1;
       //acht spielen
       self.play_card_ok(card);
       result:=true;
      end
     else result:=false; //kann nicht spielen, karte passt nicht
    end
   else if (wert(card.card)=8)and(self.rules.nine_use)and(self.ziehen=0)
   and(self.out=0) then    //9
    begin
     if (current_farbe = farbe(card.card))
     or (wert(self.last_card.card) = wert(card.card))
     then
      begin
       //neun spielen
       self.play_card_ok(card);
       result:=true;
      end
     else result:=false; //kann nicht spielen, karte passt nicht
    end
   else if (wert(card.card) = 10) and (self.rules.bube_use)
   and (self.ziehen = 0) and (self.out=0)
   then    //Bube
    begin
     if (wert(self.last_card.card) = wert(card.card)) then
      begin
       if self.rules.bube_bube then
        begin
         //spiele buben
         self.play_card_ok(card);
         server.send_one(socket,'wunsch;'+inttostr(self.current_farbe)+';');
         result:=true;
        end
       else result:=false; //kann buben nicht spielen
      end
     else
      begin
       //spiele buben
       self.play_card_ok(card);
       server.send_one(socket,'wunsch;'+inttostr(self.current_farbe)+';');
       result:=true;
      end;
    end
   else
    begin
     if ((current_farbe=farbe(card.card))
     or(wert(self.last_card.card)=wert(card.card)))
     and (self.ziehen = 0) and (self.out=0)
     then
      begin
       //spiele karte
       self.play_card_ok(card);
       result:=true;
      end
     else result:=false; //kann nicht spielen, karte passt nicht
    end;
  end;
 if result = false then
  if (wert(card.card) = 10) and (wert(self.last_card.card) = 10) then
   server.send_one(socket,'wrong;3;')
  else if self.out = 1 then server.send_one(socket,'wrong;2;')
  else if self.ziehen > 0 then server.send_one(socket,'wrong;1;')
  else server.send_one(socket,'wrong;0;');
end;


procedure TServerGame.play_card_ok(card: TServerCards);
var
 i:integer;
begin
 for i := 0 to high(self.cards) do
  if self.cards[i].position = 4 then
   self.cards[i].position := 3
  else if self.cards[i].position = 3 then
   self.cards[i].position := 2
  else if self.cards[i].position = 2 then
   self.cards[i].position := 1
  else if self.cards[i].position = 1 then
   begin
    self.cards[i].position := 0;
    self.cards[i].player := 0;
   end;
 card.position:=4;
 server.send_all('card;'+inttostr(self.current_player+1)+';'+inttostr(card.card)
                 +';');
 if (wert(card.card) <> 10) or (self.rules.bube_use = false) then
  begin
   //wenn kein bube gespielt wurde
   current_farbe:=farbe(card.card);
   if (wert(card.card) <> 8 )
   or (not self.rules.nine_use)
   or (self.rules.nine_win)
   then self.wincheck;
  end
end;



end.
