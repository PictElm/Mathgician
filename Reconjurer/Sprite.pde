public class Sprite {
    
    private PImage src;
    
    private int columnCount;
    private int rowCount;
    
    private int column;
    private int row;
    
    private int width;
    private int height;
    
    private int frameRate;
    private int frameCount;
    private long timeStamp;
    
    private float scaleX;
    private float scaleY;
    private float tilt;
    private boolean isFlippedHorizontal;
    private boolean isFlippedVertical;
    
    public Sprite(PImage frames, int columns, int rows, int framePerSecond) {
        this.src = frames;
        
        this.columnCount = columns;
        this.rowCount = rows;
        
        this.column = 0;
        this.row = 0;
        
        this.width = this.src.width / this.columnCount;
        this.height = this.src.height / this.rowCount;
        
        this.frameRate = framePerSecond;
        this.frameCount = 0;
        this.timeStamp = 0;
        
        this.scaleX = this.scaleY = 1f;
        this.tilt = 0f;
        this.isFlippedHorizontal = false;
        this.isFlippedVertical = false;
    }
    
    public Sprite(PImage frame) {
        this(frame, 1, 1, 0);
    }
    
    public Sprite setRow(int row) {
        this.row = row;
        return this;
    }
    
    public Sprite setScale(float scale) {
        this.scaleX = this.scaleY = scale;
        return this;
    }
    
    public Sprite setScale(float scaleX, float scaleY) {
        this.scaleX = scaleX;
        this.scaleY = scaleY;
        return this;
    }
    
    public Sprite setTilt(float tilt) {
        this.tilt = tilt;
        return this;
    }
    
    public Sprite setTilt(float tilt, boolean autoFlipHorizontal, boolean autoFlipVertical) {
        float r1 = tilt - this.tilt;
        float r2 = (tilt + TWO_PI) % TWO_PI - (this.tilt + TWO_PI) % TWO_PI;

        float finalAngle = (this.tilt + (min(abs(r1), abs(r2)) == abs(r2) ? r2 : r1) + TWO_PI) % TWO_PI;
        
        if (autoFlipHorizontal)
            this.setFlippedHorizontal(PI < finalAngle);
        if (autoFlipVertical)
            this.setFlippedVertical(HALF_PI < finalAngle && finalAngle < HALF_PI + PI);
        
        return this.setTilt(finalAngle);
    }
    
    public Sprite setFlippedHorizontal(boolean is) {
        this.isFlippedHorizontal = is;
        return this;
    }
    
    public Sprite setFlippedVertical(boolean is) {
        this.isFlippedVertical = is;
        return this;
    }
    
    public Sprite setFrameRate(int fps) {
        this.frameRate = fps;
        return this;
    }
    
    public float getTilt() {
        return this.tilt;
    }
    
    public float getWidth() {
        return this.width;
    }
    
    public float getHeight() {
        return this.height;
    }
    
    public void show(PApplet app, float x, float y, boolean matrix, Runnable inbetween) {
        if (0 < this.frameRate) {
            long current = app.millis();
            if (1000f / this.frameRate < current - this.timeStamp) {
                this.timeStamp = current;
                if (this.columnCount - 1 < ++this.column)
                    this.column = 0;
                this.frameCount++;
            }
        }
        
        if (matrix) app.pushMatrix();
        
        app.translate(x, y);
        app.scale(this.scaleX, this.scaleY);
        app.rotate(this.tilt);
        app.scale(this.isFlippedHorizontal ? -1 : 1, this.isFlippedVertical ? -1 : 1);
        
        app.imageMode(CENTER);
        app.image(this.src, 0, 0, this.width, this.height, this.width * this.column, this.height * this.row, this.width * (this.column + 1), this.height * (this.row + 1));
        app.imageMode(CORNER);
        
        if (inbetween != null) inbetween.run();
        
        if (matrix) app.popMatrix();
    }
    
    public void show(PApplet app, float x, float y, Runnable inbetween) {
        this.show(app, x, y, true, inbetween);
    }
    
    public void show(PApplet app, float x, float y) {
        this.show(app, x, y, true, null);
    }
    
}
