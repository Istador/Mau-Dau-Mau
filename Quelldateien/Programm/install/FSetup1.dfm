object Form1: TForm1
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Installation von Mau Dau Mau'
  ClientHeight = 268
  ClientWidth = 474
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
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 436
    Height = 13
    Caption = 
      'Bevor Sie Mau Dau Mau installieren k'#246'nnen, m'#252'ssen sie den Lizenz' +
      'bedingungen zustimmen.'
  end
  object Memo1: TMemo
    Left = 8
    Top = 27
    Width = 458
    Height = 202
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object CheckBox1: TCheckBox
    Left = 8
    Top = 235
    Width = 209
    Height = 17
    Caption = 'Ich stimme den Lizenzbedingungen zu.'
    TabOrder = 1
    OnClick = CheckBox1Click
  end
  object Button1: TButton
    Left = 391
    Top = 235
    Width = 75
    Height = 25
    Caption = 'Weiter'
    Enabled = False
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 310
    Top = 235
    Width = 75
    Height = 25
    Caption = 'Beenden'
    TabOrder = 3
    OnClick = Button2Click
  end
end
