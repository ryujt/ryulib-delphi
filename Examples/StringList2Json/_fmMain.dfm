object fmMain: TfmMain
  Left = 0
  Top = 0
  Caption = 'fmMain'
  ClientHeight = 411
  ClientWidth = 852
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 8
    Top = 148
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Memo1: TMemo
    Left = 8
    Top = 8
    Width = 833
    Height = 121
    Lines.Strings = (
      'MainIsRunning="main.py" is running.'
      
        'FormatWarning=Formatting will erase all data on AsomeBoard.\nTo ' +
        'format the disk, click Yes button.'
      'HelpWarning=This function is under construction.'
      'EnterFilename=Enter the filename.'
      'Filename=Filename'
      'Disconnected=AsomeBoard is disconnected.'
      'Refresh=Refresh'
      'backward=backward'
      'else=else')
    TabOrder = 1
  end
  object Memo2: TMemo
    Left = 8
    Top = 192
    Width = 833
    Height = 169
    Lines.Strings = (
      'Memo2')
    TabOrder = 2
  end
end
