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
