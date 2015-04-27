function  [p1,p2,p3,p4]  = update_portfolio( yesterdays_portfolio,todays_tick)

%update portfolio only due to price change
p1=yesterdays_portfolio(1)+1; % time + 1
p2=yesterdays_portfolio(2);   % cash value does not change
p3=yesterdays_portfolio(3);   % position does not change 

if(p3<=0)
    p4=p2+p3*todays_tick(1); %if position is negative or zero
else
    p4=p2+p3*todays_tick(2); %if position is positive
end



end

