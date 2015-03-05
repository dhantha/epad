%% matlab interactive game 
clear all
close all
clc
%%
G = SpriteKit.Game.instance('Title','Interactive Demo','Size',[600 320]);
bkg = SpriteKit.Background('demo/img/worldtopo.png');

bkg.Scale = 1.8;
% while 1
%     bkg.scroll('right',1);
%     pause(0.1);
% end
function action
      bkg.scroll('right',1);
end