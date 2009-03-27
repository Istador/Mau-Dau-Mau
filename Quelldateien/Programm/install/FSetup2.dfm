object Form2: TForm2
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Installation von Mau Dau Mau'
  ClientHeight = 153
  ClientWidth = 404
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 280
    Top = 120
    Width = 115
    Height = 25
    Caption = 'Installation starten'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 200
    Top = 120
    Width = 75
    Height = 25
    Caption = 'Beenden'
    TabOrder = 1
    OnClick = Button2Click
  end
  object LabeledEdit1: TLabeledEdit
    Left = 8
    Top = 24
    Width = 385
    Height = 21
    EditLabel.Width = 206
    EditLabel.Height = 13
    EditLabel.Caption = 'Wohin soll Mau Dau Mau installiert werden?'
    TabOrder = 2
    Text = 'C:\Programme\Mau Dau Mau\'
  end
  object CheckBox1: TCheckBox
    Left = 8
    Top = 51
    Width = 313
    Height = 17
    Caption = 'Verkn'#252'pfung auf dem Desktop erstellen.'
    Checked = True
    State = cbChecked
    TabOrder = 3
  end
  object CheckBox2: TCheckBox
    Left = 8
    Top = 74
    Width = 322
    Height = 17
    Caption = 'Kontextmen'#252' im Startmen'#252' erzeugen.'
    Checked = True
    State = cbChecked
    TabOrder = 4
  end
  object CheckBox3: TCheckBox
    Left = 8
    Top = 96
    Width = 393
    Height = 17
    Caption = 
      'chmfix.exe ausf'#252'hren, um evtl Probleme beim '#246'ffnen der Hilfe vor' +
      'zubeugen.'
    Checked = True
    State = cbChecked
    TabOrder = 5
  end
end
