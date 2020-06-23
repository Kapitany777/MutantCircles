unit circle;

interface

uses Windows, Graphics, ExtCtrls, SysUtils, Vector;

type

  TCircle = class

    private
      _x : integer;
      _y : integer;

      procedure SetX(const Value: integer);
      procedure SetY(const Value: integer);

    public
      r : integer;

      image      : TBitmap;
      background : TColor;
      color      : TColor;
      width      : byte;

      property ox : integer read _x write SetX;
      property oy : integer read _y write SetY;

      constructor Create;

      procedure Clear;
      procedure Render;

      procedure MulRadius(a : double);

      function CenterDistance(c : TCircle) : double;
      function Collision(c : TCircle) : boolean;
  end;

  TRope = (rpNone, rpShort, rpLong);

  TPlayer = class(TCircle)

    private
      v : TVector;

    public
      rope : TRope;

      constructor Create;
      destructor Free;

      procedure Clear;
      procedure Render;
      procedure Move(p_mx,p_my : integer);
  end;

  TObstacle = class(TCircle)

    private
      minr : integer;
      maxr : integer;
      plr  : integer;

      _pulse : boolean;
      _speedx: integer;
      _speedy: integer;

    public
      property speedx : integer read _speedx write _speedx;
      property speedy : integer read _speedy write _speedy;

      property pulse : boolean read _pulse write _pulse;

      constructor Create;

      procedure Move;
  end;

  TSurprise = class(TCircle)

    private
      c   : integer;
      plc : integer;

    public
      active : boolean;

      constructor Create;
      
      procedure Clear;
      procedure Render;
  end;

implementation

{ TCircle }

procedure TCircle.Clear;
begin
  image.Canvas.Pen.Color:=background;
  image.Canvas.Pen.Width:=width;
  image.Canvas.Ellipse(ox-r,oy-r,ox+r,oy+r);
end;

function TCircle.Collision(c: TCircle): boolean;
begin
  Result:=self.CenterDistance(c)<=(self.r + c.r);
end;

constructor TCircle.Create;
begin
  image:=nil;

  color:=RGB(255,255,255);
  background:=RGB(0,0,0);
  width:=5;

  ox:=0;
  oy:=0;
  r:=0;
end;

procedure TCircle.MulRadius(a: double);

begin
  r:=trunc(a * r);
end;

function TCircle.CenterDistance(c: TCircle): double;
begin
  Result:=sqrt(sqr(self.ox - c.ox) + sqr(self.oy - c.oy));
end;

procedure TCircle.Render;
begin
  image.Canvas.Pen.Color:=color;
  image.Canvas.Pen.Width:=width;
  image.Canvas.Ellipse(ox-r,oy-r,ox+r,oy+r);
end;

procedure TCircle.SetX(const Value: integer);
begin
  _x:=Value;
end;

procedure TCircle.SetY(const Value: integer);
begin
  _y:=Value;
end;

{ TObstacle }

constructor TObstacle.Create;
begin
  inherited;

  speedx:=0;
  speedy:=0;

  minr:=Random(20);
  maxr:=minr + 20 + Random(20);
  if (minr = maxr) then plr:=0
                   else plr:=1;

  pulse:=false;
end;

procedure TObstacle.Move;
begin
  if pulse then

    begin
      r:=r + plr;

      if (r<=minr) or (r>=maxr) then plr:=-plr;
    end;

  ox:=ox + speedx;

  if (ox<r) or (ox>image.Width-r-speedx) then speedx:=-speedx;

  oy:=oy + speedy;

  if (oy<r) or (oy>image.Height-r-speedy) then speedy:=-speedy;
end;


{ TPlayer }

constructor TPlayer.Create;
begin
  inherited;

  rope:=rpNone;

  v:=TVector.Create;
end;

destructor TPlayer.Free;
begin
  v.Free;
end;

procedure TPlayer.Clear;

  var vt : TVector;

begin
  inherited;

  if (rope = rpShort) then

    begin
      image.Canvas.Pen.Width:=self.width;

      vt:=TVector.Create(v);
      vt.Normalize;
      vt.Mul(32);
      image.Canvas.MoveTo(ox,oy);
      image.Canvas.LineTo(trunc(ox + vt.vx),trunc(oy + vt.vy));
      vt.Free;
    end

  else
  if (rope = rpLong) then

    begin
      image.Canvas.Pen.Width:=self.width;
      image.Canvas.MoveTo(ox,oy);
      image.Canvas.LineTo(trunc(ox + v.vx),trunc(oy + v.vy));
    end;
end;

procedure TPlayer.Move(p_mx,p_my : integer);

  var vxt : integer;
      vyt : integer;
      xt  : integer;
      yt  : integer;

begin
  vxt:=(p_mx - ox);
  vyt:=(p_my - oy);

  xt:=ox + round(v.vx/16);
  yt:=oy + round(v.vy/16);

  if (xt>r) and (xt<image.Width-r) then

    begin
      ox:=xt;
    end;

  if (yt>r) and (yt<image.Height-r) then

    begin
      oy:=yt;
    end;

  v.vx:=vxt;
  v.vy:=vyt;
end;

procedure TPlayer.Render;

  var maxlength : double;
      vt        : TVector;

begin
  inherited;

  if (rope = rpShort) then

    begin
      image.Canvas.Pen.Width:=self.width;

      vt:=TVector.Create(v);
      vt.Normalize;
      vt.Mul(32);
      image.Canvas.MoveTo(ox,oy);
      image.Canvas.LineTo(trunc(ox + vt.vx),trunc(oy + vt.vy));
      vt.Free;
    end

  else
  if (rope = rpLong) then

    begin
      maxlength:=sqrt(sqr(image.Width) + sqr(image.Height));
      image.Canvas.Pen.Width:=round(width * (1-(v.Magnitude/maxlength)));

      image.Canvas.MoveTo(ox,oy);
      image.Canvas.LineTo(trunc(ox + v.vx),trunc(oy + v.vy));
    end;
end;


{ TSurprise }

constructor TSurprise.Create;
begin
  inherited;

  c:=20;
  plc:=5;

  active:=false;
end;

procedure TSurprise.Clear;
begin
  inherited;
end;

procedure TSurprise.Render;
begin
  c:=c + plc;

  if (c+plc<20) or (c+plc>250) then plc:=-plc;

  color:=RGB(c,c,c);

  inherited;
end;

end.
