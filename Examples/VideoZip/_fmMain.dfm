object fmMain: TfmMain
  Left = 0
  Top = 0
  Caption = 'Demo for TVideoZip'
  ClientHeight = 320
  ClientWidth = 480
  Color = clBtnFace
  DoubleBuffered = True
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
    Width = 480
    Height = 320
    Align = alClient
    Center = True
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
