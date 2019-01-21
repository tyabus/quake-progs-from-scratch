void(string soundfile, float volume) doambient;

void() ambient_suck_wind = {doambient("ambience/suck1.wav", 1);};
void() ambient_flouro_buzz = {doambient("ambience/buzz1.wav", 1);};
void() ambient_drip = {doambient("ambience/drip1.wav", 1);};
void() ambient_comp_hum = {doambient("ambience/comp1.wav", 1);};
void() ambient_drone = {doambient("ambience/drone6.wav", 0.5);};
void() ambient_thunder = {doambient("ambience/thunder1.wav", 0.5);};
void() ambient_light_buzz = {doambient("ambience/fl_hum1.wav", 0.5);};
void() ambient_swamp1 = {doambient("ambience/swamp1.wav", 0.5);};
void() ambient_swamp2 = {doambient("ambience/swamp2.wav", 0.5);};

void(string soundfile, float volume) doambient =
{
 precache_sound (soundfile);
 ambientsound (self.origin, soundfile, volume, ATTN_STATIC);
};
