public class Spell extends MovingEntity {

    private static final float BASE_HITBOX = 50;
    private static final float BASE_SPEED = 7.1;
    
    private int accuracy;
    private Enemy target;
    
    private String name;
    private int tiltingDirection;
    
    public Spell(String name, Enemy target, int accuracy) {
        super(0, target.getAngle(), "spell", Spell.BASE_HITBOX, Spell.BASE_SPEED);
        
        this.accuracy = accuracy;
        this.target = target;
        
        this.name = "";//name;
        this.tiltingDirection = random(1) < .5 ? 1 : -1;
    }
    
    @Override
    public void tick(Reconjurer app) {
        super.tick(app);
        
        this.tilt+= QUARTER_PI / 3f * this.tiltingDirection;
        
        if (0 < this.accuracy)
            if (abs(this.target.getRadius() - this.radius) < this.target.getHitbox() / 2f + this.hitbox / 2f) {
                this.target.kill();
                this.kill();
                app.strikes++;
            }
        
        if (6 * Enemy.BASE_HITBOX < abs(this.radius))
            this.kill();
    }
    
    @Override
    public void show(Reconjurer app) {
        super.show(app, this.name);
    }
    
}
