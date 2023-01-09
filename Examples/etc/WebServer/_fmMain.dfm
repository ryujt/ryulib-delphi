object fmMain: TfmMain
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Mini WebServer'
  ClientHeight = 98
  ClientWidth = 240
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 24
    Top = 23
    Width = 69
    Height = 21
    BevelOuter = bvNone
    BorderStyle = bsSingle
    Caption = #54252#53944#48264#54840
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
    StyleElements = []
  end
  object SpinEdit: TSpinEdit
    Left = 99
    Top = 22
    Width = 118
    Height = 22
    MaxValue = 0
    MinValue = 0
    TabOrder = 1
    Value = 7777
  end
  object btStart: TButton
    Left = 142
    Top = 56
    Width = 75
    Height = 25
    Caption = 'Start'
    TabOrder = 2
    OnClick = btStartClick
  end
  object Button2: TButton
    Left = 268
    Top = 56
    Width = 75
    Height = 25
    Caption = 'Button2'
    TabOrder = 3
  end
end
