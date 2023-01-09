object frVideoSource: TfrVideoSource
  Left = 0
  Top = 0
  Width = 340
  Height = 240
  Color = clTeal
  ParentBackground = False
  ParentColor = False
  TabOrder = 0
  DesignSize = (
    340
    240)
  object Shape1: TShape
    Left = 8
    Top = 11
    Width = 75
    Height = 21
  end
  object Label1: TLabel
    Left = 12
    Top = 14
    Width = 62
    Height = 13
    Caption = 'Video Source'
  end
  object cbVideoSource: TComboBox
    Left = 89
    Top = 11
    Width = 236
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    ItemIndex = 0
    TabOrder = 0
    Text = 'Region'
    OnChange = cbVideoSourceChange
    OnKeyPress = cbVideoSourceKeyPress
    Items.Strings = (
      'Region'
      'Window'
      'Monitor')
  end
end
