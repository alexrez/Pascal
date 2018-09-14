program Final1Integral;
{номер студентческого 09}
{С заданной точностью ε=0.001 вычислить площадь плоской фигуры, ограниченной тремя кривыми}
{f1=3/(sqr(x−1)+1); f2=sqrt(x+0.5); f3 = exp(−x)}
{метод деления отрезка пополам; формула прямоугольников; eps=0.001}

const eps1=0.0001; eps2=0.0002;
    a=-0.5; b=2.0; {отрезок, на котором ищутся корни F(x)=0, F(x)=f(x)-g(x)}
    n0=10;

type Ftype=function(x:real):real;

var x1, x2, x3, S, S1, eps: real;

{заданные функции}
{$F+}
function f1(x:real):real;
    begin f1:=3/(sqr(x-1)+1) end;
function f2(x:real):real;
    begin f2:=sqrt(x+0.5) end;
function f3(x:real):real;
    begin f3:=exp(-x) end;

{для вычисления площади фигуры}
function f4(x:real):real;
    begin f4:=f1(x)-f3(x) end;
function f5(x:real):real;
    begin f5:=f1(x)-f2(x) end;

{вычисление интеграла функции}
function integral(f:Ftype; a, b, eps2:real):real;
var temp, I1n, I2n: real; n: integer;
    {подфункция вычисления интеграла при заданном n}
    function Int(f:Ftype; a,b:real; n:integer):real;
    var i:integer; h, Fi:real;
    begin
        h:=(b-a)/n; Fi:=0;
        for i:=0 to (n-1) do
            Fi:=f(a+(i+0.5)*h)+Fi;
        Int:=Fi*h
    end;
begin
    n:=n0;
    I1n:=Int(f,a,b,n);
    repeat {увеличение числа прямоугольников}
        n:=2*n;
        I2n:=Int(f,a,b,n);
        temp:=(1/3)*abs(I1n-I2n);
        I1n:=I2n;
    until temp<eps2;
    integral:=I2n
end;

{нахождение абсцисс пересечения кривых}
procedure root(f,g:Ftype; a,b,eps1:real; var x:real);
var c,y,z:real;
begin
    repeat
        c:=a+(abs(b-a))/2;
        y:=f(a)-g(a);
        z:=f(c)-g(c);
        if y*z<0 then b:=c
        else a:=c
    until abs(b-a)<eps1;
    x:=a
end;

begin
    {абсциссы пересечения кривых}
    root(@f1,@f2, a,b,eps1, x1);
    root(@f2,@f3, a,b,eps1, x2);
    root(@f1,@f3, a,b,eps1, x3);

    {площадь фигуры S=S1+S2, где S1=S(f1)-S(f3) на (x3,x2); S2=S(f1)-S(f2) на (x2,x1)}
    S:=integral(@f4, x3,x2, eps2)+integral(@f5, x2,x1, eps2);
        {Проверочный расчет}
        S1:=integral(@f1, x3,x1, eps2)-(integral(@f3, x3,x2, eps2)+integral(@f2, x2,x1, eps2));
        eps:=S-S1;

    Writeln('Абсциссы пересечения кривых:');
    Writeln('f1=3/((x−1)^2+1) и f2=sqrt(x+0.5) ==> x1=',x1:0:4);
    Writeln('f2=sqrt(x+0.5) и f3=exp(−x) ==> x2=',x2:0:4);
    Writeln('f1=3/((x−1)^2+1) и f3=exp(−x) ==> x3=',x3:0:4);
    Writeln('Площадь фигуры, ограниченной заданными кривыми на отрезке [',x3:0:4,',',x1:0:4,'] равна ',S:0:4);
    Writeln('Проверка расчета площади ',s1:0:4,' eps=',eps:0:4,', заданная точность вычисления 0.001');
readln
end.