unit FAuthor;
{
  author:     Robin Christopher Ladiges
  website:    http://blackpinguin.de/
  project:    Mau Dau Mau
  binary:     MauDauMau.exe
  unit:       FAuthor
  file:       FAuthor.pas
  filepath:   .\executable\forms\
  year:       2008/2009
  desc:       This file handles the AuthorForm, the form which displays
              version, copyright holder, and licence informations to the user.

  license:    creative commons by-nc-sa 3.0 germany
   look out license.txt in this folder
   human-readable summary : http://creativecommons.org/licenses/by-nc-sa/3.0/de/
}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  StdCtrls, jpeg, ExtCtrls;

type
  TForm7 = class(TForm)
    img_author: TImage;
    Label1: TLabel;
    lab_version: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    lab_licence: TLabel;
    Label4: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure languageload;
    procedure lab_licenceClick(Sender: TObject);
    procedure lab_MouseEnter(Sender: TObject);
    procedure lab_MouseLeave(Sender: TObject);
    procedure Label3Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Form7: TForm7;

implementation
{$R *.dfm}
uses FMainform, Udll, ULanguage, shellapi;

//------------------------------------------------------------------------------
//--- not my work --------------------------------------------------------------
//------------------------ http://www.delphipraxis.net/topic32619.html#222608 --
//------------------------------------------------------------------------------
//Gibt Versionsnummer der EXE Datei zurück
//   (Rechtsklick auf EXE -> Eigenschaften -> Version)
function GetVersion:string;
var  aFileName: array [0..MAX_PATH] of Char;
  pdwHandle: DWORD;
  nInfoSize: DWORD;
  pFileInfo: Pointer;
  pFixFInfo: PVSFixedFileInfo;
  nFixFInfo: DWORD;
begin
  StrPCopy(aFileName,ParamStr(0));
  pdwHandle := 0;
  nInfoSize := GetFileVersionInfoSize(aFileName, pdwHandle);
  result:='0';
  if nInfoSize <> 0 then
    pFileInfo := GetMemory(nInfoSize)
  else
    pFileInfo := nil;
  if Assigned(pFileInfo) then
  begin
    try
      if GetFileVersionInfo(aFileName, pdwHandle, nInfoSize, pFileInfo) then
      begin
        pFixFInfo := nil;
        nFixFInfo := 0;
        if VerQueryValue(pFileInfo, '\', Pointer(pFixFInfo), nFixFInfo) then
        begin
          result := Format('%d.%d.%d.%d',[HiWord(pFixFInfo^.dwFileVersionMS),
          LoWord(pFixFInfo^.dwFileVersionMS),HiWord(pFixFInfo^.dwFileVersionLS),
          LoWord(pFixFInfo^.dwFileVersionLS)]);
        end;
      end;
    finally
      FreeMemory(pFileInfo);
    end;
  end;
end;
//------------------------------------------------------------------------------

procedure TForm7.FormCreate(Sender: TObject);
begin
 self.languageload;
end;

procedure TForm7.Label3Click(Sender: TObject);
begin
 try
  //Öffne Internetadresse http://www.blackpinguin.de/ im Standard-Browser
  ShellExecute(handle,'open','http://www.blackpinguin.de/',nil,nil,sw_show);
 except

 end;
end;

procedure TForm7.lab_licenceClick(Sender: TObject);
begin
 mHHelp.HelpContext(1022); //Öffne Lizenz in Hilfe-Datei
end;

procedure TForm7.lab_MouseEnter(Sender: TObject);
begin
 TLabel(Sender).Font.Color:=clBlue; //Text-Farbe = Blau
 TLabel(Sender).Font.Style:=[fsUnderline]; //Text unterstreichen
end;

procedure TForm7.lab_MouseLeave(Sender: TObject);
begin
 TLabel(Sender).Font.Color:=clWindowText; //Text-Farbe = Normal
 TLabel(Sender).Font.Style:=[]; //Text unterstreichung aufheben
end;

//diese funktion lädt die Strings in entsprechend ausgewählter Sprache
procedure TForm7.languageload;
var
 ver:string;
begin
 ver:=getVersion+'.'; // funktion s.o.
 self.Caption:=lang.Author.Caption;
 Label1.Caption:=lang.Author.Lab_1;
 Label2.Caption:=lang.Author.Lab_2;
 Label3.Caption:=lang.Author.Lab_3;
 Label4.Caption:=lang.Author.Lab_4;
 lab_version.caption:=lang.Author.Lab_ver_0+' '+part('.',0,ver)+'.'
                      +part('.',1,ver)+'.'+part('.',2,ver)+' ('
                      +lang.Author.Lab_ver_1+' '+part('.',3,ver)+')';
                                                      //part funktion siehe Udll
 lab_licence.Caption:=        lang.Author.lab_licence_0
                      +#13#10+lang.Author.lab_licence_1
                      +#13#10+lang.Author.lab_licence_2
                      +#13#10+lang.Author.lab_licence_3
                      +#13#10+lang.Author.lab_licence_4;
end;


end.
