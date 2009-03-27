program MauDauMau;
{
  author:     Robin Christopher Ladiges
  website:    http://blackpinguin.de/
  project:    Mau Dau Mau
  binary:     MauDauMau.exe
  unit:       MauDauMau
  file:       MauDauMau.dpr
  filepath:   .\executable\
  year:       2008/2009
  desc:       This file handles the executable itself.

  license:    creative commons by-nc-sa 3.0 germany
   look out license.txt in this folder
   human-readable summary : http://creativecommons.org/licenses/by-nc-sa/3.0/de/
}

uses
  Forms,
  FMainform in 'forms\FMainform.pas' {Form1},
  FDeckblatt in 'forms\FDeckblatt.pas' {Form2},
  FOptions in 'forms\FOptions.pas' {Form3},
  FStats in 'forms\FStats.pas' {Form4},
  FPlayer in 'forms\FPlayer.pas' {Form5},
  FColor in 'forms\FColor.pas' {Form6},
  FAuthor in 'forms\FAuthor.pas' {Form7},
  UClientForm in 'units\UClientForm.pas',
  UClientCards in 'units\UClientCards.pas',
  UServerCards in 'units\UServerCards.pas',
  UClientGame in 'units\UClientGame.pas',
  UClientPos in 'units\UClientPos.pas',
  UClient in 'units\UClient.pas',
  UServer in 'units\UServer.pas',
  UServerGame in 'units\UServerGame.pas',
  Udll in 'units\Udll.pas',
  Uini in 'units\Uini.pas',
  UScktComp in 'units\UScktComp.pas',
  ULanguage in 'units\ULanguage.pas',
  UDialogs in 'units\UDialogs.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Mau Dau Mau';
  Application.CreateForm(TForm1, Form1);
  //FMainform
  //Application.CreateForm(TForm2, Form2); //FDeckblatt
  //Application.CreateForm(TForm3, Form3); //FOptions
  //Application.CreateForm(TForm4, Form4); //FStats
  //Application.CreateForm(TForm5, Form5); //FPlayer
  //Application.CreateForm(TForm6, Form6); //FColor
  //Application.CreateForm(TForm7, Form7); //FAuthor
    //Die Forms FDeckblatt, FOptions, FStats, FPlayer, FColor und FAuthor werden
    //hier nicht erstellt. Sie werden erst im Programm erstellt,
    //um Arbeitsspeicher zu sparen.
  Application.Run;
end.
