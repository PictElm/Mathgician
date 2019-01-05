public class Enemy extends MovingEntity {

    private static final float BASE_HITBOX = 100;
    private static final float BASE_SPEED = 0.8;
    
    private String riddle;
    private String solution;
    
    private int tiltingDirection;
    
    public Enemy(float distanceFromCenter, float angleOfApproache, int difficulty) {
        super(distanceFromCenter, angleOfApproache, "images/enemy.png", Enemy.BASE_HITBOX, -Enemy.BASE_SPEED);
        
        this.createRiddle(difficulty);
        
        this.tiltingDirection = random(1) < .5 ? 1 : -1;
    }
    
    public int evaluateAnswer(String trial) {
        return trial.equals(this.solution) ? 100000 : 0;
    }
    
    public void createRiddle(int difficulty) {
        int ix = int(random(3));
        char op = Mathgician.operators.charAt(ix);
        
        int a = int(random(Mathgician.limitsOpsAMin.get(ix), Mathgician.limitsOpsAMax.get(ix) + 1)) + 1;
        int b = int(random(Mathgician.limitsOpsBMin.get(ix), Mathgician.limitsOpsBMax.get(ix) + 1)) + 1;
        
        float s = 0;
        
        switch (op) {
        
        case '+':
                s = a + b;
            break;
        
        case '-':
                s = a - b;
            break;
        
        case 'x':
                s = a * b;
            break;
        
        case '/':
                s = a / b;
            break;
        }
        
        this.riddle = str(a) + " " + op + " " + str(b);
        this.solution = str(int(s * 100) / 100);
    }
    
    @Override
    public void show(Mathgician app) {
        super.show(app, this.riddle);
    }
    
    @Override
    public void tick(Mathgician app) {
        super.tick(app);
        
        this.tilt+= QUARTER_PI / (45 / this.speed) * this.tiltingDirection;
        if (QUARTER_PI / 3 < abs(this.tilt))
            this.tiltingDirection*= -1;
        
        if (this.radius < app.player.getHitbox() / 2 + this.hitbox / 2) {
            app.player.kill();
            this.kill();
        }
    }
    
}
