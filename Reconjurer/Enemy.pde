public class Enemy extends MovingEntity {

    private static final float BASE_HITBOX = 100;
    private static final float BASE_SPEED = 0.51;
    
    private String riddle;
    private String solution;
    
    private int tiltingDirection;
    
    private int beforeRemoveDelay;
    private boolean isLevelName;
    
    public boolean isKiller;
    
    private Enemy(float distanceFromCenter, float angleOfApproache, float hitbox, float speed) {
        super(distanceFromCenter, angleOfApproache, "enemy", 2, 4, hitbox, -speed); // toward center
        this.sprite.setRow(Reconjurer.directionalComplement(angleOfApproache, -1));
    }
    
    public Enemy(float distanceFromCenter, float angleOfApproache, int bossLevel, boolean isTraining, float mult) {
        this(distanceFromCenter, angleOfApproache, Enemy.BASE_HITBOX * mult, Enemy.BASE_SPEED / mult);
        
        this.createRiddle(bossLevel);
        if (isTraining)
            this.riddle+= ": " + this.solution;
        
        this.isLevelName = false;
        this.isKiller = false;
        
        this.tiltingDirection = random(1) < .5 ? 1 : -1;
    }
    
    public Enemy(float distanceFromCenter, float angleOfApproache, int bossLevel, boolean isTraining) {
        this(distanceFromCenter, angleOfApproache, bossLevel, isTraining, 1f);
    }
    
    public Enemy(float distanceFromCenter, float angleOfApproache, String display, String index) {
        this(distanceFromCenter, angleOfApproache, Enemy.BASE_HITBOX, 0);
        
        this.riddle = display;
        this.solution = index;
        
        this.isLevelName = true;
        this.isKiller = false;
        
        this.tiltingDirection = random(1) < .5 ? 1 : -1;
    }
    
    public int evaluateAnswer(String trial) {
        return trial.trim().equals(this.solution.trim()) ? 1 : 0;
    }
    
    public void createRiddle(int bossLevel) {
        if (Reconjurer.isSetBased) {
            this.riddle = "";
            this.solution = "";
            
            for (int k = 0; k < bossLevel; k++) {
                
                String[] qna = Reconjurer.csSet.get(int(random(Reconjurer.csSet.size()))).split(":");
                
                this.riddle+= qna[0];
                this.solution+= qna[1];
            }
            
            return;
        }
        
        int ix = int(random(Reconjurer.operators.length()));
        int a = int(random(Reconjurer.limitsOpsAMin.get(ix), Reconjurer.limitsOpsAMax.get(ix) + 1));
        
        this.riddle = str(a);
        this.solution = "";
            
        int s = 0;
        
        for (int k = 0; k < bossLevel; k++) {
            char op = Reconjurer.operators.charAt(ix);
            int b = int(random(Reconjurer.limitsOpsBMin.get(ix), Reconjurer.limitsOpsBMax.get(ix) + 1));
            
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
            
            if (k != 0 && (op == 'x' || op == '/'))
                this.riddle = "(" + this.riddle + ")";
            this.riddle+= " " + op + " " + str(b);
            
            ix = int(random(Reconjurer.operators.length()));
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
            
            if (0 < this.evaluateAnswer(this.riddle))
                this.riddle = "";
            else
                this.riddle+= " : " + this.solution;
            
            this.beforeRemoveDelay = 60;
            this.sprite = new Sprite(super.getImage("dead"));
            this.speed = 0;
        }
    }
    
    @Override
    public boolean shouldRemove() {
        return this.beforeRemoveDelay < 0 ? super.shouldRemove() : false;
    }
    
    @Override
    public void show(Reconjurer app) {
        super.show(app, this.riddle);
    }
    
    @Override
    public void tick(Reconjurer app) {
        super.tick(app);
        
        if (this.isDead) {
            this.beforeRemoveDelay--;
            return;
        }
        
        float tilt = this.sprite.getTilt();
        
        if (this.speed != 0)
            tilt+= QUARTER_PI / 45f * this.speed * this.tiltingDirection;
        else
            tilt+= QUARTER_PI / 42f * this.tiltingDirection;
        
        if (QUARTER_PI / 3f < abs(tilt))
            this.tiltingDirection*= -1;
        
        this.sprite.setTilt(tilt);
        
        if (this.radius < app.player.getHitbox() / 2f + this.hitbox / 2f) {
            app.player.kill();
            this.kill();
            app.strikes = 0;
            
            if (1 < app.bossLevel && random(1) < .2)
                app.bossLevel--;
            
            if (app.player.isDead()) {
                this.isKiller = true;
                this.sprite = null;
            }
        }
    }
    
}
