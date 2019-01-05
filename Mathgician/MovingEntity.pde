public class MovingEntity extends Entity {
    
    protected float radius;
    protected float angle;
    
    protected float speed;
    
    protected float tilt;
    
    public MovingEntity(float distanceFromCenter, float angleOfApproache, String imageFileName, float hitBoxSize, float outMovingSpeed) {
        super(imageFileName, hitBoxSize);
        
        this.radius = distanceFromCenter;
        this.angle = angleOfApproache;
        
        this.speed = outMovingSpeed;
        
        this.tilt = 0;
    }
    
    public void show(Mathgician app, String... header) {
        app.pushMatrix();
        
        app.rotate(this.angle);
        app.translate(this.radius, 0);
        
        app.rotate(this.tilt - this.angle);
        
        super.show(app);
        if (0 < header.length)
            app.text(header[0], -app.textWidth(header[0]) / 2, -this.hitbox / 2);
        
        app.popMatrix();
    }
    
    public void tick(Mathgician app) {
        this.radius+= this.speed;
    }
    
    public boolean shouldRemove() {
        return this.isDead();
    }
    
    public float getAngle() {
        return this.angle;
    }
    
    public float getRadius() {
        return this.radius;
    }
    
}
