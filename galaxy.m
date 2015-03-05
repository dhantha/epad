function galaxy

%% galaxy arcade game using matlab and accelerometer 
G = SpriteKit.Game.instance('Title','Galaxy','Size',[800 600]);
bkg = SpriteKit.Background('galaxy.png');
bkg.Scale = 1.8;
addBorders(G);


% spaceship 
s = SpriteKit.Sprite('space_ship');
s.initState('roaming','space_ship.png',true);
s.initState('explosion','explosion.png',true);

s.Scale = 0.4;
s.State = 'roaming';

% meteorite

m = SpriteKit.Sprite('meteorite');
m.initState('on','meteorite.png',true);
m.initState('explosion','explosion.png',true);
m.Location = [100 100];
m.State = 'on';

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
        
        m.Angle = m.Angle-1;
        
        bkg.scroll('right',1);
        
        [collide,target] = SpriteKit.Physics.hasCollision(s)
        if collide
            switch target.ID                
                case 'topborder'
                    s.State = 'spring';
                    s.accel(2) = -abs(s.accel(2));
                case 'bottomborder'
                    s.State = 'autumn';
                    s.accel(2) = abs(s.accel(2));
                case 'leftborder'
                    s.State = 'winter';
                    s.accel(1) = abs(s.accel(1));
                case 'rightborder'
                    s.State = 'summer';
                    s.accel(1) = -abs(s.accel(1));
                case 'm'
                    s.State = 'explosion'
                    m.State = 'explosion'
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

