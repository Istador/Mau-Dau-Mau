unit FColor;
{
  author:     Robin Christopher Ladiges
  website:    http://blackpinguin.de/
  project:    Mau Dau Mau
  binary:     MauDauMau.exe
  unit:       FColor
  file:       FColor.pas
  filepath:   .\executable\forms\
  year:       2008/2009
  desc:       This file handles the ColorForm, the form to choose a color after
              playing a jack.

  license:    creative commons by-nc-sa 3.0 germany
   look out license.txt in this folder
   human-readable summary : http://creativecommons.org/licenses/by-nc-sa/3.0/de/
}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  ExtCtrls, StdCtrls;

type
  TForm6 = class(TForm)
    Img_Herz: TImage;
    Img_Karo: TImage;
    Img_Pik: TImage;
    Img_Kreuz: TImage;
    Lab_Herz: TLabel;
    Lab_Karo: TLabel;
    Lab_Pik: TLabel;
    Lab_Kreuz: TLabel;
    procedure FarbeClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure languageload;
  private
    { Private-Deklarationen }
  public
    farbe : integer;
  end;

implementation
{$R *.dfm}
uses ULanguage, UClient;



procedure TForm6.languageload;
begin
 //Beschriftung in entsprechender Sprache
 Lab_Kreuz.Caption:=lang.Generic.color[0];
 Lab_Karo.Caption:=lang.Generic.color[1];
 Lab_Herz.Caption:=lang.Generic.color[2];
 Lab_Pik.Caption:=lang.Generic.color[3];
end;


procedure TForm6.FarbeClick(Sender: TObject);
begin
 if (sender = Img_Kreuz) or (sender = Lab_Kreuz) then self.farbe:=0;
 if (sender = Img_Karo) or (sender = Lab_Karo) then self.farbe:=1;
 if (sender = Img_Herz) or (sender = Lab_Herz) then self.farbe:=2;
 if (sender = Img_Pik) or (sender = Lab_Pik) then self.farbe:=3;
 if assigned(client) and assigned(client.game) and client.Active then
  client.send_text('wunsch;'+inttostr(self.farbe)+';');
 self.Close;
end;


procedure TForm6.FormCreate(Sender: TObject);
begin
 //zur mittigen ausrichtung der Labelinhalte
 Lab_Herz.Width:=44;
 Lab_Karo.Width:=44;
 Lab_Pik.Width:=44;
 Lab_Kreuz.Width:=44;
end;



end.
