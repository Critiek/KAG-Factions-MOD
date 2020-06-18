void onInit( CBlob@ this )
{		 	
	this.Tag("blocks water");
    this.Tag("solid");
    this.getShape().getConsts().collideWhenAttached = true;
	this.getShape().getConsts().mapCollisions = false;	
    this.getSprite().SetZ(50);
}