unit FPlayer;
{
  author:     Robin Christopher Ladiges
  website:    http://blackpinguin.de/
  project:    Mau Dau Mau
  binary:     MauDauMau.exe
  unit:       FPlayer
  file:       FPlayer.pas
  filepath:   .\executable\forms\
  year:       2008/2009
  desc:       This file handles the PlayerForm, the form wich gets displayed
              between game rounds, to set up playerslots and start a round.

  license:    creative commons by-nc-sa 3.0 germany
   look out license.txt in this folder
   human-readable summary : http://creativecommons.org/licenses/by-nc-sa/3.0/de/
}

interface

uses
   Forms, Classes, Controls, StdCtrls, SysUtils, UClient, UServer;

type
  TForm5 = class(TForm)
    player1: TGroupBox;
    lab1_name: TLabel;
    rb1_closed: TRadioButton;
    rb1_open: TRadioButton;
    player2: TGroupBox;
    lab2_name: TLabel;
    rb2_closed: TRadioButton;
    rb2_open: TRadioButton;
    player3: TGroupBox;
    lab3_name: TLabel;
    rb3_closed: TRadioButton;
    rb3_open: TRadioButton;
    player4: TGroupBox;
    lab4_name: TLabel;
    rb4_closed: TRadioButton;
    rb4_open: TRadioButton;
    but_server_roundstart: TButton;
    but_server_close: TButton;
    but_client_leave: TButton;
    but_server_rules: TButton;
    but_client_rules: TButton;
    m_chat: TMemo;
    ed_chat: TEdit;
    but_chat: TButton;
    constructor create(AOwner: TComponent; AClient: TClient);reintroduce;
    procedure load_client;
    procedure languageload;
    procedure but_client_leaveClick(Sender: TObject);
    procedure but_server_closeClick(Sender: TObject);
    procedure but_server_rulesClick(Sender: TObject);
    procedure but_chatClick(Sender: TObject);
    procedure but_client_rulesClick(Sender: TObject);
    procedure but_server_roundstartClick(Sender: TObject);
    procedure rbClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ed_chatKeyPress(Sender: TObject; var Key: Char);
  private
    { Private-Deklarationen }
  public
    AClient : TClient;
    AServer : TServer;
  end;

function bts(eingang : boolean) : string;

var
  Form5: TForm5;


implementation
{$R *.dfm}
uses FMainform, FOptions, ULanguage, Udll, UDialogs;



procedure TForm5.languageload;
begin
 //need FPlayer language implementation
 //self.Caption:=lang.Player.Caption;
 self.player1.Caption:=lang.Player.player1;
 self.player2.Caption:=lang.Player.player2;
 self.player3.Caption:=lang.Player.player3;
 self.player4.Caption:=lang.Player.player4;
 self.but_chat.Caption:=lang.Player.but_chat;
 self.but_client_leave.Caption:=lang.Player.but_client_leave;
 self.but_client_rules.Caption:=lang.Player.but_client_rules;
 self.but_server_close.Caption:=lang.Player.but_server_close;
 self.but_server_roundstart.Caption:=lang.Player.but_server_roundstart;
 self.but_server_rules.Caption:=lang.Player.but_server_rules;
 //Geschlossen
 self.rb1_closed.Caption:=lang.Player.rb_0;
 self.rb2_closed.Caption:=lang.Player.rb_0;
 self.rb3_closed.Caption:=lang.Player.rb_0;
 self.rb4_closed.Caption:=lang.Player.rb_0;
 //Offen
 self.rb1_open.Caption:=lang.Player.rb_1;
 self.rb2_open.Caption:=lang.Player.rb_1;
 self.rb3_open.Caption:=lang.Player.rb_1;
 self.rb4_open.Caption:=lang.Player.rb_1;
 self.load_client; //Einstellungen von AClient holen
end;

constructor TForm5.create(AOwner: TComponent; AClient: TClient);
begin
 inherited create(AOwner);
 self.AClient:=AClient;
 self.rb1_open.Enabled:=false;
 self.rb1_closed.Enabled:=false;
 if assigned(Server) then
  begin
   self.AServer:=Server;
   self.but_client_leave.Visible:=false;
   self.but_client_rules.Visible:=false;
   self.rb2_open.Enabled:=true;
   self.rb2_closed.Enabled:=true;
   self.rb3_open.Enabled:=true;
   self.rb3_closed.Enabled:=true;
   self.rb4_open.Enabled:=true;
   self.rb4_closed.Enabled:=true;
  end
 else
  begin
   self.but_server_roundstart.Visible:=false;
   self.but_server_close.Visible:=false;
   self.but_server_rules.Visible:=false;
   self.rb2_open.Enabled:=false;
   self.rb2_closed.Enabled:=false;
   self.rb3_open.Enabled:=false;
   self.rb3_closed.Enabled:=false;
   self.rb4_open.Enabled:=false;
   self.rb4_closed.Enabled:=false;
  end;
 self.languageload;
end;



procedure TForm5.ed_chatKeyPress(Sender: TObject; var Key: Char);
begin
 // # und ; rausfiltern
 if (key in [#35,#59]) then key:=#0;
end;

procedure TForm5.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 self.m_chat.Clear;
end;

procedure TForm5.load_client;
begin
 self.Caption:=AClient.servername;
 if AClient.playerslots[0] = 0 then
  begin
   self.lab1_name.Visible:=false;
   self.rb1_open.Checked:=false;
   self.rb1_closed.Checked:=true;
   self.player1.Height:=40;
   self.lab1_name.Caption:=lang.Player.noname;
  end
 else
  begin
   self.rb1_open.Checked:=true;
   self.rb1_closed.Checked:=false;
   self.player1.Height:=70;
   self.lab1_name.Visible:=true;
   if AClient.player[0] = '' then self.lab1_name.Caption:=lang.Player.noname
   else self.lab1_name.Caption:=AClient.player[0];
  end;
 if AClient.playerslots[1] = 0 then
  begin
   self.lab2_name.Visible:=false;
   self.rb2_open.Checked:=false;
   self.rb2_closed.Checked:=true;
   self.player2.Height:=40;
   self.lab2_name.Caption:=lang.Player.noname;
  end
 else
  begin
   self.rb2_open.Checked:=true;
   self.rb2_closed.Checked:=false;
   self.player2.Height:=70;
   self.lab2_name.Visible:=true;
   if AClient.player[1] = '' then self.lab2_name.Caption:=lang.Player.noname
   else self.lab2_name.Caption:=AClient.player[1];
  end;
 if AClient.playerslots[2] = 0 then
  begin
   self.lab3_name.Visible:=false;
   self.rb3_open.Checked:=false;
   self.rb3_closed.Checked:=true;
   self.player3.Height:=40;
   self.lab3_name.Caption:=lang.Player.noname;
  end
 else
  begin
   self.rb3_open.Checked:=true;
   self.rb3_closed.Checked:=false;
   self.player3.Height:=70;
   self.lab3_name.Visible:=true;
   if AClient.player[2] = '' then self.lab3_name.Caption:=lang.Player.noname
   else self.lab3_name.Caption:=AClient.player[2];
  end;
 if AClient.playerslots[3] = 0 then
  begin
   self.lab4_name.Visible:=false;
   self.rb4_open.Checked:=false;
   self.rb4_closed.Checked:=true;
   self.player4.Height:=40;
   self.lab4_name.Caption:=lang.Player.noname;
  end
 else
  begin
   self.rb4_open.Checked:=true;
   self.rb4_closed.Checked:=false;
   self.player4.Height:=70;
   self.lab4_name.Visible:=true;
   if AClient.player[3] = '' then self.lab4_name.Caption:=lang.Player.noname
   else self.lab4_name.Caption:=AClient.player[3];
  end;
end;


procedure TForm5.rbClick(Sender: TObject);
begin
 if assigned(self.AServer) then
  begin
   if Sender = self.rb2_open then self.AServer.playerslots[1]:=1;
   if Sender = self.rb2_closed then self.AServer.playerslots[1]:=0;
   if Sender = self.rb3_open then self.AServer.playerslots[2]:=1;
   if Sender = self.rb3_closed then self.AServer.playerslots[2]:=0;
   if Sender = self.rb4_open then self.AServer.playerslots[3]:=1;
   if Sender = self.rb4_closed then self.AServer.playerslots[3]:=0;
   self.AServer.playerstatchange;
  end;
end;


procedure TForm5.but_chatClick(Sender: TObject);
var
 text: string;
begin
 text:=Form5.ed_chat.Text;
 Form5.ed_chat.Text:='';
 if (text <> '') and assigned(self.AClient) then
  self.AClient.send_text('text;'+text+';');
end;


procedure TForm5.but_client_leaveClick(Sender: TObject);
begin
 if assigned(self.AClient) then
  self.AClient.Free;
end;



function bts(eingang : boolean) : string;
begin
 //Quasi ein BoolToString mit 'Ja' oder 'Nein'
 if eingang then result:=lang.Generic.Yes
 else result:=lang.Generic.No;
end;


procedure TForm5.but_client_rulesClick(Sender: TObject);
var
 text:string;
begin
 if assigned(self.AClient) then
  begin
   text:=lang.Player.rules_0
         +#13#10+lang.Player.rules_1
         +' ' + bts(self.AClient.rules.seven_use)
         +#13#10+lang.Player.rules_2
         +' ' + bts(self.AClient.rules.eight_use)
         +#13#10+lang.Player.rules_3
         +' ' + bts(self.AClient.rules.nine_use)
         +#13#10+lang.Player.rules_4
         +' ' + bts(self.AClient.rules.bube_use)
         +#13#10
         +#13#10+lang.Player.rules_5
         +' ' + inttostr(self.AClient.rules.seven_take)
         +#13#10+lang.Player.rules_6
         +' ' + bts(self.AClient.rules.nine_win)
         +#13#10+lang.Player.rules_7
         +' ' + bts(self.AClient.rules.bube_bube);
   ShowMessage(text, self);
  end;
end;


procedure TForm5.but_server_closeClick(Sender: TObject);
begin
 if assigned(self.AServer) then
  begin
   Form5.Close;
   self.AServer.Free;
  end;
end;

procedure TForm5.but_server_roundstartClick(Sender: TObject);
begin
 if assigned(self.AServer)
 and not //wenn beides nicht zutrifft
  (
   ( //falls 1 Platz offen
    (self.AServer.playerslots[1] = 1)
    or(self.AServer.playerslots[2] = 1)
    or(self.AServer.playerslots[3] = 1)
   )
   or
   ( //oder Spieler 1 allein
    (self.AServer.playerslots[1]=0)
    and (self.AServer.playerslots[2]=0)
    and (self.AServer.playerslots[3]=0)
   )
  )
 then
  AServer.gamestart;
end;


procedure TForm5.but_server_rulesClick(Sender: TObject);
begin
 Form3:=TForm3.Create(Form1);
 Form3.Left := Form1.Left + (Form1.Width div 2) - (Form3.Width div 2);
 Form3.Top := Form1.Top + (Form1.Height div 2) - (Form3.Height div 2);
 Form3.ShowModal;
 Form3.Free;
end;



end.
