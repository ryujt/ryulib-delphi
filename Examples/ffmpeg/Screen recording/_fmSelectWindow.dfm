object fmSelectWindow: TfmSelectWindow
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'fmSelectWindow'
  ClientHeight = 240
  ClientWidth = 320
  Color = clRed
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnClose = FormClose
  OnDeactivate = FormDeactivate
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  DesignSize = (
    320
    240)
  PixelsPerInch = 96
  TextHeight = 13
  object plClient: TPanel
    Left = 3
    Top = 3
    Width = 314
    Height = 234
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelOuter = bvNone
    Color = clBlack
    ParentBackground = False
    TabOrder = 0
  end
  object Timer: TTimer
    Interval = 100
    OnTimer = TimerTimer
    Left = 148
    Top = 108
  end
end
