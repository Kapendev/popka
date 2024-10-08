/// This example shows how to use the tile map structure of Parin.
import parin;

// The game variables.
auto atlas = TextureId();
auto tileMap = TileMap();

void ready() {
    lockResolution(320, 180);
    setBackgroundColor(toRgb(0x0b0b0b));
    // Load the `atlas.png` file from the assets folder.
    atlas = loadTexture("atlas.png");
    // Parse the tile map CSV file.
    tileMap.parse("145,0,65\n21,22,23\n37,38,39\n53,54,55", 16, 16);
}

bool update(float dt) {
    // Draw the tile map.
    drawTileMap(atlas, tileMap, Vec2(), Camera(), DrawOptions(Vec2(2)));
    return false;
}

void finish() { }

mixin runGame!(ready, update, finish);
