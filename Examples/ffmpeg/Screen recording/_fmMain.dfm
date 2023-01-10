object fmMain: TfmMain
  Left = 0
  Top = 0
  Caption = 'Screen Recording Example'
  ClientHeight = 681
  ClientWidth = 1064
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  inline frVideoPreview: TfrVideoPreview
    Left = 0
    Top = 0
    Width = 744
    Height = 681
    Align = alClient
    TabOrder = 0
    ExplicitWidth = 744
    ExplicitHeight = 681
  end
  inline frControlBox: TfrControlBox
    Left = 744
    Top = 0
    Width = 320
    Height = 681
    Align = alRight
    TabOrder = 1
    ExplicitLeft = 744
    ExplicitHeight = 681
    inherited frVideoSource: TfrVideoSource
      inherited plMonitor: TPanel
        ExplicitWidth = 301
        inherited cbMonitor: TComboBox
          ExplicitWidth = 284
        end
      end
    end
  end
end
