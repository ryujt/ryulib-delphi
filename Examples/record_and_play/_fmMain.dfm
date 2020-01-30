object fmMain: TfmMain
  Left = 0
  Top = 0
  Caption = 'fmMain'
  ClientHeight = 411
  ClientWidth = 852
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object btCreate: TButton
    Left = 56
    Top = 52
    Width = 75
    Height = 25
    Caption = 'btCreate'
    TabOrder = 0
    OnClick = btCreateClick
  end
  object btStart: TButton
    Left = 137
    Top = 52
    Width = 75
    Height = 25
    Caption = 'btStart'
    TabOrder = 1
    OnClick = btStartClick
  end
  object btRelease: TButton
    Left = 299
    Top = 52
    Width = 75
    Height = 25
    Caption = 'btRelease'
    TabOrder = 2
    OnClick = btReleaseClick
  end
  object btStop: TButton
    Left = 218
    Top = 52
    Width = 75
    Height = 25
    Caption = 'btStop'
    TabOrder = 3
    OnClick = btStopClick
  end
end
