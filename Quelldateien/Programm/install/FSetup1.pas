unit FSetup1;
{
  author:     Robin Christopher Ladiges
  website:    http://blackpinguin.de/
  project:    Mau Dau Mau
  binary:     Install.exe
  unit:       FSetup1
  file:       FSetup1.pas
  filepath:   .\install\
  year:       2008/2009
  desc:       This file handles the first Setup Form.

  license:    creative commons by-nc-sa 3.0 germany
   look out license.txt in this folder
   human-readable summary : http://creativecommons.org/licenses/by-nc-sa/3.0/de/
}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Registry;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Memo1: TMemo;
    CheckBox1: TCheckBox;
    Button1: TButton;
    Button2: TButton;
    procedure CheckBox1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Form1: TForm1;

implementation
{$R *.dfm}
uses FSetup2, FSetup3;



procedure TForm1.Button1Click(Sender: TObject);
begin
 Form1.Hide;
 Form2.ShowModal;
 Form1.Close;
end;


procedure TForm1.Button2Click(Sender: TObject);
begin
 Form1.Close;
end;


procedure TForm1.CheckBox1Click(Sender: TObject);
begin
 Button1.Enabled:=TCheckBox(Sender).Checked;
end;


procedure TForm1.FormShow(Sender: TObject);
var reg:TRegistry;
installed:boolean;
begin
 installed:=false;
 self.Left:=(Screen.Width div 2)-(self.Width div 2);
 self.Top:=(Screen.Height div 2)-(self.Height div 2);
 reg:=TRegistry.Create;
 try
  reg.RootKey:=HKEY_LOCAL_MACHINE;
  installed:=reg.KeyExists('Software\MauDauMau');
 finally
  reg.Free;
 end;
 if installed then
  begin
   self.Button1.Enabled:=false;
   self.CheckBox1.Enabled:=false;
   self.Memo1.Enabled:=false;
   ShowMessage('MauDauMau ist bereits installiert.');
   self.Close;
  end
 else
  Memo1.Lines.LoadFromFile(ExtractFilePath(ParamStr(0))+'license.txt');
end;

end.
