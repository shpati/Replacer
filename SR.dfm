object Form1: TForm1
  Left = 1203
  Top = 506
  AutoScroll = False
  Caption = 'Replacer'
  ClientHeight = 456
  ClientWidth = 632
  Color = clBtnFace
  Constraints.MinHeight = 480
  Constraints.MinWidth = 640
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = startup
  OnResize = resize
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter4: TSplitter
    Left = 0
    Top = 0
    Width = 632
    Height = 153
    Cursor = crDefault
    Align = alTop
    ResizeStyle = rsNone
  end
  object Label1: TLabel
    Left = 5
    Top = 8
    Width = 77
    Height = 13
    Caption = 'Search in folder:'
  end
  object Label2: TLabel
    Left = 5
    Top = 56
    Width = 456
    Height = 13
    Caption = 
      'Filter by text contained in the file name. You can enter multipl' +
      'e values separated by semicolons (;)'
  end
  object Label3: TLabel
    Left = 8
    Top = 136
    Width = 72
    Height = 13
    Caption = 'Search for text:'
  end
  object Label4: TLabel
    Left = 320
    Top = 136
    Width = 85
    Height = 13
    Caption = 'Replace with text:'
  end
  object Splitter2: TSplitter
    Left = 628
    Top = 153
    Width = 4
    Height = 191
    Align = alRight
  end
  object Splitter3: TSplitter
    Left = 0
    Top = 344
    Width = 632
    Height = 4
    Cursor = crVSplit
    Align = alBottom
  end
  object Splitter1: TSplitter
    Left = 0
    Top = 153
    Width = 4
    Height = 191
  end
  object Splitter5: TSplitter
    Left = 321
    Top = 153
    Width = 4
    Height = 191
    MinSize = 4
    OnMoved = resize
  end
  object CheckBox1: TCheckBox
    Left = 5
    Top = 104
    Width = 120
    Height = 25
    Caption = 'Include subfolders'
    TabOrder = 3
  end
  object Button1: TButton
    Left = 472
    Top = 24
    Width = 57
    Height = 21
    Caption = 'Browse'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 536
    Top = 24
    Width = 89
    Height = 69
    Caption = 'Run'
    Default = True
    TabOrder = 10
    OnClick = Button2Click
  end
  object CheckBox2: TCheckBox
    Left = 408
    Top = 104
    Width = 97
    Height = 25
    Caption = 'Case Sensitive'
    TabOrder = 5
  end
  object Memo1: TMemo
    Left = 4
    Top = 153
    Width = 317
    Height = 191
    Align = alLeft
    Constraints.MinWidth = 1
    ScrollBars = ssVertical
    TabOrder = 7
    WantTabs = True
    OnKeyPress = MemoKeyPress
  end
  object Memo2: TMemo
    Left = 325
    Top = 153
    Width = 303
    Height = 191
    Align = alClient
    Anchors = [akTop, akRight, akBottom]
    Constraints.MinWidth = 1
    ScrollBars = ssVertical
    TabOrder = 8
    WantTabs = True
    OnKeyPress = MemoKeyPress
  end
  object CheckBox4: TCheckBox
    Left = 144
    Top = 104
    Width = 233
    Height = 25
    Caption = 'Apply changes to read-only and hidden files'
    TabOrder = 4
  end
  object CheckBox5: TCheckBox
    Left = 536
    Top = 104
    Width = 89
    Height = 25
    Caption = 'Search only'
    Checked = True
    State = cbChecked
    TabOrder = 6
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 436
    Width = 632
    Height = 20
    DragMode = dmAutomatic
    Panels = <
      item
        Width = 150
      end
      item
        Width = 180
      end
      item
        Width = 196
      end
      item
        Alignment = taRightJustify
        Text = #169' Shpati Koleka - MIT License        '
        Width = 50
      end>
  end
  object ListView1: TListView
    Left = 0
    Top = 348
    Width = 632
    Height = 88
    Align = alBottom
    Columns = <
      item
        Caption = 'File name'
        Width = 400
      end
      item
        Alignment = taRightJustify
        Caption = 'File size (bytes)'
        Width = 100
      end
      item
        Alignment = taCenter
        AutoSize = True
        Caption = 'Text Found'
      end
      item
        Alignment = taCenter
        AutoSize = True
        Caption = 'Text Replaced'
      end>
    RowSelect = True
    TabOrder = 11
    ViewStyle = vsReport
    OnChange = listchange
    OnColumnClick = ListView1ColumnClick
    OnCompare = ListView1Compare
    OnDblClick = openitem
    OnKeyDown = openfile
  end
  object Edit1: TEdit
    Left = 4
    Top = 24
    Width = 461
    Height = 21
    TabStop = False
    ReadOnly = True
    TabOrder = 0
  end
  object Edit2: TEdit
    Left = 4
    Top = 72
    Width = 525
    Height = 21
    TabOrder = 2
  end
end
