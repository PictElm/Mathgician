public Player player;

public ArrayList<Enemy> enemies;
public ArrayList<Spell> spells;

public PImage background;
public PImage foreground;

public static String operators = "";

public static IntList spawnDelayMin = new IntList();
public static IntList spawnDelayMax = new IntList();

public static IntList limitsOpsAMin = new IntList();
public static IntList limitsOpsAMax = new IntList();
public static IntList limitsOpsBMin = new IntList();
public static IntList limitsOpsBMax = new IntList();

public static boolean isSetBased = false;
public static ArrayList<StringList> csSet = new ArrayList(); //new StringList();

public static boolean isTraining = false;

public static final int WAVE_SIZE = 15;

public int nextSpawnDelay;
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
    Reconjurer.isSetBased = false;
    
    this.player = new Player();
    
    this.spells = new ArrayList();
    this.enemies = new ArrayList();
    //for (String name : this.loadStrings("levels/list.txt"))
    for (String name : this.loadFiles(sketchPath() + "/data/levels/"))
        if (name.contains(".txt")) {
            String tmp = name.substring(0, name.length() - 4).replace(' ', '_');
            this.enemies.add(new Enemy(3 * Enemy.BASE_HITBOX, random(TWO_PI), tmp, tmp));
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
    this.text(" Type the name of an enemy around you!", 0, this.height * .053f / 2f);
    this.text(" Press space to toggle training mode: " + (Reconjurer.isTraining ? "[on]" : "[off]"), 0, 2 * this.height * .053f / 2f);
    this.textSize(this.height * .053f);
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
    
    /*if (Reconjurer.WAVE_SIZE < this.strikes - 1) {
        this.inGame = false;
        this.inVictory = true;
        
        this.player.getSpell();
    }*/
    
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
    
    if (--this.nextSpawnDelay < 0 && this.strikes < Reconjurer.WAVE_SIZE && this.enemies.size() < 7) {
            this.enemies.add(new Enemy(7 * Enemy.BASE_HITBOX, random(TWO_PI), this.bossLevel));
            this.nextSpawnDelay = int(random(Reconjurer.spawnDelayMin.get(int(Reconjurer.spawnDelayMin.size() * float(this.strikes / Reconjurer.WAVE_SIZE))),
                                             Reconjurer.spawnDelayMax.get(int(Reconjurer.spawnDelayMax.size() * float(this.strikes / Reconjurer.WAVE_SIZE)))));
    }
    
    
    if (Reconjurer.WAVE_SIZE - 1 < this.strikes) {
        this.strikes = 0;
        this.enemies.add(new Enemy(8 * Enemy.BASE_HITBOX, random(TWO_PI), this.bossLevel, this.bossLevel++));
        this.nextSpawnDelay = 2 * Reconjurer.spawnDelayMax.get(0);
    } 
    
    this.translate(-this.width / 2f, -this.height / 2f);
    this.image(this.foreground, 0, (this.height - this.foreground.height) / 2f);
    
    this.fill(0);
    this.rect(0, 0, this.textWidth(" Strikes: " + this.strikes + " over " + Reconjurer.WAVE_SIZE), this.height * .053);
    this.rect(this.width - this.textWidth("Level: " + this.bossLevel), 0, this.textWidth("Level: " + this.bossLevel), this.height * .053);
    
    this.fill(255);
    this.text(" Strikes: " + this.strikes + " over " + Reconjurer.WAVE_SIZE, 0, this.height * .053f);
    this.text("Level: " + this.bossLevel, this.width - this.textWidth("Level: " + this.bossLevel), this.height * .053f);
    
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
            Reconjurer.isTraining = !Reconjurer.isTraining;
        else if (this.key != CODED)
            this.player.casting(this.key);
    }
}

public void loadLevel(String name) {
    this.bossLevel = 1;
    
    String[] data = loadStrings("levels/" + name + ".txt");
    
    for (String line : data) {
        if (line.charAt(0) == '_' && line.charAt(2) == ':') {
            
            switch (line.charAt(1)) {
                case '+':
                case '-':
                case 'x':
                case '/':
                        Reconjurer.operators+= line.charAt(1);
                        String[] limsOps = line.substring(3, line.length()).trim().split(";");
                        Reconjurer.limitsOpsAMin.append(int(limsOps[0].split(",")[0]));
                        Reconjurer.limitsOpsAMax.append(int(limsOps[0].split(",")[1]));
                        Reconjurer.limitsOpsBMin.append(int(limsOps[1].split(",")[0]));
                        Reconjurer.limitsOpsBMax.append(int(limsOps[1].split(",")[1]));
                    break;
                
                case 't':
                        String[] limsDly = line.substring(3, line.length()).trim().split(";");
                        for (int k = 0; k < limsDly.length; k++) {
                            Reconjurer.spawnDelayMin.append(int(limsDly[k].split(",")[0]));
                            Reconjurer.spawnDelayMax.append(int(limsDly[k].split(",")[1]));
                        }
                    break;
                    
                case 'l':
                        this.bossLevel = int(line.substring(3, line.length()));
                    break;
            }
            
        } else {
            Reconjurer.isSetBased = true;
            
            if (!line.contains(":"))
                line+= ":" + line;
            
            int length = Reconjurer.csSet.size();
            if (length < 1) {
                Reconjurer.csSet.add(new StringList());
                length++;
            }
            
            Reconjurer.csSet.get(length - 1).append(line);
            
            /*for (String l : line.substring(2, line.length()).split("&")) {
                StringList builder = new StringList();
                
                for (String q : l.split(";"))
                    builder.append(q);
                
                Reconjurer.csSet.add(builder);
            }*/
        }
    }
    
    this.inMenu = false;
    this.inGame = true;
    
    this.enemies = new ArrayList();
    this.spells = new ArrayList();
    
    if (Reconjurer.spawnDelayMin.size() * Reconjurer.spawnDelayMax.size() < 1)
        this.makeLevel(1);
    
    this.nextSpawnDelay = int(random(Reconjurer.spawnDelayMin.get(0), Reconjurer.spawnDelayMax.get(0)));
    this.strikes = 0;
    
    this.deathScreenKiller = null;
}

public void makeLevel(int love) { // -t:120,360;60,240;42,72
    int tmp = Reconjurer.csSet.size();
    if (tmp == 0)
        tmp = 1;
    
    for (int k = 0; k < tmp; k++) {
        Reconjurer.spawnDelayMin.append(new IntList(120, 60, 42));
        Reconjurer.spawnDelayMax.append(new IntList(360, 240, 72));
    }
}

public String[] loadFiles(String dir) {
    File file = new File(dir);
    
    if (file.isDirectory())
        return file.list();
    return new String[0];
}
