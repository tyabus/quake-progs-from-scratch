void() Chasecam_Update;
void() ClientKill = {};
void() ClientConnect;
void() ClientDisconnect;
void() PlayerPreThink;
void() PlayerPostThink;
void() PutClientInServer;

void() PlayerPreThink =
{
 CheckImpulses();
 Chasecam_Update();
 SetClientFrame ();
 WaterMove ();
 if (self.button2)
 {
 PlayerJump ();
 }
};

void() PutClientInServer =
{
local entity spawn_spot; // This holds where we want to spawn
spawn_spot = find (world, classname, "info_player_start"); // Find it 
self.classname = "player"; // I'm a player 
self.health = self.max_health = 100; // My health and my max is 100
self.takedamage = DAMAGE_AIM; // I can be fired at 
self.solid = SOLID_SLIDEBOX; // Things sort of 'slide' past me 
self.movetype = MOVETYPE_WALK; // Yes I want to walk 
self.flags = FL_CLIENT; // Yes, I'm a client 

self.th_die = PlayerDie;
self.th_pain = PlayerPain;

self.origin = spawn_spot.origin + '0 0 1'; // Move to the spawnspot location 
self.angles = spawn_spot.angles; // Face the angle the spawnspot indicates 
self.fixangle = TRUE; // Turn this way immediately 

setmodel (self, "progs/player.mdl"); // Set player model
setsize (self, VEC_HULL_MIN, VEC_HULL_MAX); // Set my size 

self.view_ofs = '0 0 22'; // Center my view
self.velocity = '0 0 0'; // Stop any old movement
};

void() ClientConnect =
{
 bprint (self.netname);
 bprint (" entered the game\n");
};

void() ClientDisconnect =
{
                bprint (self.netname);
		bprint (" left the game with ");
		bprint (ftos(self.frags));
		bprint (" frags\n");
	        sound (self, CHAN_BODY, "player/tornoff2.wav", 1, ATTN_NONE);
};

void() PlayerPostThink =
{        
        if ((self.jump_flag < -300) && (self.flags & FL_ONGROUND) && (self.health > 0))
        {
                if (self.watertype == CONTENT_WATER)
                        sound (self, CHAN_BODY, "player/h2ojump.wav", 1, ATTN_NORM);
                else if (self.jump_flag < -650)
                {
                        T_Damage (self, world, world, 5);
                        sound (self, CHAN_VOICE, "player/land2.wav", 1, ATTN_NORM);
                        self.deathtype = "falling";
                }
                else
                        sound (self, CHAN_VOICE, "player/land.wav", 1, ATTN_NORM);
                self.jump_flag = 0;
        }
        if (!(self.flags & FL_ONGROUND))
                self.jump_flag = self.velocity_z;
};
