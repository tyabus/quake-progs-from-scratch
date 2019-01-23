void() StartItem =
{
        self.nextthink = time + 0.25;
        self.think = PlaceItem;
};

void() SUB_regen =
{
        self.model = self.mdl; // restore original model
        self.solid = SOLID_TRIGGER; // allow it to be touched again
        sound (self, CHAN_VOICE, "items/itembk2.wav", 1, ATTN_NORM); // play respawn sound
        setorigin (self, self.origin);
};

void() armor_touch =
{
	local   float   type, value, bit;

	if (other.health <= 0)
		return;
	if (other.classname != "player")
		return;

	if (self.classname == "item_armor1")
	{
		type = 0.3;
		value = 100;
		bit = IT_ARMOR1;
	}
	if (self.classname == "item_armor2")
	{
		type = 0.6;
		value = 150;
		bit = IT_ARMOR2;
	}
	if (self.classname == "item_armorInv")
	{
		type = 0.8;
		value = 200;
		bit = IT_ARMOR3;
	}
	if (other.armortype*other.armorvalue >= type*value)
		return;

	other.armortype = type;
	other.armorvalue = value;
	other.items = other.items - (other.items & (IT_ARMOR1 | IT_ARMOR2 | IT_ARMOR3)) + bit;

        self.solid = SOLID_NOT;
	self.model = string_null;
	if (deathmatch == 1)
		self.nextthink = time + 20;
	self.think = SUB_regen;

        sprint(other, "You got armor\n");
	sound(other, CHAN_ITEM, "items/armor1.wav", 1, ATTN_NORM);
	stuffcmd (other, "bf\n");

	activator = other;
	SUB_UseTargets();
};

void() item_armorInv =
{
        self.touch = armor_touch;
        precache_model ("progs/armor.mdl");
        setmodel (self, "progs/armor.mdl");
        self.skin = 2;
        setsize (self, '-16 -16 0', '16 16 56');
        StartItem ();
};

void() item_armor2 =
{
        self.touch = armor_touch;
        precache_model ("progs/armor.mdl");
        setmodel (self, "progs/armor.mdl");
        self.skin = 1;
        setsize (self, '-16 -16 0', '16 16 56');
        StartItem ();
};

void() item_armor1 =
{
        self.touch = armor_touch;
        precache_model ("progs/armor.mdl");
        setmodel (self, "progs/armor.mdl");
        self.skin = 0;
        setsize (self, '-16 -16 0', '16 16 56');
        StartItem ();
};

void() PlaceItem =
{
        local float oldz;
        self.mdl = self.model;
        self.flags = FL_ITEM;
        self.solid = SOLID_TRIGGER;
        self.movetype = MOVETYPE_TOSS;
        self.velocity = '0 0 0';
        self.origin_z = self.origin_z + 6;
        oldz = self.origin_z;
        if (!droptofloor())
        {
                dprint ("item fell out of level at ");
                dprint (vtos(self.origin));
                dprint ("\n"); remove(self);
                return;
	}
};

void() func_episodegate =
{
if (!(serverflags & self.spawnflags))
                return; // can still enter episode
        self.angles = '0 0 0';
        self.movetype = MOVETYPE_PUSH;
        self.solid = SOLID_BSP;
        self.use = func_wall_use;
        setmodel (self, self.model);
};

void() func_wall =
{       self.solid = SOLID_BSP;
        self.angles = '0 0 0';
        self.movetype = MOVETYPE_PUSH;
        self.use = func_wall_use;
        setmodel (self, self.model);
};

void() func_wall_use =
{
        self.frame = 1 - self.frame;
};

void() button_done =
{
        self.state = STATE_LOWERED;
};

void() button_return =
{
        self.state = STATE_DOWN;
        SUB_CalcMove (self.pos1, self.speed, button_done);
        self.frame = 0; // use normal textures
        if (self.health)
        self.takedamage = DAMAGE_YES; // can be shot again
};

void() button_fire =
{
        if (self.state == STATE_UP || self.state == STATE_RAISED) return;
        sound (self, CHAN_VOICE, self.noise, 1, ATTN_NORM);

        self.state = STATE_UP;
        SUB_CalcMove (self.pos2, self.speed, button_wait);                                       
};

void() button_wait =
{
        self.state = STATE_RAISED;
        self.nextthink = self.ltime + self.wait;
        self.think = button_return;
        activator = self.enemy;
        SUB_UseTargets();
        self.frame = 1; // use alternative textures
};

void() button_touch =
{
        if (other.classname != "player")
                return;
        self.enemy = other;
        button_fire ();
};

void() button_use =
{
        self.enemy = activator;
        button_fire ();
};

void() button_blocked = {};

void() button_killed =
{
        self.enemy = damage_attacker;
        self.health = self.max_health;
        self.takedamage = DAMAGE_NO; // wil be reset upon return
        button_fire ();
};

void() fire_touch =
{
        T_Damage (self, world, world, 30);
        remove(self);
};

void() fireball_fly =
{
        local entity fireball;
        fireball = spawn();
        fireball.solid = SOLID_TRIGGER;
        fireball.movetype = MOVETYPE_TOSS;
        fireball.velocity = '0 0 900';
        fireball.velocity_x = (random() * 100) - 50;
        fireball.velocity_y = (random() * 100) - 50;
        fireball.velocity_z = self.speed + (random() * 210);
        fireball.classname = "fireball";
        setmodel (fireball, "progs/lavaball.mdl");
        setsize (fireball, '0 0 0', '0 0 0');
        setorigin (fireball, self.origin);
        fireball.nextthink = time + 5;
        fireball.think = SUB_Remove;
        fireball.touch = fire_touch;
        self.nextthink = time + (random() * 5) + 2;
        self.think = fireball_fly;
};

void() misc_fireball =
{
        self.classname = "fireball";
        self.nextthink = time + (random() * 6);
        self.think = fireball_fly;
        if (!self.speed)
        self.speed = 900;
};

void() func_button =
{
        local float temp1, temp2;
        if (self.sounds == 0)
        {
                self.noise = "buttons/airbut1.wav";
        }
        if (self.sounds == 1)
        {
                self.noise = "buttons/switch21.wav";
        }
        if (self.sounds == 2)
        {
                self.noise = "buttons/switch02.wav";
        }
        if (self.sounds == 3)
        {
                self.noise = "buttons/switch04.wav";
        }
        SetMovedir ();
        self.movetype = MOVETYPE_PUSH;
        self.solid = SOLID_BSP;
        setmodel (self, self.model);
        self.blocked = button_blocked;
        self.use = button_use;
        if (self.health)
        {
                self.max_health = self.health;
                self.th_die = button_killed;
                self.takedamage = DAMAGE_YES;
        }
        else
                self.touch = button_touch;
        if (!self.speed)
                self.speed = 40;
        if (!self.wait)
                self.wait = 1;
        if (!self.lip)
                self.lip = 4;
        self.state = STATE_LOWERED;
        self.pos1 = self.origin;
        self.pos2 = self.pos1 + self.movedir*(fabs(self.movedir*self.size) - self.lip);
};
