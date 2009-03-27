program Autostart;
{
  author:     Robin Christopher Ladiges
  website:    http://blackpinguin.de/
  project:    Mau Dau Mau
  binary:     Autostart.exe
  unit:       Autostart
  file:       Autostart.dpr
  filepath:   .\autostart\
  year:       2008/2009
  desc:       This file handles the executable itself.

  license:    creative commons by-nc-sa 3.0 germany
   look out license.txt in this folder
   human-readable summary : http://creativecommons.org/licenses/by-nc-sa/3.0/de/
}

uses
  Forms,
  FAutoStart in 'FAutoStart.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Autostart';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
