function galaxy

%% galaxy arcade game using matlab and accelerometer 
G = SpriteKit.Game.instance('Title','Galaxy','Size',[800 400]);
bkg = SpriteKit.Background('img/galaxy.png');
bkg.Scale = 1.8;
addBorders(G);

scale_1 = 1.2;
scale_2 = 0.4;


% spaceship 
s = SpriteKit.Sprite('ship');
s.initState('roaming','img/space.png',true);
s.initState('explosion','img/explosion.png',true);
s.Scale = scale_1;
s.Location = [50 300];
s.State = 'roaming';

% meteorite sprites
a = SpriteKit.Sprite('a');
a.initState('on','img/meteorite.png',true);
a.initState('explosion','img/explosion.png',true);
a.Location = [randi([25 G.Size(1)-25]) randi([25 G.Size(2)-25])];
a.Scale = scale_1;
a.State = 'on';

b = SpriteKit.Sprite('b');
b.initState('on','img/meteorite.png',true);
b.initState('explosion','img/explosion.png',true);
b.Location = [randi([25 G.Size(1)-25]) randi([25 G.Size(2)-25])];
b.Scale = scale_1;
b.State = 'on';

c = SpriteKit.Sprite('c');
c.initState('on','img/meteorite.png',true);
c.initState('explosion','img/explosion.png',true);
c.Location = [randi([25 G.Size(1)-25]) randi([25 G.Size(2)-25])];
c.Scale = scale_1;
c.State = 'on';

d = SpriteKit.Sprite('d');
d.initState('on','img/meteorite.png',true);
d.initState('explosion','img/explosion.png',true);
d.Location = [randi([25 G.Size(1)-25]) randi([25 G.Size(2)-25])];
d.Scale = scale_1;
d.State = 'on';

e = SpriteKit.Sprite('e');
e.initState('on','img/meteorite.png',true);
e.initState('explosion','img/explosion.png',true);
e.Location = [randi([25 G.Size(1)-25]) randi([25 G.Size(2)-25])];
e.Scale = scale_1;
e.State = 'on';


addprop(s,'accel');
s.accel = [0 0];

% setup keyboard functions
G.onKeyPress = @keypressfcn;
G.play(@action);

    function action
        
        s.accel = s.accel*0.97;
        L = s.Location;
        L = L + s.accel;
        s.Location = L;
        
        a.Angle = a.Angle-1;
        b.Angle = b.Angle-1;
        c.Angle = c.Angle-1;
        d.Angle = d.Angle-1;
        e.Angle = e.Angle-1;
        
        randi([25 600-25]);
        
        %a.Location = 
        
        bkg.scroll('right',1);
        
        % move meteorites to the left
        a.Location(1) = a.Location(1)-1;
        b.Location(1) = b.Location(1)-1;
        c.Location(1) = c.Location(1)-1;
        d.Location(1) = d.Location(1)-1;
        e.Location(1) = e.Location(1)-1;
        
        if a.Location(1) < 0
            a.Location = [randi([25 G.Size(2)-35])+650 randi([G.Size(1)-100])];
            a.State = 'on';
            a.Scale = scale_1;
        elseif b.Location(1) < 0
            b.Location = [randi([25 G.Size(2)-35])+650 randi([G.Size(1)-100])];           
            b.State = 'on';
            b.Scale = scale_1;
        else
        end
        
        if c.Location(1) < 0                
            c.Location = [randi([25 G.Size(2)-35])+650 randi([G.Size(1)-100])];
            c.State = 'on';
            c.Scale = scale_1;
        elseif d.Location(1) < 0
            d.Location = [randi([25 G.Size(2)-35])+650 randi([G.Size(1)-100])];
            d.State = 'on';
            d.Scale = scale_1;
        else            
        end
        if e.Location(1) < 0
            e.Location = [randi([25 G.Size(2)-35])+650 randi([G.Size(1)-100])];
            e.State = 'on';
            e.Scale = scale_1;
        end
        
        [collide,target] = SpriteKit.Physics.hasCollision(s);
        if collide
            switch target.ID                
                case 'topborder'
                    %s.State = 'spring';
                    s.accel(2) = -abs(s.accel(2));
                case 'bottomborder'
                    %s.State = 'autumn';
                    s.accel(2) = abs(s.accel(2));
                case 'leftborder'
                    %s.State = 'winter';
                    s.accel(1) = abs(s.accel(1));
                case 'rightborder'
                    %s.State = 'summer';
                    s.accel(1) = -abs(s.accel(1));
                case 'a'
                    s.State = 'explosion';
                    s.Scale = scale_2;
                    
                    a.State = 'explosion';
                    a.Scale = scale_2;
                case 'b'
                    s.State = 'explosion';
                    s.Scale = scale_2;
                    
                    b.State = 'explosion';
                    b.Scale = scale_2;
                case 'c'
                    s.State = 'explosion';
                    s.Scale = scale_2;
                    
                    c.State = 'explosion';
                    c.Scale = scale_2;
                case 'd'
                    s.State = 'explosion';
                    s.Scale = scale_2;
                    
                    d.State = 'explosion';
                    d.Scale = scale_2;
                case 'e'
                    s.State = 'explosion';
                    s.Scale = scale_2;
                    
                    e.State = 'explosion';
                    e.Scale = scale_2;             
            end
        end        
    end

% key pressing events

    function keypressfcn(~,e)
        mag = 10;
        switch e.Key
            case 'uparrow'
                s.accel = s.accel + [0 mag];
            case 'downarrow'
                s.accel = s.accel - [0 10];
            case 'leftarrow'
                s.accel = s.accel - [10 0];
            case 'rightarrow'
                s.accel = s.accel + [10 0];
        end
    end

end

