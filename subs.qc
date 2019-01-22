void() DelayThink =
{
        activator = self.enemy;
        SUB_UseTargets ();
        remove(self);
};

void() SUB_UseTargets =
{
	local entity t, stemp, otemp, act;

        if (self.delay)
	{
	// create a temp object to fire at a later time
		t = spawn();
		t.classname = "DelayedUse";
		t.nextthink = time + self.delay;
		t.think = DelayThink;
		t.enemy = activator;
		t.message = self.message;
		t.killtarget = self.killtarget;
		t.target = self.target;
		return;
	}

        if (activator.classname == "player" && self.message != "")
	{
		centerprint (activator, self.message);
		if (!self.noise)
			sound (activator, CHAN_VOICE, "misc/talk.wav", 1, ATTN_NORM);
	}
        if (self.killtarget)
	{
		t = world;
		do
		{
			t = find (t, targetname, self.killtarget);
			if (!t)
				return;
			remove (t);
		} while ( 1 );
	}
};
















void(vector tdest, float tspeed, void() func) SUB_CalcMove =
{ 
        local vector vdestdelta;
        local float len, traveltime;
        if (!tspeed)
                objerror("No speed is defined!");
        self.think1 = func;
        self.finaldest = tdest;
        self.think = SUB_CalcMoveDone;
        if (tdest == self.origin)
        {
                self.velocity = '0 0 0';
                self.nextthink = self.ltime + 0.1;
                return;
        }
        vdestdelta = tdest - self.origin; // calculate length of vector
        len = vlen (vdestdelta); // divide by speed to get time to reach dest
        traveltime = len / tspeed;

        if (traveltime < 0.1)
        {
                self.velocity = '0 0 0';
                self.nextthink = self.ltime + 0.1;
                return;
        }
        // set nextthink to trigger a think when dest is reached
        self.nextthink = self.ltime + traveltime;
        // scale the destdelta vector by the time spent traveling to get velocity
        self.velocity = vdestdelta * (1/traveltime);    // qcc won't take vec/float
};

void() SUB_CalcMoveDone =
{
        setorigin(self, self.finaldest);
        self.velocity = '0 0 0';
        self.nextthink = -1;
        if (self.think1)
                self.think1();
};
