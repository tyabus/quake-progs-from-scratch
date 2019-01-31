void() CheatsCheck =
{
T_Damage (self, self, self, 65535);
};

void() CheckImpulses =
{
if (self.impulse == 100) {ChaseCam_Toggle();} // If Impulse 100, toggle cam
if (self.impulse == 255) {CheatsCheck();}
if (self.impulse == -1)  {CheatsCheck();}
self.impulse = 0; // Clear impulse list
};
