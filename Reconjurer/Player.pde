public class Player extends Entity {

    private static final float BASE_HITBOX = 150;
    private static final int BASE_HEALTH = 3;

    private int imageComplement;

    private int health;
    private PImage imageHealth;

    private float lastFacing;

    private String spellName;

    public Player() {
        super("player", 2, 4, Player.BASE_HITBOX);
        
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
        this.imageComplement = Reconjurer.directionalComplement(this.lastFacing, +1);
        this.sprite.setRow(this.imageComplement);

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
    public void show(final Reconjurer app) {
        float tilt = this.sprite.getTilt();

        this.sprite.setTilt(tilt + this.lastFacing);

        super.show(app, new Runnable() {
            @Override
            public void run() {
                app.text(Player.this.spellName, -app.textWidth(Player.this.spellName) / 2f, -Player.this.hitbox / 2f);
                app.scale(.16);
                for (int k = 0; k < Player.this.health; k++)
                    app.image(Player.this.imageHealth, (k - Player.this.health / 2f) * Player.this.hitbox * 1.53f, Player.this.hitbox * 5f);
            }
        });

        this.sprite.setTilt(tilt);

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

        this.imageComplement = Reconjurer.directionalComplement(this.lastFacing, +1);
        this.sprite.setRow(0 < this.imageComplement ? this.imageComplement : int(random(4)));

        if (this.imageComplement < 2)
            this.lastFacing-= PI * (this.imageComplement - .5);
        else
            this.lastFacing-= PI * (this.imageComplement - 4);

        delay(250);
    }
}
