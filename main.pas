unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, ToolWin, Circle, Game, IniFiles, StdCtrls,
  MPlayer;

type

  TFormMain = class(TForm)
    ImageMain: TImage;
    TimerMain: TTimer;
    TimerClock: TTimer;
    PanelGameOver: TPanel;
    PanelStart: TPanel;
    PanelExit: TPanel;
    PanelTitle: TPanel;
    ImageInfo: TImage;
    MediaPlayerMusic: TMediaPlayer;
    TimerMusic: TTimer;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ImageMainMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure TimerMainTimer(Sender: TObject);
    procedure ImageMainMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormDblClick(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TimerClockTimer(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure PanelStartClick(Sender: TObject);
    procedure PanelExitClick(Sender: TObject);
    procedure PanelGameOverDblClick(Sender: TObject);
    procedure TimerMusicTimer(Sender: TObject);
  private
    { Private declarations }
    game : TGame;

    tmpbitmapgame : TBitmap;
    tmpbitmapinfo : TBitmap;

    xd : integer;
    yd : integer;

    timemin       : integer;
    timesec       : integer;
    timetsec      : integer;
    timetsectotal : integer;

    teleport  : boolean;
    collision : boolean;
    music     : boolean;

    surprise  : boolean;

    pulse : boolean;

    collected : integer;

    score          : integer;
    timescore      : integer;
    collectedscore : integer;

    removeobstaclemod : integer;
    addobstacletime   : integer;
    addobstacleflag   : boolean;

    gameover : boolean;

    procedure RenderGameInfo;
    procedure StartGame;
    procedure RestartGame;
  public
    { Public declarations }
  end;

var
  FormMain: TFormMain;

implementation

{$R *.dfm}

procedure TFormMain.FormClose(Sender: TObject; var Action: TCloseAction);

begin
  tmpbitmapgame.Free;
  tmpbitmapinfo.Free;
  game.Free;
end;

procedure TFormMain.StartGame;

  var ini   : TIniFile;
      rad   : byte;
      rope  : TRope;
      obsn  : byte;
      a     : integer;

begin
  with tmpBitmapGame do

    begin
      Canvas.Pen.Color:=RGB(0,0,0);
      Canvas.Brush.Color:=RGB(0,0,0);

      Canvas.Rectangle(0,0,Width,Height);
    end;

  with ImageMain.Canvas do

    begin
      Pen.Color:=RGB(0,0,0);
      Brush.Color:=RGB(0,0,0);

      Rectangle(0,0,ImageMain.Width,ImageMain.Height);
    end;

  ini:=TIniFile.Create('./circles.ini');

  try
    a:=ini.ReadInteger('GameSettings','TimerInterval',20);
    TimerMain.Interval:=a;

    teleport:=ini.ReadBool('GameSettings','Teleport',true);
    collision:=ini.ReadBool('GameSettings','Collision',true);
    music:=ini.ReadBool('GameSettings','Music',true);
    surprise:=ini.ReadBool('GameSettings','Surprise',true);
    timescore:=ini.ReadInteger('GameSettings','TimeScore',1);
    collectedscore:=ini.ReadInteger('GameSettings','CollectedScore',100);
    removeobstaclemod:=ini.ReadInteger('GameSettings','RemoveObstacleMod',0);
    addobstacletime:=ini.ReadInteger('GameSettings','AddObstacleTime',0);

    rad:=ini.ReadInteger('PlayerSettings','Radius',10);
    if (rad<10) or (rad>50) then rad:=10;

    a:=ini.ReadInteger('PlayerSettings','Rope',0);
    rope:=TRope(a);
    obsn:=ini.ReadInteger('ObstacleSettings','ObstacleNum',0);
    pulse:=ini.ReadBool('ObstacleSettings','Pulse',true);
    game:=TGame.Create(tmpbitmapgame,rad,rope,obsn,pulse);

  except
    game:=TGame.Create(tmpbitmapgame,15,rpNone,0,true);
  end;

  ini.Free;

  xd:=ImageMain.Width - 50;
  yd:=ImageMain.Height - 50;

  collected:=0;
  score:=0;

  timemin:=0;
  timesec:=0;
  timetsec:=0;
  timetsectotal:=0;
  addobstacleflag:=false;
end;

procedure TFormMain.FormCreate(Sender: TObject);

  var ini : TIniFile;

begin
  Randomize;

  DoubleBuffered:=true;

  // A jatek imagenek beallitasai
  ImageMain.Width:=700;
  ImageMain.Height:=600;
  ImageMain.Left:=(Screen.Width - ImageMain.Width) div 2;
  ImageMain.Top:=(Screen.Height - ImageMain.Height) div 2;

  // A jatekhoz szukseges ideiglenes bitmap
  tmpBitmapGame:=TBitmap.Create;

  tmpBitmapGame.Width:=ImageMain.Width;
  tmpBitmapGame.Height:=ImageMain.Height;

  // A jatek cimet tartalmazo panel
  PanelTitle.Left:=(Screen.Width - PanelTitle.Width) div 2;
  PanelTitle.Top:=(Screen.Height - PanelTitle.Height) div 3;
  PanelTitle.Show;

  // A Game over feliratot tartalmazo panel
  PanelGameOver.Left:=(Screen.Width - PanelGameOver.Width) div 2;
  PanelGameOver.Top:=(Screen.Height - PanelGameOver.Height) div 2;

  // A Start game panel
  PanelStart.Left:=ImageMain.Left + ImageMain.Width + 20;
  PanelStart.Top:=ImageMain.Top + ImageMain.Height + 20;

  // Az Exit game panel
  PanelExit.Left:=ImageMain.Left - PanelExit.Width - 20;
  PanelExit.Top:=ImageMain.Top + ImageMain.Height + 20;

  // Az informaciokat tartalmazo image
  ImageInfo.Left:=0;
  ImageInfo.Top:=(ImageMain.Top div 2) - 10;
  ImageInfo.Width:=Screen.Width;
  ImageInfo.Height:=40;

  // Az informaciok megjelenitesehez szukseges ideiglenes bitmap
  tmpBitmapInfo:=TBitmap.Create;

  tmpBitmapInfo.Width:=ImageInfo.Width;
  tmpBitmapInfo.Height:=ImageInfo.Height;

  // Zene elinditasa

  ini:=TIniFile.Create('./circles.ini');
  music:=ini.ReadBool('GameSettings','Music',true);
  ini.Free;  

  if music then

    begin
      MediaPlayerMusic.FileName:=GetCurrentDir + '/mutantcircles01.mp3';

      try
        if FileExists(GetCurrentDir + '/mutantcircles01.mp3') then

          begin
            MediaPlayerMusic.Open;
            MediaPlayerMusic.Play;

            TimerMusic.Enabled:=true;
          end;
          
      except
        music:=false;
      end;
    end;

  StartGame;
end;

procedure TFormMain.FormDblClick(Sender: TObject);
begin
  RestartGame;
end;

procedure TFormMain.FormKeyPress(Sender: TObject; var Key: Char);
begin
  // Boss key kezelese
  if (Key = chr(VK_ESCAPE)) then

    begin
      TimerMain.Enabled:=false;
      TimerClock.Enabled:=false;
      TimerMusic.Enabled:=false;

      Top:=Screen.Height + 10;
    end;
end;

procedure TFormMain.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  // Pause funkcio
  if (Button in [mbRight]) then

    begin
      if not gameover then

        begin
          PanelTitle.Hide;

          TimerMain.Enabled:=not TimerMain.Enabled;
          TimerClock.Enabled:=not TimerClock.Enabled;
          TimerMusic.Enabled:=not TimerMusic.Enabled;
        end;
    end;
end;

procedure TFormMain.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  xd:=x - ImageMain.Left;
  yd:=y - ImageMain.Top;
end;

procedure TFormMain.ImageMainMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if (Button in [mbLeft]) then

    begin
      // Jatekos teleportalasa
      if teleport and not gameover then game.TeleportPlayer(x,y);
    end

  else
  if (Button in [mbRight]) then

    begin
      // Pause funkcio
      if not gameover then

        begin
          PanelTitle.Hide;

          TimerMain.Enabled:=not TimerMain.Enabled;
          TimerClock.Enabled:=not TimerClock.Enabled;
          TimerMusic.Enabled:=not TimerMusic.Enabled;
        end;
    end;
end;

procedure TFormMain.ImageMainMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  xd:=x;
  yd:=y;
end;

procedure TFormMain.PanelExitClick(Sender: TObject);
begin
  Close;
end;

procedure TFormMain.PanelGameOverDblClick(Sender: TObject);
begin
  RestartGame;
end;

procedure TFormMain.PanelStartClick(Sender: TObject);
begin
  RestartGame;
end;

procedure TFormMain.RenderGameInfo;

  var xk,yk : integer;
      s1    : string;
      s2    : string;

begin
  with FormMain.Canvas do

    begin
      // Keret kirajzolasa
      Pen.Color:=RGB(255,255,255);
      Brush.Color:=RGB(0,0,0);

      MoveTo(ImageMain.Left - 1,ImageMain.Top - 1);
      LineTo(ImageMain.Left + ImageMain.Width + 1,ImageMain.Top-1);
      LineTo(ImageMain.Left + ImageMain.Width + 1,ImageMain.Top + ImageMain.Height + 1);
      LineTo(ImageMain.Left - 1,ImageMain.Top + ImageMain.Height + 1);
      LineTo(ImageMain.Left - 1,ImageMain.Top - 1);
    end;

  with tmpBitmapInfo.Canvas do

    begin
      // Adatok kiirasa
      xk:=(Screen.Width - 710) div 2;
      yk:=0;

      Pen.Color:=FormMain.Color;
      Brush.Color:=FormMain.Color;
      Rectangle(0,0,tmpBitmapInfo.Width,tmpBitmapInfo.Height);

      Font.Name:='Terminal';
      Font.Size:=20;
      Font.Color:=clLime;
      Font.Style:=FormMain.Canvas.Font.Style + [fsBold];

      // Eltelt ido kiirasa
      s1:=IntToStr(timemin);
      if (Length(s1) = 1) then s1:='0' + s1;
      s2:=IntToStr(timesec);
      if (Length(s2) = 1) then s2:='0' + s2;
      TextOut(xk,yk,'Time : ' +
      s1 + ' : ' + s2 + ' : ' + IntToStr(timetsec) + '   ');

      // Osszegyujtott bogyok szamanak kiirasa
      TextOut(xk+300,yk,'Collected : ' + IntToStr(collected));

      // Elert pontszam kiirasa
      TextOut(xk+600,yk,'Score : ' + IntToStr(score));
    end;

  ImageInfo.Canvas.Draw(0,0,tmpBitmapInfo);  
end;

procedure TFormMain.RestartGame;
begin
  PanelTitle.Hide;
  PanelGameOver.Hide;

  TimerMain.Enabled:=false;
  TimerClock.Enabled:=false;

  if (Assigned(game)) then game.Free;

  gameover:=false;

  StartGame;

  TimerMain.Enabled:=true;
  TimerClock.Enabled:=true;
end;

procedure TFormMain.TimerClockTimer(Sender: TObject);

begin
  score:=score + timescore;

  timetsec:=timetsec + 1;

  timetsectotal:=timetsectotal + 1;
  addobstacleflag:=false;

  if (timetsec = 10) then

    begin
      timesec:=timesec + 1;

      if (timesec = 60) then

        begin
          timemin:=timemin + 1;
          timesec:=0;
       end;

      timetsec:=0;
    end;
end;

procedure TFormMain.TimerMainTimer(Sender: TObject);

begin
  // Bogyok megjelenitese
  if surprise then game.RenderSurprise;

  // Jatekos mozgatasa
  game.MovePlayer(xd,yd);

  // Korok mozgatasa
  game.MoveObstacles;

  // Ha osszeszedte a bogyot
  if game.SurpriseCollide then

    begin
      game.ProcessSurprise;

      collected:=collected + 1;
      score:=score + collectedscore;

      game.SetSurprise;

      // Ha elegendo bogyot szedett ossze, akkor elveszunk egy akadalyt
      if (RemoveObstacleMod>0) then

        begin
          if ((collected mod RemoveObstacleMod) = 0) then

            begin
              game.RemoveObstacle;
            end;
        end;
    end

  // Ha eltelt annyi ido, hogy uj kort kell kirajzolni
  else
  if (AddObstacleTime>0) then

    begin
      if (timetsectotal>8) and
         ((timetsectotal mod AddObstacleTime) = 0) and
          not addobstacleflag then

        begin
          game.AddObstacle(pulse);

          addobstacleflag:=true;          
        end;
    end;

  // Igy kell, kozvetlenul egymas utan kirajzolni, kulonben beszaggat a megjelenites  
  // Kirajzoljuk a jatekmezot
  ImageMain.Canvas.Draw(0,0,tmpbitmapgame);
  // Game informaciok kiirasa
  RenderGameInfo;

  if game.ObstacleCollide then

    begin
      if collision then

        begin
          TimerMain.Enabled:=false;
          TimerClock.Enabled:=false;

          gameover:=true;

          PanelGameOver.Show;
        end;
    end;
end;

procedure TFormMain.TimerMusicTimer(Sender: TObject);
begin
  if music and (MediaPlayerMusic.Mode = mpStopped) then MediaPlayerMusic.Play;
end;

end.
