void() precaches;
void() LightStyles_setup; 
void() main = {};
void() worldspawn = {precaches(); LightStyles_setup();};
void() SetNewParms = {};
void() SetChangeParms = {};
void() StartFrame = {};
void() precaches =
{
 precache_model ("progs/player.mdl");
 precache_model ("progs/s_bubble.spr");
 precache_sound ("player/drown1.wav"); // drowning pain
 precache_sound ("player/drown2.wav"); // drowning pain
 precache_sound ("player/lburn1.wav"); // slime/lava burn
 precache_sound ("player/lburn2.wav"); // slime/lava burn
 precache_sound ("player/pain1.wav");
 precache_sound ("player/pain2.wav");
 precache_sound ("player/pain3.wav");
 precache_sound ("player/pain4.wav");
 precache_sound ("player/pain5.wav");
 precache_sound ("player/pain6.wav");
 precache_sound ("player/h2odeath.wav"); // drowning death
 precache_sound ("player/death1.wav");
 precache_sound ("player/death2.wav");
 precache_sound ("player/death3.wav");
 precache_sound ("player/death4.wav");
 precache_sound ("player/death5.wav");
 precache_sound ("player/plyrjmp8.wav"); // player jump
};
