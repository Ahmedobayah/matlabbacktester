classdef algo_forecaster < handle 
    properties
        time=0;
        data_last31 = [];
        mid_price_last31=[];
        
        MA15=0
        MA30=0
        signal=0   
    end
    
    methods
        
        function obj=algo_forecaster()
        end
        
        function read_data(obj, time, new_data)
            temp_size=size(obj.data_last31);
            if(temp_size(1)<31)
                obj.data_last31=[obj.data_last31; new_data];
                obj.mid_price_last31=[obj.mid_price_last31;mean(new_data)];
            else
                obj.data_last31=[obj.data_last31(2:end,:); new_data];
                obj.mid_price_last31=[obj.mid_price_last31(2:end);mean(new_data)];
            end
            obj.time=time;
            obj.update_properties();
         
        end

        function update_properties(obj)
            
            if(obj.time<=15)
                obj.MA15=mean(obj.mid_price_last31);
            else
                obj.MA15=1/15*(15*obj.MA15+obj.data_last31(end,1)-obj.data_last31(end-15,1));
            end
                 
            if(obj.time<=30)
                obj.MA30=mean(obj.mid_price_last31);
            else
                %size(obj.data_last31)
                obj.MA30=1/30*(30*obj.MA30+obj.data_last31(end,1)-obj.data_last31(end-30,1));
            end
            obj.signal=-(obj.MA15-obj.MA30);
            %disp(['Current Time: ',num2str(obj.time),' MA5 is :',num2str(obj.MA15),' -----  MA30 is: ', num2str(obj.MA30),' signal is: ',num2str(obj.signal)]);
            
            
        end
    end
    
end
    

