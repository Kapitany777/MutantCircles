unit game;

interface

uses Windows, Graphics, ExtCtrls, SysUtils, Circle;

const MaxObstacles = 50;

type TGame = class

  private
    player    : TPlayer;
    obstacles : array[1..MaxObstacles] of TObstacle;
    
    surprise   : TSurprise;

    _obstaclenum : byte;

    procedure SetObstacleNum(const Value: byte);

  public
    image : TBitmap;

    property obstaclenum : byte read _obstaclenum write SetObstacleNum;

    constructor Create(p_image        : TBitmap;
                       p_playerradius : byte;
                       p_playerrope   : TRope;
                       p_obstaclenum  : byte;
                       p_pulse        : boolean);
    destructor Free;

    procedure AddObstacle(p_pulse : boolean);
    procedure RemoveObstacle;

    procedure TeleportPlayer(x,y : integer);
    procedure MovePlayer(x,y : integer);
    procedure MoveObstacles;

    procedure SetSurprise;
    procedure RenderSurprise;
    procedure ProcessSurprise;

    function ObstacleCollide : boolean;
    function SurpriseCollide : boolean;
end;

implementation

{ TGame }

procedure TGame.AddObstacle(p_pulse : boolean);
begin
  if (obstaclenum<MaxObstacles) then

    begin
      obstaclenum:=obstaclenum + 1;

      obstacles[obstaclenum]:=TObstacle.Create;

      with obstacles[obstaclenum] do

        begin
          image:=self.image;

          repeat
            ox:=Random(image.Width div 2) + 50;
            oy:=Random(image.Height div 2) + 50;
            r:=Random(25) + 25;
          until (player.CenterDistance(obstacles[obstaclenum])>200);

          pulse:=p_pulse;
          speedx:=Random(10) + 1;
          speedy:=Random(10) + 1;

          color:=RGB(Random(200)+50,Random(200)+50,Random(200)+50);
        end;
    end;
end;

function TGame.ObstacleCollide: boolean;

  var c : boolean;
      i : byte;

begin
  c:=false;

  for i:=1 to ObstacleNum do

    begin
      if player.Collision(obstacles[i]) then

        begin
          c:=true;
          break;
        end;
    end;

  Result:=c;
end;

procedure TGame.ProcessSurprise;
begin
  surprise.Clear;

  surprise.active:=false;
end;

constructor TGame.Create(p_image        : TBitmap;
                         p_playerradius : byte;
                         p_playerrope   : TRope;
                         p_obstaclenum  : byte;
                         p_pulse        : boolean);

  var i : byte;

begin
  image:=p_image;

  player:=TPlayer.Create;

  with player do

    begin
      image:=p_image;

      rope:=p_playerrope;

      ox:=image.Width - 50;
      oy:=image.Height - 50;
      r:=p_playerradius;

      color:=RGB(100,100,200);
    end;

  for i:=1 to p_obstaclenum do

    begin
      AddObstacle(p_pulse);
    end;

  surprise:=TSurprise.Create;

  SetSurprise;
end;

destructor TGame.Free;

  var i : byte;

begin
  player.Free;

  for i:=1 to ObstacleNum do

    obstacles[i].Free;

  surprise.Free;  
end;

procedure TGame.MoveObstacles;

  var i : byte;

begin
  for i:=1 to ObstacleNum do

    begin
      obstacles[i].Clear;
      obstacles[i].Move;
      obstacles[i].Render;
    end;
end;

procedure TGame.MovePlayer(x, y: integer);
begin
  player.Clear;
  player.Move(x,y);
  player.Render;
end;

procedure TGame.RemoveObstacle;
begin
  if (obstaclenum>2) then

    begin
      obstacles[obstaclenum].Clear;
      obstacles[obstaclenum].Free;

      obstaclenum:=obstaclenum - 1;
    end;
end;

procedure TGame.RenderSurprise;
begin
  if surprise.active then

    begin
      surprise.Render;
    end;
end;

procedure TGame.SetObstacleNum(const Value: byte);
begin
  if (Value>MaxObstacles) then _obstaclenum:=MaxObstacles
  else _obstaclenum:=Value;
end;

procedure TGame.SetSurprise;
begin
  with surprise do

    begin
      image:=self.image;

      ox:=Random(image.Width - 80) + 20;
      oy:=Random(image.Height - 80) + 20;
      r:=10;

      active:=true;
    end;
end;

function TGame.SurpriseCollide: boolean;

  var c : boolean;

begin
  if (not surprise.active) then c:=false
  else
  if (player.Collision(surprise)) then c:=true
  else c:=false;

  Result:=c;
end;

procedure TGame.TeleportPlayer(x, y: integer);

begin
  player.MulRadius(1.2);

  if (player.r>40) then player.r:=40;

  player.Clear;
  player.ox:=x;
  player.oy:=y;
end;

end.
