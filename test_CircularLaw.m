clf;% hold on;
N=1000;
bw=0.1;
cirR = exp(2j*pi*[1:100]/100); % Radius

%for L=[ 1e1 1e2 1e3 1e4]
%for L=[ 1e1 1e2 1e3 5e3 ]
for L=[ 1e0:1e0:1e1-1 1e1:1e1:1e2-1 1e2:1e2:4e2  ]
  NpL=ceil(N/L);
  Y=zeros(L,NpL);

  for n=1:NpL
    %平均値0分散1の正規分布に従うNxN行列
    %H=randn(L);
    H=(randn(L)+1j*randn(L))/sqrt( 2 );
    %行列サイズに依存しない様にsqrt(L)で(正規化固有値)
    Y(:,n)=eig(H)/sqrt(L);
  end

  range=[-2 +2];
  x=-2:bw:2;
  yr=real(Y(:));
  yi=imag(Y(:));

  subplot(3,3,[1 2]);bar ( x, hist(yr,x) ); % real
  xlabel (sprintf('L=%d',L))
  xlim(range); grid on
  subplot(3,3,[6 9]);barh( x, hist(yi,x) ); % imag
  xlabel (sprintf('L=%d',L))
  ylim(range); grid on

  subplot(3,3,[4 8]);
  plot( Y(:) , '.' ); hold on
  plot( cirR , '.' ); hold off

  xlim(range)
  ylim(range)
  grid on

  pause(1)

end
