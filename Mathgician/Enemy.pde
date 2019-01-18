public class Enemy extends MovingEntity {

    private static final float BASE_HITBOX = 100;
    private static final float BASE_SPEED = 0.8;
    
    private String riddle;
    private String solution;
    
    private int tiltingDirection;
    
    private int beforeRemoveDelay;
    private boolean isLevelName;
    
    public boolean isKiller;
    
    public Enemy(float distanceFromCenter, float angleOfApproache) {
        super(distanceFromCenter, angleOfApproache, 
              "enemy" + Mathgician.directionalComplement(angleOfApproache, -1),
              Enemy.BASE_HITBOX, -Enemy.BASE_SPEED);
        
        this.createRiddle(0);
        if (Mathgician.isTraining)
            this.riddle+= "—" + this.solution;
        
        this.isLevelName = false;
        this.isKiller = false;
        
        this.tiltingDirection = random(1) < .5 ? 1 : -1;
    }
    
    public Enemy(float distanceFromCenter, float angleOfApproache, int bossLevel) {
        super(distanceFromCenter, angleOfApproache, 
              "enemy" + Mathgician.directionalComplement(angleOfApproache, -1),
              Enemy.BASE_HITBOX * 2f, -Enemy.BASE_SPEED / 2f);
        
        this.createRiddle(bossLevel);
        if (Mathgician.isTraining)
            this.riddle+= " — " + this.solution;
        
        this.isLevelName = false;
        this.isKiller = false;
        
        this.tiltingDirection = random(1) < .5 ? 1 : -1;
    }
    
    public Enemy(float distanceFromCenter, float angleOfApproache, String display, String index) {
        super(distanceFromCenter, angleOfApproache, 
              "enemy" + Mathgician.directionalComplement(angleOfApproache, -1),
              Enemy.BASE_HITBOX, 0);
        
        this.riddle = display;
        this.solution = index;
        
        this.isLevelName = true;
        this.isKiller = false;
        
        this.tiltingDirection = random(1) < .5 ? 1 : -1;
    }
    
    public int evaluateAnswer(String trial) {
        return trial.equals(this.solution) ? 1 : 0;
    }
    
    public void createRiddle(int bossLevel) {
        if (Mathgician.isSetBased) {
            this.riddle = "";
            this.solution = "";
            
            for (int k = 0; k < bossLevel + 1; k++) {
                String s = Mathgician.csSet.get(int(random(Mathgician.csSet.size())));
                String[] qna = s.split(",");
                
                this.riddle+= qna[0];
                this.solution+= qna[1];
            }
            
            return;
        }
        
        int ix = int(random(3));
        int a = int(random(Mathgician.limitsOpsAMin.get(ix), Mathgician.limitsOpsAMax.get(ix) + 1));
        
        this.riddle = str(a);
        this.solution = "";
            
        int s = 0;
        
        for (int k = 0; k < bossLevel + 1; k++) {
            char op = Mathgician.operators.charAt(ix);
            int b = int(random(Mathgician.limitsOpsBMin.get(ix), Mathgician.limitsOpsBMax.get(ix) + 1));
            
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
            
            this.riddle+= " " + op + " " + str(b);
            
            a = int(s);
        }
        this.solution = str(int(s));
    }
    
    public String getRiddle() {
        return this.riddle;
    }
    
    public String getDeathScreen() {
        return this.solution;
    }
    
    @Override
    public void kill() {
        if (this.isLevelName)
            super.kill();
        
        else if (!this.isDead) {
            super.kill();
            
            this.riddle+= "—" + this.solution;
            this.beforeRemoveDelay = 60;
            this.image = null;
            this.speed = 0;
        }
    }
    
    @Override
    public boolean shouldRemove() {
        return this.beforeRemoveDelay < 0 ? super.shouldRemove() : false;
    }
    
    @Override
    public void show(Mathgician app) {
        super.show(app, this.riddle);
    }
    
    @Override
    public void tick(Mathgician app) {
        super.tick(app);
        
        if (this.isDead) {
            this.beforeRemoveDelay--;
            return;
        }
        
        if (this.speed != 0)
            this.tilt+= QUARTER_PI / 45f * this.speed * this.tiltingDirection;
        else
            this.tilt+= QUARTER_PI / 42f * this.tiltingDirection;
        
        if (QUARTER_PI / 3f < abs(this.tilt))
            this.tiltingDirection*= -1;
        
        if (this.radius < app.player.getHitbox() / 2f + this.hitbox / 2f) {
            app.player.kill();
            this.kill();
            app.strikes = 0;
            
            if (app.player.isDead())
                this.isKiller = true;
        }
    }
    
}
