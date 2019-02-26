public Player player;

public ArrayList<Enemy> enemies;
public ArrayList<Spell> spells;

public PImage background;
public PImage foreground;

public static String operators;

public static int[] spawnDelayMin;
public static int[] spawnDelayMax;
public static int spawnDelayCount;
public int nextSpawnDelay;

public static IntList limitsOpsAMin;
public static IntList limitsOpsAMax;
public static IntList limitsOpsBMin;
public static IntList limitsOpsBMax;

public static boolean isSetBased;
public static StringList csSet;

public boolean isTraining;

public int waveSize;
public int strikes;
public int bossLevel;

public Entity deathScreenKiller;

public boolean inMenu;
public boolean inGame;
public boolean inDeath;
public boolean inVictory;

public void settings() {
    this.fullScreen();
}

public void setup() {
    this.surface.setIcon(loadImage("images/icon.png"));
    
    this.noCursor();
    this.fill(0);
    
    this.textFont(this.loadFont("Dialog.plain-32.vlw"), this.height * .053f);
    //this.textSize(this.height * .053f);
    
    this.background = loadImage("images/background.png");
    this.foreground = loadImage("images/foreground.png");
    
    this.background.resize(this.width, this.height);
    this.foreground.resize(this.width, this.width);
    
    this.init();
}

public void init() {
    Reconjurer.operators = "";
    
    Reconjurer.isSetBased = false;
    this.isTraining = false;
    
    this.player = new Player();
    
    this.spells = new ArrayList();
    this.enemies = new ArrayList();
    
    int k = 0;
    String[] levelNames = this.loadFiles(sketchPath() + "/data/levels/");
    for (String name : levelNames)
        if (name.endsWith(".txt")) {
            String tmp = name.substring(0, name.length() - 4).replace(' ', '_');
            this.enemies.add(new Enemy(3 * Enemy.BASE_HITBOX, k++ * TWO_PI / levelNames.length, tmp, tmp));
        }
    
    this.inMenu = true;
    this.inGame = false;
    this.inDeath = false;
    this.inVictory = false;
    
    if (this.enemies.size() == 1)
        this.loadLevel(this.enemies.get(0).getRiddle());
}

public void drawMenu() {
    this.background(this.background);
    this.translate(this.width / 2f, this.height / 2f);
    
    this.player.show(this);
    
    for (Enemy e : this.enemies) {
        e.tick(this);
        e.show(this);
        
        if (e.shouldRemove())
            this.loadLevel(e.getRiddle());
    }
    
    for (Spell s : this.spells) {
        s.tick(this);
        s.show(this);
    }
    
    this.translate(-this.width / 2f, -this.height / 2f);
    this.image(this.foreground, 0, (this.height - this.foreground.height) / 2f);
    
    this.textSize(this.height * .053f / 2f);
    this.textLabel(" Type the name of an enemy around you!", 0, this.height * .053f / 2f, color(255), color(0), this.height * .053f / 2f);
    this.textLabel(" Press space to toggle training mode: " + (this.isTraining ? "[on]" : "[off]"), 0, 2 * this.height * .053f / 2f, color(255), color(0), this.height * .053f / 2f);
    this.textSize(this.height * .053f);
    
    this.fill(0);
}

public void drawGame() {
    this.background(this.background);
    this.translate(this.width / 2f, this.height / 2f);
    
    this.player.show(this);
    
    for (int k = 0; k < this.enemies.size(); k++) {
        Enemy e = this.enemies.get(k);
        
        e.tick(this);
        e.show(this);
        
        if (e.shouldRemove() && !player.isDead()) {
            this.enemies.remove(k);
        }
    }
    
    for (int k = 0; k < this.spells.size(); k++) {
        Spell s = this.spells.get(k);
        
        s.tick(this);
        s.show(this);
        
        if (s.shouldRemove())
            this.spells.remove(k);
    }
    
    if (this.player.isDead()) {
        this.inGame = false;
        this.inDeath = true;
        
        this.player.getSpell();
        
        for (Enemy e : this.enemies)
            if (e.isKiller) {
                this.deathScreenKiller = e;
                break;
            }
    }
    
    if (--this.nextSpawnDelay < 0 && this.strikes < this.waveSize && this.enemies.size() < 7) {
            this.enemies.add(new Enemy(7 * Enemy.BASE_HITBOX, random(TWO_PI), this.bossLevel, this.isTraining));
            this.nextSpawnDelay = int(random(Reconjurer.spawnDelayMin[int(Reconjurer.spawnDelayCount * float(this.strikes) / this.waveSize)],
                                             Reconjurer.spawnDelayMax[int(Reconjurer.spawnDelayCount * float(this.strikes) / this.waveSize)]));
    }
    
    
    if (this.waveSize - 1 < this.strikes && this.enemies.size() < 1) {
        this.strikes = 0;
        this.enemies.add(new Enemy(8 * Enemy.BASE_HITBOX, random(TWO_PI), ++this.bossLevel + 1, this.isTraining, 2));
        this.nextSpawnDelay = 2 * Reconjurer.spawnDelayMax[0];
    } 
    
    this.translate(-this.width / 2f, -this.height / 2f);
    this.image(this.foreground, 0, (this.height - this.foreground.height) / 2f);
    
    String tmp;
    if (this.strikes < this.waveSize)
        tmp = " Strikes: " + this.strikes + " over " + this.waveSize;
    else
        tmp = " Boss approaching!";
    
    this.textLabel(tmp, 0, this.height * .053f, color(255), color(0), this.height * .053f);
    this.textLabel("Level: " + this.bossLevel, this.width - this.textWidth("Level: " + this.bossLevel), this.height * .053f, color(255), color(0), this.height * .053f);
    
    this.fill(0);
}

public void drawDeath() {
    this.background(255);
    
    this.translate(this.width / 2f, this.height / 2f);
    
    this.player.show(this);
    this.deathScreenKiller.show(this);
    
    if (keyPressed && key == ENTER)
        this.init();
    
    this.translate(-this.width / 2f, -this.height / 2f);
    this.image(this.foreground, 0, (this.height - this.foreground.height) / 2f);
}

public void drawVictory() {
    this.background(this.background);
    this.translate(this.width / 2f, this.height / 2f);
    
    this.player.show(this);
    this.player.dance();
    
    if (keyPressed && key == ENTER)
        this.init();
}

public void draw() {
    if (this.inMenu)
        this.drawMenu();
    
    if (this.inGame)
        this.drawGame();
    
    if (this.inDeath)
        this.drawDeath();
    
    if (this.inVictory)
        this.drawVictory();
}

public void keyTyped() {
    if (this.inMenu || this.inGame) {
        if (this.key == ENTER)
            this.spells.addAll(this.player.shoot(this.enemies));
        else if (this.key == BACKSPACE)
            this.player.oops();
        else if (this.inMenu && this.key == ' ')
            this.isTraining = !this.isTraining;
        else if (this.key != CODED)
            this.player.casting(this.key);
    }
}

public void loadLevel(String name) {
    this.bossLevel = 1;
    this.waveSize = 15;
    
    String[] data = loadStrings("levels/" + name + ".txt");
    
    for (String line : data) {
        if (line.charAt(0) == '_' && line.charAt(2) == ':') {
            switch (line.charAt(1)) {
                case '+':
                case '-':
                case 'x':
                case '/':
                        if (Reconjurer.operators == "") {
                            Reconjurer.limitsOpsAMin = new IntList();
                            Reconjurer.limitsOpsAMax = new IntList();
                            Reconjurer.limitsOpsBMin = new IntList();
                            Reconjurer.limitsOpsBMax = new IntList();
                        }
                        Reconjurer.operators+= line.charAt(1);
                        
                        String[] limsOps = line.substring(3, line.length()).trim().split(";");
                        
                        Reconjurer.limitsOpsAMin.append(int(limsOps[0].split(",")[0]));
                        Reconjurer.limitsOpsAMax.append(int(limsOps[0].split(",")[1]));
                        Reconjurer.limitsOpsBMin.append(int(limsOps[1].split(",")[0]));
                        Reconjurer.limitsOpsBMax.append(int(limsOps[1].split(",")[1]));
                    break;
                
                case 't':
                        String[] limsDly = line.substring(3, line.length()).trim().split(";");
                        
                        Reconjurer.spawnDelayCount = limsDly.length;
                        Reconjurer.spawnDelayMin = new int[limsDly.length];
                        Reconjurer.spawnDelayMax = new int[limsDly.length];
                        
                        if (line.contains(",")) {
                            for (int k = 0; k < limsDly.length; k++) {
                                String[] tmp = limsDly[k].split(",");
                                Reconjurer.spawnDelayMin[k] = int(tmp[0]);
                                Reconjurer.spawnDelayMax[k] = int(tmp[1]);
                            }
                        } else {
                            for (int k = 0; k < limsDly.length; k++) {
                                int[] tmp = makeDelayLevels(int(limsDly[k]));
                                Reconjurer.spawnDelayMin[k] = tmp[0];
                                Reconjurer.spawnDelayMax[k] = tmp[1];
                            }
                        }
                    break;
                    
                case 'l':
                        this.bossLevel = int(line.substring(3, line.length()));
                    break;
                    
                case 'w':
                        this.waveSize = int(line.substring(3, line.length()));
                    break;
            }
            
        } else {
            if (!Reconjurer.isSetBased) {
                Reconjurer.isSetBased = true;
                Reconjurer.csSet = new StringList();
            }
            
            if (!line.contains(":"))
                line+= ":" + line;
            
            Reconjurer.csSet.append(line);
        }
    }
    
    this.inMenu = false;
    this.inGame = true;
    
    this.enemies = new ArrayList();
    this.spells = new ArrayList();
    
    if (Reconjurer.spawnDelayCount < 1) {
        Reconjurer.spawnDelayCount = 3;
        Reconjurer.spawnDelayMin = new int[Reconjurer.spawnDelayCount];
        Reconjurer.spawnDelayMax = new int[Reconjurer.spawnDelayCount];
        for (int k = 0; k < Reconjurer.spawnDelayCount; k++) {
            int[] tmp = makeDelayLevels(k + 1);
            Reconjurer.spawnDelayMin[k] = int(tmp[0]);
            Reconjurer.spawnDelayMax[k] = int(tmp[1]);
        }
    }
    
    this.nextSpawnDelay = int(random(Reconjurer.spawnDelayMin[0], Reconjurer.spawnDelayMax[0]));
    this.strikes = 0;
    
    this.deathScreenKiller = null;
}

public int[] makeDelayLevels(int lvl) {
    switch (lvl) {
        case 1: return new int[] { 300, 600 };
        case 2: return new int[] { 120, 300 };
        case 3: return new int[] { 60, 240 };
        case 4: return new int[] { 42, 72 };
        case 5: return new int[] { 24, 27 };
    }
    return new int[2];
}

public String[] loadFiles(String dir) {
    File file = new File(dir);
    
    if (file.isDirectory())
        return file.list();
    return new String[0];
}

public float textLabel(Object c, float x, float y, color fg, color bg, float textSize) {
    String text = c.toString();
    float r = this.textWidth(text);
    
    this.fill(bg);
    this.rect(x, y - textSize, r, textSize);
    
    this.fill(fg);
    this.text(text, x, y);
    
    return r;
}
