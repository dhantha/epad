function demo2
%DEMO2 User Interaction

% Copyright 2014 The MathWorks, Inc.

%% Start a new Game
G = SpriteKit.Game.instance('Title','Interactive Demo','Size',[600 320]);
bkg = SpriteKit.Background('demo/img/worldtopo.png');
bkg.Scale = 1.8;
addBorders(G);


%% Setup the Sprite
s = SpriteKit.Sprite('ship');
% s.initState('ship','space.png',true);
% s.initState('explosion','explosion.png',true);
s.initState('spring','img/space.png',true);
s.initState('summer','img/space.png',true);
s.initState('autumn','img/space.png',true);
s.initState('winter','img/space.png',true);

s.Scale = 0.4;
s.State = 'spring';

mole = SpriteKit.Sprite('mole');
mole.initState('meteorite','meteorite.png',true);
mole.initState('explosion','explosion.png',true);
mole.State = 'meteorite';
mole.Location = [100 100];


%% Add pertinent properties to the Sprite handle
addprop(s,'accel');
s.accel = [0 0];

%% Setup a KeyPressFcn and play!
G.onKeyPress = @keypressfcn;
G.play(@action)

%% Function to be called on each tic/toc of gameplay
    function action
        
        % decay to [0 0] accel
        s.accel = s.accel*0.97; % lose %3 of its acceleration
        L = s.Location;
        L = L + s.accel;
        s.Location = L;
        
        mole.Angle = mole.Angle-1;
        
        bkg.scroll('right',1);
        
        [collide,target] = SpriteKit.Physics.hasCollision(s);
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
                case 'mole'
                    newLoc(1) = randi([25 G.Size(1)-25]);
                    newLoc(2) = randi([25 G.Size(2)-25]);
                    mole.Location = newLoc;
            end
        end
    end

%% Functions for user interactions
    function keypressfcn(~,e)
        mag = 10;
        switch e.Key
            case 'uparrow'
                s.accel = s.accel + [0 mag];
            case 'downarrow'
                s.accel = s.accel - [0 mag];
            case 'leftarrow'
                s.accel = s.accel - [mag 0];
            case 'rightarrow'
                s.accel = s.accel + [mag 0];
            case 'a'
                s.State = 'spring';
            case 's'
                s.State = 'summer';
            case 'd'
                s.State = 'autumn';
            case 'f'
                s.State = 'winter';
        end
    end

end