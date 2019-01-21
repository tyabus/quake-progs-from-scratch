void(string modelname) Precache_Set = // Precache model, and set myself to it
{
 precache_model(modelname);
 setmodel(self, modelname);
};

void(entity ent) SetViewPoint = // Alter the Viewpoint Entity
{
 msg_entity = self; // This message is to myself
 WriteByte(1, SVC_SETVIEW); // Network Protocol: Set Viewpoint Entity
 WriteEntity(1, ent); // Write entity to clients
};
