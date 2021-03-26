clf;% hold on;
bw=0.1;
bw0=bw;
NrxNtx={
  [300,1000],
  [200,1000],
  [100,1000],

  [2,2^1], % Tx-Div
  [2,2^2],
  [2,2^3],
  %[2,2^4],
  %[2,2^5],
  %[2,2^6],
  %[2,2^7],
  %[2,2^8],

  % Somthing Wrong with Rx-Div. Need Bug-Fix ??
  [2^1,2], % Rx-Div(MRC)
  [2^2,2],
  [2^3,2],
  %[2^4,2],
  %[2^5,2],
  %[2^6,2],
  %[2^7,2],
  %[2^8,2],
  }';
norm_method = 0; % [0]:sigma^2==1, [1]:sigma^2==1/L

for b=NrxNtx
  Nrx = b{1}(1);
  Ntx = b{1}(2);
  Beta = Nrx/Ntx;

  L=min(Ntx,Nrx);
  iter =min(1e4, ceil(1e6/Nrx/Ntx) );
  Y=zeros(L,iter);

  switch norm_method
    case 0
      sigma  = 1;
      sigma2 = 1; % sigma^2
    case 1
      sigma  = 1/sqrt(L);
      sigma2 = 1/L; % sigma^2
  end % switch norm_method

  bw     = sigma2*bw0;
  %range  = sigma2*[0 +3];

  for n=1:iter
    H=(randn(Nrx,Ntx)                  );           % N(0,1)
    H=(randn(Nrx,Ntx)+1j*randn(Nrx,Ntx))/sqrt( 2 ); % N(0,1)

    H=sigma*H; % N(0,sigma)

    %R=H'*H; % symmetrise
    R=H*H'; % symmetrise

    eigAll = eig(R)/Ntx;
    Y(:,n)=eigAll(end-L+1:end); % keep the Most Significant Only
  end


  %% MP-Raw
  Umin = sigma2*(1-sqrt(Beta)).^2;
  Umax = sigma2*(1+sqrt(Beta)).^2;
  u=Umin:bw:Umax; u =[ Umin u Umax ];
  Fu =sqrt((u-Umin).*(Umax-u))./u./(2*pi*sigma2*Beta);


  range  = [Umin Umax];
  x=range(1):bw:range(end);
  yr=real(Y(:));

  hold off
  bar( x, hist(yr,x)/(min(Nrx,Ntx)*bw*iter) ); % real
  hold on
  plot(u,Fu,'-*r')
  title (sprintf('Nrx,Ntx,Beta=%d,%d,%d',Nrx,Ntx,Beta))
  xlabel (sprintf('L,Iter=%d,%d',L,iter))
  xlim(range); grid on

  pause(1)

end
