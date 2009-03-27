unit UServerCards;
{
  author:     Robin Christopher Ladiges
  website:    http://blackpinguin.de/
  project:    Mau Dau Mau
  binary:     MauDauMau.exe
  unit:       UServerCards
  file:       UServerCards.pas
  filepath:   .\executable\units\
  year:       2008/2009
  desc:       This file handles the TServerCards Class. This is a simple class
              and could be replaced by a record. but records can't be nil. in
              some methods i return a object of this type and sometimes it's nil

  license:    creative commons by-nc-sa 3.0 germany
   look out license.txt in this folder
   human-readable summary : http://creativecommons.org/licenses/by-nc-sa/3.0/de/
}

interface
uses ExtCtrls;

type TServerCards = class
     public
     card : integer;
     position : 0..4;  // 0 im Deck oder Hand  | 1,2,3,4 -> offene karten
     player : 0..4;    // 0 im Deck; 1: Player 1 offene Karte(position:1-5)
                       //               oder auf hand(Position:0)
     constructor create(card, position, player: integer);
     end;

implementation



constructor TServerCards.create(card : integer; position: integer;
                                player : integer);
begin
 self.card:=card;
 self.position:=position;
 self.player:=player;
end;



end.
