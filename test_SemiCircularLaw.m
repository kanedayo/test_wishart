clf;% hold on;
N=1000;
bw=0.1;
cirR = exp(2j*pi*[1:100]/100); % Radius

for L=[ 1e1 1e2 1e3 ]
  iter=ceil(N/L);
  Y=zeros(L,iter);

  for n=1:iter
    %平均値0分散1の正規分布に従うNxN行列
    %行列サイズに依存しない様にsqrt(L)で(正規化固有値)
    %H=randn(L)/sqrt(L);
    H=(randn(L)+1j*randn(L))/sqrt( 2 * L );

    %H=H/sqrt(L);
    R=( H + H')/2; % symmetrise
    Y(:,n)=eig(R);
  end

  range=[-2 +2];
  x=-2:bw:2;
  yr=real(Y(:));
  yi=imag(Y(:));

  subplot(3,3,[1 2]);bar ( x, hist(yr,x) ); % real
  xlabel (sprintf('L,Iter=%d,%d',L,iter))
  xlim(range); grid on
  subplot(3,3,[6 9]);barh( x, hist(yi,x) ); % imag
  xlabel (sprintf('L,Iter=%d,%d',L,iter))
  ylim(range); grid on

  subplot(3,3,[4 8]);
  plot( yr,yi, '.' ); hold on
  plot( cirR , '.' ); hold off

  xlim(range)
  ylim(range)
  grid on

  pause(1)

end
