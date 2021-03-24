unit SR;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, FileCtrl, StrUtils, ExtCtrls, ShellApi;

type
  TStringArray = array of string;
  TForm1 = class(TForm)
    Memo1: TMemo;
    Memo2: TMemo;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Button1: TButton;
    Button2: TButton;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    ListView1: TListView;
    StatusBar1: TStatusBar;
    Edit1: TEdit;
    Edit2: TEdit;
    Splitter2: TSplitter;
    Splitter3: TSplitter;
    Splitter4: TSplitter;
    Splitter1: TSplitter;
    Splitter5: TSplitter;

    procedure startup(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure resize(Sender: TObject);
    procedure update_statusbar;
    procedure openitem(Sender: TObject);
    procedure openfile(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ListView1ColumnClick(Sender: TObject; Column: TListColumn);
    procedure ListView1Compare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure ListAllFilesInDir(const Dir: string);
    procedure listchange(Sender: TObject; Item: TListItem;
      Change: TItemChange);

    function splitstring(str: string): TStringArray;
    function LoadTextFromFile(const FileName: string): string;
    function SaveTextToFile(const FileName: string; str: string): string;
    function HasText(FileName: string; SearchStr: string;
      CaseSensitive: boolean): string;
    function ReplaceText(FileName: string; SearchStr, ReplaceStr: string;
      CaseSensitive: boolean): string;
    procedure MemoKeyPress(Sender: TObject; var Key: Char);

  private
    { Private declarations }
    Descending: Boolean;
    SortedColumn: Integer;

  public

  end;

var
  Form1: TForm1;
  Path: string;
  filecount, foundcount, replacedcount: integer;

implementation

{$R *.dfm}

procedure TForm1.startup(Sender: TObject);
begin
  Form1.Width := round(Screen.WorkAreaWidth * 0.6);
  Form1.Height := round(Screen.WorkAreaHeight * 0.6);
  Memo1.Width := Round(StatusBar1.Width / 2) - 6;
  filecount := 0;
  foundcount := 0;
  replacedcount := 0;
  Path := ExtractFilePath(Application.ExeName);
  Edit1.Text := Path;
  Edit2.Text := '.txt;.md;.htm;.css;.js;.php;.py;.rb;.asp;.pl;.cgi;.sh';
  ListView1.ShowColumnHeaders := true;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  if SelectDirectory('Select a directory', '', Path) then
    Path := Path + '\';
  Edit1.Text := Path;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  confirm: integer;
begin
  filecount := 0;
  foundcount := 0;
  replacedcount := 0;
  if not Checkbox5.Checked and (Memo1.Text <> '') then
  begin
    confirm := MessageDlg('Are you sure that you want to replace the text' +
      ' in all the matching files?' + sLineBreak + sLineBreak + 'TIP: It is' +
      ' recommended to always use the "Search only" option to view' + sLineBreak +
      'the files that will be changed before actually performing any changes.'
      , mtCustom, [mbYes, mbNo], 0);
    if confirm <> mrYes then Exit;
  end;
  ListView1.Clear;
  ListAllFilesInDir(Path);
  update_statusbar;
end;

procedure TForm1.resize(Sender: TObject);
begin
  StatusBar1.Width := Form1.Width;
  Button2.Width := 89;
  Button2.Left := StatusBar1.Width - Button2.Width - 6;
  Button1.Left := Button2.Left - 4 - Button1.Width;
  Edit1.Width := Button1.Left - 8;
  Edit2.Width := Button2.Left - 8;
  Label4.Left := Memo2.Left + 1;
  ListView1.Column[0].Width := Round(ListView1.Width * 0.50);
  ListView1.Column[1].Width := Round(ListView1.Width * 0.20);
  ListView1.Column[2].Width := Round(ListView1.Width * 0.12);
  ListView1.Column[3].Width := Round(ListView1.Width * 0.12);
  ShowScrollBar(ListView1.Handle, SB_HORZ, False);
end;

procedure TForm1.update_statusbar;
begin
  StatusBar1.Panels[0].Text := ' Files in location: ' +
    inttostr(filecount);
  StatusBar1.Panels[1].Text := ' Files with text found: ' +
    inttostr(foundcount);
  StatusBar1.Panels[2].Text := ' Files with text replaced : ' +
    inttostr(replacedcount);
end;

procedure TForm1.openitem(Sender: TObject);
begin
  if ListView1.SelCount = 1 then
    ShellExecute(Handle, 'open', PAnsiChar(ListView1.Selected.Caption), nil,
      nil, SW_SHOWNORMAL);
end;

procedure TForm1.openfile(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (ord(Key) = VK_RETURN) or (ord(Key) = 32) then
    openitem(nil);
end;

procedure TForm1.ListView1ColumnClick(Sender: TObject; Column: TListColumn);
begin
  TListView(Sender).SortType := stNone;
  if Column.Index <> SortedColumn then
  begin
    SortedColumn := Column.Index;
    Descending := False;
  end
  else
    Descending := not Descending;
  TListView(Sender).SortType := stData;
end;

procedure TForm1.ListView1Compare(Sender: TObject; Item1, Item2: TListItem;
  Data: Integer; var Compare: Integer);
begin
  if SortedColumn = 0 then Compare := CompareText(Item1.Caption, Item2.Caption)
  else
    if SortedColumn <> 0 then
      Compare := CompareText(Item1.SubItems[SortedColumn - 1],
        Item2.SubItems[SortedColumn - 1]);
  if Descending then Compare := -Compare;
end;

procedure TForm1.ListAllFilesInDir(const Dir: string);
var
  SRec: TSearchRec;
  ListItem: TListItem;
  i: integer;
  TSA: TStringArray;
label
  list;
begin
  TSA := splitstring(Edit2.Text);
  ListView1.Items.BeginUpdate;
  if FindFirst(IncludeTrailingBackslash(Dir) + '*.*', faAnyFile or faDirectory, SRec) = 0 then
  try
    repeat
      i := 0;
      if (SRec.Attr and faDirectory) = 0 then
      begin
        if Edit2.Text = '' then goto list else
          if (i < High(TSA) + 1) then
            if AnsiContainsText(SRec.Name, TSA[i]) then
            begin
              list:
              ListItem := ListView1.Items.Add;
              ListItem.Caption := IncludeTrailingBackslash(Dir) + SRec.Name;
              ListItem.SubItems.Add(InttoStr(SRec.Size));
              ListItem.SubItems.Add(HasText(IncludeTrailingBackslash(Dir) + SRec.Name, Memo1.Text, CheckBox2.Checked));
              inc(filecount);
              if CheckBox5.Checked then
                ListItem.SubItems.Add('No')
              else
                ListItem.SubItems.Add(ReplaceText(IncludeTrailingBackslash(Dir) + SRec.Name, Memo1.Text,
                  Memo2.Text, CheckBox2.Checked));
              inc(i);
            end;
      end
      else
        if (SRec.Name <> '.') and (SRec.Name <> '..') then
          if CheckBox1.Checked then
            ListAllFilesInDir(IncludeTrailingBackslash(Dir) + SRec.Name); // recursion
    until FindNext(SRec) <> 0;
  finally
    FindClose(SRec);
  end;
  ListView1.Items.EndUpdate;
  ListView1.SortType := stData;
end;

procedure TForm1.listchange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
begin
  if ListView1.SelCount = 1 then
    Button2.Default := false
  else
    Button2.Default := true;
end;

function TForm1.splitstring(str: string): TStringArray;
var
  i, j: integer;
begin
  j := 0;
  for i := 1 to Length(str) do
    if str[i] <> ';' then
    begin
      SetLength(Result, j + 1);
      Result[j] := Result[j] + str[i];
    end
    else
      inc(j);
end;

function TForm1.LoadTextFromFile(const FileName: string): string;
var
  Stream: TFileStream;
begin
  Stream := TFileStream.Create(FileName, fmOpenRead);
  try
    SetLength(Result, Stream.Size);
    Stream.Position := 0;
    Stream.ReadBuffer(Pointer(Result)^, Stream.Size);
  finally
    Stream.Free;
  end;
end;

function TForm1.SaveTextToFile(const FileName: string; str: string): string;
var
  Stream: TFileStream;
begin
  Result := 'No';
  Stream := TFileStream.Create(FileName, fmCreate);
  try
    Stream.WriteBuffer(Pointer(str)^, Length(str));
    Result := 'Yes';
  finally
    Stream.Free;
  end;
end;

function TForm1.HasText(FileName: string; SearchStr: string;
  CaseSensitive: boolean): string;
var
  txt: string;
begin
  Result := 'No';
  try
    txt := LoadTextFromFile(FileName);
    if CaseSensitive then
      if AnsiContainsStr(txt, SearchStr) then
      begin
        Result := 'Yes';
        inc(foundcount);
      end;
    if not CaseSensitive then
      if AnsiContainsText(txt, SearchStr)
        then
      begin
        Result := 'Yes';
        inc(foundcount);
      end;
  except
    Result := 'Denied';
  end;
end;

function TForm1.ReplaceText(FileName: string; SearchStr, ReplaceStr: string;
  CaseSensitive: boolean): string;
var
  txt, old: string;
  FA: integer;
begin
  Result := 'No';
  try
    FA := FileGetAttr(FileName);
    if (FileGetAttr(FileName) and faReadOnly > 0) or (FileGetAttr(FileName)
      and faHidden > 0) then
      if CheckBox4.Checked then
      begin
        FileSetAttr(FileName, FileGetAttr(FileName) and not faReadOnly);
        FileSetAttr(FileName, FileGetAttr(FileName) and not faHidden);
      end;
    if (FileGetAttr(FileName) and faReadOnly > 0) or (FileGetAttr(FileName)
      and faHidden > 0) then
    begin
      Result := 'Denied';
      exit;
    end;
    old := LoadTextFromFile(FileName);
    txt := old;
    if AnsiContainsText(txt, SearchStr) then
    begin
      if CaseSensitive then
        txt := StringReplace(txt, SearchStr, ReplaceStr, [rfReplaceAll])
      else
        txt := StringReplace(txt, SearchStr, ReplaceStr, [rfReplaceAll,
          rfIgnoreCase]);
      if old <> txt then
      begin
        Result := SaveTextToFile(FileName, txt);
        inc(replacedcount);
      end;
    end;
    FileSetAttr(FileName, FA);
  except
    Result := 'Denied';
  end;
end;

procedure TForm1.MemoKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = ^A then
  begin
    (Sender as TMemo).SelectAll;
    Key := #0;
  end;
end;

end.

