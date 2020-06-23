program Circles;

uses
  Forms,
  main in 'main.pas' {FormMain},
  circle in 'circle.pas',
  game in 'game.pas',
  vector in 'vector.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
