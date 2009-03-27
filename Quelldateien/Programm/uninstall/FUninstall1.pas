unit FUninstall1;
{
  author:     Robin Christopher Ladiges
  website:    http://blackpinguin.de/
  project:    Mau Dau Mau
  binary:     Uninstall.exe
  unit:       FUninstall1
  file:       FUninstall1.pas
  filepath:   .\uninstall\
  year:       2008/2009
  desc:       This file contains the TForm1.uninstgall mmethod that uninstalls
              the game if it is installed.

  license:    creative commons by-nc-sa 3.0 germany
   look out license.txt in this folder
   human-readable summary : http://creativecommons.org/licenses/by-nc-sa/3.0/de/
}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Registry;

type
  TForm1 = class(TForm)
  procedure uninstall;
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Form1: TForm1;

implementation

procedure TForm1.uninstall;
var
 installed:boolean;
 fname:string;
 reg:TRegistry;
 path, ppath, dpath:string;
begin
 installed:=false;
 reg:=TRegistry.Create;
 try
  reg.RootKey:=HKEY_LOCAL_MACHINE;
  installed:=reg.KeyExists('Software\MauDauMau');
  if installed then
   begin
    reg.OpenKey('Software\MauDauMau',false);
    path:=reg.ReadString('GamePath');
    reg.CloseKey;
    reg.RootKey:=HKEY_CURRENT_USER;
    reg.OpenKeyReadOnly('Software\Microsoft\Windows\CurrentVersion\Explorer\'
                        +'Shell Folders');
    dpath:=reg.ReadString('Desktop')+'\';
    ppath:=reg.ReadString('Start Menu')+'\';
    reg.CloseKey;
   end
 finally
  reg.Free;
 end;
 if installed and (path <> '') then
  begin //deinstalliere
   //Dateien im Verzeichnisch löschen
   fname:=path+'MauDauMau.exe';
   if FileExists(fname) then
    DeleteFile(fname);
   fname:=path+'MauDauMau.dll';
   if FileExists(fname) then
    DeleteFile(fname);
   fname:=path+'MauDauMau.chm';
   if FileExists(fname) then
    DeleteFile(fname);
   fname:=path+'language.rcl';
   if FileExists(fname) then
    DeleteFile(fname);
   fname:=path+'MauDauMau.ini';
   if FileExists(fname) then
    DeleteFile(fname);
   fname:=path+'chmfix.exe';
   if FileExists(fname) then
    DeleteFile(fname);
   fname:=path+'cards.dll';
   if FileExists(fname) then
    DeleteFile(fname);
   fname:=path+'license.txt';
   if FileExists(fname) then
    DeleteFile(fname);
   //Verzeichnisch löschen
   if DirectoryExists(path) then
    rmdir(path);
   if DirectoryExists(ppath+'Mau Dau Mau') then
    begin
     //Verknüpfungen in Start->Programme->Mau Dau Mau
     fname:=ppath+'Mau Dau Mau\Mau Dau Mau.lnk';
     if FileExists(fname) then
      DeleteFile(fname);
     fname:=ppath+'Mau Dau Mau\Hilfe.lnk';
     if FileExists(fname) then
      DeleteFile(fname);
     rmdir(ppath+'Mau Dau Mau');
    end;
   if FileExists(dpath+'Mau Dau Mau.lnk') then
    DeleteFile(dpath+'Mau Dau Mau.lnk');
   //Registry Eintrag löschen
   reg:=TRegistry.Create;
   try
    reg.RootKey:=HKEY_LOCAL_MACHINE;
    if reg.KeyExists('Software\MauDauMau') then
     reg.DeleteKey('Software\MauDauMau')
   finally
    reg.Free;
   end;
   ShowMessage('Mau Dau Mau wurde erfolgreich deinstalliert.');
  end
 else
  begin
   ShowMessage('Mau Dau Mau ist nicht installiert.');
  end;
 self.Close;
end;

{$R *.dfm}

end.
