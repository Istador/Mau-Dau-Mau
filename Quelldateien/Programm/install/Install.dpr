program Install;
{
  author:     Robin Christopher Ladiges
  website:    http://blackpinguin.de/
  project:    Mau Dau Mau
  binary:     Install.exe
  unit:       Install
  file:       Install.dpr
  filepath:   .\install\
  year:       2008/2009
  desc:       This file handles the executable itself.

  license:    creative commons by-nc-sa 3.0 germany
   look out license.txt in this folder
   human-readable summary : http://creativecommons.org/licenses/by-nc-sa/3.0/de/
}

uses
  Forms,
  FSetup1 in 'FSetup1.pas' {Form1},
  FSetup2 in 'FSetup2.pas' {Form2},
  FSetup3 in 'FSetup3.pas' {Form3};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Setup';
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.
