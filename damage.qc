void(entity targ, entity attacker) Killed =
{
	local entity oself;
	if (targ.health < -99)
		targ.health = -99; // don't let sbar look bad if a player
	targ.takedamage = DAMAGE_NO;
	targ.touch = SUB_Null;
	oself = self;
	self = targ; // self must be targ for th_die
	self.th_die ();
	self = oself;
};

void(entity targ, entity inflictor, entity attacker, float damage) T_Damage = {
    local	vector	dir;
    local	entity	oldself;
    local       float   save;
    local       float   take;
    if (!targ.takedamage)
        return;

    damage_attacker = attacker;

    if ( (inflictor != world) && (targ.movetype == MOVETYPE_WALK) )
    {
        dir = targ.origin - (inflictor.absmin + inflictor.absmax) * 0.5;
        dir = normalize(dir);
        targ.velocity = targ.velocity + dir*damage*8;
    }
        save = ceil(targ.armortype*damage);
        if (save >= targ.armorvalue)
        {
                save = targ.armorvalue;
                targ.armortype = 0; // lost all armor
                targ.items = targ.items - (targ.items & (IT_ARMOR1 | IT_ARMOR2 | IT_ARMOR3));
        }

        targ.armorvalue = targ.armorvalue - save;
        take = ceil(damage-save);

// check for godmode
    if (targ.flags & FL_GODMODE)
        return; // add to the damage total for clients, which will be sent as a single // message at the end of the frame
    if (targ.flags & FL_CLIENT)
    {
        targ.dmg_take = targ.dmg_take + damage;
        targ.dmg_save = targ.dmg_save + damage;
        targ.dmg_inflictor = inflictor;
    }
// team play damage avoidance
    if ( (teamplay == 1) && (targ.team > 0)&&(targ.team == attacker.team) )
        return;
		
// do the damage
    targ.health = targ.health - damage;
    if (targ.health <= 0)
    {
        Killed (targ, attacker);
        return;
    }
// react to the damage
    oldself = self;
    self = targ;
    if (self.th_pain)
        self.th_pain (attacker, damage);
    self = oldself;
};

void() WaterMove = {
    if (self.movetype == MOVETYPE_NOCLIP)
        return;
    if (self.health < 0)
        return;
    if (self.waterlevel != 3)
    {
        self.air_finished = time + 12;
        self.dmg = 2;
    }
    else if (self.air_finished < time && self.pain_finished < time)
    { // drown!
        self.dmg = self.dmg + 2;
        if (self.dmg > 15)
            self.dmg = 10;
        T_Damage (self, world, world, self.dmg);
        self.pain_finished = time + 1;
    }
    if (self.watertype == CONTENT_LAVA && self.dmgtime < time)
    { // do damage
        self.dmgtime = time + 0.2;
        T_Damage (self, world, world, 6*self.waterlevel);
    }
    else if (self.watertype == CONTENT_SLIME && self.dmgtime < time)
    { // do damage
        self.dmgtime = time + 1;
        T_Damage (self, world, world, 4*self.waterlevel);
    }
};
