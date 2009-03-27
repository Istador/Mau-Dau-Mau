unit UClientGame;
{
  author:     Robin Christopher Ladiges
  website:    http://blackpinguin.de/
  project:    Mau Dau Mau
  binary:     MauDauMau.exe
  unit:       UClientGame
  file:       UClientGame.pas
  filepath:   .\executable\units\
  year:       2008/2009
  desc:       This file handles the TClientGame class, the class that represent
              the client side of the game, saves a few properties and contains
              the Form.

  license:    creative commons by-nc-sa 3.0 germany
   look out license.txt in root folder
   human-readable summary : http://creativecommons.org/licenses/by-nc-sa/3.0/de/
}

interface
uses UClientForm, UIni, FMainform, FColor, ComCtrls, SysUtils;

type TClientGamePlayer = class
     name:string;
     position : 1..4;
     constructor create(name : string; position : word);
     end;

type TClientGame = class
     Form : TClientForm;
     PlayerSelf : TClientGamePlayer;
     Player1 : TClientGamePlayer;
     Player2 : TClientGamePlayer;
     Player3 : TClientGamePlayer;
     canplay : boolean;
     currentplayer:integer; //nur fürs language ändern wichtig
     ziehen : 1..16;
     out : 0..1;
     rules : TIniRules;
     ClForm : TForm6;
     constructor create(self_name, Player1_name, Player2_name, Player3_name
                        : string; self_position, Player1_position,
                        Player2_position, Player3_position : integer;
                        rules: TIniRules);
     destructor Destroy; Override;
     function player(position: Word) : TClientGamePlayer;
     procedure colorshow(nofarbe:integer);
     end;

var ClientGame : TClientGame;

implementation
uses UServer, ULanguage, UClient;



constructor TClientGamePlayer.create(name: string; position: Word);
begin
 self.name:=name;
 self.position:=position;
end;


constructor TClientGame.create(self_name,Player1_name,Player2_name,Player3_name:
                               string; self_position, Player1_position,
                               Player2_position, Player3_position: integer;
                               rules: TIniRules);
begin
 self.Form := TClientForm.create;
 self.PlayerSelf:=TClientGamePlayer.create(self_name,self_position);
 self.Player1:=TClientGamePlayer.create(Player1_name,Player1_position);
 self.Player2:=TClientGamePlayer.create(Player2_name,Player2_position);
 self.Player3:=TClientGamePlayer.create(Player3_name,Player3_position);
 Form1.Spiel1.Visible:=true;
 if assigned(server) then Form1.RundeBeenden1.Visible:=true;
 Form1.RundeAussetzen1.Enabled:=false;
 Form1.xKartenziehen1.Enabled:=false;
 Form1.xKartenziehen1.Caption:='1 '+lang.Mainform.MM_1_1_0+' '
                               +lang.Mainform.MM_1_1_2;
 canplay:=false;
 self.rules:=rules;
end;


destructor TClientGame.Destroy;
begin
 if assigned(self.ClForm) then
  begin
   self.ClForm.Hide; //aus irgendeinem grund bleibt sie sichtbar nach close+free
   self.ClForm.Close;
  end;
 FreeAndNil(self.PlayerSelf);
 FreeAndNil(self.Player1);
 FreeAndNil(self.Player2);
 FreeAndNil(self.Player3);
 FreeAndNil(self.Form);

 Form1.StatusBar1.Panels[1].Text:='';
 Form1.StatusBar1.Panels[1].Bevel:=pbNone;
 Form1.StatusBar1.Panels[2].Text:='';
 Form1.StatusBar1.Panels[2].Bevel:=pbNone;
 Form1.RundeBeenden1.Visible:=false;
 Form1.Spiel1.Visible:=false;
 inherited;
end;


function TClientGame.player(position: Word) : TClientGamePlayer;
begin
 if self.PlayerSelf.position = position+1 then result:=self.PlayerSelf
 else if self.Player1.position = position+1 then result:=self.Player1
 else if self.Player2.position = position+1 then result:=self.Player2
 else if self.Player3.position = position+1 then result:=self.Player3
 else result:=nil;
end;


procedure TClientGame.colorshow(nofarbe:integer);
begin
 self.ClForm:=TForm6.Create(Form1);
 self.ClForm.languageload;
 //ausblenden der Farbe die bereits liegt
 if nofarbe = 0 then
  begin
   self.ClForm.Img_Kreuz.Visible:=false;
   self.ClForm.Lab_Kreuz.Visible:=false;
  end
 else if nofarbe = 1 then
  begin
   self.ClForm.Img_Karo.Visible:=false;
   self.ClForm.Lab_Karo.Visible:=false;
  end
 else if nofarbe = 2 then
  begin
   self.ClForm.Img_Herz.Visible:=false;
   self.ClForm.Lab_Herz.Visible:=false;
  end
 else
  begin
   self.ClForm.Img_Pik.Visible:=false;
   self.ClForm.Lab_Pik.Visible:=false;
  end;
 self.ClForm.Left:=Form1.Left+(Form1.Width div 2)-(self.ClForm.Width div 2);
 self.ClForm.Top:=Form1.Top+(Form1.Height div 2)-(self.ClForm.Height div 2);
 self.ClForm.ShowModal;
end;



end.
