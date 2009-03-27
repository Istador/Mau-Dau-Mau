unit UServer;
{
  author:     Robin Christopher Ladiges
  website:    http://blackpinguin.de/
  project:    Mau Dau Mau
  binary:     MauDauMau.exe
  unit:       UServer
  file:       UServer.pas
  filepath:   .\executable\units\
  year:       2008/2009
  desc:       This file handles the TServer Class. It manages the connections to
              the clients and informations from/to the clients/TServerGame.

  license:    creative commons by-nc-sa 3.0 germany
   look out license.txt in root folder
   human-readable summary : http://creativecommons.org/licenses/by-nc-sa/3.0/de/
}

interface
uses UScktComp, UServerGame, classes, SysUtils, Udll, windows, Uini;



type TServer = class(TServerSocket)
     public
     game : TServerGame;
     current_player:integer;
     playerslots : Array[1..3] of byte; // 0 : geschlossen   1 : offen
                                        // 2 : player    3 : computer
     player : Array[0..3] of TCustomWinSocket;
     // settings aus ini holen
     constructor create(AOwner: TComponent; port:integer);reintroduce;
     destructor Destroy; Override;
     procedure ClientDisconnect(Sender: TObject; Socket: TCustomWinSocket);
     procedure inichange;
     procedure playerstatchange;
     procedure newplayer(socket : TCustomWinSocket; username:string);
     procedure leftplayer(socket : TCustomWinSocket);
     procedure gamestart;
     function g_rules:string;
     function g_player:string;
     function g_playerslot:string;
     procedure send_one(socket : TCustomWinSocket; text : string);
     procedure send_all(text : string);
     procedure send;
     procedure Read(Sender: TObject; Socket: TCustomWinSocket);
     end;


var server : TServer;
implementation
uses FMainform, UServerCards;



constructor TServer.create(AOwner: TComponent; port:integer);
begin
 inherited create(AOwner);
 self.Port:=port;
 self.current_player:=0;
 self.playerslots[1]:=0;
 self.playerslots[2]:=0;
 self.playerslots[3]:=0;
 self.OnClientRead:=self.Read;
 self.OnClientDisconnect:=self.ClientDisconnect;
 self.Active:=true; //Server starten
end;


destructor TServer.Destroy;
begin
 self.send_all('disconnect;close;');
 self.send;
 self.Active:=false; //Server ausschalten
 if assigned(self.game) then FreeAndNil(self.game);
 server:=nil;
 inherited;
end;


procedure TServer.ClientDisconnect(Sender: TObject; Socket: TCustomWinSocket);
begin
 if (socket = self.player[0]) or (socket = self.player[1])
 or (socket = self.player[2]) or (socket = self.player[3])
 then
  begin
   self.leftplayer(socket); //aus self.player array entfernen
   self.send_all(g_player); //anderen spielern mitteilen
   if assigned(self.game) then self.game.playerleft(socket);//aus game entfernen
   self.send; //abschicken
  end;
end;


procedure TServer.inichange;
begin
 //nur bei änderung name/regeln
 if (self.Name <> config.server.name)
 or
 (
  assigned(self.game)
  and
  (
   (self.game.rules.seven_use <> config.server.seven_use)
   or
   (self.game.rules.seven_take <> config.server.seven_take)
   or
   (self.game.rules.eight_use <> config.server.eight_use)
   or
   (self.game.rules.nine_use <> config.server.nine_use)
   or
   (self.game.rules.nine_win <> config.server.nine_win)
   or
   (self.game.rules.bube_use <> config.server.bube_use)
   or
   (self.game.rules.bube_bube <> config.server.bube_bube)
  )
 )
 then
  begin
   self.send_all(g_rules);
   self.send;
  end;
end;


procedure TServer.playerstatchange;
var
 i: Integer;
begin
 for i := 1 to 3 do
  if assigned(self.player[i]) and (self.playerslots[i] = 0) then
   self.send_one(self.player[i],'disconnect;kick;');
 self.send_all(g_rules);
 self.send_all(g_playerslot);
 self.send;
end;


procedure TServer.newplayer(socket : TCustomWinSocket; username:string);
var
 i: integer;
begin
 if socket <> nil then
  begin
   socket.RL_username:=username;
   if socket.RemoteAddress = '127.0.0.1' then
    self.player[0]:=socket
   else if self.playerslots[1] = 1 then
    begin
     self.player[1]:=socket;
     self.playerslots[1]:=2;
    end
   else if self.playerslots[2] = 1 then
    begin
     self.player[2]:=socket;
     self.playerslots[2]:=2;
    end
   else if self.playerslots[3] = 1 then
    begin
     self.player[3]:=socket;
     self.playerslots[3]:=2;
    end
   else
    begin
     socket.RL_username:='';
     self.send_one(socket,'disconnect;full;'); // alle slots voll
    end;
   if socket.RL_username <> '' then
    for i := 0 to 3 do
     if assigned(self.player[i]) then
      begin
       if (socket<>self.player[i])and(self.player[i].RL_username=username) then
        username:='';
       break;
      end;
   if username <> '' then
    begin
     self.send_one(socket,g_rules);
     self.send_all(g_playerslot);
     self.send_all(g_player);
    end
   else self.send_one(socket,'disconnect;username;');
  end;
end;


procedure TServer.leftplayer(socket: TCustomWinSocket);
var
 i : integer;
begin
 for i := 1 to 3 do
  if self.player[i] = socket then
   begin
    self.player[i]:=nil;
    if (self.playerslots[i] > 1) then self.playerslots[i]:=1;
   end;
end;


procedure TServer.gamestart;
begin
 if not assigned(self.game) then
  begin
   if not assigned(self.player[self.current_player]) then
    self.current_player:=0;
   self.game:=TServerGame.create(self.current_player,self.player[0],
                                 self.player[1],self.player[2],self.player[3]);
  end;
end;


function TServer.g_rules : string;
var
 now: TDateTime;
 var3, var4: string;
begin                 // rules;stunde;minute;rest
 now:=Time; //<- Funktion
 var3:=Copy(TimeToStr(now),0,2);
 var4:=Copy(TimeToStr(now),4,2);
 result:='rules;'+var3+';'+var4+';'
         +booltostr(config.server.seven_use)+';'
         +booltostr(config.server.eight_use)+';'
         +booltostr(config.server.nine_use)+';'
         +booltostr(config.server.bube_use)+';'
         +inttostr(config.server.seven_take)+';'
         +booltostr(config.server.nine_win)+';'
         +booltostr(config.server.bube_bube)+';'
         +config.server.name+';';
end;


function TServer.g_player : string;
begin
 result:='player;';
 if assigned(self.player[0]) then
  result:=result+player[0].RL_username+';'
 else result:=result+';';
 if assigned(self.player[1]) and (self.playerslots[1]<>0) then
  result:=result+player[1].RL_username+';'
 else result:=result+';';
 if assigned(self.player[2]) and (self.playerslots[2]<>0) then
  result:=result+player[2].RL_username+';'
 else result:=result+';';
 if assigned(self.player[3]) and (self.playerslots[3]<>0) then
  result:=result+player[3].RL_username+';'
 else result:=result+';';
end;


function TServer.g_playerslot : string;
begin
 result:='playerslot;2;'
         +inttostr(self.playerslots[1])+';'
         +inttostr(self.playerslots[2])+';'
         +inttostr(self.playerslots[3])+';';
end;


procedure TServer.send_one(socket : TCustomWinSocket; text : string);
begin
 socket.RL_AddText(text);
end;


procedure TServer.send_all(text : string);
var
 i: Integer;
begin
 for i:= 0 to 3 do
  if assigned(player[i]) then self.send_one(player[i],text);
end;


procedure TServer.send;
var
 i: Integer;
begin
 for i:= 0 to self.Socket.ActiveConnections-1 do
  self.Socket.Connections[i].RL_SendText;
end;


procedure TServer.Read(Sender: TObject; Socket: TCustomWinSocket);
var
 text, var1, var2, var3, var4: string;
 now: TDateTime;
 i: Integer;
begin
 text:=Socket.ReceiveText;
//##############################################################################
//##############################################################################
//##############################################################################
 var1:=part(';',0,text);
//###############################################################  connect  ####
 if (var1 = 'connect') then  //connect;username;
  begin
   var2:=part(';',1,text);
   if assigned(self.game) then //game is running
    self.send_one(socket,'disconnect;running;')
   else
    begin
     if config.server.password = '' then
      self.newplayer(socket,var2)
     else if socket.RemoteAddress = '127.0.0.1' then
      self.newplayer(socket,var2)
     else
      self.send_one(socket,'password;');
    end;
  end
//##############################################################  password  ####
 else if var1 = 'password' then // password;username;password;
  begin
   var2:=part(';',1,text);
   var3:=part(';',2,text);
   if var3 = config.server.password then
    self.newplayer(socket,var2)
   else
    self.send_one(socket,'disconnect;password;');
  end
//##############################################################################
//############################### start chatbefehle  ###########################

//##################################################################  text  ####
 else if (var1 = 'text') then
  begin
   var2:=part(';',1,text);
   now:=Time; //<- Funktion
   var3:=Copy(TimeToStr(now),0,2);
   var4:=Copy(TimeToStr(now),4,2);
   self.send_all('text;'+socket.RL_username+';'+var3+';'+var4+';'+var2+';');
  end
//############################################################  namechange  ####
 else if (var1 = 'namechange') then
  begin        //namechange;oldname;newname;
   var2:=part(';',1,text);
   var3:=part(';',2,text);
   var4:='1';
   for i := 0 to 3 do
    if assigned(self.player[i]) and (self.player[i].RL_username = var3) then
     var4:='0';
   if var4 = '1' then
    begin
     for i := 0 to 3 do
      if assigned(self.player[i]) and (var2 = self.player[i].RL_username) then
       self.player[i].RL_username:=var3;
     self.send_all('namechange;'+var2+';'+var3+';');
    end;
  end

//################################ ende chatbefehle  ###########################
//##############################################################################
 else if assigned(self.game) then //############################################
  begin //######################################################################
//##############################################################################
//############################### start gamebefehle  ###########################

//###################################################################  out  ####
   if (var1 = 'out') then  // out;
    self.game.play_out(socket)
//################################################################  wunsch  ####
   else if (var1 = 'wunsch') then  // wunsch;farbe;
    begin
     var2:=part(';',1,text);
     self.game.play_wunsch(socket,strtoint(var2));
    end
//##################################################################  card  ####
   else if (var1 = 'card') then  // card;card;
    begin
     var2:=part(';',1,text);
     self.game.play_card(socket,self.game.gcard(strtoint(var2)));
    end
//##################################################################  draw  ####
   else if (var1 = 'draw') and (self.game.play_draw(socket)) then  // draw;
    self.send_all(self.game.nextplayer)
//##############################################################  gameleft  ####
   else if (var1 = 'gameleft') then  // gameleft;
    self.game.playerleft(socket)
//###########################################################  cardammount  ####
   else if (var1 = 'cardammount') then //cardammount;anzahl;
    begin
     // newgame;player0;player1;player2;player3;
     var2:=part(';',1,text);
     text:='newgame;';
     if assigned(self.game.player[0]) then
      text:=text+self.game.player[0].RL_username+';'
     else text:=text+';';
     if assigned(self.game.player[1]) then
      text:=text+self.game.player[1].RL_username+';'
     else text:=text+';';
     if assigned(self.game.player[2]) then
      text:=text+self.game.player[2].RL_username+';'
     else text:=text+';';
     if assigned(self.game.player[3]) then
      text:=text+self.game.player[3].RL_username+';'
     else text:=text+';';
     self.send_all(text);
     text:='';
     if assigned(self.game.player[0]) then
      begin
       self.game.nextplayer;
       self.game.ziehen:=strtoint(var2);
       self.game.play_draw(self.game.player[self.game.current_player]);
      end;
     if assigned(self.game.player[1]) then
      begin
       self.game.nextplayer;
       self.game.ziehen:=strtoint(var2);
       self.game.play_draw(self.game.player[self.game.current_player]);
      end;
     if assigned(self.game.player[2]) then
      begin
       self.game.nextplayer;
       self.game.ziehen:=strtoint(var2);
       self.game.play_draw(self.game.player[self.game.current_player]);
      end;
     if assigned(self.game.player[3]) then
      begin
       self.game.nextplayer;
       self.game.ziehen:=strtoint(var2);
       self.game.play_draw(self.game.player[self.game.current_player]);
      end;
     self.game.play_draw(nil);
     self.send_all(self.game.nextplayer);
    end;
//################################ ende gamebefehle  ###########################
//##############################################################################
  end;
//##############################################################################
//##############################################################################
//##############################################################################
 self.send;
end;





end.
