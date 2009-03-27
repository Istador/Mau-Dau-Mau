unit FStats;
{
  author:     Robin Christopher Ladiges
  website:    http://blackpinguin.de/
  project:    Mau Dau Mau
  binary:     MauDauMau.exe
  unit:       FStats
  file:       FStats.pas
  filepath:   .\executable\forms\
  year:       2008/2009
  desc:       This file handles the StatsForm, the form which display
              the statistics.

  license:    creative commons by-nc-sa 3.0 germany
   look out license.txt in this folder
   human-readable summary : http://creativecommons.org/licenses/by-nc-sa/3.0/de/
}

interface

uses
  Forms, Classes, Controls, StdCtrls, SysUtils;

type
  TForm4 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    lab_win_3: TLabel;
    lab_win_2: TLabel;
    lab_win_1: TLabel;
    lab_looses: TLabel;
    lab_turnouts: TLabel;
    lab_draws: TLabel;
    lab_7: TLabel;
    lab_8: TLabel;
    lab_9: TLabel;
    lab_bube: TLabel;
    Label11: TLabel;
    lab_plays: TLabel;
    procedure languageload;
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Form4: TForm4;

implementation
{$R *.dfm}
uses UIni, ULanguage;



procedure TForm4.FormCreate(Sender: TObject);
begin
 self.languageload;
end;


procedure TForm4.languageload;
begin
 self.Caption:=lang.Stats.Caption;
 self.Label1.Caption:=lang.Stats.Lab_1;
 self.Label2.Caption:=lang.Stats.Lab_2;
 self.Label3.Caption:=lang.Stats.Lab_3;
 self.Label4.Caption:=lang.Stats.Lab_4;
 self.Label5.Caption:=lang.Stats.Lab_5;
 self.Label6.Caption:=lang.Stats.Lab_6;
 self.Label7.Caption:=lang.Stats.Lab_7;
 self.Label8.Caption:=lang.Stats.Lab_8;
 self.Label9.Caption:=lang.Stats.Lab_9;
 self.Label10.Caption:=lang.Stats.Lab_10;
end;


procedure TForm4.FormActivate(Sender: TObject);
begin
 //schreibe die stats aus der config in die form objekte
 lab_win_3.Caption:=inttostr(config.stats.winsvs3);
 lab_win_2.Caption:=inttostr(config.stats.winsvs2);
 lab_win_1.Caption:=inttostr(config.stats.winsvs1);
 lab_looses.Caption:=inttostr(config.stats.winsvs0);
 lab_plays.Caption:=inttostr(config.stats.plays);
 lab_draws.Caption:=inttostr(config.stats.draws);
 lab_turnouts.Caption:=inttostr(config.stats.turnouts);
 lab_7.Caption:=inttostr(config.stats.sevens);
 lab_8.Caption:=inttostr(config.stats.eights);
 lab_9.Caption:=inttostr(config.stats.nines);
 lab_bube.Caption:=inttostr(config.stats.bubes);
end;



end.
