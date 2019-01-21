void() CheckImpulses =
{
if (self.impulse == 100) {ChaseCam_Toggle();} // If Impulse 100, toggle cam
self.impulse = 0; // Clear impulse list
};
