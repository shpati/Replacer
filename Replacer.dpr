program Replacer;

uses
  Forms,
  SR in 'SR.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Replacer';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
