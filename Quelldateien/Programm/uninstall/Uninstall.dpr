program Uninstall;
{
  author:     Robin Christopher Ladiges
  website:    http://blackpinguin.de/
  project:    Mau Dau Mau
  binary:     Uninstall.exe
  unit:       Uninstall
  file:       Uninstall.dpr
  filepath:   .\uninstall\
  year:       2008/2009
  desc:       This file handles the executable itself.

  license:    creative commons by-nc-sa 3.0 germany
   look out license.txt in this folder
   human-readable summary : http://creativecommons.org/licenses/by-nc-sa/3.0/de/
}

uses
  Forms,
  FUninstall1 in 'FUninstall1.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Uninstaller';
  Application.ShowMainForm:=false; //die leere form wird nicht angezeigt
  Application.CreateForm(TForm1, Form1);
  Form1.uninstall;
  Application.Run;
end.
