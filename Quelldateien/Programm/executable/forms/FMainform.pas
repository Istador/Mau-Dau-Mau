unit FMainform;
{
  author:     Robin Christopher Ladiges
  website:    http://blackpinguin.de/
  project:    Mau Dau Mau
  binary:     MauDauMau.exe
  unit:       FMainform
  file:       FMainform.pas
  filepath:   .\executable\forms\
  year:       2008/2009
  desc:       This file handles the MainForm, the form on/from which all other
              gets loaded. The form which gets displayed first.

  license:    creative commons by-nc-sa 3.0 germany
   look out license.txt in this folder
   human-readable summary : http://creativecommons.org/licenses/by-nc-sa/3.0/de/
}

interface

uses
  Forms, Windows, Classes, Controls, StdCtrls, SysUtils, Menus,
  ToolWin, ActnMan, ActnCtrls, ComCtrls,
  //"Delphi HTML Help Kit" von "The Helpware Group" (http://helpware.net/delphi/)
  hh, hh_funcs;

type
TForm1 = class(TForm)
    MainMenu1: TMainMenu;
     Programm1: TMenuItem;         //Programm
      NeuesSpiel1: TMenuItem;     //Neues Spiel / Spiel beenden
      SpielBeitreten1: TMenuItem; //Spiel beitreten / Spiel verlassen
      N4: TMenuItem;              //------
      Statistik1: TMenuItem;      //Statistiken...
      Deckblatt1: TMenuItem;      //Deckblatt...
      Optionen1: TMenuItem;       //Optionen...
      N1: TMenuItem;              //------
      Beenden1: TMenuItem;        //Beenden
     Spiel1: TMenuItem;            //Spiel
      RundeAussetzen1: TMenuItem; //Runde Aussetzen
      xKartenziehen1: TMenuItem;  //x Karten ziehen
      N5: TMenuItem;              //-------
      REgeln1: TMenuItem;         //Regeln...
      N6: TMenuItem;              //-------
      RundeBeenden1: TMenuItem;   //Runde beenden
      Zurcktreten1: TMenuItem;    //Aufgeben
     N2: TMenuItem;                //?
      Hilfe1: TMenuItem;          //Hilfethemen
      N3: TMenuItem;              //-------
      Info1: TMenuItem;           //Info
    m_chat: TMemo;
    ed_chat: TEdit;
    but_chat: TButton;
    StatusBar1: TStatusBar;
    //Form Ereignisse
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormDragOver(Sender, Source: TObject; X, Y: Integer;
                           State: TDragState; var Accept: Boolean);
    procedure FormDragDrop(Sender, Source: TObject; X, Y: Integer);
    //Objekt Ereignisse / Sonstiges
    procedure FormIniChange;
    procedure languageload;
    procedure but_chatClick(Sender: TObject);
    procedure ed_chatKeyPress(Sender: TObject; var Key: Char);
    //Main Menu Clicks
    procedure NeuesSpiel1Click(Sender: TObject);
    procedure SpielBeitreten1Click(Sender: TObject);
    procedure Statistik1Click(Sender: TObject);
    procedure Deckblatt1Click(Sender: TObject);
    procedure Optionen1Click(Sender: TObject);
    procedure Beenden1Click(Sender: TObject);
    procedure RundeAussetzen1Click(Sender: TObject);
    procedure xKartenziehen1Click(Sender: TObject);
    procedure REgeln1Click(Sender: TObject);
    procedure RundeBeenden1Click(Sender: TObject);
    procedure Zurcktreten1Click(Sender: TObject);
    procedure Hilfe1Click(Sender: TObject);
    procedure Info1Click(Sender: TObject);
    { Private-Deklarationen }
    public
    { Public-Deklarationen }
    end;


var   // können auch in anderen Units aufgerufen werden
  Form1: TForm1;
  c_width, c_height : integer; // Kartenhöhe/breite wird mit cdtInit von der dll
                               //zurückgegeben. Theoretisch könnte man die Größe
                               //auch selbst bestimmen, müsste dann aber
                               //cdtDrawExt anstatt cdtDraw nehmen und die werte
                               //übergeben
  mHHelp: THookHelpSystem;     //chm Hilfe



implementation
{$R *.dfm}
uses // zum aufrufen von variablen / methoden anderer Units.
  // Forms
  FAuthor,
  FDeckblatt,
  FOptions,
  FPlayer,
  FStats,
  // KlassenUnits
  UClient,         // Client Komponente
  UClientCards,    // Background refresh / Drag&Drop
  UDialogs,        // eigenes ShowMessage / InputQuery
  Udll,            // procedure cdtInit | procedure cdtTerm
  UIni,            // var config
  ULanguage,       // einbindung der verschiedenen Sprachen
  UServer;         // Server Komponente

var   //diese globale vars können nur in dieser Unit aufgerufen werden
  bg_temp : word; //um zu überprüfen ob sich das deckblatt ändert
  lang_temp : word; //um zu überprüfen ob sich die sprache ändert



procedure TForm1.FormCreate(Sender: TObject);
var
 chmFile: string;
begin
 randomize;
 config:=TIniConfig.create; //config erstellen
 lang_temp:=config.client.language; //um später änderungen festzustellen
 bg_temp:=config.client.background; //um später änderungen festzustellen
 lang:=TLanguage.create; //lang objekt erstellen und der lang var zuweisen
 self.languageload; //procedur zum laden der strings aufrufen
 //gespeicherte positionierung der Form
 Form1.Top:=config.client.PosTop;
 Form1.Left:=config.client.PosLeft;
 Form1.Height:=config.client.PosHeight;
 Form1.Width:=config.client.PosWidth;
 //-----------------------------------------------------------------------------
 //--- not my work -------------------------------------------------------------
 //------------- http://www.delphi-treff.de/tutorials/tools/html-hilfe/page/9/ -
 //-----------------------------------------------------------------------------
 // Help File festlegen, das neuere *.chm dateiformat geht mit borland delphi
 // nicht, sondern nur das ältere *.hlp format. deshalb dieser externe Code
 chmFile := ExtractFilePath(ParamStr(0))+'MauDauMau.chm';
 mHHelp := nil;
 if not FileExists(chmFile) then
  ShowMessage(lang.Mainform.Help_0+#13+chmFile, self);
 if (hh.HHCtrlHandle = 0)
 or (hh_funcs._hhMajVer < 4)
 or ((hh_funcs._hhMajVer = 4) and (hh_funcs._hhMinVer < 73)) then
  ShowMessage(lang.Mainform.Help_1, self);
 mHHelp := hh_funcs.THookHelpSystem.Create(chmFile, '', htHHAPI);
 //-----------------------------------------------------------------------------
 cdtInit(c_width,  c_height); // cards.dll initialisieren, schreibt in c_width
                              // und c_height die Kartenhöhe/breite;
end;


procedure TForm1.FormDestroy(Sender: TObject);
begin
 //-----------------------------------------------------------------------------
 //--- not my work -------------------------------------------------------------
 //------------- http://www.delphi-treff.de/tutorials/tools/html-hilfe/page/9/ -
 //-----------------------------------------------------------------------------
 // Hilfe Datei schließen fals geöffnet
 HHCloseAll;
 if Assigned(mHHelp) then mHHelp.Free;
 //-----------------------------------------------------------------------------
 if assigned(client) then client.Free; // Client beenden
 if assigned(server) then server.Free; // Server beenden
 if assigned(config) then
  begin
   //Form position speichern
   config.client.PosTop:=self.Top;
   config.client.PosLeft:=self.Left;
   config.client.PosHeight:=self.Height;
   config.client.PosWidth:=self.Width;
   config.Free; // Ini Zugriff beenden
  end;
 if assigned(lang) then lang.Free;
 cdtTerm; // cards.dll beenden
end;


procedure TForm1.FormResize(Sender: TObject);
begin
 // Wenn die Form Ausmaße verändert werden, z.B. beim maximieren
 ed_chat.Top:=self.ClientHeight-self.ed_chat.Height-self.StatusBar1.Height;
 ed_chat.Left:=self.ClientWidth-self.ed_chat.Width-self.but_chat.Width;
 but_chat.Top:=self.ClientHeight-self.but_chat.Height-self.StatusBar1.Height;
 but_chat.Left:=self.ClientWidth-self.but_chat.Width;
 m_chat.Top:=self.ClientHeight-self.ed_chat.Height-self.m_chat.Height
             -self.StatusBar1.Height;
 m_chat.Left:=self.ClientWidth-self.m_chat.Width;
 if assigned(client)
 and assigned(client.game)
 and assigned(client.game.Form) then
  Client.game.Form.card_position; // Karten neu positionieren
 //StatusBar Pannels in der Breite proportional zur Form Breite anpassen
 StatusBar1.Panels[0].Width:=round(160+(Form1.Width-505)/8);
 StatusBar1.Panels[1].Width:=round(190+(Form1.Width-505)/8*6);
 StatusBar1.Panels[2].Width:=round(155+(Form1.Width-505)/8);
end;


procedure TForm1.FormDragOver(Sender, Source: TObject; X, Y: Integer;
                              State: TDragState; var Accept: Boolean);
begin
 //weiterleiten an das DragOver Ereignis der Karte (Source)
 if Source is TClientCards then
  TClientCards(Source).DragOver(Sender, Source, X, Y, State, Accept);
end;


procedure TForm1.FormDragDrop(Sender, Source: TObject; X, Y: Integer);
begin
 //weiterleiten an das DragDrop Ereignis der Karte (Source)
 if Source is TClientCards then
  TClientCards(Source).DragDrop(Sender, Source, X, Y);
end;


procedure TForm1.FormIniChange;
var
 i:integer;
begin
 if bg_temp <> config.client.background then
  begin //wenn sich das Deckblatt geändert hat.
   bg_temp:=config.client.background;
   for i := 0 to high(clCards) do // geht alle Karten durch
    if clCards[i].side = 1 then // wenn die Karte die Rückseite anzeigt
     begin
      clCards[i].card := bg_temp; //Alter Hintergrundwert mit neuem beschreiben
      clCards[i].imagerefresh;    //funktion zum neu zeichnen der images.
                                  //(anhand von clCards[i].card)
     end;
  end;
 if lang_temp <> config.client.language then
  begin //wenn sich die sprache geändert hat
   lang_temp:=config.client.language;
   lang.read;
   self.languageload;
  end;
 //server/client mitteilen dass sich einstellungen geändert haben
 if assigned(server) then server.inichange;
 if assigned(client) then client.inichange;
end;


procedure TForm1.languageload;
var
 var5:string;
begin
 self.Caption:=lang.Mainform.Caption;           //Mau Dau Mau
 self.but_chat.Caption:=lang.Player.but_chat;   //Chat
 self.Programm1.Caption:=lang.Mainform.MM_0;    //Programm
 self.Statistik1.Caption:=lang.Mainform.MM_0_2; //Statistiken...
 self.Deckblatt1.Caption:=lang.Mainform.MM_0_3; //Deckblatt...
 self.Optionen1.Caption:=lang.Mainform.MM_0_4;  //Optionen...
 self.Beenden1.Caption:=lang.Mainform.MM_0_5;   //Beenden...
 if assigned(client) then
  begin
   self.NeuesSpiel1.Caption:=lang.Mainform.MM_0_0_1;     //Spiel beenden
   self.SpielBeitreten1.Caption:=lang.Mainform.MM_0_1_1; //Spiel verlassen
  end
 else
  begin
   self.NeuesSpiel1.Caption:=lang.Mainform.MM_0_0_0;      //Neues Spiel
   self.SpielBeitreten1.Caption:=lang.Mainform.MM_0_1_0;  //Spiel beitreten
  end;
 self.Spiel1.Caption:=lang.Mainform.MM_1;                      //Spiel
 self.RundeAussetzen1.Caption:=lang.Mainform.MM_1_0;           //Runde Aussetzen
 if assigned(client) and assigned(client.game) then
  begin
   self.xKartenziehen1.Caption:=inttostr(client.game.ziehen)+' '; //anzahl
   if client.game.ziehen > 1 then
    self.xKartenziehen1.Caption:=self.xKartenziehen1.Caption
                                 +lang.Mainform.MM_1_1_1          //Karten
   else
    self.xKartenziehen1.Caption:=self.xKartenziehen1.Caption
                                 +lang.Mainform.MM_1_1_0;         //Karte
   self.xKartenziehen1.Caption:=self.xKartenziehen1.Caption+' '
                                +lang.Mainform.MM_1_1_2;          //ziehen
  end
 else
  begin
   self.xKartenziehen1.Caption:='x '+lang.Mainform.MM_1_1_1+' '
                                +lang.Mainform.MM_1_1_2;
  end;
 self.REgeln1.Caption:=lang.Mainform.MM_1_2;       //Regeln...
 self.RundeBeenden1.Caption:=lang.Mainform.MM_1_3; //Runde beenden
 self.Zurcktreten1.Caption:=lang.Mainform.MM_1_4;  //Aufgeben
 self.N2.Caption:=lang.Mainform.MM_2;              //?
 self.Hilfe1.Caption:=lang.Mainform.MM_2_0;        //Hilfethemen
 self.Info1.Caption:=lang.Mainform.MM_2_1;         //Info

 self.StatusBar1.Panels[1].Text:='';
 self.StatusBar1.Panels[1].Bevel:=pbNone;
 if assigned(client) then
  begin
   //Verbunden mit ...
   self.StatusBar1.Panels[0].Text:=lang.Mainform.SB_0_1+' '+client.Host;
   if assigned(client.game) then
    begin
     //wer dran ist in statusbar
     var5:=client.game.player(client.game.currentplayer).name;
     if var5 = config.client.name then
      begin
       Form1.StatusBar1.Panels[2].Bevel:=pbLowered;
       Form1.StatusBar1.Panels[2].Text:='['+lang.Mainform.Chat_1_0+'] '
                                        +lang.Mainform.Chat_6_0+'.';
      end
     else
      begin
       Form1.StatusBar1.Panels[2].Bevel:=pbLowered;
       Form1.StatusBar1.Panels[2].Text:='['+var5+'] '
                                        +lang.Mainform.Chat_6_1+'.';
      end;
    end;
  end
 else
  begin
   self.StatusBar1.Panels[0].Text:=lang.Mainform.SB_0_0; //Nicht Verbunden
  end;
 //languageloads der anderen Forms aufrufen
 if assigned(Form2) then Form2.languageload;
 if assigned(Form3) then Form3.languageload;
 if assigned(Form4) then Form4.languageload;
 if assigned(Form5) then Form5.languageload;
 if assigned(Form7) then Form7.languageload;
end;


procedure TForm1.but_chatClick(Sender: TObject);
var
 text : string;
begin
 text := ed_chat.Text;
 ed_chat.Text:='';
 if (text <> '') and assigned(client) then
  client.send_text('text;'+text+';')
end;


procedure TForm1.ed_chatKeyPress(Sender: TObject; var Key: Char);
begin
 // # und ; rausfiltern
 if (key in [#35,#59]) then key:=#0;
end;


procedure TForm1.NeuesSpiel1Click(Sender: TObject);
var
 server_port: string;
 temp: integer;
begin
 if not assigned(server) then
  begin
   if not assigned(client) then
    begin
     server_port:=inttostr(config.server.port); //default
     //solange der Server nochnicht erstellt ist läuft sie ab.
     //Wenn der user auf abbrechen clickt geht er raus aus der schleife.
     while (assigned(Server) = false) and
     InputQuery(lang.Mainform.Crea_1_0,lang.Mainform.Crea_0_1,server_port,self)
     do
      begin
       //wenn der vom user übergeben wert eine zahl ist
       if TryStrToInt(server_port,temp) then
        begin
         temp:=strtoint(server_port);
         if config.client.rfc4340 and ((temp<49152)or(temp>65535)) then
          begin
           //wenn die zahl nicht zwischen 49152 und 65535 liegt
           //(IANA: Dynamic/Private Ports | also unregistrierte ports)
           ShowMessage(lang.Mainform.Crea_1_2, self);
          end
         else
          begin
           //erstelle server
           config.server.port:=strtoint(server_port);
           Server:=TServer.create(Form1,strtoint(server_port));
          end;
        end
       else
        begin
         ShowMessage(lang.Mainform.Crea_1_1, self);
        end;
      end;
     if assigned(Server) then
      begin
       NeuesSpiel1.Caption:=lang.Mainform.MM_0_0_1;
       SpielBeitreten1.Visible:=false;
       // wenn der server erstellt wurde, verbinde über loopback auf den server.
       // Bei spielen gegen sich selbst auf dem eigenem PC muss die
       // Netzwerk/internet adresse/hostname benutzt werden
       Client:=TClient.create(Form1,'127.0.0.1',strtoint(server_port));
      end;
    end;
  end
 else
  begin
   NeuesSpiel1.Caption:=lang.Mainform.MM_0_0_0;
   SpielBeitreten1.Visible:=true;
   Server.Free;
  end;
end;


procedure TForm1.SpielBeitreten1Click(Sender: TObject);
var
 temp: integer;
 server_addr,server_port: string;
 btemp: boolean;
begin
 if not assigned(client) then
  begin
   if not assigned(server) then
    begin
     btemp:=true;
     //letzter port über den verbunden wurde
     server_port:=inttostr(config.client.lastport);
     //letzter server über den verbunden wurde
     server_addr:=config.client.lastserver;
     while btemp and
     InputQuery(lang.Mainform.Crea_1_0,lang.Mainform.Crea_0_0,server_addr, self)
     do
      begin
       if server_addr = '' then
        begin
         ShowMessage(lang.Mainform.Crea_1_4, self);
         //mit nichts kann keine verbindung aufgabaut werden
        end
       else if (server_addr = '127.0.0.1') or (server_addr = 'localhost') then
        begin
         ShowMessage(lang.Mainform.Crea_1_5, self);
         //weil bei einem server auf dem selben computer die exe des servers
         //über 127.0.0.1 verbunden ist.
        end
       else
        begin
         config.client.lastserver:=server_addr; //Server Adresse speichern
         btemp:=false; // damit wenn das nächste while abbricht er nicht nochmal
                       // nach Port fragt, sondern abbricht.
         while (assigned(client) = false) and InputQuery(lang.Mainform.Crea_1_0,
         lang.Mainform.Crea_0_1, server_port, self)
         do
          begin
           //wenn der vom user übergeben wert eine zahl ist
           if TryStrToInt(server_port,temp) then
            begin
             temp:=strtoint(server_port);
             if config.client.rfc4340 and ((temp<49152)or(temp>65535)) then
              begin
               //wenn die zahl nicht zwischen 49152 und 65535 liegt
               //(IANA: Dynamic/Private Ports | also unregistrierte ports)
               ShowMessage(lang.Mainform.Crea_1_2, self);
              end
             else
              begin
               //erstelle client
               SpielBeitreten1.Caption:=lang.Mainform.MM_0_1_1;
               NeuesSpiel1.Visible:=false;
               config.client.lastport:=strtoint(server_port);
               Form1.StatusBar1.Panels[0].Text:=lang.Mainform.SB_0_13;
               Client:=TClient.create(Form1,server_addr,strtoint(server_port));
              end;
            end
           else
            begin
             ShowMessage(lang.Mainform.Crea_1_1, self);
            end;
          end;
        end;
      end;
    end;
  end
 else if not assigned(server) then  //damit der Server das spiel nicht verlässt
  begin
   SpielBeitreten1.Caption:=lang.Mainform.MM_0_1_0;
   NeuesSpiel1.Visible:=true;
   Client.Free;
   Client:=nil;
  end;
end;


procedure TForm1.Statistik1Click(Sender: TObject);
begin
 if config.client.savestats then
  begin //wenn statistiken gespeichert werden ->anzeigen
   //siehe TForm1.Deckblatt1Click
   Form4:=TForm4.Create(Form1);
   Form4.Left := Form1.Left + (Form1.Width div 2) - (Form4.Width div 2);
   Form4.Top := Form1.Top + (Form1.Height div 2) - (Form4.Height div 2);
   Form4.ShowModal;
   Form4.Free;
   Form4:=nil;
  end
 else // ansonsten benachrichtiggen
  begin
   ShowMessage(lang.Mainform.Stats_0+#13+#10+lang.Mainform.Stats_1, self);
  end;
end;


procedure TForm1.Deckblatt1Click(Sender: TObject);
begin
 Form2:=TForm2.Create(Form1); //erstelle Form
 //in die Mitte von der Mainform setzen
 Form2.Left := Form1.Left + (Form1.Width div 2) - (Form2.Width div 2);
 Form2.Top := Form1.Top + (Form1.Height div 2) - (Form2.Height div 2);
 Form2.ShowModal; //Zeige die Form. MainForm darf nicht angeklickt werden.
 //hier landet er erst wieder nach dem schließen/close der form
 Form2.Free; //Destroy
 Form2:=nil; //Variable freigeben um späteren versehentlichen zugriff mit
             //assigned(Form2) abzufangen
end;


procedure TForm1.Optionen1Click(Sender: TObject);
begin
 //siehe TForm1.Deckblatt1Click
 Form3:=TForm3.Create(Form1);
 Form3.Left := Form1.Left + (Form1.Width div 2) - (Form3.Width div 2);
 Form3.Top := Form1.Top + (Form1.Height div 2) - (Form3.Height div 2);
 Form3.ShowModal;
 Form3.Free;
 Form3:=nil;
end;


procedure TForm1.Beenden1Click(Sender: TObject);
begin
 Form1.Close;
end;


procedure TForm1.RundeAussetzen1Click(Sender: TObject);
begin
 if assigned(client) and assigned(client.game) and client.game.canplay then
  client.send_text('out;');
end;


procedure TForm1.xKartenziehen1Click(Sender: TObject);
begin
 if assigned(client) and assigned(client.game) and client.game.canplay then
  client.send_text('draw;');
end;


procedure TForm1.REgeln1Click(Sender: TObject);
var
 text:string;
begin
 if assigned(Client) and assigned(Client.game) then
  begin
   text:=lang.Player.rules_0
         +#13#10+lang.Player.rules_1
         +' ' + bts(Client.game.rules.seven_use)
         +#13#10+lang.Player.rules_2
         +' ' + bts(Client.game.rules.eight_use)
         +#13#10+lang.Player.rules_3
         +' ' + bts(Client.game.rules.nine_use)
         +#13#10+lang.Player.rules_4
         +' ' + bts(Client.game.rules.bube_use)
         +#13#10
         +#13#10+lang.Player.rules_5
         +' ' + inttostr(Client.game.rules.seven_take)
         +#13#10+lang.Player.rules_6
         +' ' + bts(Client.game.rules.nine_win)
         +#13#10+lang.Player.rules_7
         +' ' + bts(Client.game.rules.bube_bube);
   ShowMessage(text, self);
  end;
end;


procedure TForm1.RundeBeenden1Click(Sender: TObject);
begin
 if assigned(server) and assigned(server.game) then
  begin
   server.game.Free;
   server.send;
  end;
end;


procedure TForm1.Zurcktreten1Click(Sender: TObject);
begin
 if assigned(client) and assigned(client.game) then
  client.send_text('gameleft;');
end;


procedure TForm1.Hilfe1Click(Sender: TObject);
begin
 mHHelp.HelpContext(1001); //öfnet Thema 1001 in der Hilfe Datei
end;


procedure TForm1.Info1Click(Sender: TObject);
begin
 //siehe TForm1.Deckblatt1Click
 Form7:=TForm7.Create(Form1);
 Form7.Left := Form1.Left + (Form1.Width div 2) - (Form7.Width div 2);
 Form7.Top := Form1.Top + (Form1.Height div 2) - (Form7.Height div 2);
 Form7.ShowModal;
 Form7.Free;
 Form7:=nil;
end;




end.
