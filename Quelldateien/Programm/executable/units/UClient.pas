unit UClient;
{
  author:     Robin Christopher Ladiges
  website:    http://blackpinguin.de/
  project:    Mau Dau Mau
  binary:     MauDauMau.exe
  unit:       UClient
  file:       UClient.pas
  filepath:   .\executable\units\
  year:       2008/2009
  desc:       This file handles the TClient class. This class represents the
              Client site of the connection to the server and the pre/after
              gameround time.

  license:    creative commons by-nc-sa 3.0 germany
   look out license.txt in root folder
   human-readable summary : http://creativecommons.org/licenses/by-nc-sa/3.0/de/
}

interface
uses UClientGame, ScktComp, SysUtils, StdCtrls, classes, ComCtrls, UIni;

type TClient = class(TClientSocket)
     public
     game : TClientGame;
     rules : TIniRules;
     servername:string;
     firstrules : boolean; // true=die ersten regeln;
     firstplayer: boolean; //um zu gucken ob ein -neuer- spieler beitritt
     playername:string;
     player : Array[0..3] of string;
     playerslots : Array[0..3] of byte;
     constructor create(AOwner: TComponent; host: string; port: integer);
                 reintroduce;
     destructor Destroy;Override;
     procedure Connect(Sender: TObject; Socket: TCustomWinSocket);
     procedure ownerror(Sender: TObject; Socket: TCustomWinSocket;
                        ErrorEvent: TErrorEvent; var ErrorCode: Integer);
     procedure inichange;
     procedure chatline(text: string);
     function s_farbe(card: string):string;
     function s_wert(card: string):string;
     procedure send_text(text: string);
     procedure Read(Sender: TObject; Socket: TCustomWinSocket);
     end;

var Client: TClient;

implementation
uses FMainform, FPlayer, ULanguage, Udll, UDialogs;



constructor TClient.create(AOwner: TComponent; host:string; port:integer);
begin
 inherited create(AOwner); //der vererbte constructor
 self.Host:=host;
 self.Port:=port;
 self.OnConnect:=self.Connect;
 self.OnRead:=self.Read;
 self.OnError:=self.ownerror;
 self.firstrules:=false;
 self.firstplayer:=false;
 self.playername:=config.client.name;
 self.Active:=true;
end;


destructor TClient.Destroy;
begin
 self.Active:=false;
 if assigned(Form5) then Form5.Close;
 if assigned(self.game) then FreeAndNil(self.game);
 with Form1 do //so brauch ich nicht immer Form1 vor die objekte schreiben
  begin
   ed_chat.Visible:=false;
   but_chat.Visible:=false;
   m_chat.Visible:=false;
   m_chat.Clear;
   NeuesSpiel1.Caption:=lang.Mainform.MM_0_0_0;
   SpielBeitreten1.Caption:=lang.Mainform.MM_0_1_0;
   NeuesSpiel1.Visible:=true;
   SpielBeitreten1.Visible:=true;
   if StatusBar1.Panels[0].Text = lang.Mainform.SB_0_1+' '+self.Host then
    StatusBar1.Panels[0].Text:=lang.Mainform.SB_0_0;
  end;
 client:=nil; //damit ich überall mit Assigned prüfen kann
 inherited; //der vererbte destructor
end;


procedure TClient.Connect(Sender: TObject; Socket: TCustomWinSocket);
begin
 Form1.StatusBar1.Panels[0].Text:=lang.Mainform.SB_0_1+' '+self.Host;
 self.send_text('connect;'+self.playername+';');
 Form5:=TForm5.Create(Form1,self);
 Form5.Left := Form1.Left + (Form1.Width div 2) - (Form5.Width div 2);
 Form5.Top := Form1.Top + (Form1.Height div 2) - (Form5.Height div 2);
 Form5.ShowModal;
end;


procedure TClient.ownerror(Sender: TObject; Socket: TCustomWinSocket;
                           ErrorEvent: TErrorEvent; var ErrorCode: Integer);
var
 meldung:string;
begin
 ErrorCode:=0; //methode löst keine Exception aus | dafür showmessage von mir
 if ErrorEvent = eeGeneral then meldung:=lang.Mainform.SB_0_2;
 if ErrorEvent = eeSend then meldung:=lang.Mainform.SB_0_3;
 if ErrorEvent = eeReceive then meldung:=lang.Mainform.SB_0_4;
 if ErrorEvent = eeConnect then meldung:=lang.Mainform.SB_0_5;
 if ErrorEvent = eeDisconnect then meldung:=lang.Mainform.SB_0_6;
 Form1.StatusBar1.Panels[0].Text:=meldung;
 self.Free;
end;


procedure TClient.inichange;
var
 temp: string;
begin
 if config.client.name <> self.playername then
  begin
   temp:=config.client.name;
   config.client.name:=self.playername;
   self.send_text('namechange;'+self.playername+';'+temp+';');
  end;
end;


procedure TClient.chatline(text : string);
begin
 Form1.m_chat.Lines.Add(text);
 if assigned(Form5) then Form5.m_chat.Lines.Add(text);
end;


function TClient.s_farbe(card : string):string;
begin
 result:=lang.Generic.Color[farbe(strtoint(card))]
end;


function TClient.s_wert(card : string):string;
begin
 result:=lang.Generic.Face[wert(strtoint(card))]
end;


procedure TClient.send_text(text : string);
begin
 self.Socket.SendText(text);
end;


procedure TClient.Read(Sender: TObject; Socket: TCustomWinSocket);
var
 rec,text, //rec=die gesammte nachricht die kommt; text=einzelne in schleife
 var1,var2,var3,var4,var5, //parameter der Nachrichten
 hsis //he she it s kommt mit falls englisch
 : string;
 i,a,temp : integer;
{ b: TStringList; } //für protokollierung der eingehenden nachrichten testzwecke
begin
 rec:=Socket.ReceiveText;
 {b:=TStringList.Create;
 b.LoadFromFile(ExtractFilePath(ParamStr(0))+'clog.txt');
 b.Add(rec);
 b.SaveToFile(ExtractFilePath(ParamStr(0))+'clog.txt');}
 for a := 1 to strtoint(part('#',0,rec)) do
  begin
   text:=part('#',a,rec);
   var1:=part(';',0,text);
//##############################################################################
//##############################################################################
//##############################################################################

//############################################################  disconnect  ####
   if (var1 = 'disconnect') then
    begin
     var2:=part(';',1,text);
     if var2 = 'full' then var3:=lang.Mainform.SB_0_7
     else if var2 = 'running' then var3:=lang.Mainform.SB_0_8
     else if var2 = 'username' then var3:=lang.Mainform.SB_0_9
     else if var2 = 'kick' then var3:=lang.Mainform.SB_0_10
     else if var2 = 'password' then var3:=lang.Mainform.SB_0_11
     else if var2 = 'close' then var3:=lang.Mainform.SB_0_12;
     Form1.StatusBar1.Panels[0].Text:=var3;
     self.Free;
    end;
//##############################################################  password  ####
   if var1 = 'password' then
    begin
     if assigned(Form5) then Form5.Hide;
     while (var2='') and
     InputQuery(lang.Mainform.Crea_1_0,lang.Mainform.Crea_0_2,var2,Form1)
     do
      begin
       if var2 = '' then ShowMessage(lang.Mainform.Crea_1_6,Form1)
       else self.send_text('password;'+self.playername+';'+var2+';');
      end;
     if assigned(Form5) then Form5.Show;
     if var2 = '' then self.free;
    end;
//############################################################  namechange  ####
   if var1 = 'namechange' then
    begin        //namechange;oldname;newname;
     var2:=part(';',1,text);
     var3:=part(';',2,text);
     if var2 = self.playername then
      begin
       self.playername:=var3;
       config.client.name:=var3;
      end;
     for i := 0 to 3 do if self.player[i] = var2 then self.player[i]:=var3;
     if assigned(self.game) then
      begin
       if assigned(self.game.PlayerSelf)and(self.game.PlayerSelf.name = var2)then
        self.game.PlayerSelf.name:=var3;
       if assigned(self.game.Player1)and(self.game.Player1.name = var2)then
        self.game.Player1.name:=var3;
       if assigned(self.game.Player2)and(self.game.Player2.name = var2)then
        self.game.Player2.name:=var3;
       if assigned(self.game.Player3)and(self.game.Player3.name = var2)then
        self.game.Player3.name:=var3;
      end;
     if assigned(Form5) then Form5.load_client;
    end;
//#################################################################  rules  ####
   if var1 = 'rules' then
    begin
     if (self.firstrules)
     and ((self.rules.seven_use <> strtobool(part(';',3,text)))
     or (self.rules.eight_use <> strtobool(part(';',4,text)))
     or (self.rules.nine_use <> strtobool(part(';',5,text)))
     or (self.rules.bube_use <> strtobool(part(';',6,text)))
     or (self.rules.seven_take <> strtoint(part(';',7,text)))
     or (self.rules.nine_win <> strtobool(part(';',8,text)))
     or (self.rules.bube_bube <> strtobool(part(';',9,text)))) then
      begin
       var2:=part(';',1,text);
       var3:=part(';',2,text);
       self.chatline(lang.Mainform.Chat_0+'('+var2+':'+var3+')');
      end;
     self.firstrules:=true;
     with self.rules do
      begin
       seven_use := strtobool(part(';',3,text));
       eight_use := strtobool(part(';',4,text));
       nine_use := strtobool(part(';',5,text));
       bube_use := strtobool(part(';',6,text));
       seven_take:= strtoint(part(';',7,text));
       nine_win := strtobool(part(';',8,text));
       bube_bube := strtobool(part(';',9,text));
      end;
     self.servername:=part(';',10,text);
     if assigned(Form5) then
      begin
       Form5.Caption:=self.servername;
      end;
    end;
//################################################################  player  ####
   if var1 = 'player' then   // player;name1;name2;name3;name4;
    begin
     var2:=part(';',1,text);
     var3:=part(';',2,text);
     var4:=part(';',3,text);
     var5:=part(';',4,text);
     if self.firstplayer then
      begin
       if (self.player[0] <> var2) and (self.player[0]='') then
        self.chatline('['+var2+'] '+lang.Mainform.Chat_9_0);
       if (self.player[1] <> var3) and (self.player[1]='') then
        self.chatline('['+var3+'] '+lang.Mainform.Chat_9_0);
       if (self.player[2] <> var4) and (self.player[2]='') then
        self.chatline('['+var4+'] '+lang.Mainform.Chat_9_0);
       if (self.player[3] <> var5) and (self.player[3]='') then
        self.chatline('['+var5+'] '+lang.Mainform.Chat_9_0);
       if (self.player[0] <> var2) and (var2='') then
        self.chatline('['+self.player[0]+'] '+lang.Mainform.Chat_9_1);
       if (self.player[1] <> var3) and (var3='') then
        self.chatline('['+self.player[1]+'] '+lang.Mainform.Chat_9_1);
       if (self.player[2] <> var4) and (var4='') then
        self.chatline('['+self.player[2]+'] '+lang.Mainform.Chat_9_1);
       if (self.player[3] <> var5) and (var5='') then
        self.chatline('['+self.player[3]+'] '+lang.Mainform.Chat_9_1);
      end
     else self.firstplayer:=true;
     self.player[0]:=var2;
     self.player[1]:=var3;
     self.player[2]:=var4;
     self.player[3]:=var5;
     if assigned(Form5) then Form5.load_client;
    end;
//############################################################  playerslot  ####
   if var1 = 'playerslot' then // playerslot;slot1;slot2;slot3;slot4;
    begin
     self.playerslots[0]:=strtoint(part(';',1,text));
     self.playerslots[1]:=strtoint(part(';',2,text));
     self.playerslots[2]:=strtoint(part(';',3,text));
     self.playerslots[3]:=strtoint(part(';',4,text));
     if assigned(Form5) then Form5.load_client;
    end;

//##############################################################################
//############################### start chatbefehle  ###########################

//##################################################################  text  ####
   if (var1 = 'text') then  //text;username;stunde;minute;text;
    begin
     var2:=part(';',1,text);
     var3:=part(';',2,text);
     var4:=part(';',3,text);
     var5:=part(';',4,text);
     self.chatline(var2+'('+var3+':'+var4+'): '+var5);
    end;
//################################ ende chatbefehle  ###########################
//##############################################################################
   if not assigned(self.game) then //###########################################
    begin //####################################################################
//##############################################################################
//############################# start vor-gamebefehle  #########################

//###############################################################  newgame  ####
     if (var1 = 'newgame') then  //newgame;0name;1name;2name;3name;
      begin
       var2:=part(';',1,text);
       var3:=part(';',2,text);
       var4:=part(';',3,text);
       var5:=part(';',4,text);
       Form1.ed_chat.Visible:=true;
       Form1.but_chat.Visible:=true;
       Form1.m_chat.Visible:=true;
       if assigned(Form5) then Form5.Close;
       if (var2 = self.playername) then
        self.game:=TClientGame.create(self.playername,var3,var4,var5,1,2,3,4,
                                      self.rules)
       else if (var3 = self.playername) then
        self.game:=TClientGame.create(self.playername,var4,var5,var2,2,3,4,1,
                                      self.rules)
       else if (var4 = self.playername) then
        self.game:=TClientGame.create(self.playername,var5,var2,var3,3,4,1,2,
                                      self.rules)
       else if (var5 = self.playername) then
        self.game:=TClientGame.create(self.playername,var2,var3,var4,4,1,2,3,
                                      self.rules)
      end;
//###########################################################  cardammount  ####
     if (var1 = 'cardammount') then //cardammount;
      begin
       var2:=inttostr(config.client.austeilen);
       var3:='';
       while (var3='') and
       (InputQuery(lang.Mainform.Crea_1_0,lang.Mainform.Crea_0_3,var2,Form1))
       do
        begin
         if trystrtoint(var2,temp) then
          begin
           if (strtoint(var2) >= 4) and (strtoint(var2) <= 10) then var3:=var2
           else
            begin
             ShowMessage(lang.Mainform.Crea_1_3,Form1);
             var2:=inttostr(config.client.austeilen);
             var3:='';
            end;
          end
         else
          begin
           ShowMessage(lang.Mainform.Crea_1_1,Form1);
           var2:=inttostr(config.client.austeilen);
           var3:='';
          end;
        end;
       self.send_text('cardammount;'+var2+';');
      end;
//############################## ende vor-gamebefehle  #########################
//##############################################################################
    end   //####################################################################
   else   //####################################################################
    begin //####################################################################
//##############################################################################
//################################ start gamebefehle  ##########################

//##################################################################  draw  ####
     if (var1 = 'draw') then //draw;playerposition;anzahl;
      begin
       var2:=part(';',1,text);
       var3:=part(';',2,text);
       hsis:='';
       if var3='1' then var4:=lang.Mainform.MM_1_1_0+'.'
       else var4:=lang.Mainform.MM_1_1_1+'.';
       var5:=self.game.player(strtoint(var2)).name;
       if var5 = self.playername then
        begin
         var5:=lang.Mainform.Chat_1_0;
         config.stats.draws:=config.stats.draws+strtoint(var3);
        end
       else if config.client.language = 1 then
        hsis:='s'; //falls andere spieler und sprache englisch
       self.chatline('['+var5+'] '+lang.Mainform.Chat_2+hsis+' '+var3+' '+var4);
       for i := 0 to (strtoint(var3)-1) do
        begin
         if strtoint(var2)+1 = self.game.Player1.position then
          self.game.Form.Player1.new_card
         else if strtoint(var2)+1 = self.game.Player2.position then
          self.game.Form.Player2.new_card
         else if strtoint(var2)+1 = self.game.Player3.position then
          self.game.Form.Player3.new_card;
        end;
       self.game.Form.card_position;
       Form1.StatusBar1.Panels[1].Text:='';
       Form1.StatusBar1.Panels[1].Bevel:=pbNone;
      end;
//#################################################################  wrong  ####
     if (var1 = 'wrong') then //wrong;errorcode; 0=farbe/wert falsch;
      begin                   //1=7 oder ziehen; 2=8 oder aussetzen; 3=bubebube;
                              //4=kann jetzt nicht aussetzen
       var2:=part(';',1,text);
       self.game.Form.Player0.position;
       Form1.StatusBar1.Panels[1].Bevel:=pbLowered;
       case strtoint(var2) of
        0: var3:=lang.Mainform.SB_1_0;
        1: var3:=lang.Mainform.SB_1_1;
        2: var3:=lang.Mainform.SB_1_2;
        3: var3:=lang.Mainform.SB_1_3;
        4: var3:=lang.Mainform.SB_1_4;
        end;
       Form1.StatusBar1.Panels[1].Text:=var3;
      end;
//################################################################  wunsch  ####
     if (var1 = 'wunsch') then //wunsch;nofarbe;
      begin
       var2:=part(';',1,text);
       Form1.StatusBar1.Panels[1].Text:='';
       Form1.StatusBar1.Panels[1].Bevel:=pbNone;
       self.game.colorshow(strtoint(var2));
      end;
//###############################################################  uwunsch  ####
     if (var1 = 'uwunsch') then //uwunsch;playerposition;farbe;
      begin
       var2:=part(';',1,text);
       var3:=part(';',2,text);
       hsis:='';
       var4:=self.game.player(strtoint(var2)).name;
       var5:=lang.Mainform.Chat_1_2;
       if var4 = self.playername then
        begin
         var4:=lang.Mainform.Chat_1_0;
         var5:=lang.Mainform.Chat_1_1;
        end
       else if config.client.language = 1 then
        hsis:='s'; //falls andere spieler und sprache englisch
       self.chatline('['+var4+'] '+lang.Mainform.Chat_3+hsis+' '+var5+' ['
                     +s_farbe(var3)+'].');
      end;
//###################################################################  out  ####
     if (var1 = 'out') then //out;playerposition;
      begin
       var2:=part(';',1,text);
       var3:=self.game.player(strtoint(var2)).name;
       if var3 = self.playername then
        begin
         var3:=lang.Mainform.Chat_1_0;
         inc(config.stats.turnouts);
        end;
       self.chatline('['+var3+'] '+lang.Mainform.Chat_4+'.');
      end;
//##################################################################  turn  ####
     if (var1 = 'turn') then //turn;playerposition;ziehen;out;
      begin
       var2:=part(';',1,text);
       var3:=part(';',2,text);
       var4:=part(';',3,text);
       self.game.currentplayer:=strtoint(var2);
       if var2='-1' then
        begin
         Form1.StatusBar1.Panels[2].Text:='';
         Form1.StatusBar1.Panels[2].Bevel:=pbNone;
         self.game.Form.Tocken.sett(-1);
        end
       else
        begin
         with self.game do
          begin
           if PlayerSelf.position = player(strtoint(var2)).position then
            Form.Tocken.sett(0);
           if Player1.position = player(strtoint(var2)).position then
            Form.Tocken.sett(1);
           if Player2.position = player(strtoint(var2)).position then
            Form.Tocken.sett(2);
           if Player3.position = player(strtoint(var2)).position then
            Form.Tocken.sett(3);
           var5:=player(strtoint(var2)).name;
          end;
         if var5 = self.playername then
          begin
           Form1.StatusBar1.Panels[2].Bevel:=pbLowered;
           Form1.StatusBar1.Panels[2].Text:='['+lang.Mainform.Chat_1_0+'] '
                                            +lang.Mainform.Chat_6_0;
           self.game.canplay:=true;
          end
         else
          begin
           Form1.StatusBar1.Panels[2].Bevel:=pbLowered;
           Form1.StatusBar1.Panels[2].Text:='['+var5+'] '+lang.Mainform.Chat_6_1;
           self.game.canplay:=false;
          end;
         Form1.StatusBar1.Panels[1].Text:='';
         Form1.StatusBar1.Panels[1].Bevel:=pbNone;
         if var3='0' then var3:='1';
         if var3<>'1' then var5:=lang.Mainform.MM_1_1_1
         else var5:=lang.Mainform.MM_1_1_0;
         Form1.xKartenziehen1.Caption:=var3+' '+var5+' '+lang.Mainform.MM_1_1_2;
         Form1.xKartenziehen1.Enabled:=true;
         if var4 <> '0' then
          begin
           Form1.RundeAussetzen1.Enabled:=true;
           Form1.xKartenziehen1.Enabled:=false;
          end
         else Form1.RundeAussetzen1.Enabled:=false;
        end;
      end;
//##############################################################  yourcard  ####
     if (var1 = 'yourcard') then //yourcard;card;
      begin
       self.game.Form.Player0.new_card(strtoint(part(';',1,text)));
      end;
//##################################################################  card  ####
     if (var1 = 'card') then  // card;playerposition;card;
      begin
       var2:=part(';',1,text);
       var3:=part(';',2,text);
       hsis:='';
       self.game.Form.OpenCards.new_card(strtoint(var3),strtoint(var2));
       if var2 <> '0' then
        begin
         var4:=self.game.player(strtoint(var2)-1).name;
         if var4 = self.playername then
          begin
           var4:=lang.Mainform.Chat_1_0;
           inc(config.stats.plays);
          end
         else if config.client.language = 1 then
          hsis:='s'; //falls andere spieler und sprache englisch
         if strtoint(var2) = self.game.PlayerSelf.position then
          self.game.Form.Player0.drop_card(strtoint(var3))
         else if strtoint(var2) = self.game.Player1.position then
          self.game.Form.Player1.drop_card
         else if strtoint(var2) = self.game.Player2.position then
          self.game.Form.Player2.drop_card
         else if strtoint(var2) = self.game.Player3.position then
          self.game.Form.Player3.drop_card;
         self.chatline('['+var4+'] '+lang.Mainform.Chat_5+hsis
                       +' ['+s_farbe(var3)+'] ['+s_wert(var3)+']');
        self.game.Form.Player0.position;
        end
       else self.chatline(lang.Mainform.MM_1_1_0+': ['+s_farbe(var3)+'] ['
                          +s_wert(var3)+']');
       if (wert(strtoint(var3)) = 6) and self.rules.seven_use then
        inc(config.stats.sevens); //stats 7
       if (wert(strtoint(var3)) = 7) and self.rules.eight_use then
        inc(config.stats.eights); //stats 8
       if (wert(strtoint(var3)) = 8) and self.rules.nine_use then
        inc(config.stats.nines); //stats 9
       if (wert(strtoint(var3)) = 10) and self.rules.bube_use then
        inc(config.stats.bubes); //stats bube
       Form1.StatusBar1.Panels[1].Text:='';
       Form1.StatusBar1.Panels[1].Bevel:=pbNone;
       self.game.Form.card_position;
      end;
//###################################################################  win  ####
     if (var1 = 'win') then //win;playerposition;lastplayercount;
      begin
       var2:=part(';',1,text);
       var3:=part(';',2,text);
       hsis:='';
       var4:=self.game.player(strtoint(var2)).name;
       if var4 = self.playername then var4:=lang.Mainform.Chat_1_0
       else if config.client.language = 1 then
        hsis:='s'; //falls andere spieler und sprache englisch
       if strtoint(var3) = -1 then
        self.chatline(lang.Mainform.Chat_7_0+' ['+var4+']')
       else
        begin
         if var4 = lang.Mainform.Chat_1_0 then
          begin
          if var3='0' then inc(config.stats.winsvs0);
          if var3='1' then inc(config.stats.winsvs1);
          if var3='2' then inc(config.stats.winsvs2);
          if var3='3' then inc(config.stats.winsvs3);
          end;
         if var3='0'then self.chatline('['+var4+'] '+lang.Mainform.Chat_7_2+hsis)
         else self.chatline(lang.Mainform.Chat_7_1+' ['+var4+']');
        end;
      end;
//###############################################################  endgame  ####
     if (var1 = 'endgame') then //endgame;
      begin
       FreeAndNil(self.game);
       self.chatline(lang.Mainform.Chat_10);
       Form1.ed_chat.Visible:=false;
       Form1.but_chat.Visible:=false;
       Form1.m_chat.Visible:=false;
       Form1.m_chat.Clear;
       Form5.Left := Form1.Left + (Form1.Width div 2) - (Form5.Width div 2);
       Form5.Top := Form1.Top + (Form1.Height div 2) - (Form5.Height div 2);
       //Form5.load_client;
       Form5.ShowModal;
      end;
//############################################################  playerleft  ####
     if (var1 = 'gameleft') then //gameleft;playerposition;
      begin
       var2:=part(';',1,text);
       if self.game.player(strtoint(var2)) = self.game.PlayerSelf then
        self.game.Form.Player0.drop_allcards;
       if self.game.player(strtoint(var2)) = self.game.Player1 then
        self.game.Form.Player1.drop_allcards;
       if self.game.player(strtoint(var2)) = self.game.Player2 then
        self.game.Form.Player2.drop_allcards;
       if self.game.player(strtoint(var2)) = self.game.Player3 then
        self.game.Form.Player3.drop_allcards;
       var3:=self.game.player(strtoint(var2)).name;
       if var3 = self.playername then
        begin
         var3:=lang.Mainform.Chat_1_0;
         var4:=lang.Mainform.Chat_8_0;
        end
       else var4:=lang.Mainform.Chat_8_1;
       self.chatline('['+var3+'] '+var4);
      end;
//################################ ende gamebefehle  ###########################
//##############################################################################
    end;
//##############################################################################
//##############################################################################
//##############################################################################
  end;
end;



end.
