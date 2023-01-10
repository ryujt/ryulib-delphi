object frMainControl: TfrMainControl
  Left = 0
  Top = 0
  Width = 340
  Height = 240
  Color = clSkyBlue
  ParentBackground = False
  ParentColor = False
  TabOrder = 0
  object btStartCaptrue: TButton
    Left = 12
    Top = 12
    Width = 75
    Height = 25
    Caption = 'stoped'
    TabOrder = 0
    OnClick = btStartCaptrueClick
  end
  object btResolution: TButton
    Left = 93
    Top = 12
    Width = 75
    Height = 25
    Caption = 'HD'
    TabOrder = 1
    OnClick = btResolutionClick
  end
end
