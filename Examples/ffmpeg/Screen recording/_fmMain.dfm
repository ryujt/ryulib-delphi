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
    ExplicitLeft = 66
    ExplicitTop = -39
  end
  inline frControlBox: TfrControlBox
    Left = 744
    Top = 0
    Width = 320
    Height = 681
    Align = alRight
    TabOrder = 1
    ExplicitLeft = 1208
    ExplicitTop = 402
    inherited frAudioControl: TfrAudioControl
      ExplicitTop = 120
      inherited cbSelectInputDevice: TComboBox
        ExplicitWidth = 216
      end
    end
  end
end
