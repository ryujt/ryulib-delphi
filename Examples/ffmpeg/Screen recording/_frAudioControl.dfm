object frAudioControl: TfrAudioControl
  Left = 0
  Top = 0
  Width = 340
  Height = 678
  Color = clMoneyGreen
  ParentBackground = False
  ParentColor = False
  TabOrder = 0
  DesignSize = (
    340
    678)
  object Shape1: TShape
    Left = 8
    Top = 11
    Width = 75
    Height = 21
  end
  object Label1: TLabel
    Left = 28
    Top = 14
    Width = 15
    Height = 13
    Caption = 'Mic'
  end
  object cbSelectInputDevice: TComboBox
    Left = 89
    Top = 11
    Width = 236
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
    Text = 'default audio input device'
  end
  object checkUseSystemAudio: TCheckBox
    Left = 8
    Top = 44
    Width = 317
    Height = 17
    Caption = 'Use System Audio'
    TabOrder = 1
  end
end
