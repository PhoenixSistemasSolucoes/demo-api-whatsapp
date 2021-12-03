object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Plataforma Phoenix Whatsapp '
  ClientHeight = 211
  ClientWidth = 744
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  PixelsPerInch = 96
  DesignSize = (
    744
    211)
  TextHeight = 15
  object Label1: TLabel
    Left = 18
    Top = 11
    Width = 51
    Height = 15
    Caption = 'Usu'#225'rio'
  end
  object Label2: TLabel
    Left = 18
    Top = 62
    Width = 43
    Height = 15
    Caption = 'Senha'
  end
  object Edit1: TEdit
    Left = 18
    Top = 32
    Width = 259
    Height = 23
    TabOrder = 0
    Text = '28.254.501/0001-13'
  end
  object Edit2: TEdit
    Left = 18
    Top = 83
    Width = 259
    Height = 23
    TabOrder = 1
    Text = 'DEMO'
  end
  object Button1: TButton
    Left = 18
    Top = 115
    Width = 259
    Height = 25
    Caption = 'Menssagem'
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 18
    Top = 146
    Width = 259
    Height = 25
    Caption = 'PDF'
    TabOrder = 3
    OnClick = Button2Click
  end
  object Memo1: TMemo
    Left = 296
    Top = 38
    Width = 440
    Height = 164
    Anchors = [akLeft, akTop, akRight]
    Lines.Strings = (
      'Memo1')
    TabOrder = 4
  end
  object Button3: TButton
    Left = 17
    Top = 177
    Width = 260
    Height = 25
    Caption = 'Image'
    TabOrder = 5
    OnClick = Button3Click
  end
  object OpenDialog1: TOpenDialog
    Left = 392
    Top = 112
  end
end
