unit FDeckblatt;
{
  author:     Robin Christopher Ladiges
  website:    http://blackpinguin.de/
  project:    Mau Dau Mau
  binary:     MauDauMau.exe
  unit:       FDeckblatt
  file:       FDeckblatt.pas
  filepath:   .\executable\forms\
  year:       2008/2009
  desc:       This file handles the DeckblattForm, the form to choose a cover.

  license:    creative commons by-nc-sa 3.0 germany
   look out license.txt in this folder
   human-readable summary : http://creativecommons.org/licenses/by-nc-sa/3.0/de/
}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  ExtCtrls, Menus, ScktComp, StdCtrls, IniFiles;

type
  TForm2 = class(TForm)
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    Image6: TImage;
    Image7: TImage;
    Image8: TImage;
    Image9: TImage;
    Image10: TImage;
    Image11: TImage;
    Image12: TImage;
    procedure ImageClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormActivate(Sender: TObject);
    procedure languageload;
    procedure FormCreate(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Form2: TForm2;

implementation
{$R *.dfm}
uses FMainform, Udll, UIni, ULanguage;


procedure TForm2.languageload;
begin
 self.Caption:=lang.Deckblatt.Caption;
end;


procedure TForm2.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 config.write; // schreibe in die ini file
 Form1.FormIniChange; // Änderung umzusetzen
end;


procedure TForm2.FormCreate(Sender: TObject);
begin
 self.languageload;
end;

procedure TForm2.FormActivate(Sender: TObject);
var selected : TImage;
begin
 // herausfinden welcher hintergrund eingestellt ist und in selected merken
 selected:=Image1;
 case config.client.background of
  54:selected:=Image1;
  55:selected:=Image2;
  56:selected:=Image3;
  57:selected:=Image4;
  58:selected:=Image5;
  59:selected:=Image6;
  60:selected:=Image7;
  61:selected:=Image8;
  62:selected:=Image9;
  63:selected:=Image10;
  64:selected:=Image11;
  65:selected:=Image12;
 end;
 // die Image Objekte zeichnen, mit der cards.dll funktion
 cdtDrawExt(Image1.Canvas.Handle,0,0,57,77,54,1,0);
 cdtDrawExt(Image2.Canvas.Handle,0,0,57,77,55,1,0);
 cdtDrawExt(Image3.Canvas.Handle,0,0,57,77,56,1,0);
 cdtDrawExt(Image4.Canvas.Handle,0,0,57,77,57,1,0);
 cdtDrawExt(Image5.Canvas.Handle,0,0,57,77,58,1,0);
 cdtDrawExt(Image6.Canvas.Handle,0,0,57,77,59,1,0);
 cdtDrawExt(Image7.Canvas.Handle,0,0,57,77,60,1,0);
 cdtDrawExt(Image8.Canvas.Handle,0,0,57,77,61,1,0);
 cdtDrawExt(Image9.Canvas.Handle,0,0,57,77,62,1,0);
 cdtDrawExt(Image10.Canvas.Handle,0,0,57,77,63,1,0);
 cdtDrawExt(Image11.Canvas.Handle,0,0,57,77,64,1,0);
 cdtDrawExt(Image12.Canvas.Handle,0,0,57,77,65,1,0);
 // den eingestellten Hintergrund markieren (umranden)
 TImage(selected).Transparent:=false; //bei den anderen Aktiv, um keinen weißen
                                      //Rand zu haben. Bezieht sich auf die
                                      //Farbe des obersten linken Pixels
 TImage(selected).Canvas.Pen.Color:=clLime; //Farbe des Pinsels zur Umrandung
 TImage(selected).Canvas.Pen.Width:=8; //breite des Pinsels zur umrandung
 TImage(selected).Canvas.MoveTo(0,0);  //Pinsel auf den Punkt (0|0) setzen
 TImage(selected).Canvas.LineTo(TImage(selected).Width,0);
                                       //linie nach rechts oben
 TImage(selected).Canvas.LineTo(TImage(selected).Width,TImage(selected).Height);
                                       //linie nach rechts unten
 TImage(selected).Canvas.LineTo(0,TImage(selected).Height);
                                       //linie nach links unten
 TImage(selected).Canvas.LineTo(0,0);  //linie nach links oben (start)
 //repaint
 Image1.Repaint;
 Image2.Repaint;
 Image3.Repaint;
 Image4.Repaint;
 Image5.Repaint;
 Image6.Repaint;
 Image7.Repaint;
 Image8.Repaint;
 Image9.Repaint;
 Image10.Repaint;
 Image11.Repaint;
 Image12.Repaint;
end;

procedure TForm2.ImageClick(Sender: TObject);
begin
 // sender(angeklicktes image) hintergrund in config speichern

 if TImage(Sender) = Image2  then config.client.background := 55
 else if TImage(Sender) = Image3  then config.client.background := 56
 else if TImage(Sender) = Image4  then config.client.background := 57
 else if TImage(Sender) = Image5  then config.client.background := 58
 else if TImage(Sender) = Image6  then config.client.background := 59
 else if TImage(Sender) = Image7  then config.client.background := 60
 else if TImage(Sender) = Image8  then config.client.background := 61
 else if TImage(Sender) = Image9  then config.client.background := 62
 else if TImage(Sender) = Image10 then config.client.background := 63
 else if TImage(Sender) = Image11 then config.client.background := 64
 else if TImage(Sender) = Image12 then config.client.background := 65
 else config.client.background := 54;
 //alle neu zeichnen (um den makierten zu demakieren)
 cdtDrawExt(Image1.Canvas.Handle,0,0,57,77,54,1,0);
 cdtDrawExt(Image2.Canvas.Handle,0,0,57,77,55,1,0);
 cdtDrawExt(Image3.Canvas.Handle,0,0,57,77,56,1,0);
 cdtDrawExt(Image4.Canvas.Handle,0,0,57,77,57,1,0);
 cdtDrawExt(Image5.Canvas.Handle,0,0,57,77,58,1,0);
 cdtDrawExt(Image6.Canvas.Handle,0,0,57,77,59,1,0);
 cdtDrawExt(Image7.Canvas.Handle,0,0,57,77,60,1,0);
 cdtDrawExt(Image8.Canvas.Handle,0,0,57,77,61,1,0);
 cdtDrawExt(Image9.Canvas.Handle,0,0,57,77,62,1,0);
 cdtDrawExt(Image10.Canvas.Handle,0,0,57,77,63,1,0);
 cdtDrawExt(Image11.Canvas.Handle,0,0,57,77,64,1,0);
 cdtDrawExt(Image12.Canvas.Handle,0,0,57,77,65,1,0);
 //transparenz (des eben noch markierten) wieder aktivieren
 Image1.Transparent:=true;
 Image2.Transparent:=true;
 Image3.Transparent:=true;
 Image4.Transparent:=true;
 Image5.Transparent:=true;
 Image6.Transparent:=true;
 Image7.Transparent:=true;
 Image8.Transparent:=true;
 Image9.Transparent:=true;
 Image10.Transparent:=true;
 Image11.Transparent:=true;
 Image12.Transparent:=true;
 //den ausgewählten hintergrund(sender) markieren(siehe TForm2.FormActivate)
 TImage(Sender).Transparent:=false;
 TImage(Sender).Canvas.Pen.Color:=clLime;
 TImage(Sender).Canvas.Pen.Width:=8;
 TImage(Sender).Canvas.MoveTo(0,0);
 TImage(Sender).Canvas.LineTo(TImage(Sender).Width,0);
 TImage(Sender).Canvas.LineTo(TImage(Sender).Width,TImage(Sender).Height);
 TImage(Sender).Canvas.LineTo(0,TImage(Sender).Height);
 TImage(Sender).Canvas.LineTo(0,0);
 //repaint
 Image1.Repaint;
 Image2.Repaint;
 Image3.Repaint;
 Image4.Repaint;
 Image5.Repaint;
 Image6.Repaint;
 Image7.Repaint;
 Image8.Repaint;
 Image9.Repaint;
 Image10.Repaint;
 Image11.Repaint;
 Image12.Repaint;
end;

end.
