public class MovingEntity extends Entity {
    
    protected float radius;
    protected float angle;
    
    protected float speed;
    
    public MovingEntity(float distanceFromCenter, float angleOfApproache, String imageFileName, int columns, int rows, float hitBoxSize, float outMovingSpeed) {
        super(imageFileName, columns, rows, hitBoxSize);
        
        this.radius = distanceFromCenter;
        this.angle = angleOfApproache;
        
        this.speed = outMovingSpeed;
        
        this.sprite.setTilt(random(-QUARTER_PI / 3f, QUARTER_PI / 3f));
    }
    
    public void show(final Reconjurer app, final String... header) {
        final float distanceLimit = app.height * .42f;
        app.pushMatrix();
        
        app.rotate(this.angle);
        app.translate(this.radius, 0);
        app.rotate(-this.angle);
        
        super.show(app, new Runnable() {
            @Override
            public void run() {
                if (0 < header.length && MovingEntity.this.radius < distanceLimit)
                    app.text(header[0], -app.textWidth(header[0]) / 2f, -MovingEntity.this.hitbox / 2f);
            }
        });
        
        app.popMatrix();
        
        if (0 < header.length && distanceLimit < this.radius) {
            PVector pos = PVector.fromAngle(this.angle).mult(distanceLimit);
            app.text(header[0], pos.x - textWidth(header[0]) / 2f, pos.y + app.height * .053f / 2f);
        }
    }
    
    public void tick(Reconjurer app) {
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
