clc;
clear;
load('eurusd10k_c');
data(:,2)=data(:,1);
[num_rows num_cols]=size(data);%assume no spread for simplicity
f=algo_forecaster;
signal=0;
portfolio=[0,100000,0,100000];  % time in sequence number, cash in dollars , position in number of contracts , net value in dollars
         tic                     % start from time 0 
for time=1:150000
    
    [tp1,tp2,tp3,tp4]=update_portfolio(portfolio(end,:),data(time,:));   
    
    portfolio=[ portfolio ; [tp1,tp2,tp3,tp4]];
    todays_portfolio = portfolio(end,:);
    %disp(['-----start of the day portfolio: ',num2str(todays_portfolio(end,1)),'    ',num2str(todays_portfolio(end,2)),'    ',num2str(todays_portfolio(end,3)),'    ','    ',num2str(todays_portfolio(end,4))]);

    f.read_data(time,data(time,:));
    signal=f.signal;
    
    if(signal==0)
        % do nothing 
        %disp('signal is 0, we do nothing!');
    elseif (signal>0)
        if(todays_portfolio(3)>0)
            %do nothing, as we keep holding the positive position 
           % disp(['signal is: ',num2str(signal),' positive portfolio, keep holding the positive position ']);
        else  %we are holding negative or zero positions    
            %in the case our portfolio is negative, we immediately buy back
            %the borrowed products and return them to our lender. Then use all our cash to
            %buy product
            %disp(['signal is: ',num2str(signal),' nonpositive portfolio, turn our position to positive ']);
            todays_portfolio(2)=todays_portfolio(2) + todays_portfolio(3)*data(time,1); %use cash to buy back product for the lender 
            
            if(todays_portfolio(2)<0)
             %   disp(['Error: negative cash due to extreme wrong prediction!']);
            else
            todays_portfolio(3)=todays_portfolio(2)/data(time,1); %use all cash left to buy product 
            
            todays_portfolio(2)=0;
            end
        end
    else % signal<0
        if(todays_portfolio(3)>=0)
            %disp(['signal is: ',num2str(signal),' nonnegative portfolio, turn our position to negative ']);
            %in the case our portfolio is positive, we immediately sell all
            %our product and short sell a certain amout 
            todays_portfolio(2)=todays_portfolio(2)+todays_portfolio(3)*data(time,2);% we get cash from selling our entire positions
            todays_portfolio(3)=-todays_portfolio(2)/data(time,2); %we borrow the product worthing the same amount as our current cash value
            todays_portfolio(2)=2*todays_portfolio(2);%we sell the borrowed product immediately and thus our cash doubled
        else
             %do nothing as we keep holding the negative position 
             %disp(['signal is: ',num2str(signal),' negative portfolio, keep holding the negative position ']);
        end
     
    end
    %disp(['-----end of the day portfolio:   ',num2str(todays_portfolio(end,1)),'    ',num2str(todays_portfolio(end,2)),'    ',num2str(todays_portfolio(end,3)),'    ','    ',num2str(todays_portfolio(end,4)),]);
    portfolio(end,:)=todays_portfolio;
    %fprintf('\n');
    
end
toc
plot(portfolio(:,4));