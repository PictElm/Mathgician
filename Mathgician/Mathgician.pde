public Player player;

public ArrayList<Enemy> enemies;
public ArrayList<Spell> spells;

public PImage background;
public PImage foreground;

public static String operators = "";

public static IntList limitsOpsAMin = new IntList();
public static IntList limitsOpsAMax = new IntList();
public static IntList limitsOpsBMin = new IntList();
public static IntList limitsOpsBMax = new IntList();
public static IntList spawnDelayMin = new IntList();
public static IntList spawnDelayMax = new IntList();

public int nextSpawnDelay;
public int strikes;

public void settings() {
    this.fullScreen();
}

public void setup() {
    this.noCursor();
    this.fill(255);
    
    this.textFont(this.loadFont("Gabriola-48.vlw"), 48);
    
    this.background = loadImage("images/background.png");
    this.foreground = loadImage("images/foreground.png");
    
    this.background.resize(this.width, this.height);
    this.foreground.resize(this.width, this.height);
    
    this.init();
}

public void init() {
    this.player = new Player();
    
    this.enemies = new ArrayList();
    this.spells = new ArrayList();
    
    this.loadLevel("all");
    
    this.nextSpawnDelay = int(random(Mathgician.spawnDelayMin.get(0), Mathgician.spawnDelayMax.get(0)));
    this.strikes = 0;
}

public void draw() {
    this.background(this.background);
    /*this.background(0);
    this.image(this.background, 0, 0, this.width, this.height);*/
    this.translate(this.width / 2, this.height / 2);
    
    this.player.show(this);
    
    for (int k = 0; k < this.enemies.size(); k++) {
        Enemy e = this.enemies.get(k);
        
        e.tick(this);
        e.show(this);
        
        if (e.shouldRemove() && !player.isDead())
            this.enemies.remove(k);
    }
    
    for (int k = 0; k < this.spells.size(); k++) {
        Spell s = this.spells.get(k);
        
        s.tick(this);
        s.show(this);
        
        if (s.shouldRemove())
            this.spells.remove(k);
    }
    
    if (this.player.isDead()) {
        this.background(0);
        this.player.shoot(this.enemies);
        this.player.show(this);
        for (Enemy e : this.enemies)
            if (e.shouldRemove())
                e.show(this);
        this.noLoop();
    }
    
    if (100 < this.strikes + 1) {
        this.background(0);
        this.player.shoot(this.enemies);
        this.player.show(this);
        this.noLoop();
    }
    
    
    if (--this.nextSpawnDelay < 0) {
        this.enemies.add(new Enemy(7 * Enemy.BASE_HITBOX, random(TWO_PI), 42));
        this.nextSpawnDelay = int(random(Mathgician.spawnDelayMin.get(int(Mathgician.spawnDelayMin.size() * this.strikes / 100)),
                                         Mathgician.spawnDelayMax.get(int(Mathgician.spawnDelayMax.size() * this.strikes / 100))));
    }
    
    /*this.translate(-this.width / 2, -this.height / 2);
    this.image(this.foreground, 0, 0, this.width, this.height);*/
}

public void keyTyped() {
    /*if (this.key == ' ') {
        this.enemies.add(new Enemy(7 * Enemy.BASE_HITBOX, random(TWO_PI), 42));
        return;
    }*/
    
    if (this.key == ENTER)
        this.spells.addAll(this.player.shoot(this.enemies));
    
    else if (this.key == BACKSPACE)
        this.player.oops();
    
    else if (this.key != CODED)
        this.player.casting(this.key);
}

public void loadLevel(String name) {
    String[] datas = loadStrings("levels/" + name + ".txt");
    
    for (String line : datas)
        switch(line.charAt(0)) {
            
            case '+':
            case '-':
            case 'x':
            case '/':
                    Mathgician.operators+= line.charAt(0);
                    String[] limsOps = line.substring(2, line.length()).split(";");
                    Mathgician.limitsOpsAMin.append(int(limsOps[0].split(",")[0]));
                    Mathgician.limitsOpsAMax.append(int(limsOps[0].split(",")[1]));
                    Mathgician.limitsOpsBMin.append(int(limsOps[1].split(",")[0]));
                    Mathgician.limitsOpsBMax.append(int(limsOps[1].split(",")[1]));
                break;
            
            case 't':
                    String[] limsDly = line.substring(2, line.length()).split(";");
                    for (int k = 0; k < limsDly.length; k++) {
                        Mathgician.spawnDelayMin.append(int(limsDly[k].split(",")[0]));
                        Mathgician.spawnDelayMax.append(int(limsDly[k].split(",")[1]));
                    }
                break;
        }
}
