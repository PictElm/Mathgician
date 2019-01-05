private static ArrayList<PImage> LOADED_IMAGES = new ArrayList();
private static ArrayList<String> LOADED_NAMES = new ArrayList();
private static int LOADED_COUNTER = 0;

public class Entity {
    
    protected PImage image;
    
    protected float hitbox;
    private boolean isDead;

    public Entity(String imageFileName, float hitboxSize) {
        int k;
        for (k = 0; k < Mathgician.LOADED_COUNTER; k++)
            if (Mathgician.LOADED_NAMES.get(k) == imageFileName)
                break;
        
        if (k == Mathgician.LOADED_COUNTER) {
            Mathgician.LOADED_IMAGES.add(loadImage(imageFileName));
            Mathgician.LOADED_NAMES.add(imageFileName);
            Mathgician.LOADED_COUNTER++;
        }
        
        this.image = Mathgician.LOADED_IMAGES.get(k);
        
        this.hitbox = hitboxSize;
        this.isDead = false;
    }
    
    public void show(Mathgician app) {
        app.pushMatrix();
        
        app.scale(this.hitbox / this.image.width, this.hitbox / this.image.height);
        app.translate(-this.image.width / 2, -this.image.height / 2);
        
        app.image(this.image, 0, 0);
        
        app.popMatrix();
    }
    
    public float getHitbox() {
        return this.hitbox;
    }
    
    public boolean isDead() {
        return this.isDead;
    }
    
    public void kill() {
        this.isDead = true;
    }
    
}
