void() button_wait; // many entites will use this later
void() InitTrigger; // init function for triggers/trigger-like entities
void() SetMovedir;
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
 precache_model ("progs/lavaball.mdl");
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
 precache_sound ("player/land.wav"); // landing
 precache_sound ("player/land2.wav");
 precache_sound ("player/h2ojump.wav"); // water jump
 precache_sound ("player/plyrjmp8.wav"); // player jump
 precache_sound ("buttons/airbut1.wav"); // buttons
 precache_sound ("buttons/switch21.wav");
 precache_sound ("buttons/switch02.wav");
 precache_sound ("buttons/switch04.wav");
 precache_sound ("misc/talk.wav"); // talk
 precache_sound ("player/tornoff2.wav"); // disconnect sound
 precache_sound ("misc/r_tele1.wav"); // teleport
 precache_sound ("misc/r_tele2.wav");
 precache_sound ("misc/r_tele3.wav");
 precache_sound ("misc/r_tele4.wav");
 precache_sound ("misc/r_tele5.wav");
 precache_sound ("items/armor1.wav"); // armor pickup
};
void() InitTrigger =
{
        if (self.angles != '0 0 0')
                SetMovedir ();
        self.solid = SOLID_TRIGGER;
        setmodel (self, self.model); // set size and link into world
        self.movetype = MOVETYPE_NONE;
        self.modelindex = 0;
        self.model = "";
};

void() SetMovedir =
{
        if (self.angles == '0 -1 0')
                self.movedir = '0 0 1';
        else if (self.angles == '0 -2 0')
                self.movedir = '0 0 -1';
        else
        {
                makevectors (self.angles);
                self.movedir = v_forward;
        }
        self.angles = '0 0 0';
};
