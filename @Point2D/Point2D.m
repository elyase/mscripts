classdef Point2D
    %POINT2D simply a point
    %   Detailed explanation goes here
    
    properties
        x,y
    end
    
    methods
        function p=Point2D(x,y)
            p.x=x;
            p.y=y;
        end
        
        function disp(obj)
            disp([obj.x obj.y])
        end
        
        function s=scalar(obj1,obj2)
            s=dot([obj1.x obj1.y],[obj2.x obj2.y]);
        end
    end
    
end

