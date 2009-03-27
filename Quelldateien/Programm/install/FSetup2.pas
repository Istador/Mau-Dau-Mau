unit FSetup2;
{
  author:     Robin Christopher Ladiges
  website:    http://blackpinguin.de/
  project:    Mau Dau Mau
  binary:     Install.exe
  unit:       FSetup2
  file:       FSetup2.pas
  filepath:   .\install\
  year:       2008/2009
  desc:       This file handles the second Setup Form.

  license:    creative commons by-nc-sa 3.0 germany
   look out license.txt in this folder
   human-readable summary : http://creativecommons.org/licenses/by-nc-sa/3.0/de/
}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, FileCtrl, ExtCtrls;

type
  TForm2 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    LabeledEdit1: TLabeledEdit;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Form2: TForm2;

implementation
{$R *.dfm}
uses FSetup1, FSetup3;



procedure TForm2.Button1Click(Sender: TObject);
begin
 //zum  anhängen eines \ am ende des strings falls nicht vorhanden
 if LabeledEdit1.Text[length(LabeledEdit1.Text)] <> #92 then
  LabeledEdit1.Text:=LabeledEdit1.Text+#92;
 Form2.Hide; //Form2 verstecken
 Form3.ShowModal; //zeige Form3 an
 Form2.Close; //wird beim schließen von Form3 ausgeführt
end;


procedure TForm2.Button2Click(Sender: TObject);
begin
 Form2.Close;
end;


procedure TForm2.FormShow(Sender: TObject);
begin
 self.Left:=Form1.Left;
 self.Top:=Form1.Top;
end;

end.
