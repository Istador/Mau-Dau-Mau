object Form3: TForm3
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Installation von Mau Dau Mau'
  ClientHeight = 221
  ClientWidth = 474
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 343
    Top = 200
    Width = 17
    Height = 13
    Caption = '0%'
  end
  object Button1: TButton
    Left = 391
    Top = 191
    Width = 75
    Height = 25
    Caption = 'Beenden'
    Enabled = False
    TabOrder = 0
    OnClick = Button1Click
  end
  object Memo1: TMemo
    Left = 8
    Top = 8
    Width = 458
    Height = 177
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object ProgressBar1: TProgressBar
    Left = 8
    Top = 196
    Width = 329
    Height = 17
    Max = 15
    TabOrder = 2
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 368
    Top = 136
  end
end
