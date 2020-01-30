object fmMain: TfmMain
  Left = 0
  Top = 0
  Caption = 'Demo for TVideoZip'
  ClientHeight = 281
  ClientWidth = 384
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
  object Image: TImage
    Left = 0
    Top = 0
    Width = 384
    Height = 281
    Align = alClient
    Center = True
    ExplicitLeft = 296
    ExplicitTop = 168
    ExplicitWidth = 105
    ExplicitHeight = 105
  end
  object Timer: TTimer
    Interval = 50
    OnTimer = TimerTimer
    Left = 708
    Top = 296
  end
end
