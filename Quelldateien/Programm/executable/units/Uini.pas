unit Uini;
{
  author:     Robin Christopher Ladiges
  website:    http://blackpinguin.de/
  project:    Mau Dau Mau
  binary:     MauDauMau.exe
  unit:       Uini
  file:       Uini.pas
  filepath:   .\executable\units\
  year:       2008/2009
  desc:       This file handles the TIniConfig class. This class read and write
              the options, rules and statistics of the user, and saves it for
              future use.

  license:    creative commons by-nc-sa 3.0 germany
   look out license.txt in root folder
   human-readable summary : http://creativecommons.org/licenses/by-nc-sa/3.0/de/
}

interface
uses IniFiles, sysutils, windows;

type TIniClient = record
     PosTop: integer;
     PosLeft: integer;
     PosHeight: integer;
     PosWidth: integer;
     language: integer;
     background: word;
     sortorder: integer;
     lastserver: string;
     lastport: integer;
     name: string;
     austeilen: integer;
     savestats: boolean;
     rfc4340: boolean;
     end;
type TIniRules = record
     seven_use: boolean;
     seven_take: integer;
     eight_use: boolean;
     nine_use: boolean;
     nine_win: boolean;
     bube_use: boolean;
     bube_bube: boolean;
     end;
type TIniServer = record
     name: string;
     port: integer;
     password: string;
     seven_use: boolean;
     seven_take: integer;
     eight_use: boolean;
     nine_use: boolean;
     nine_win: boolean;
     bube_use: boolean;
     bube_bube: boolean;
     end;
type TIniStats = record
     winsvs3: integer;
     winsvs2: integer;
     winsvs1: integer;
     winsvs0: integer;
     plays: integer;
     draws: integer;
     turnouts: integer;
     sevens: integer;
     eights: integer;
     nines: integer;
     bubes: integer;
     end;
type TIniConfig = class
     public
      client: TIniClient;
      server: TIniServer;
      stats: TIniStats;
      constructor create;
      destructor Destroy;Override;
      procedure read;
      procedure write;
     end;
//abwandlung zur entfernung von errormessages bei fehlenden schreibrechten
type TRLIniFile = class(TIniFile)
     private
      FFileName:string;
     public
      constructor Create(const FileName: string);reintroduce;
      procedure WrStr(const Section, Ident, Value: string);
      procedure WrInt(const Section, Ident: string; Value: Longint);
      procedure WrBool(const Section, Ident: string; Value: Boolean);
     end;

var config : TIniConfig;
implementation
uses Forms, FMainform;



constructor TIniConfig.create;
begin
 self.read;
end;


destructor TIniConfig.Destroy;
begin
 self.write;
 config:=nil;
end;


procedure TIniConfig.read;
var
 ini: TIniFile;
begin
 ini:= TIniFile.Create(ExtractFilePath(ParamStr(0))+'MauDauMau.ini');
 try
  with self.client do
   begin
    language := ini.ReadInteger('Client','Language',0); //0=Deutsch; 1=Englisch;
                                                        //2=Französich
    PosHeight := ini.ReadInteger('Client','PosHeight',504);
    PosWidth := ini.ReadInteger('Client','PosWidth',458);
    PosTop:=ini.ReadInteger('Client','PosTop',((Screen.Monitors[0].Height div 2)
                                              -(PosHeight div 2)));
    PosLeft:=ini.ReadInteger('Client','PosLeft',((Screen.Monitors[0].Width div 2)
                                                -(PosWidth div 2)));
    background := ini.ReadInteger('Client','background',54);
    sortorder := ini.ReadInteger('Client','SortOrder',1); //0=garnicht;
                                                          //1=nach Farbe;
                                                          //2=nach Wert
    lastserver := ini.ReadString('Client','lastServer','');
    lastport := ini.ReadInteger('Client','lastPort',50000);
    name := ini.ReadString('Client','name','Player');
    austeilen := ini.ReadInteger('Client','cardammount',7);
    savestats := ini.ReadBool('Client','savestats',false);
    rfc4340 := ini.ReadBool('Client','RFC4340',true);
   end;
  with self.server do
   begin
    name := ini.ReadString('Server','name','Server');
    port := ini.ReadInteger('Server','lastPort',50000);
    password := ini.ReadString('Server','password','');
    seven_use := ini.ReadBool('Server','seven-use',true);
    seven_take := ini.ReadInteger('Server','seven-take',2);
    eight_use := ini.ReadBool('Server','eight-use',true);
    nine_use := ini.ReadBool('Server','nine-use',true);
    nine_win := ini.ReadBool('Server','nine-win',false);
    bube_use := ini.ReadBool('Server','bube-use',true);
    bube_bube := ini.ReadBool('Server','bube-bube',false);
   end;
  with self.stats do
   begin
    winsvs3 := ini.ReadInteger('Statistic','winsvs3',0);
    winsvs2 := ini.ReadInteger('Statistic','winsvs2',0);
    winsvs1 := ini.ReadInteger('Statistic','winsvs1',0);
    winsvs0 := ini.ReadInteger('Statistic','winsvs0',0);
    plays := ini.ReadInteger('Statistic','plays',0);
    draws := ini.ReadInteger('Statistic','draws',0);
    turnouts := ini.ReadInteger('Statistic','turnouts',0);
    sevens := ini.ReadInteger('Statistic','sevens',0);
    eights := ini.ReadInteger('Statistic','eights',0);
    nines := ini.ReadInteger('Statistic','nines',0);
    bubes := ini.ReadInteger('Statistic','bubes',0);
   end;
 finally
  ini.free;
 end;
end;


procedure TIniConfig.write;
var
 ini: TRLIniFile;
begin
 ini:= TRLIniFile.Create(ExtractFilePath(ParamStr(0))+'MauDauMau.ini');
 try
  with self.client do
   begin
    ini.WrInt('Client','Language',language);
    ini.WrInt('Client','PosTop',PosTop);
    ini.WrInt('Client','PosLeft',PosLeft);
    ini.WrInt('Client','PosHeight',PosHeight);
    ini.WrInt('Client','PosWidth',PosWidth);
    ini.WrInt('Client','background',background);
    ini.WrInt('Client','SortOrder',sortorder);
    ini.WrStr('Client','lastServer',lastserver);
    ini.WrInt('Client','lastPort',lastport);
    ini.WrStr('Client','name',name);
    ini.WrInt('Client','cardammount',austeilen);
    ini.WrBool('Client','savestats',savestats);
   end;
  with self.server do
   begin
    ini.WrStr('Server','name',name);
    ini.WrInt('Server','port',port);
    ini.WrStr('Server','password',password);
    ini.WrBool('Server','seven-use',seven_use);
    ini.WrInt('Server','seven-take',seven_take);
    ini.WrBool('Server','eight-use',eight_use);
    ini.WrBool('Server','nine-use',nine_use);
    ini.WrBool('Server','nine-win',nine_win);
    ini.WrBool('Server','bube-use',bube_use);
    ini.WrBool('Server','bube-bube',bube_bube);
   end;
  with self.stats do
   begin
    ini.WrInt('Statistic','winsvs3',winsvs3);
    ini.WrInt('Statistic','winsvs2',winsvs2);
    ini.WrInt('Statistic','winsvs1',winsvs1);
    ini.WrInt('Statistic','winsvs0',winsvs0);
    ini.WrInt('Statistic','plays',plays);
    ini.WrInt('Statistic','draws',draws);
    ini.WrInt('Statistic','turnouts',turnouts);
    ini.WrInt('Statistic','sevens',sevens);
    ini.WrInt('Statistic','eights',eights);
    ini.WrInt('Statistic','nines',nines);
    ini.WrInt('Statistic','bubes',bubes);
   end;
 finally
  ini.free;
 end;
end;


//------------------------------------------------------------------------------
//Der folgende Abschnitt ist eine Kopie der TIniFile klasse. Sie dient dazu eine
//abgeänderte Form der WriteString procedure zu erstellen, die keine Fehler-
//meldung ausgibt falls nicht geschrieben werden kann (z.B. schreiben auf CD)
//------------------------------------------------------------------------------
constructor TRLIniFile.Create(const FileName: string);
begin
 inherited Create(FileName);
 self.FFileName:=FileName;
end;


procedure TRLIniFile.WrStr(const Section, Ident, Value: string);
begin
 WritePrivateProfileString(PChar(Section), PChar(Ident), PChar(Value),
                           PChar(FFileName));
end;


procedure TRLIniFile.WrInt(const Section, Ident: string; Value: Longint);
begin
 WrStr(Section, Ident, IntToStr(Value));
end;


procedure TRLIniFile.WrBool(const Section, Ident: string; Value: Boolean);
const
 Values: array[Boolean] of string = ('0', '1');
begin
 WrStr(Section, Ident, Values[Value]);
end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------




end.
