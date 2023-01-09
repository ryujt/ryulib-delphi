object frAudioControl: TfrAudioControl
  Left = 0
  Top = 0
  Width = 340
  Height = 678
  TabOrder = 0
  DesignSize = (
    340
    678)
  object Shape1: TShape
    Left = 12
    Top = 51
    Width = 75
    Height = 21
  end
  object Label1: TLabel
    Left = 32
    Top = 54
    Width = 15
    Height = 13
    Caption = 'Mic'
  end
  object btStartCaptrue: TButton
    Left = 12
    Top = 12
    Width = 75
    Height = 25
    Caption = 'off the air'
    TabOrder = 0
    OnClick = btStartCaptrueClick
  end
  object cbSelectInputDevice: TComboBox
    Left = 93
    Top = 51
    Width = 236
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 1
    Text = 'default audio input device'
  end
  object checkUseSystemAudio: TCheckBox
    Left = 12
    Top = 84
    Width = 317
    Height = 17
    Caption = 'Use System Audio'
    TabOrder = 2
  end
end
