public class Spell extends MovingEntity {

    private static final float BASE_HITBOX = 50;
    private static final float BASE_SPEED = 4.2;
    
    private String name;
    private int accuracy;
    
    private int tiltingDirection;
    
    public Spell(String name, Enemy target, int accuracy) {
        super(0, target.getAngle(), "images/spell.png", Spell.BASE_HITBOX, Spell.BASE_SPEED);
        
        this.name = name;
        this.accuracy = accuracy;
        
        this.tiltingDirection = random(1) < .5 ? 1 : -1;
    }
    
    @Override
    public void tick(Mathgician app) {
        super.tick(app);
        
        this.tilt+= QUARTER_PI / 3 * this.tiltingDirection;
        
        if (this.accuracy != 0)
            for (Enemy e : app.enemies) 
                if (abs(e.getRadius() - this.radius) < e.getHitbox() / 2 + this.hitbox / 2 && 1 / this.accuracy < random(1)) {
                    e.kill();
                    this.kill();
                    app.strikes++;
                }
        
        if (7 * Enemy.BASE_HITBOX < abs(this.radius))
            this.kill();
    }
    
    @Override
    public void show(Mathgician app) {
        super.show(app, this.name);
    }
    
}
