unit FSetup3;
{
  author:     Robin Christopher Ladiges
  website:    http://blackpinguin.de/
  project:    Mau Dau Mau
  binary:     Install.exe
  unit:       FSetup3
  file:       FSetup3.pas
  filepath:   .\install\
  year:       2008/2009
  desc:       This file handles the third Setup Form.

  license:    creative commons by-nc-sa 3.0 germany
   look out license.txt in this folder
   human-readable summary : http://creativecommons.org/licenses/by-nc-sa/3.0/de/
}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, shellapi, registry, ExtCtrls;

type
  TForm3 = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    Timer1: TTimer;
    ProgressBar1: TProgressBar;
    Label1: TLabel;
    procedure incprogress;
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Form3: TForm3;
  installing:boolean=false;
  installed:boolean=false;

implementation
{$R *.dfm}
uses FSetup2, ShlObj, ActiveX, ComObj;



//------------------------------------------------------------------------------
//--- not my work --------------------------------------------------------------
//------------- http://www.delphi-treff.de/tipps/dateienverzeichnisse/wiki/ ----
//--------------- Verkn%C3%BCpfung%20(*.lnk)%20zu%20einer%20Datei%20erstellen/ -
//------------------------------------------------------------------------------
function CreateLink(const AFilename,ALNKFilename,ADescription: string):Boolean;
var
 psl : IShellLink;
 ppf : IPersistFile;
 wsz : PWideChar;
begin
 result:=false;
 if SUCCEEDED(CoCreateInstance(CLSID_ShellLink, nil,
 CLSCTX_inPROC_SERVER, IID_IShellLinkA, psl)) then
  begin
   psl.SetPath(PChar(AFilename));
   psl.SetDescription(PChar(ADescription));
   psl.SetWorkingDirectory(PChar(ExtractFilePath(AFilename)));
   if SUCCEEDED(psl.QueryInterface(IPersistFile, ppf)) then
    begin
     GetMem(wsz, MAX_PATH*2);
     try
      MultiByteToWideChar(CP_ACP, 0, PChar(ALNKFilename), -1, wsz, MAX_PATH);
      ppf.Save(wsz, true);
      result:=true;
     finally
      FreeMem(wsz, MAX_PATH*2);
     end;
    end;
  end;
end;
//------------------------------------------------------------------------------


procedure TForm3.Button1Click(Sender: TObject);
begin
 self.Close;
end;


procedure TForm3.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 if installed then ShellExecute(handle,'open',PChar(ExtractFilePath(ParamStr(0))
                                +'Autostart.exe'),nil,nil,sw_show);
end;


procedure TForm3.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
 CanClose:=not installing;
end;


procedure TForm3.FormCreate(Sender: TObject);
begin
 self.Left:=(Screen.Width div 2)-(self.Width div 2);
 self.Top:=(Screen.Height div 2)-(self.Height div 2);
end;


procedure TForm3.FormShow(Sender: TObject);
begin
 self.Left:=Form2.Left;
 self.Top:=Form2.Top;
 //Installationsbalken
 // 15 insgesammt
 // 9 muss
 // 1 chmfix
 // 1 dektopverknüpfung
 // 3 Startmenü
 // 1 fertig
 self.ProgressBar1.Max:=9 + Integer(Form2.CheckBox1.Checked)
                        + Integer(Form2.CheckBox3.Checked)
                        + (Integer(Form2.CheckBox2.Checked)*3);
 self.Timer1.Enabled:=true;
end;

procedure TForm3.incprogress;
begin
 self.ProgressBar1.Position:=self.ProgressBar1.Position+1;
 self.Label1.Caption:=IntToStr(100 * self.ProgressBar1.Position
                               div self.ProgressBar1.Max)+'%';
end;


procedure TForm3.Timer1Timer(Sender: TObject);
var
 state:boolean;
 fname, path, spath, dpath, ppath:string;
 reg:TRegistry;
begin
 Timer1.Enabled:=false;
 //installiere
 state:=true;
 path:=Form2.LabeledEdit1.Text;       //pfad wohin installiert werden  soll
 spath:=ExtractFilePath(ParamStr(0)); //setup path auf CD
 dpath:='';                           //Dektop Pfad
 ppath:='';                           //Start->Programme Pfad
 installing:=true;
 Memo1.Lines.Add('Installation gestartet.');
 if state then
  begin
   Memo1.Lines.Add('Erstelle Verzeichnis "'+path+'" ...');
   self.Refresh;
   state:=CreateDir(path);
   if state then
    begin
     Memo1.Lines.Add('--Verzeichnis erstellt.');
     self.incprogress;
    end;
  end;
 if state then
  begin
   fname:='MauDauMau.exe';
   Memo1.Lines.Add('Kopiere Datei "'+fname+'"...');
   self.Refresh;
   state:=CopyFile(PChar(spath+'Data\'+fname),PChar(path+fname),false);
   if state then
    begin
     Memo1.Lines.Add('--Datei kopiert.');
     self.incprogress;
    end;
  end;
 if state then
  begin
   fname:='MauDauMau.chm';
   Memo1.Lines.Add('Kopiere Datei "'+fname+'"...');
   self.Refresh;
   state:=CopyFile(PChar(spath+'Data\'+fname),PChar(path+fname),false);
   if state then
    begin
     Memo1.Lines.Add('--Datei kopiert.');
     self.incprogress;
    end;
  end;
 if state then
  begin
   fname:='MauDauMau.dll';
   Memo1.Lines.Add('Kopiere Datei "'+fname+'"...');
   self.Refresh;
   state:=CopyFile(PChar(spath+'Data\'+fname),PChar(path+fname),false);
   if state then
    begin
     Memo1.Lines.Add('--Datei kopiert.');
     self.incprogress;
    end;
  end;
 if state then
  begin
   fname:='cards.dll';
   Memo1.Lines.Add('Kopiere Datei "'+fname+'"...');
   self.Refresh;
   state:=CopyFile(PChar(spath+'Data\'+fname),PChar(path+fname),false);
   if state then
    begin
     Memo1.Lines.Add('--Datei kopiert.');
     self.incprogress;
    end;
  end;
 if state then
  begin
   fname:='language.rcl';
   Memo1.Lines.Add('Kopiere Datei "'+fname+'"...');
   self.Refresh;
   state:=CopyFile(PChar(spath+'Data\'+fname),PChar(path+fname),false);
   if state then
    begin
     Memo1.Lines.Add('--Datei kopiert.');
     self.incprogress;
    end;
  end;
 if state then
  begin
   fname:='license.txt';
   Memo1.Lines.Add('Kopiere Datei "'+fname+'"...');
   self.Refresh;
   state:=CopyFile(PChar(spath+fname),PChar(path+fname),false);
   if state then
    begin
     Memo1.Lines.Add('--Datei kopiert.');
     self.incprogress;
    end;
  end;
 if state then
  begin
   fname:='chmfix.exe';
   Memo1.Lines.Add('Kopiere Datei "'+fname+'"...');
   self.Refresh;
   state:=CopyFile(PChar(spath+'Data\'+fname),PChar(path+fname),false);
   if state then
    begin
     Memo1.Lines.Add('--Datei kopiert.');
     self.incprogress;
    end;
  end;
 //Pfade zu Desktop und Start->Programme auslesen
 if state then
  begin
   reg:=TRegistry.Create;
   try
    state:=false;
    reg.RootKey:=HKEY_CURRENT_USER;
    reg.OpenKeyReadOnly('Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders');
    dpath:=reg.ReadString('Desktop')+'\';
    ppath:=reg.ReadString('Start Menu')+'\';
    reg.CloseKey;
    self.incprogress;
    state:=true;
   finally
    reg.Free;
   end;
  end;
 if state and Form2.CheckBox1.Checked then
  begin
   Memo1.Lines.Add('Erstelle Desktop Verknüpfung...');
   self.Refresh;
   state:= CreateLink(path+'MauDauMau.exe',dpath+'Mau Dau Mau.lnk','Mau Dau Mau');
   if state then
    begin
     Memo1.Lines.Add('--Verknüpfung erstellt.');
     self.incprogress;
    end;
  end;
 if state and Form2.CheckBox2.Checked then
  begin
   Memo1.Lines.Add('Erstelle Startmenü Verzeichnis...');
   self.Refresh;
   state:=CreateDir(ppath+'Mau Dau Mau');
   if state then
    begin
     Memo1.Lines.Add('--Verzeichnis erstellt.');
     self.incprogress;
    end;
   if state then
    begin
     fname:='MauDauMau.exe';
     Memo1.Lines.Add('Erstelle Verknüpfung mit "'+fname+'"...');
     self.Refresh;
     state:= CreateLink(path+fname,ppath+'Mau Dau Mau\Mau Dau Mau.lnk','Mau Dau Mau');
     if state then
      begin
       Memo1.Lines.Add('--Verknüpfung erstellt.');
       self.incprogress;
      end;
    end;
   if state then
    begin
     fname:='MauDauMau.chm';
     Memo1.Lines.Add('Erstelle Verknüpfung mit "'+fname+'"...');
     self.Refresh;
     state:= CreateLink(path+fname,ppath+'Mau Dau Mau\Hilfe.lnk','Hilfe');
     if state then
      begin
       Memo1.Lines.Add('--Verknüpfung erstellt.');
       self.incprogress;
      end;
    end;
  end;
 if state and Form2.CheckBox3.Checked then
  begin
   Memo1.Lines.Add('Führe "chmfix.exe" aus.');
   self.incprogress;
   ShellExecute(handle,'open',PChar(path+'chmfix.exe'),nil,nil,sw_show);
  end;
 if state then
  begin
   //registry einträge erstellen. um den progpfad für den autostart zu speichern
   reg:=TRegistry.Create;
   try
    state:=false;
    reg.RootKey:=HKEY_LOCAL_MACHINE;
    reg.CreateKey('Software\MauDauMau');
    reg.OpenKey('Software\MauDauMau',false);
    reg.WriteString('GamePath',path);
    state:=true; //falls die befehle vorher keine fehler auslösen
   finally
    reg.Free;
   end;
  end;
 if state then
  begin
   //installation erfolgreich
   Memo1.Lines.Add('Installation abgeschlossen');
   self.incprogress;
   installed:=true;
  end
 else
  begin
   Memo1.Lines.Add('Fehler bei der Installation aufgetreten');
   self.ProgressBar1.Position:=0;
   self.Label1.Caption:='0%';
   self.Refresh;
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
   //evtl. vorhandenen Registry Eintrag löschen
   //is eigtl. unnötig da er ihn nur erstellt wenn er nciht in diesem else block
   //ist, entfernt jedoch evtl schon vorhandene installationen.
   reg:=TRegistry.Create;
   try
    reg.RootKey:=HKEY_LOCAL_MACHINE;
    if reg.KeyExists('Software\MauDauMau') then
     reg.DeleteKey('Software\MauDauMau')
   finally
    reg.Free;
   end;
  end;
 installing:=false;
 button1.Enabled:=true;
end;



end.
