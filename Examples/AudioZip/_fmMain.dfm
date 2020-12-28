object fmMain: TfmMain
  Left = 0
  Top = 0
  Caption = 'Exapmle of AudioZip'
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
  object moMsg: TMemo
    Left = 0
    Top = 41
    Width = 852
    Height = 370
    Align = alClient
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 0
    ExplicitTop = 0
    ExplicitHeight = 411
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 852
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitLeft = 488
    ExplicitTop = 232
    ExplicitWidth = 185
    object btStart: TButton
      Left = 12
      Top = 9
      Width = 75
      Height = 25
      Caption = 'Start'
      TabOrder = 0
      OnClick = btStartClick
    end
    object btStop: TButton
      Left = 93
      Top = 9
      Width = 75
      Height = 25
      Caption = 'Stop'
      TabOrder = 1
      OnClick = btStopClick
    end
  end
end
