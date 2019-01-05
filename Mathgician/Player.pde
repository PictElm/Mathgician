public class Player extends Entity {
    
    private static final float BASE_HITBOX = 150;
    private static final int BASE_HEALTH = 7;
    
    private PImage image;
    private int health;
    
    private float lastFacing;
    
    private String spellName;
    
    public Player() {
        super("images/player.png", Player.BASE_HITBOX);
        
        this.health = Player.BASE_HEALTH;
        
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
        this.spellName = "";
        
        return r; 
    }
    
    public void oops() {
        if (0 < this.spellName.length())
            this.spellName = this.spellName.substring(0, this.spellName.length() - 1);
    }
    
    @Override
    public void show(Mathgician app) {
        app.pushMatrix();
        
        app.rotate(this.lastFacing);
        
        super.show(app);
        app.text(this.spellName, -app.textWidth(this.spellName) / 2, -this.hitbox / 2);
        
        app.popMatrix();
    }
    
    @Override
    public void kill() {
        if (--this.health < 1)
            super.kill();
        
        print("Health left: ");
        println(this.health);
    }
    
}
