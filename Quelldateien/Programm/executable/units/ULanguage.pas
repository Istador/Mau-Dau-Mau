unit ULanguage;
{
  author:     Robin Christopher Ladiges
  website:    http://blackpinguin.de/
  project:    Mau Dau Mau
  binary:     MauDauMau.exe
  unit:       ULanguage
  file:       ULanguage.pas
  filepath:   .\executable\units\
  year:       2008/2009
  desc:       This file handles the TLanguage class. This class contains all
              strings in the current selected language. Every Form reads the
              strings from this Class.
              The reason to save all strings ina class and not dynamicly reads
              the strings when they are needed is to save cpu time account of
              RAM needed.

  license:    creative commons by-nc-sa 3.0 germany
   look out license.txt in root folder
   human-readable summary : http://creativecommons.org/licenses/by-nc-sa/3.0/de/
}

interface
uses IniFiles, sysutils;



type TLangFMainform = class
     Caption,  // Mau Dau Mau
     Stats_0,  //Statistiken werden nicht gespeichert.
     Stats_1,  //Sie können dies in den Optionen ändern.
     Help_0,   //Hilfe-Datei nicht gefunden
     Help_1,   //Diese Anwendung erfordert die Installation der MS HTML Help 1.2
               //oder höher
     Crea_0_0, //Server Adresse
     Crea_0_1, //Server Port
     Crea_0_2, //Server Passwort
     Crea_0_3, //Anzahl an Karten
     Crea_1_0, //Eingabe benötigt
     Crea_1_1, //Bitte nur Zahlen eingeben
     Crea_1_2, //Bitte nur Zahlen zwischen 49152 und 65535 eingeben
     Crea_1_3, //Bitte nur Zahlen zwischen 4 und 10 eingeben
     Crea_1_4, //Sie müssen einen DNS-Namen oder eine IP eingeben
     Crea_1_5, //Sie können nicht auf localhost verbinden..
     Crea_1_6, //Sie müssen ein Passwort eingeben
     MM_0,     //programm
     MM_0_0_0, //spiel starten
     MM_0_0_1, //spielbeenden
     MM_0_1_0, //spiel beitreten
     MM_0_1_1, //spiel verlassen
     MM_0_2,   //Statistik
     MM_0_3,   //Deckblatt
     MM_0_4,   //Optionen
     MM_0_5,   //Beenden
     MM_1,     // Spiel
     MM_1_0,   //Runde Aussetzen
     MM_1_1_0, //karte
     MM_1_1_1, //karten
     MM_1_1_2, //ziehen
     MM_1_2,   //Regeln
     MM_1_3,   //Runde beenden
     MM_1_4,   //Zurücktreten
     MM_2,     // ?
     MM_2_0,   //Hilfethemen
     MM_2_1,   //Info
     Chat_0,   //Regeländerung
     Chat_1_0, //Ihr
     Chat_1_1, //euch
     Chat_1_2, //sich
     Chat_2,   //zieht
     Chat_3,   //wünscht
     Chat_4,   //setzt aus
     Chat_5,   //spielt
     Chat_6_0, //seid dran
     Chat_6_1, //ist dran
     Chat_7_0, //letzte Karte
     Chat_7_1, //Mau Mau
     Chat_7_2, //(x) verliert
     Chat_8_0, //(Ihr) gebt auf
     Chat_8_1, //(x) gibt auf
     Chat_9_0, //(x) betritt das Spiel
     Chat_9_1, //(x) verlässt das Spiel
     Chat_10,  //Runde beendet
     SB_0_0,   //Nicht Verbunden
     SB_0_1,   //Verbunden mit
     SB_0_2,   //Unbekannter Fehler
     SB_0_3,   //Fehler beim Senden
     SB_0_4,   //Fehler beim Empfangen
     SB_0_5,   //Fehler beim Verbinden
     SB_0_6,   //Fehler beim schließen der Verbindung
     SB_0_7,   //Server ist voll
     SB_0_8,   //Spiel läuft schon
     SB_0_9,   //Name schon vergeben
     SB_0_10,  //Sie wurden entfernt
     SB_0_11,  //Passwort falsch
     SB_0_12,  //Spiel wurde Beendet
     SB_0_13,  //Verbinde...
     SB_1_0,   //Farbe oder Wert stimmt nicht überein
     SB_1_1,   //7 spielen oder ziehen
     SB_1_2,   //8 spielen oder aussetzen
     SB_1_3,   //Bube auf Bube nicht erlaubt
     SB_1_4,   //Sie können jetzt nicht aussetzen
     SB_1_5,   //Ihr seid nicht dran
     SB_2_0,   // (Ihr) seid dran
     SB_2_1    // (x) ist dran
      : string;
     procedure load(langfile : TIniFile);
     end;
type TLangFDeckblatt = class
     Caption: string; //Deckblatt
     procedure load(langfile : TIniFile);
     end;
type TLangFOptions = class
     Caption,      //Optionen
     Err_0,        //Sie müssen einen Spieler- und Servernamen eingeben.
     Err_1,        //Sie müssen einen Spielernamen eingeben.
     Err_2,        //Sie müssen einen Servernamen eingeben.
     TC_0,         //Spieler
     TC_1,         //Server
     C_name,       //Ihr Name
     C_Stats,      //Statistiken speichern?
     C_Label1,     //Wieviele Karten austeilen
     C_Label2,     //Sortierart
     C_sortorder_0,//unsortiert
     C_sortorder_1,//nach Farbe
     C_sortorder_2,//nach Wertigkeit
     C_Label3,     //Sprache
     C_language_0, //Deutsch
     C_language_1, //Englisch
     C_language_2, //Französich
     S_name,       //Server Name
     S_pass,       //Passwort
     S_action,     //Aktionskarten
     S_Label1,     //Wieviele Karten ziehen pro 7
     S_n_w,        //Mit letzter Karte 9 gewinnen
     S_b_b         //Bube auf Bube spielen
      : string;
     procedure load(langfile : TIniFile);
     end;
type TLangFStats = class
     Caption, //Statistiken
     Lab_1,   //Gewonnen gegen 3 Spieler:
     Lab_2,   //Gewonnen gegen 2 Spieler:
     Lab_3,   //Gewonnen gegen 1 Spieler:
     Lab_4,   //Verlorene Spiele:
     Lab_5,   //Karten gespielt:
     Lab_6,   //Karten gezogen:
     Lab_7,   //Runden ausgesetzt:
     Lab_8,   //Gespielte Siebenen:
     Lab_9,   //Gespielte Achten:
     Lab_10,  //Gespielte Neunen:
     Lab_11   //Gespielte Buben:
      : string;
     procedure load(langfile : TIniFile);
     end;
type TLangFAuthor = class
     Caption,       //Info über Mau Dau Mau
     Lab_1,         //Mau Dau Mau
     Lab_ver_0,     //Version
     Lab_ver_1,     //Build
     Lab_2,         //Copyright C 2009 Robin C. Ladiges
     Lab_3,         //http://www.blackpinguin.de/
     Lab_4,         //Französiche Übersetzung von Christian Stoffers
     lab_licence_0, //Zeile1
     lab_licence_1, //Zeile2
     lab_licence_2, //Zeile3
     lab_licence_3, //Zeile4
     lab_licence_4  //Zeile5
      : string;
     procedure load(langfile : TIniFile);
     end;
type TLangFPlayer = class
     player1,              //Spieler 1
     player2,              //Spieler 2
     player3,              //Spieler 3
     player4,              //Spieler 4
     rb_0,                 //Geschlossen
     rb_1,                 //Offen
     noname,               //kein Spieler
     but_chat,             //chat
     but_client_leave,     //Spiel verlassen
     but_client_rules,     //Regeln anzeigen
     but_server_close,     //Spiel beenden
     but_server_roundstart,//Runde starten
     but_server_rules,     //Regeln...
     rules_0,              //Regeln
     rules_1,              //7 Aktionskarte:
     rules_2,              //8 Aktionskarte:
     rules_3,              //9 Aktionskarte:
     rules_4,              //J Aktionskarte:
     rules_5,              //7 - Karten ziehen:
     rules_6,              //9 - Als letzte Karte:
     rules_7               //J - Bube auf Bube:
     : string;
     procedure load(langfile : TIniFile);
     end;
type TLangGeneric = class
     Yes,No : string;
     Color: Array [-1..3] of string;
     Face: Array [-1..12] of string;
     procedure load(langfile : TIniFile);
     end;
type TLanguage = class
     public
     Mainform : TLangFMainform;
     Deckblatt : TLangFDeckblatt;
     Options : TLangFOptions;
     Stats : TLangFStats;
     Player: TLangFPlayer;
     Author : TLangFAuthor;
     Generic : TLangGeneric;
     constructor create;
     destructor Destroy;Override;
     procedure read;
     end;

var lang : TLanguage;
implementation
uses Uini;



procedure TLangFMainform.load(langfile: TIniFile);
var
 tlang: string;
begin
 tlang:=inttostr(config.client.language);
 with langfile do
  begin
   self.Caption:=ReadString(tlang,'FMain_Caption','Error');
   self.Stats_0:=ReadString(tlang,'FMain_Stats_0','Error');
   self.Stats_1:=ReadString(tlang,'FMain_Stats_1','Error');
   self.Help_0:=ReadString(tlang,'FMain_Help_0','Error');
   self.Help_1:=ReadString(tlang,'FMain_Help_1','Error');
   self.Crea_0_0:=ReadString(tlang,'FMain_Crea_0_0','Error');
   self.Crea_0_1:=ReadString(tlang,'FMain_Crea_0_1','Error');
   self.Crea_0_2:=ReadString(tlang,'FMain_Crea_0_2','Error');
   self.Crea_0_3:=ReadString(tlang,'FMain_Crea_0_3','Error');
   self.Crea_1_0:=ReadString(tlang,'FMain_Crea_1_0','Error');
   self.Crea_1_1:=ReadString(tlang,'FMain_Crea_1_1','Error');
   self.Crea_1_2:=ReadString(tlang,'FMain_Crea_1_2','Error');
   self.Crea_1_3:=ReadString(tlang,'FMain_Crea_1_3','Error');
   self.Crea_1_4:=ReadString(tlang,'FMain_Crea_1_4','Error');
   self.Crea_1_5:=ReadString(tlang,'FMain_Crea_1_5','Error');
   self.Crea_1_6:=ReadString(tlang,'FMain_Crea_1_6','Error');
   self.MM_0:=ReadString(tlang,'FMain_MM_0','Error');
   self.MM_0_0_0:=ReadString(tlang,'FMain_MM_0_0_0','Error');
   self.MM_0_0_1:=ReadString(tlang,'FMain_MM_0_0_1','Error');
   self.MM_0_1_0:=ReadString(tlang,'FMain_MM_0_1_0','Error');
   self.MM_0_1_1:=ReadString(tlang,'FMain_MM_0_1_1','Error');
   self.MM_0_2:=ReadString(tlang,'FMain_MM_0_2','Error');
   self.MM_0_3:=ReadString(tlang,'FMain_MM_0_3','Error');
   self.MM_0_4:=ReadString(tlang,'FMain_MM_0_4','Error');
   self.MM_0_5:=ReadString(tlang,'FMain_MM_0_5','Error');
   self.MM_1:=ReadString(tlang,'FMain_MM_1','Error');
   self.MM_1_0:=ReadString(tlang,'FMain_MM_1_0','Error');
   self.MM_1_1_0:=ReadString(tlang,'FMain_MM_1_1_0','Error');
   self.MM_1_1_1:=ReadString(tlang,'FMain_MM_1_1_1','Error');
   self.MM_1_1_2:=ReadString(tlang,'FMain_MM_1_1_2','Error');
   self.MM_1_2:=ReadString(tlang,'FMain_MM_1_2','Error');
   self.MM_1_3:=ReadString(tlang,'FMain_MM_1_3','Error');
   self.MM_1_4:=ReadString(tlang,'FMain_MM_1_4','Error');
   self.MM_2:=ReadString(tlang,'FMain_MM_2','Error');
   self.MM_2_0:=ReadString(tlang,'FMain_MM_2_0','Error');
   self.MM_2_1:=ReadString(tlang,'FMain_MM_2_1','Error');
   self.Chat_0:=ReadString(tlang,'FMain_Chat_0','Error');
   self.Chat_1_0:=ReadString(tlang,'FMain_Chat_1_0','Error');
   self.Chat_1_1:=ReadString(tlang,'FMain_Chat_1_1','Error');
   self.Chat_1_2:=ReadString(tlang,'FMain_Chat_1_2','Error');
   self.Chat_2:=ReadString(tlang,'FMain_Chat_2','Error');
   self.Chat_3:=ReadString(tlang,'FMain_Chat_3','Error');
   self.Chat_4:=ReadString(tlang,'FMain_Chat_4','Error');
   self.Chat_5:=ReadString(tlang,'FMain_Chat_5','Error');
   self.Chat_6_0:=ReadString(tlang,'FMain_Chat_6_0','Error');
   self.Chat_6_1:=ReadString(tlang,'FMain_Chat_6_1','Error');
   self.Chat_7_0:=ReadString(tlang,'FMain_Chat_7_0','Error');
   self.Chat_7_1:=ReadString(tlang,'FMain_Chat_7_1','Error');
   self.Chat_7_2:=ReadString(tlang,'FMain_Chat_7_2','Error');
   self.Chat_8_0:=ReadString(tlang,'FMain_Chat_8_0','Error');
   self.Chat_8_1:=ReadString(tlang,'FMain_Chat_8_1','Error');
   self.Chat_9_0:=ReadString(tlang,'FMain_Chat_9_0','Error');
   self.Chat_9_1:=ReadString(tlang,'FMain_Chat_9_1','Error');
   self.Chat_10:=ReadString(tlang,'FMain_Chat_10','Error');
   self.SB_0_0:=ReadString(tlang,'FMain_SB_0_0','Error');
   self.SB_0_1:=ReadString(tlang,'FMain_SB_0_1','Error');
   self.SB_0_2:=ReadString(tlang,'FMain_SB_0_2','Error');
   self.SB_0_3:=ReadString(tlang,'FMain_SB_0_3','Error');
   self.SB_0_4:=ReadString(tlang,'FMain_SB_0_4','Error');
   self.SB_0_5:=ReadString(tlang,'FMain_SB_0_5','Error');
   self.SB_0_6:=ReadString(tlang,'FMain_SB_0_6','Error');
   self.SB_0_7:=ReadString(tlang,'FMain_SB_0_7','Error');
   self.SB_0_8:=ReadString(tlang,'FMain_SB_0_8','Error');
   self.SB_0_9:=ReadString(tlang,'FMain_SB_0_9','Error');
   self.SB_0_10:=ReadString(tlang,'FMain_SB_0_10','Error');
   self.SB_0_11:=ReadString(tlang,'FMain_SB_0_11','Error');
   self.SB_0_12:=ReadString(tlang,'FMain_SB_0_12','Error');
   self.SB_0_13:=ReadString(tlang,'FMain_SB_0_13','Error');
   self.SB_1_0:=ReadString(tlang,'FMain_SB_1_0','Error');
   self.SB_1_1:=ReadString(tlang,'FMain_SB_1_1','Error');
   self.SB_1_2:=ReadString(tlang,'FMain_SB_1_2','Error');
   self.SB_1_3:=ReadString(tlang,'FMain_SB_1_3','Error');
   self.SB_1_4:=ReadString(tlang,'FMain_SB_1_4','Error');
   self.SB_1_5:=ReadString(tlang,'FMain_SB_1_5','Error');
   self.SB_2_0:=ReadString(tlang,'FMain_SB_2_0','Error');
   self.SB_2_1:=ReadString(tlang,'FMain_SB_2_1','Error');
  end;
end;


procedure TLangFDeckblatt.load(langfile: TIniFile);
begin
 self.Caption:=langfile.ReadString(inttostr(config.client.language),
                                    'FDeckblatt_Caption','Error');
end;


procedure TLangFOptions.load(langfile: TIniFile);
var
 tlang: string;
begin
 tlang:=inttostr(config.client.language);
 with langfile do
  begin
   self.Caption:=ReadString(tlang,'FOptions_Caption','Error');
   self.Err_0:=ReadString(tlang,'FOptions_Err_0','Error');
   self.Err_1:=ReadString(tlang,'FOptions_Err_1','Error');
   self.Err_2:=ReadString(tlang,'FOptions_Err_2','Error');
   self.TC_0:=ReadString(tlang,'FOptions_TC_0','Error');
   self.TC_1:=ReadString(tlang,'FOptions_TC_1','Error');
   self.C_name:=ReadString(tlang,'FOptions_C_name','Error');
   self.C_Stats:=ReadString(tlang,'FOptions_C_Stats','Error');
   self.C_Label1:=ReadString(tlang,'FOptions_C_Label1','Error');
   self.C_Label2:=ReadString(tlang,'FOptions_C_Label2','Error');
   self.C_sortorder_0:=ReadString(tlang,'FOptions_C_sortorder_0','Error');
   self.C_sortorder_1:=ReadString(tlang,'FOptions_C_sortorder_1','Error');
   self.C_sortorder_2:=ReadString(tlang,'FOptions_C_sortorder_2','Error');
   self.C_Label3:=ReadString(tlang,'FOptions_C_Label3','Error');
   self.C_language_0:=ReadString(tlang,'FOptions_C_language_0','Error');
   self.C_language_1:=ReadString(tlang,'FOptions_C_language_1','Error');
   self.C_language_2:=ReadString(tlang,'FOptions_C_language_2','Error');
   self.S_name:=ReadString(tlang,'FOptions_S_name','Error');
   self.S_pass:=ReadString(tlang,'FOptions_S_pass','Error');
   self.S_action:=ReadString(tlang,'FOptions_S_action','Error');
   self.S_Label1:=ReadString(tlang,'FOptions_S_Label1','Error');
   self.S_n_w:=ReadString(tlang,'FOptions_S_n_w','Error');
   self.S_b_b:=ReadString(tlang,'FOptions_S_b_b','Error');
  end;
end;


procedure TLangFStats.load(langfile: TIniFile);
var
 tlang: string;
begin
 tlang:=inttostr(config.client.language);
 with langfile do
  begin
   self.Caption:=ReadString(tlang,'FStats_Caption','Error');
   self.Lab_1 :=ReadString(tlang,'FStats_Lab_1','Error');
   self.Lab_2 :=ReadString(tlang,'FStats_Lab_2','Error');
   self.Lab_3 :=ReadString(tlang,'FStats_Lab_3','Error');
   self.Lab_4 :=ReadString(tlang,'FStats_Lab_4','Error');
   self.Lab_5 :=ReadString(tlang,'FStats_Lab_5','Error');
   self.Lab_6 :=ReadString(tlang,'FStats_Lab_6','Error');
   self.Lab_7 :=ReadString(tlang,'FStats_Lab_7','Error');
   self.Lab_8 :=ReadString(tlang,'FStats_Lab_8','Error');
   self.Lab_9 :=ReadString(tlang,'FStats_Lab_9','Error');
   self.Lab_10:=ReadString(tlang,'FStats_Lab_10','Error');
   self.Lab_11:=ReadString(tlang,'FStats_Lab_11','Error');
  end;
end;


procedure TLangFAuthor.load(langfile: TIniFile);
var
 tlang: string;
begin
 tlang:=inttostr(config.client.language);
 with langfile do
  begin
   self.Caption:=ReadString(tlang,'FAuthor_Caption','Error');
   self.Lab_1:=ReadString(tlang,'FAuthor_Lab_1','Error');
   self.Lab_ver_0:=ReadString(tlang,'FAuthor_Lab_ver_0','Error');
   self.Lab_ver_1:=ReadString(tlang,'FAuthor_Lab_ver_1','Error');
   self.Lab_2:=ReadString(tlang,'FAuthor_Lab_2','Error');
   self.Lab_3:=ReadString(tlang,'FAuthor_Lab_3','Error');
   self.Lab_4:=ReadString(tlang,'FAuthor_Lab_4','Error');
   self.lab_licence_0:=ReadString(tlang,'FAuthor_lab_licence_0','Error');
   self.lab_licence_1:=ReadString(tlang,'FAuthor_lab_licence_1','Error');
   self.lab_licence_2:=ReadString(tlang,'FAuthor_lab_licence_2','Error');
   self.lab_licence_3:=ReadString(tlang,'FAuthor_lab_licence_3','Error');
   self.lab_licence_4:=ReadString(tlang,'FAuthor_lab_licence_4','Error');
  end;
end;


procedure TLangFPlayer.load(langfile: TIniFile);
var
 tlang: string;
begin
 tlang:=inttostr(config.client.language);
 with langfile do
  begin
   self.player1:=ReadString(tlang,'FPlayer_p_1','Error');
   self.player2:=ReadString(tlang,'FPlayer_p_2','Error');
   self.player3:=ReadString(tlang,'FPlayer_p_3','Error');
   self.player4:=ReadString(tlang,'FPlayer_p_4','Error');
   self.rb_0:=ReadString(tlang,'FPlayer_rb_0','Error');
   self.rb_1:=ReadString(tlang,'FPlayer_rb_1','Error');
   self.noname:=ReadString(tlang,'FPlayer_nn','Error');
   self.but_chat:=ReadString(tlang,'FPlayer_b_0','Error');
   self.but_client_leave:=ReadString(tlang,'FPlayer_b_c_0','Error');
   self.but_client_rules:=ReadString(tlang,'FPlayer_b_c_1','Error');
   self.but_server_close:=ReadString(tlang,'FPlayer_b_s_0','Error');
   self.but_server_roundstart:=ReadString(tlang,'FPlayer_b_s_1','Error');
   self.but_server_rules:=ReadString(tlang,'FPlayer_b_s_2','Error');
   self.rules_0:=ReadString(tlang,'FPlayer_r_0','Error');
   self.rules_1:=ReadString(tlang,'FPlayer_r_1','Error');
   self.rules_2:=ReadString(tlang,'FPlayer_r_2','Error');
   self.rules_3:=ReadString(tlang,'FPlayer_r_3','Error');
   self.rules_4:=ReadString(tlang,'FPlayer_r_4','Error');
   self.rules_5:=ReadString(tlang,'FPlayer_r_5','Error');
   self.rules_6:=ReadString(tlang,'FPlayer_r_6','Error');
   self.rules_7:=ReadString(tlang,'FPlayer_r_7','Error');
  end;
end;


procedure TLangGeneric.load(langfile: TIniFile);
var
 tlang: string;
begin
 tlang:=inttostr(config.client.language);
 with langfile do
  begin
   self.Yes:=ReadString(tlang,'Generic_Yes','Error');
   self.No:=ReadString(tlang,'Generic_No','Error');
   self.Color[-1]:=ReadString(tlang,'Generic_unknown','Error');
   self.Color[0]:=ReadString(tlang,'Generic_C_0','Error');
   self.Color[1]:=ReadString(tlang,'Generic_C_1','Error');
   self.Color[2]:=ReadString(tlang,'Generic_C_2','Error');
   self.Color[3]:=ReadString(tlang,'Generic_C_3','Error');
   self.Face[-1]:=ReadString(tlang,'Generic_unknown','Error');
   self.Face[0]:=ReadString(tlang,'Generic_F_0','Error');
   self.Face[1]:=ReadString(tlang,'Generic_F_1','Error');
   self.Face[2]:=ReadString(tlang,'Generic_F_2','Error');
   self.Face[3]:=ReadString(tlang,'Generic_F_3','Error');
   self.Face[4]:=ReadString(tlang,'Generic_F_4','Error');
   self.Face[5]:=ReadString(tlang,'Generic_F_5','Error');
   self.Face[6]:=ReadString(tlang,'Generic_F_6','Error');
   self.Face[7]:=ReadString(tlang,'Generic_F_7','Error');
   self.Face[8]:=ReadString(tlang,'Generic_F_8','Error');
   self.Face[9]:=ReadString(tlang,'Generic_F_9','Error');
   self.Face[10]:=ReadString(tlang,'Generic_F_10','Error');
   self.Face[11]:=ReadString(tlang,'Generic_F_11','Error');
   self.Face[12]:=ReadString(tlang,'Generic_F_12','Error');
  end;
end;


constructor TLanguage.create;
begin
 self.Mainform:=TLangFMainform.Create;
 self.Deckblatt:=TLangFDeckblatt.Create;
 self.Options:=TLangFOptions.Create;
 self.Stats:=TLangFStats.Create;
 self.Player:=TLangFPlayer.Create;
 self.Author:=TLangFAuthor.Create;
 self.Generic:=TLangGeneric.Create;
 self.read;
end;


destructor TLanguage.Destroy;
begin
 FreeAndNil(self.Mainform);
 FreeAndNil(self.Deckblatt);
 FreeAndNil(self.Options);
 FreeAndNil(self.Stats);
 FreeAndNil(self.Player);
 FreeAndNil(self.Author);
 FreeAndNil(self.Generic);
end;


procedure TLanguage.read;
var langfile : TIniFile;
begin
 langfile:= TIniFile.Create(ExtractFilePath(ParamStr(0))+'language.rcl');
 try
  self.Mainform.load(langfile);
  self.Deckblatt.load(langfile);
  self.Options.load(langfile);
  self.Stats.load(langfile);
  self.Player.load(langfile);
  self.Author.load(langfile);
  self.Generic.load(langfile);
 finally
  langfile.Free;
 end;
end;



end.
