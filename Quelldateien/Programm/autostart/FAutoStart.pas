unit FAutoStart;
{
  author:     Robin Christopher Ladiges
  website:    http://blackpinguin.de/
  project:    Mau Dau Mau
  binary:     Autostart.exe
  unit:       FAutostart
  file:       FAutostart.pas
  filepath:   .\autostart\
  year:       2008/2009
  desc:       This file handles the AutoStart Form.

  license:    creative commons by-nc-sa 3.0 germany
   look out license.txt in this folder
   human-readable summary : http://creativecommons.org/licenses/by-nc-sa/3.0/de/
}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, hh, hh_funcs, shellapi, registry;

type
  TForm1 = class(TForm)
    p_close: TPanel;
    p_2: TPanel;
    p_0: TPanel;
    l_caption: TLabel;
    Label1: TLabel;
    Image1: TImage;
    p_1: TPanel;
    procedure pMouseDown(Sender: TObject; Button: TMouseButton;
                         Shift: TShiftState; X, Y: Integer);
    procedure pMouseUp(Sender: TObject; Button: TMouseButton;
                       Shift: TShiftState; X, Y: Integer);
    procedure p_closeClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure p_2Click(Sender: TObject);
    procedure p_0Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure p_1Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

function cdtDraw(hdc:HDC; x,y,card,typ:integer; color:DWORD):boolean; stdcall;
         external 'Data/cards.dll';
function cdtInit(var width,height:integer):boolean; stdcall;
         external 'Data/cards.dll';
procedure cdtTerm(); stdcall; external 'Data/cards.dll';


var
  Form1: TForm1;
  mHHelp: THookHelpSystem;
  installed: boolean;
  gamepath:string;

implementation
{$R *.dfm}

procedure TForm1.FormActivate(Sender: TObject);
var
 reg: TRegistry;
begin
 Image1.Canvas.Brush.Color:=clGreen;
 Image1.Canvas.Pen.Color:=clGreen;
 Image1.Canvas.Rectangle(0,0,Image1.Width,Image1.Height);
 cdtDraw(Image1.Canvas.Handle, 15,  0, 24, 0, 0);
 cdtDraw(Image1.Canvas.Handle, 30, 15, 25, 0, 0);
 cdtDraw(Image1.Canvas.Handle, 45, 30, 26, 0, 0);
 cdtDraw(Image1.Canvas.Handle, 60, 45, 27, 0, 0);
 reg:=TRegistry.Create;
 try
  reg.RootKey:=HKEY_LOCAL_MACHINE;
  installed:= reg.KeyExists('Software\MauDauMau');
 except
  installed:= false;
 end;
 if installed then
  begin
   try
    reg.OpenKeyReadOnly('Software\MauDauMau');
    gamepath:=reg.ReadString('GamePath')
   except
    gamepath:=ExtractFilePath(ParamStr(0))+'Data\';
    installed:=false;
   end;
  end;
 if installed then
  begin
   p_0.Caption:='Spielen';
   p_1.Caption:='Deinstallieren';
  end
 else
  begin
   p_0.Caption:='Von CD Spielen';
   p_1.Caption:='Installieren';
   gamepath:=ExtractFilePath(ParamStr(0))+'Data\';
  end;
 reg.Free;
end;


procedure TForm1.FormCreate(Sender: TObject);
var
 c_width, c_height:integer;
begin
 self.Left:=(Screen.Width div 2)-(self.Width div 2);
 self.Top:=(Screen.Height div 2)-(self.Height div 2);
 cdtInit(c_width,  c_height);
end;


procedure TForm1.FormDestroy(Sender: TObject);
begin
 HHCloseAll;
 if Assigned(mHHelp) then mHHelp.Free;
 cdtTerm();
end;


procedure TForm1.pMouseDown(Sender: TObject; Button: TMouseButton;
                            Shift: TShiftState; X, Y: Integer);
begin
 TPanel(Sender).BevelOuter:=bvLowered;
end;


procedure TForm1.pMouseUp(Sender: TObject; Button: TMouseButton;
                          Shift: TShiftState; X, Y: Integer);
begin
 TPanel(Sender).BevelOuter:=bvRaised;
end;


procedure TForm1.p_closeClick(Sender: TObject);
begin
 Form1.Close;
end;


procedure TForm1.p_2Click(Sender: TObject);
var
 chmfile,htmlfile: string;
 yn: byte;
begin
 chmFile := gamepath+'MauDauMau.chm';
 if assigned(mHHelp) then mHHelp.HelpContext(1001)
 else
  begin
   mHHelp := nil;
   if not FileExists(chmFile) then
    ShowMessage('Hilfe-Datei nicht gefunden'+#13#10+chmFile)
   else
    begin
     if (hh.HHCtrlHandle = 0) or (hh_funcs._hhMajVer < 4)
     or ((hh_funcs._hhMajVer = 4) and (hh_funcs._hhMinVer < 73)) then
      begin
       yn:=Application.MessageBox('Zum Anzeigen der Hilfe wird die Installation'
                                  +' von MS HTML Help 1.2 oder höher benötigt.'
                                  +#13#10+'Soll es installiert werden?',
                                  'Autostart',MB_YESNO);
       if yn = 6 then
        begin
         htmlfile:=ExtractFilePath(ParamStr(0))+'Data\hhupd.exe';
         if not FileExists(htmlfile) then
          ShowMessage('Installations-Datei nicht gefunden'+#13#10+htmlfile)
         else ShellExecute(handle,'open',PChar(htmlfile),nil,nil,sw_show);
        end;
      end
     else
      begin
       mHHelp := hh_funcs.THookHelpSystem.Create(chmFile, '', htHHAPI);
       mHHelp.HelpContext(1001);
      end;
    end;
  end;
end;


procedure TForm1.p_0Click(Sender: TObject);
var
 appfile: string;
begin
 appfile:=gamepath+'MauDauMau.exe';
 if not FileExists(appfile) then
  ShowMessage('Spiel-Datei nicht gefunden'+#13#10+appfile)
 else
  begin
   ShellExecute(handle,'open',PChar(appfile),nil,nil,sw_show);
   self.Close;
  end;
end;


procedure TForm1.p_1Click(Sender: TObject);
var
 insfile: string;
begin
 if installed then
  begin
   insfile:=ExtractFilePath(ParamStr(0))+'Uninstall.exe';
   if not FileExists(insfile) then
    ShowMessage('Deinstallations-Datei nicht gefunden'+#13#10+insfile)
   else
    begin
     ShellExecute(handle,'open',PChar(insfile),nil,nil,sw_show);
     self.Close;
    end;
  end
 else
  begin
   insfile:=ExtractFilePath(ParamStr(0))+'Install.exe';
   if not FileExists(insfile) then
    ShowMessage('Installations-Datei nicht gefunden'+#13#10+insfile)
   else
    begin
     ShellExecute(handle,'open',PChar(insfile),nil,nil,sw_show);
     self.Close;
    end;
  end;
end;



end.
