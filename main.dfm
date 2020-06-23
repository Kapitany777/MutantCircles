object FormMain: TFormMain
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'Mutant Circles'
  ClientHeight = 585
  ClientWidth = 698
  Color = clBlack
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poDesigned
  WindowState = wsMaximized
  OnClose = FormClose
  OnCreate = FormCreate
  OnDblClick = FormDblClick
  OnKeyPress = FormKeyPress
  OnMouseDown = FormMouseDown
  OnMouseMove = FormMouseMove
  PixelsPerInch = 96
  TextHeight = 13
  object ImageMain: TImage
    Left = 2
    Top = 2
    Width = 105
    Height = 105
    OnMouseDown = ImageMainMouseDown
    OnMouseMove = ImageMainMouseMove
  end
  object ImageInfo: TImage
    Left = 8
    Top = 126
    Width = 105
    Height = 105
  end
  object PanelGameOver: TPanel
    Left = 46
    Top = 456
    Width = 269
    Height = 95
    BevelInner = bvRaised
    BevelKind = bkSoft
    Caption = 'GAME OVER!'
    Color = clBlack
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -43
    Font.Name = 'Terminal'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    Visible = False
    OnDblClick = PanelGameOverDblClick
  end
  object PanelStart: TPanel
    Left = 8
    Top = 263
    Width = 127
    Height = 34
    BevelOuter = bvNone
    Caption = 'Start game'
    Color = clBlack
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clLime
    Font.Height = -19
    Font.Name = 'Terminal'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnClick = PanelStartClick
  end
  object PanelExit: TPanel
    Left = 16
    Top = 308
    Width = 127
    Height = 34
    BevelOuter = bvNone
    Caption = 'Exit game'
    Color = clBlack
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clLime
    Font.Height = -19
    Font.Name = 'Terminal'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    OnClick = PanelExitClick
  end
  object PanelTitle: TPanel
    Left = 210
    Top = 20
    Width = 455
    Height = 327
    BevelKind = bkSoft
    Color = clBlack
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clLime
    Font.Height = -43
    Font.Name = 'Terminal'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
    Visible = False
    object Label1: TLabel
      Left = 78
      Top = 38
      Width = 295
      Height = 36
      Caption = 'MUTANT CIRCLES'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clLime
      Font.Height = -43
      Font.Name = 'Terminal'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label2: TLabel
      Left = 27
      Top = 120
      Width = 78
      Height = 18
      Caption = 'Design:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clLime
      Font.Height = -21
      Font.Name = 'Terminal'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label3: TLabel
      Left = 176
      Top = 120
      Width = 78
      Height = 18
      Caption = 'Kellisz'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clLime
      Font.Height = -21
      Font.Name = 'Terminal'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label4: TLabel
      Left = 27
      Top = 158
      Width = 133
      Height = 18
      Caption = 'Programming:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clLime
      Font.Height = -21
      Font.Name = 'Terminal'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label5: TLabel
      Left = 176
      Top = 158
      Width = 89
      Height = 18
      Caption = 'Kapitany'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clLime
      Font.Height = -21
      Font.Name = 'Terminal'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label6: TLabel
      Left = 27
      Top = 196
      Width = 67
      Height = 18
      Caption = 'Music:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clLime
      Font.Height = -21
      Font.Name = 'Terminal'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label7: TLabel
      Left = 176
      Top = 196
      Width = 78
      Height = 18
      Caption = 'Samuraj'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clLime
      Font.Height = -21
      Font.Name = 'Terminal'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label8: TLabel
      Left = 27
      Top = 248
      Width = 187
      Height = 12
      Caption = '(C) 2007 Tumuslak Vorvahes Team'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clLime
      Font.Height = -16
      Font.Name = 'Terminal'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label9: TLabel
      Left = 27
      Top = 274
      Width = 385
      Height = 12
      Caption = 'This game is made for the minigame contest of Jatekfejlesztes.hu'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clLime
      Font.Height = -16
      Font.Name = 'Terminal'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object MediaPlayerMusic: TMediaPlayer
    Left = 332
    Top = 466
    Width = 253
    Height = 30
    Visible = False
    TabOrder = 4
  end
  object TimerMain: TTimer
    Enabled = False
    Interval = 20
    OnTimer = TimerMainTimer
    Left = 42
    Top = 396
  end
  object TimerClock: TTimer
    Enabled = False
    Interval = 100
    OnTimer = TimerClockTimer
    Left = 108
    Top = 396
  end
  object TimerMusic: TTimer
    Enabled = False
    OnTimer = TimerMusicTimer
    Left = 170
    Top = 396
  end
end
