unit UClientForm;
{
  author:     Robin Christopher Ladiges
  website:    http://blackpinguin.de/
  project:    Mau Dau Mau
  executable: MauDauMau.exe
  unit:       UClientForm
  file:       UClientForm.pas
  filepath:   .\executable\units\
  year:       2008/2009
  desc:       This file handles the TClientForm class. This class only group up
              the classes in UClientPos. It create, destroy and reposition the
              cards and the token.

  license:    creative commons by-nc-sa 3.0 germany
   look out license.txt in root folder
   human-readable summary : http://creativecommons.org/licenses/by-nc-sa/3.0/de/
}

interface
uses UClientPos, stdctrls;

type TClientForm = class
     Deck : TClientPosDeck;
     OpenCards : TClientPosOpenCards;
     Player0 : TClientPosPlayer0;
     Player1 : TClientPosPlayer1;
     Player2 : TClientPosPlayer2;
     Player3 : TClientPosPlayer3;
     Tocken : TClientPosTocken;
     constructor create;
     procedure card_position;
     destructor Destroy;Override;
     end;

var ClientForm : TClientForm;

implementation
uses FMainform;



constructor TClientForm.create;
begin
 self.Deck := TClientPosDeck.create;
 self.OpenCards:=TClientPosOpenCards.create;
 self.Tocken:=TClientPosTocken.create(Form1);
 self.Player0:=TClientPosPlayer0.create;
 self.Player1:=TClientPosPlayer1.create;
 self.Player2:=TClientPosPlayer2.create;
 self.Player3:=TClientPosPlayer3.create;
end;


procedure TClientForm.card_position;
begin
 self.Deck.position;
 self.OpenCards.position;
 self.Tocken.position;
 self.Player3.position;
 self.Player2.position;
 self.Player1.position;
 self.Player0.position;
end;


destructor TClientForm.Destroy;
begin
 self.Deck.Free;
 self.OpenCards.Free;
 self.Tocken.Free;
 self.Player0.Free;
 self.Player1.Free;
 self.Player2.Free;
 self.Player3.Free;
 inherited;
end;



end.
