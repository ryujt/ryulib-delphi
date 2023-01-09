object frControlBox: TfrControlBox
  Left = 0
  Top = 0
  Width = 320
  Height = 540
  TabOrder = 0
  inline frAudioControl: TfrAudioControl
    Left = 0
    Top = 120
    Width = 320
    Height = 120
    Align = alTop
    Color = clMoneyGreen
    ParentBackground = False
    ParentColor = False
    TabOrder = 0
    ExplicitTop = 120
    ExplicitWidth = 320
    ExplicitHeight = 120
    inherited cbSelectInputDevice: TComboBox
      Width = 216
      ExplicitWidth = 216
    end
  end
  inline frMainControl: TfrMainControl
    Left = 0
    Top = 0
    Width = 320
    Height = 120
    Align = alTop
    Color = clSkyBlue
    ParentBackground = False
    ParentColor = False
    TabOrder = 1
    ExplicitWidth = 320
    ExplicitHeight = 120
  end
  inline frVideoSource: TfrVideoSource
    Left = 0
    Top = 240
    Width = 320
    Height = 120
    Align = alTop
    Color = clTeal
    ParentBackground = False
    ParentColor = False
    TabOrder = 2
    ExplicitTop = 240
    ExplicitWidth = 320
    ExplicitHeight = 120
  end
end
