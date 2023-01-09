object fmMain: TfmMain
  Left = 0
  Top = 0
  Caption = 'Audio Sender'
  ClientHeight = 201
  ClientWidth = 324
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  inline frAudioControl: TfrAudioControl
    Left = 0
    Top = 0
    Width = 324
    Height = 201
    Align = alClient
    TabOrder = 0
    ExplicitWidth = 324
    ExplicitHeight = 81
    inherited cbSelectInputDevice: TComboBox
      Width = 220
    end
  end
end
