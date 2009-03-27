unit FOptions;
{
  author:     Robin Christopher Ladiges
  website:    http://blackpinguin.de/
  project:    Mau Dau Mau
  binary:     MauDauMau.exe
  unit:       FOptions
  file:       FOptions.pas
  filepath:   .\executable\forms\
  year:       2008/2009
  desc:       This file handles the OptionsForm, the form on which the user can
              setting up his client/server/language options.

  license:    creative commons by-nc-sa 3.0 germany
   look out license.txt in this folder
   human-readable summary : http://creativecommons.org/licenses/by-nc-sa/3.0/de/
}

interface

uses
  Forms, Classes, Controls, StdCtrls, ExtCtrls, ComCtrls;

type
  TForm3 = class(TForm)
    client_name: TLabeledEdit;
    TabControl1: TTabControl;
    client_cardammount: TComboBox;
    client_Label1: TLabel;
    client_savestats: TRadioGroup;
    server_name: TLabeledEdit;
    server_password: TLabeledEdit;
    server_action: TGroupBox;
    server_seven_use: TCheckBox;
    server_seven_take: TComboBox;
    server_Label1: TLabel;
    server_eight_use: TCheckBox;
    server_nine_use: TCheckBox;
    server_nine_win: TCheckBox;
    server_bube_use: TCheckBox;
    server_bube_bube: TCheckBox;
    client_sortorder: TComboBox;
    client_Label2: TLabel;
    client_language: TComboBox;
    client_Label3: TLabel;
    procedure FormActivate(Sender: TObject);
    procedure TabControl1Change(Sender: TObject);
    procedure use_change(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure languageload;
    procedure edKeyPress(Sender: TObject; var Key: Char);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Form3: TForm3;

implementation
{$R *.dfm}
uses FMainform, UIni, ULanguage, Udll, UDialogs;



procedure TForm3.languageload;
begin
 self.Caption:=lang.Options.Caption;  //Optionen
 self.TabControl1.Tabs.Clear;
 self.TabControl1.Tabs.Add(lang.Options.TC_0);  //Spieler
 self.TabControl1.Tabs.Add(lang.Options.TC_1);  //Server
 self.client_name.EditLabel.Caption:=lang.Options.C_name; //Spieler Name
 self.client_Label1.Caption:=lang.Options.C_Label1;
 self.client_savestats.Caption:=lang.Options.C_Stats; //Statistiken speichern?
 self.client_savestats.Items[0]:=lang.Generic.Yes; //Ja
 self.client_savestats.Items[1]:=lang.Generic.No;  //Nein
 self.client_sortorder.Items[0]:=lang.Options.C_sortorder_0; //unsortiert
 self.client_sortorder.Items[1]:=lang.Options.C_sortorder_1; //nach Farbe
 self.client_sortorder.Items[2]:=lang.Options.C_sortorder_2; //nach Wert
 self.client_Label2.Caption:=lang.Options.C_Label2;
 self.client_language.Items[0]:=lang.Options.C_language_0; //Deutsch
 self.client_language.Items[1]:=lang.Options.C_language_1; //Englisch
 self.client_language.Items[2]:=lang.Options.C_language_2; //Französich
 self.client_Label3.Caption:=lang.Options.C_Label3;
 self.server_name.EditLabel.Caption:=lang.Options.S_name; //Server Name
 self.server_password.EditLabel.Caption:=lang.Options.S_pass; //Passwort
 self.server_action.Caption:=lang.Options.S_action; //Aktionskarten
 self.server_Label1.Caption:=lang.Options.S_Label1;
 self.server_nine_win.Caption:=lang.Options.S_n_w;
 self.server_bube_bube.Caption:=lang.Options.S_b_b;
end;


procedure TForm3.edKeyPress(Sender: TObject; var Key: Char);
begin
 // # und ; rausfiltern
 if (key in [#35,#59]) then key:=#0;
end;


procedure TForm3.FormActivate(Sender: TObject);
begin
 self.languageload;
 //fülle die form mit informationen aus der config
 client_name.Text := config.client.name;
 client_cardammount.ItemIndex:=(config.client.austeilen-4);
 client_sortorder.ItemIndex:=config.client.sortorder;
 client_language.ItemIndex:=config.client.language;
 if config.client.savestats then client_savestats.ItemIndex:=0
 else client_savestats.ItemIndex:=1;
 server_name.Text :=config.server.name;
 server_password.Text := config.server.password;
 server_seven_use.Checked:=config.server.seven_use;
 server_seven_take.ItemIndex:=config.server.seven_take-1;
 server_eight_use.Checked:=config.server.eight_use;
 server_nine_use.Checked:=config.server.nine_use;
 server_nine_win.Checked:=config.server.nine_win;
 server_bube_use.Checked:=config.server.bube_use;
 server_bube_bube.Checked:=config.server.bube_bube;
 Form3.use_change(Form3);//deaktiviere eigenschaften von evtl. deaktivierten
                         //aktionskarten
end;


procedure TForm3.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 if not config.client.savestats then
  begin
   // wenn statistiken deaktiviert werden, sollen sie auf 0 gesetzt werden
   config.stats.winsvs3 := 0;
   config.stats.winsvs2 := 0;
   config.stats.winsvs1 := 0;
   config.stats.winsvs0 := 0;
   config.stats.plays := 0;
   config.stats.draws := 0;
   config.stats.turnouts := 0;
   config.stats.sevens := 0;
   config.stats.eights := 0;
   config.stats.nines := 0;
   config.stats.bubes := 0;
  end;
 config.write; // schreibe in die ini file
 Form1.FormIniChange; // Änderung umzusetzen
end;

procedure TForm3.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
 // wird ausgeführt wenn man die form schließt, bevor sie geschlossen wird
 //(um abzufangen ob man sie schließen darf)
 // form auslesen und in config schreiben
 config.client.name := client_name.Text;
 config.client.austeilen := client_cardammount.ItemIndex+4;
 config.client.sortorder := client_sortorder.ItemIndex;
 config.client.language := client_language.ItemIndex;
 if client_savestats.ItemIndex=0 then config.client.savestats := true
 else config.client.savestats := false;
 config.server.name := server_name.Text;
 config.server.password := server_password.Text;
 config.server.seven_use := server_seven_use.Checked;
 config.server.seven_take := server_seven_take.ItemIndex+1;
 config.server.eight_use := server_eight_use.Checked;
 config.server.nine_use := server_nine_use.Checked;
 config.server.nine_win := server_nine_win.Checked;
 config.server.bube_use := server_bube_use.Checked;
 config.server.bube_bube := server_bube_bube.Checked;
 if (config.client.name = '') or (config.server.name = '') then
  begin
   canclose:=false; //form darf nicht geschlossen werden
   if (config.client.name = '') and (config.server.name = '') then
    begin
     ShowMessage(lang.Options.Err_0, self);
     if (TabControl1.TabIndex = 0) then
      begin     //wenn wir bei den client einstellungen sind
       Form3.FocusControl(client_name);// setze fokus auf den Spieler Namen
      end
     else
      begin     //wenn wir bei den server einstellungen sind
       Form3.FocusControl(server_name);// setze fokus auf den Server Namen
      end;
    end
   else
    begin
     if (config.client.name = '') and (config.server.name <> '') then
      begin
       // wenn der spielername falsch ist
       TabControl1.TabIndex := 0; //gehe zu den client einstellungen
       Form3.TabControl1Change(TabControl1);
       Form3.FocusControl(client_name); //markiere den spieler namen
       ShowMessage(lang.Options.Err_1, self);
      end
     else
      begin
       TabControl1.TabIndex := 1; //gehe zu den server einstellungen
       Form3.TabControl1Change(TabControl1);
       Form3.FocusControl(server_name); //markiere den server namen
       ShowMessage(lang.Options.Err_2, self);
      end;
    end;
  end
 else
  begin
   canclose:=true; //form darf geschlossen werden
  end;
end;


procedure TForm3.use_change(Sender: TObject);
begin
 if server_seven_use.Checked then //ob die 7 eine aktionskarte sein soll
  begin
   //wenn ja, erlaube weitere einstellungen zur 7
   server_Label1.Enabled:=true;
   server_seven_take.Enabled:=true;
  end
 else
  begin
   //wenn nein deaktiviere weitere einstellungen
   server_Label1.Enabled:=false;
   server_seven_take.Enabled:=false;
  end;
 if server_nine_use.Checked then //ob die 9 eine aktionskarte sein soll
  begin
   //wenn ja, erlaube weitere einstellungen zur 9
   server_nine_win.Enabled:=true;
  end
 else
  begin
   //wenn nein deaktiviere weitere einstellungen
   server_nine_win.Enabled:=false;
  end;
 if server_bube_use.Checked then //ob der Bube eine aktionskarte sein soll
  begin
   //wenn ja, erlaube weitere einstellungen zum Buben
   server_bube_bube.Enabled:=true;
  end
 else
  begin
   //wenn nein deaktiviere weitere einstellungen
   server_bube_bube.Enabled:=false;
  end;
end;


procedure TForm3.TabControl1Change(Sender: TObject);
begin
 if TTabControl(Sender).TabIndex = 0 then
  begin
   // player settings sichtbar machen
   client_name.Visible:=true;
   client_Label1.Visible:=true;
   client_cardammount.Visible:=true;
   client_savestats.Visible:=true;
   client_Label2.Visible:=true;
   client_sortorder.Visible:=true;
   client_Label3.Visible:=true;
   client_language.Visible:=true;
   // server settings unsichtbar machen
   server_name.Visible:=false;
   server_password.Visible:=false;
   server_action.Visible:=false;
  end
 else
  begin
   // client settings unsichtbar machen
   client_name.Visible:=false;
   client_Label1.Visible:=false;
   client_cardammount.Visible:=false;
   client_savestats.Visible:=false;
   client_Label2.Visible:=false;
   client_sortorder.Visible:=false;
   client_Label3.Visible:=false;
   client_language.Visible:=false;
   // server settings sichtbar machen
   server_name.Visible:=true;
   server_password.Visible:=true;
   server_action.Visible:=true;
  end;
end;



end.


