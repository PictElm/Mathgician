public class Player extends Entity {
    
    private static final float BASE_HITBOX = 150;
    private static final int BASE_HEALTH = 3;
    
    private PImage images[];
    private int imageComplement;
    
    private int health;
    private PImage imageHealth;
    
    private float lastFacing;
    
    private String spellName;
    
    public Player() {
        super("player3", Player.BASE_HITBOX);
        
        this.images = new PImage[4];
        for (int k = 0; k < 4; this.images[k] = super.getImage("player" + k++))
            ;
        this.imageComplement = 0;
        
        this.health = Player.BASE_HEALTH;
        this.imageHealth = super.getImage("health");
        
        this.lastFacing = 0;
        this.spellName = "";
    }
    
    public void casting(char key) {
        this.spellName+= key;
    }
    
    public ArrayList<Spell> shoot(ArrayList<Enemy> enemies) {
        if (enemies.isEmpty()) {
            this.spellName = "";
            return new ArrayList();
        }
        
        ArrayList<Enemy> targets = new ArrayList();
        int bestAccuracy = 0;
        
        for (Enemy e : enemies) {
            int acc = e.evaluateAnswer(this.spellName);
            if (bestAccuracy < acc) {
                targets.clear();
                bestAccuracy = acc;
            }
            if (bestAccuracy == acc)
                targets.add(e);
        }
        
        if (bestAccuracy == 0) {
            this.spellName = "";
            return new ArrayList();
        }
        
        ArrayList<Spell> r = new ArrayList(targets.size());
        
        for (Enemy t : targets)
            r.add(new Spell(this.spellName, t, bestAccuracy));
        
        this.lastFacing = r.get(int(random(r.size()))).getAngle();
        this.imageComplement = Mathgician.directionalComplement(this.lastFacing, +1);
        this.image = this.images[this.imageComplement];
        
        if (this.imageComplement < 2)
            this.lastFacing-= PI * (this.imageComplement - .5);
        else
            this.lastFacing-= PI * (this.imageComplement - 4);
        
        this.spellName = "";
        return r;
    }
    
    public void oops() {
        if (0 < this.spellName.length())
            this.spellName = this.spellName.substring(0, this.spellName.length() - 1);
    }
    
    public String getSpell() {
        String r = this.spellName;
        this.spellName = "";
        return r;
    }
    
    @Override
    public void show(Mathgician app) {
        app.pushMatrix();
        
        app.rotate(this.lastFacing);
        
        super.show(app);
        app.text(this.spellName, -app.textWidth(this.spellName) / 2f, -this.hitbox / 2f);
        
        app.rotate(-this.lastFacing);
        
        app.scale(.16);
        for (int k = 0; k < this.health; k++)
            app.image(this.imageHealth, (k - this.health / 2f) * this.hitbox * 1.53f, this.hitbox * 5f);
        
        app.popMatrix();
    }
    
    @Override
    public void kill() {
        if (--this.health < 1)
            super.kill();
    }
    
    public void dance() {
        if (random(1) < .0001)
            this.lastFacing = random(TWO_PI);
        //this.lastFacing+= QUARTER_PI / 120f;
        
        this.imageComplement = Mathgician.directionalComplement(this.lastFacing, +1);
        this.image = this.images[0 < this.imageComplement ? this.imageComplement : int(random(4))];
        
        if (this.imageComplement < 2)
            this.lastFacing-= PI * (this.imageComplement - .5);
        else
            this.lastFacing-= PI * (this.imageComplement - 4);
        
        delay(150);
    }
    
}
