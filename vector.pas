unit vector;

interface

type
  TVectorType = double;

  TVector = class

    public
      vx : TVectorType;
      vy : TVectorType;

      constructor Create; overload;
      constructor Create(p_x,p_y : TVectorType); overload;
      constructor Create(v : TVector); overload;

      procedure Zero;
      procedure Negative;
      procedure Add(v : TVector);
      procedure Mul(a : TVectorType);
      procedure Normalize;

      function Equal(v : TVector) : boolean;
      function Magnitude : double;
      function Distance(v : TVector) : double;
      function DotProduct(v : TVector) : TVectorType;
  end;

implementation

{ TVector }

constructor TVector.Create;
begin
  vx:=0;
  vy:=0;
end;

constructor TVector.Create(p_x, p_y: TVectorType);
begin
  vx:=p_x;
  vy:=p_y;
end;

constructor TVector.Create(v: TVector);
begin
  self.vx:=v.vx;
  self.vy:=v.vy;
end;

function TVector.Distance(v: TVector): double;
begin
  Result:=sqrt(sqr(self.vx - v.vx) + sqr(self.vy - v.vy));
end;

function TVector.DotProduct(v: TVector): TVectorType;
begin
  Result:=self.vx * v.vx + self.vy * v.vy;
end;

function TVector.Equal(v: TVector): boolean;
begin
  Result:=(self.vx = v.vx) and (self.vy = v.vy);
end;

procedure TVector.Add(v: TVector);
begin
  self.vx:=self.vx + v.vx;
  self.vy:=self.vy + v.vy;
end;

function TVector.Magnitude: double;
begin
  Result:=sqrt(sqr(vx) + sqr(vy));
end;

procedure TVector.Mul(a: TVectorType);
begin
  vx:=a * vx;
  vy:=a * vy;
end;

procedure TVector.Zero;
begin
  vx:=0;
  vy:=0;
end;

procedure TVector.Negative;
begin
  vx:=-vx;
  vy:=-vy;
end;

procedure TVector.Normalize;

  var m : double;

begin
  m:=self.Magnitude;

  if (m<>0) then

    begin
      vx:=vx / m;
      vy:=vy / m;
    end;
end;

end.
