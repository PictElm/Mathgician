public class Enemy extends MovingEntity {

    private static final float BASE_HITBOX = 100;
    private static final float BASE_SPEED = 0.8;
    
    private String riddle;
    private String solution;
    
    private int tiltingDirection;
    
    public Enemy(float distanceFromCenter, float angleOfApproache) {
        super(distanceFromCenter, angleOfApproache, 
              "enemy" + Mathgician.directionalComplement(angleOfApproache, -1),
              Enemy.BASE_HITBOX, -Enemy.BASE_SPEED);
        
        this.createRiddle();
        
        this.tiltingDirection = random(1) < .5 ? 1 : -1;
    }
    
    public Enemy(float distanceFromCenter, float angleOfApproache, String display, String index) {
        super(distanceFromCenter, angleOfApproache, 
              "enemy" + Mathgician.directionalComplement(angleOfApproache, -1),
              Enemy.BASE_HITBOX, 0);
        
        this.riddle = display;
        this.solution = index;
        
        this.tiltingDirection = random(1) < .5 ? 1 : -1;
    }
    
    public int evaluateAnswer(String trial) {
        return trial.equals(this.solution) ? 1 : 0;
    }
    
    public void createRiddle() {
        if (Mathgician.isSetBased) {
            String[] qna = Mathgician.csSet.get(int(random(Mathgician.csSet.size()))).split(",");
            
            this.riddle = qna[0];
            this.solution = qna[1];
            
            return;
        }
        
        int ix = int(random(3));
        char op = Mathgician.operators.charAt(ix);
        
        int a = int(random(Mathgician.limitsOpsAMin.get(ix), Mathgician.limitsOpsAMax.get(ix) + 1));
        int b = int(random(Mathgician.limitsOpsBMin.get(ix), Mathgician.limitsOpsBMax.get(ix) + 1));
        
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
        this.solution = op == '/' ? str(int(s * 100) / 100f) : str(int(s));
    }
    
    public String getRiddle() {
        return this.riddle;
    }
    
    public String getDeathScreen() {
        return this.solution;
    }
    
    @Override
    public void show(Mathgician app) {
        super.show(app, this.riddle);
    }
    
    @Override
    public void tick(Mathgician app) {
        super.tick(app);
        
        if (this.speed != 0)
            this.tilt+= QUARTER_PI / (45f / this.speed) * this.tiltingDirection;
        else
            this.tilt+= QUARTER_PI / random(12, 88) * this.tiltingDirection;
        
        if (QUARTER_PI / 3f < abs(this.tilt))
            this.tiltingDirection*= -1;
        
        if (this.radius < app.player.getHitbox() / 2f + this.hitbox / 2f) {
            app.player.kill();
            this.kill();
            app.strikes = 0;
        }
    }
    
}
