// ---
// Copyright 2024 Alexandros F. G. Kapretsos
// SPDX-License-Identifier: MIT
// Email: alexandroskapretsos@gmail.com
// Project: https://github.com/Kapendev/popka
// Version: v0.0.17
// ---

// TODO: Make a timer struct.
// TODO: Make a sprite struct.

// TODO: Think about toggle functions.
// TODO: Update setup script.
// TODO: Clean web script.

/// The `engine` module functions as a lightweight 2D game engine.
module popka.engine;

import rl = popka.rl;
public import joka;

@safe @nogc nothrow:

EngineState engineState;

/// A type representing flipping orientations.
enum Flip : ubyte {
    none, /// No flipping.
    x,    /// Flipped along the X-axis.
    y,    /// Flipped along the Y-axis.
    xy,   /// Flipped along both X and Y axes.
}

/// A type representing texture filtering modes.
enum Filter : ubyte {
    nearest, /// Nearest neighbor filtering (blocky).
    linear,  /// Bilinear filtering (smooth).
}

/// A type representing a limited set of keyboard keys.
enum Keyboard {
    a = rl.KEY_A,                 /// The A key.
    b = rl.KEY_B,                 /// The B key.
    c = rl.KEY_C,                 /// The C key.
    d = rl.KEY_D,                 /// The D key.
    e = rl.KEY_E,                 /// The E key.
    f = rl.KEY_F,                 /// The F key.
    g = rl.KEY_G,                 /// The G key.
    h = rl.KEY_H,                 /// The H key.
    i = rl.KEY_I,                 /// The I key.
    j = rl.KEY_J,                 /// The J key.
    k = rl.KEY_K,                 /// The K key.
    l = rl.KEY_L,                 /// The L key.
    m = rl.KEY_M,                 /// The M key.
    n = rl.KEY_N,                 /// The N key.
    o = rl.KEY_O,                 /// The O key.
    p = rl.KEY_P,                 /// The P key.
    q = rl.KEY_Q,                 /// The Q key.
    r = rl.KEY_R,                 /// The R key.
    s = rl.KEY_S,                 /// The S key.
    t = rl.KEY_T,                 /// The T key.
    u = rl.KEY_U,                 /// The U key.
    v = rl.KEY_V,                 /// The V key.
    w = rl.KEY_W,                 /// The W key.
    x = rl.KEY_X,                 /// The X key.
    y = rl.KEY_Y,                 /// The Y key.
    z = rl.KEY_Z,                 /// The Z key.
    n0 = rl.KEY_ZERO,             /// The 0 key.
    n1 = rl.KEY_ONE,              /// The 1 key.
    n2 = rl.KEY_TWO,              /// The 2 key.
    n3 = rl.KEY_THREE,            /// The 3 key.
    n4 = rl.KEY_FOUR,             /// The 4 key.
    n5 = rl.KEY_FIVE,             /// The 5 key.
    n6 = rl.KEY_SIX,              /// The 6 key.
    n7 = rl.KEY_SEVEN,            /// The 7 key.
    n8 = rl.KEY_EIGHT,            /// The 8 key.
    n9 = rl.KEY_NINE,             /// The 9 key.
    nn0 = rl.KEY_KP_0,            /// The 0 key on the numpad.
    nn1 = rl.KEY_KP_1,            /// The 1 key on the numpad.
    nn2 = rl.KEY_KP_2,            /// The 2 key on the numpad.
    nn3 = rl.KEY_KP_3,            /// The 3 key on the numpad.
    nn4 = rl.KEY_KP_4,            /// The 4 key on the numpad.
    nn5 = rl.KEY_KP_5,            /// The 5 key on the numpad.
    nn6 = rl.KEY_KP_6,            /// The 6 key on the numpad.
    nn7 = rl.KEY_KP_7,            /// The 7 key on the numpad.
    nn8 = rl.KEY_KP_8,            /// The 8 key on the numpad.
    nn9 = rl.KEY_KP_9,            /// The 9 key on the numpad.
    f1 = rl.KEY_F1,               /// The f1 key.
    f2 = rl.KEY_F2,               /// The f2 key.
    f3 = rl.KEY_F3,               /// The f3 key.
    f4 = rl.KEY_F4,               /// The f4 key.
    f5 = rl.KEY_F5,               /// The f5 key.
    f6 = rl.KEY_F6,               /// The f6 key.
    f7 = rl.KEY_F7,               /// The f7 key.
    f8 = rl.KEY_F8,               /// The f8 key.
    f9 = rl.KEY_F9,               /// The f9 key.
    f10 = rl.KEY_F10,             /// The f10 key.
    f11 = rl.KEY_F11,             /// The f11 key.
    f12 = rl.KEY_F12,             /// The f12 key.
    left = rl.KEY_LEFT,           /// The left arrow key.
    right = rl.KEY_RIGHT,         /// The right arrow key.
    up = rl.KEY_UP,               /// The up arrow key.
    down = rl.KEY_DOWN,           /// The down arrow key.
    esc = rl.KEY_ESCAPE,          /// The escape key.
    enter = rl.KEY_ENTER,         /// The enter key.
    tab = rl.KEY_TAB,             /// The tab key.
    space = rl.KEY_SPACE,         /// The space key.
    backspace = rl.KEY_BACKSPACE, /// THe backspace key.
    shift = rl.KEY_LEFT_SHIFT,    /// The left shift key.
    ctrl = rl.KEY_LEFT_CONTROL,   /// The left control key.
    alt = rl.KEY_LEFT_ALT,        /// The left alt key.
    win = rl.KEY_LEFT_SUPER,      /// The left windows/super/command key.
    insert = rl.KEY_INSERT,       /// The insert key.
    del = rl.KEY_DELETE,          /// The delete key.
    home = rl.KEY_HOME,           /// The home key.
    end = rl.KEY_END,             /// The end key.
    pageUp = rl.KEY_PAGE_UP,      /// The page up key.
    pageDown = rl.KEY_PAGE_DOWN,  /// The page down key.
}

/// A type representing a limited set of mouse keys.
enum Mouse {
    left = rl.MOUSE_BUTTON_LEFT,     /// The left mouse button.
    right = rl.MOUSE_BUTTON_RIGHT,   /// The right mouse button.
    middle = rl.MOUSE_BUTTON_MIDDLE, /// The middle mouse button.
}

/// A type representing a limited set of gamepad buttons.
enum Gamepad {
    left = rl.GAMEPAD_BUTTON_LEFT_FACE_LEFT,   /// The left button.
    right = rl.GAMEPAD_BUTTON_LEFT_FACE_RIGHT, /// The right button.
    up = rl.GAMEPAD_BUTTON_LEFT_FACE_UP,       /// The up button.
    down = rl.GAMEPAD_BUTTON_LEFT_FACE_DOWN,   /// The down button.
    y = rl.GAMEPAD_BUTTON_RIGHT_FACE_UP,       /// The Xbox y, PlayStation triangle and Nintendo x button.
    x = rl.GAMEPAD_BUTTON_RIGHT_FACE_RIGHT,    /// The Xbox x, PlayStation square and Nintendo y button.
    a = rl.GAMEPAD_BUTTON_RIGHT_FACE_DOWN,     /// The Xbox a, PlayStation cross and Nintendo b button.
    b = rl.GAMEPAD_BUTTON_RIGHT_FACE_LEFT,     /// The Xbox b, PlayStation circle and Nintendo a button.
    lt = rl.GAMEPAD_BUTTON_LEFT_TRIGGER_2,     /// The left trigger button.
    lb = rl.GAMEPAD_BUTTON_LEFT_TRIGGER_1,     /// The left bumper button.
    lsb = rl.GAMEPAD_BUTTON_LEFT_THUMB,        /// The left stick button.
    rt = rl.GAMEPAD_BUTTON_RIGHT_TRIGGER_2,    /// The right trigger button.
    rb = rl.GAMEPAD_BUTTON_RIGHT_TRIGGER_1,    /// The right bumper button.
    rsb = rl.GAMEPAD_BUTTON_RIGHT_THUMB,       /// The right stick button.
    back = rl.GAMEPAD_BUTTON_MIDDLE_LEFT,      /// The back button.
    start = rl.GAMEPAD_BUTTON_MIDDLE_RIGHT,    /// The start button.
    middle = rl.GAMEPAD_BUTTON_MIDDLE,         /// The middle button.
}

struct DrawOptions {
    Vec2 origin    = Vec2(0.0f);   /// The origin point of the drawn object.
    Vec2 scale     = Vec2(1.0f);   /// The scale of the drawn object.
    float rotation = 0.0f;         /// The rotation of the drawn object.
    Color color    = white;        /// The color of the drawn object.
    Hook hook      = Hook.topLeft; /// An value representing the origin point of the drawn object when origin is set to zero.
    Flip flip      = Flip.none;    /// An value representing flipping orientations.
}

struct Camera {
    Vec2 position;
    float rotation = 0.0f;
    float scale = 1.0f;
    bool isAttached;
    bool isCentered;

    @safe @nogc nothrow:

    this(Vec2 position) {
        this.position = position;
    }

    this(float x, float y) {
        this(Vec2(x, y));
    }

    Hook hook() {
        return isCentered ? Hook.center : Hook.topLeft;
    }

    void followPosition(Vec2 target, float delta = 120.0f) {
        position = position.moveTo(target, Vec2(delta * deltaTime));
    }

    void followPositionWithSlowdown(Vec2 target, float slowdown = 0.15f) {
        if (slowdown <= 0.0f) {
            position = target;
        } else {
            position = position.moveToWithSlowdown(target, Vec2(deltaTime), slowdown);
        }
    }

    void followScale(float target, float delta = 0.75f) {
        scale = scale.moveTo(target, delta * deltaTime);
    }

    void followScaleWithSlowdown(float target, float slowdown = 0.15f) {
        if (slowdown <= 0.0f) {
            scale = target;
        } else {
            scale = scale.moveToWithSlowdown(target, deltaTime, slowdown);
        }
    }

    @trusted
    void attach() {
        if (isAttached) {
            return;
        }
        isAttached = true;
        auto temp = this.toRl();
        if (isPixelPerfect) {
            temp.target.x = floor(temp.target.x);
            temp.target.y = floor(temp.target.y);
            temp.offset.x = floor(temp.offset.x);
            temp.offset.y = floor(temp.offset.y);
        }
        rl.BeginMode2D(temp);
    }

    @trusted
    void detach() {
        if (isAttached) {
            isAttached = false;
            rl.EndMode2D();
        }
    }
}

struct TextId {
    GenerationalIndex data;
    alias data this;

    @safe @nogc nothrow:

    bool isValid() {
        return data.value != 0 && engineState.resources.texts.has(data);
    }

    ref LStr get() {
        if (!isValid) {
            assert(0, "Index `{}` with generation `{}` does not exist.".format(data.value, data.generation));
        }
        return engineState.resources.texts[data];
    }

    LStr getOr() {
        return isValid ? get() : LStr();
    }

    void free() {
        if (engineState.resources.texts.has(data)) {
            engineState.resources.texts[data].free();
            engineState.resources.texts.remove(data);
            engineState.resources.textNames.remove(data);
        }
    }
}

struct Texture {
    rl.Texture2D data;
    Filter filter;

    @safe @nogc nothrow:

    /// Returns true if the texture has not been loaded.
    bool isEmpty() {
        return data.id <= 0;
    }

    /// Returns the width of the texture.
    int width() {
        return data.width;
    }

    /// Returns the height of the texture.
    int height() {
        return data.height;
    }

    /// Returns the size of the texture.
    Vec2 size() {
        return Vec2(width, height);
    }

    /// Set the filter mode of the texture.
    @trusted
    void setFilter(Filter value) {
        if (isEmpty) return;
        filter = value;
        rl.SetTextureFilter(data, value.toRl());
    }

    /// Frees the loaded image.
    /// If an image is already freed, then this function will do nothing.
    @trusted
    void free() {
        if (isEmpty) {
            return;
        }
        rl.UnloadTexture(data);
        this = Texture();
    }
}

// Note: Think about adding a tag to the resource ids. A tag could be used to free only some resources.
struct TextureId {
    GenerationalIndex data;
    alias data this;

    @safe @nogc nothrow:

    bool isValid() {
        return data.value != 0 && engineState.resources.textures.has(data);
    }

    ref Texture get() {
        if (!isValid) {
            assert(0, "Index `{}` with generation `{}` does not exist.".format(data.value, data.generation));
        }
        return engineState.resources.textures[data];
    }

    Texture getOr() {
        return isValid ? get() : Texture();
    }

    void free() {
        if (engineState.resources.textures.has(data)) {
            engineState.resources.textures[data].free();
            engineState.resources.textures.remove(data);
            engineState.resources.textureNames.remove(data);
        }
    }
}

struct Font {
    rl.Font data;
    Filter filter;
    int runeSpacing;
    int lineSpacing;

    @safe @nogc nothrow:

    /// Returns true if the font has not been loaded.
    bool isEmpty() {
        return data.texture.id <= 0;
    }

    /// Returns the size of the font.
    int size() {
        return data.baseSize;
    }

    /// Set the filter mode of the font.
    @trusted
    void setFilter(Filter value) {
        if (isEmpty) return;
        filter = value;
        rl.SetTextureFilter(data.texture, value.toRl());
    }

    @trusted
    void free() {
        if (isEmpty) {
            return;
        }
        rl.UnloadFont(data);
        this = Font();
    }
}

struct FontId {
    GenerationalIndex data;
    alias data this;

    @safe @nogc nothrow:

    bool isValid() {
        return data.value != 0 && engineState.resources.fonts.has(data);
    }

    ref Font get() {
        if (!isValid) {
            assert(0, "Index `{}` with generation `{}` does not exist.".format(data.value, data.generation));
        }
        return engineState.resources.fonts[data];
    }

    Font getOr() {
        return isValid ? get() : Font();
    }

    void free() {
        if (engineState.resources.fonts.has(data)) {
            engineState.resources.fonts[data].free();
            engineState.resources.fonts.remove(data);
            engineState.resources.fontNames.remove(data);
        }
    }
}

struct Sound {
    Variant!(rl.Sound, rl.Music) data;

    @safe @nogc nothrow:

    bool isSound() {
        return data.isKind!(rl.Sound);
    }

    bool isMusic() {
        return data.isKind!(rl.Music);
    }

    bool isEmpty() {
        if (isSound) {
            return data.get!(rl.Sound)().stream.sampleRate == 0;
        } else {
            return data.get!(rl.Music)().stream.sampleRate == 0;
        }
    }

    @trusted
    float time() {
        if (isSound) {
            return 0.0f;
        } else {
            return rl.GetMusicTimePlayed(data.get!(rl.Music)());
        }
    }

    @trusted
    float waitTime() {
        if (isSound) {
            return 0.0f;
        } else {
            return rl.GetMusicTimeLength(data.get!(rl.Music)());
        }
    }

    @trusted
    void setVolume(float value) {
        if (isSound) {
            rl.SetSoundVolume(data.get!(rl.Sound)(), value);
        } else {
            rl.SetMusicVolume(data.get!(rl.Music)(), value);
        }
    }

    @trusted
    void setPitch(float value) {
        if (isSound) {
            rl.SetSoundPitch(data.get!(rl.Sound)(), value);
        } else {
            rl.SetMusicPitch(data.get!(rl.Music)(), value);
        }
    }

    @trusted
    void setPan(float value) {
        if (isSound) {
            rl.SetSoundPan(data.get!(rl.Sound)(), value);
        } else {
            rl.SetMusicPan(data.get!(rl.Music)(), value);
        }
    }

    @trusted
    void free() {
        if (isEmpty) {
            return;
        }
        if (isSound) {
            rl.UnloadSound(data.get!(rl.Sound)());
        } else {
            rl.UnloadMusicStream(data.get!(rl.Music)());
        }
        this = Sound();
    }
}

struct SoundId {
    GenerationalIndex data;
    alias data this;

    @safe @nogc nothrow:

    bool isValid() {
        return data.value != 0 && engineState.resources.sounds.has(data);
    }

    ref Sound get() {
        if (!isValid) {
            assert(0, "Index `{}` with generation `{}` does not exist.".format(data.value, data.generation));
        }
        return engineState.resources.sounds[data];
    }

    Sound getOr() {
        return isValid ? get() : Sound();
    }

    void free() {
        if (engineState.resources.sounds.has(data)) {
            engineState.resources.sounds[data].free();
            engineState.resources.sounds.remove(data);
            engineState.resources.soundNames.remove(data);
        }
    }
}

struct Viewport {
    rl.RenderTexture2D data;
    Filter filter;

    @safe @nogc nothrow:

    /// Returns true if the viewport has not been loaded.
    bool isEmpty() {
        return data.texture.id <= 0;
    }

    /// Returns the width of the viewport.
    int width() {
        return data.texture.width;
    }

    /// Returns the height of the viewport.
    int height() {
        return data.texture.height;
    }

    /// Returns the size of the viewport.
    Vec2 size() {
        return Vec2(width, height);
    }

    /// Set the filter mode of the viewport.
    @trusted
    void setFilter(Filter value) {
        if (isEmpty) return;
        filter = value;
        rl.SetTextureFilter(data.texture, value.toRl());
    }

    @trusted
    void free() {
        if (isEmpty) {
            return;
        }
        rl.UnloadRenderTexture(data);
        this = Viewport();
    }
}

struct EngineFlags {
    bool isUpdating;
    bool isPixelPerfect;
    bool isCursorHidden;
}

struct EngineFullscreenState {
    int lastWindowWidth;
    int lastWindowHeight;
    float toggleTimer = toggleTimerDuration;

    enum toggleTimerDuration = 0.1f;

    @safe @nogc nothrow:

    bool isToggleTimerRunning() {
        return toggleTimer != toggleTimerDuration;
    }

    bool hasToggleTimerEnded() {
        return toggleTimer == toggleTimerDuration;
    }

    void startToggleTimer() {
        toggleTimer = 0.0f;
    }

    void endToggleTimer() {
        toggleTimer = toggleTimerDuration;
    }

    void updateToggleTimer() {
        toggleTimer = min(toggleTimer + deltaTime, toggleTimerDuration);
    }
}

struct EngineResources {
    GenerationalList!LStr textNames;
    GenerationalList!LStr texts;

    GenerationalList!LStr textureNames;
    GenerationalList!Texture textures;

    GenerationalList!LStr fontNames;
    GenerationalList!Font fonts;

    GenerationalList!LStr soundNames;
    GenerationalList!Sound sounds;

    @safe @nogc nothrow:

    void free() {
        foreach (name; textNames.items) {
            name.free();
        }
        textNames.free();
        foreach (ref text; texts.items) {
            text.free();
        }
        texts.free();

        foreach (name; textureNames.items) {
            name.free();
        }
        textureNames.free();
        foreach (ref texture; textures.items) {
            texture.free();
        }
        textures.free();

        foreach (name; fontNames.items) {
            name.free();
        }
        fontNames.free();
        foreach (ref font; fonts.items) {
            font.free();
        }
        fonts.free();

        foreach (name; soundNames.items) {
            name.free();
        }
        soundNames.free();
        foreach (ref sound; sounds.items) {
            sound.free();
        }
        sounds.free();
    }
}

struct EngineViewport {
    Viewport data;
    int targetWidth;
    int targetHeight;
    alias data this;

    @safe @nogc nothrow:

    bool isLocking() {
        return (targetWidth != 0 && targetHeight != 0) && (data.width != targetWidth && data.height != targetHeight);
    }

    bool isUnlocking() {
        return (targetWidth == 0 && targetHeight == 0) && (!data.isEmpty);
    }

    void startLocking(int width, int height) {
        targetWidth = width;
        targetHeight = height;
    }

    void startUnlocking() {
        targetWidth = 0;
        targetHeight = 0;
    }
}

struct EngineState {
    EngineFlags flags;
    EngineFullscreenState fullscreenState;
    EngineViewport viewport;
    EngineResources resources;

    LStr tempText;
    LStr assetsPath;

    Color backgroundColor;
    ulong tickCount;

    @safe @nogc nothrow:

    void free() {
        viewport.free();
        resources.free();
        tempText.free();
        assetsPath.free();
        this = EngineState();
    }
}

/// Converts a raylib color to a Popka color.
Color toPopka(rl.Color from) {
    return Color(from.r, from.g, from.b, from.a);
}

/// Converts a raylib vector to a Popka vector.
Vec2 toPopka(rl.Vector2 from) {
    return Vec2(from.x, from.y);
}

/// Converts a raylib vector to a Popka vector.
Vec3 toPopka(rl.Vector3 from) {
    return Vec3(from.x, from.y, from.z);
}

/// Converts a raylib vector to a Popka vector.
Vec4 toPopka(rl.Vector4 from) {
    return Vec4(from.x, from.y, from.z, from.w);
}

/// Converts a raylib rectangle to a Popka rectangle.
Rect toPopka(rl.Rectangle from) {
    return Rect(from.x, from.y, from.width, from.height);
}

/// Converts a raylib texture to a Popka texture.
Texture toPopka(rl.Texture2D from) {
    auto result = Texture();
    result.data = from;
    return result;
}

/// Converts a raylib font to a Popka font.
Font toPopka(rl.Font from) {
    auto result = Font();
    result.data = from;
    return result;
}

/// Converts a raylib render texture to a Popka viewport.
Viewport toPopka(rl.RenderTexture2D from) {
    auto result = Viewport();
    result.data = from;
    return result;
}

/// Converts a Popka color to a raylib color.
rl.Color toRl(Color from) {
    return rl.Color(from.r, from.g, from.b, from.a);
}

/// Converts a Popka vector to a raylib vector.
rl.Vector2 toRl(Vec2 from) {
    return rl.Vector2(from.x, from.y);
}

/// Converts a Popka vector to a raylib vector.
rl.Vector3 toRl(Vec3 from) {
    return rl.Vector3(from.x, from.y, from.z);
}

/// Converts a Popka vector to a raylib vector.
rl.Vector4 toRl(Vec4 from) {
    return rl.Vector4(from.x, from.y, from.z, from.w);
}

/// Converts a Popka rectangle to a raylib rectangle.
rl.Rectangle toRl(Rect from) {
    return rl.Rectangle(from.position.x, from.position.y, from.size.x, from.size.y);
}

/// Converts a Popka texture to a raylib texture.
rl.Texture2D toRl(Texture from) {
    return from.data;
}

/// Converts a Popka font to a raylib font.
rl.Font toRl(Font from) {
    return from.data;
}

/// Converts a Popka viewport to a raylib render texture.
rl.RenderTexture2D toRl(Viewport from) {
    return from.data;
}

/// Converts a Popka filter to a raylib filter.
int toRl(Filter filter) {
    final switch (filter) {
        case Filter.nearest: return rl.TEXTURE_FILTER_POINT;
        case Filter.linear: return rl.TEXTURE_FILTER_BILINEAR;
    }
}

rl.Camera2D toRl(Camera camera) {
    return rl.Camera2D(
        Rect(resolution).origin(camera.isCentered ? Hook.center : Hook.topLeft).toRl(),
        camera.position.toRl(),
        camera.rotation,
        camera.scale,
    );
}

/// Returns the opposite flip value.
/// The opposite of every flip value except none is none.
/// The fallback value is returned if the flip value is none.
Flip opposite(Flip flip, Flip fallback) {
    if (flip == fallback) {
        return Flip.none;
    } else {
        return fallback;
    }
}

/// Returns a random integer between 0 and int.max (inclusive).
@trusted
int randi() {
    return rl.GetRandomValue(0, int.max);
}

/// Returns a random floating point number between 0.0f and 1.0f (inclusive).
@trusted
float randf() {
    return rl.GetRandomValue(0, cast(int) float.max) / cast(float) cast(int) float.max;
}

/// Sets the seed of the random number generator to the given value.
@trusted
void randomize(int seed) {
    rl.SetRandomSeed(seed);
}

/// Randomizes the seed of the random number generator.
void randomize() {
    randomize(randi);
}

/// Converts a world position to a screen position based on the given camera.
@trusted
Vec2 toScreenPosition(Vec2 position, Camera camera) {
    return toPopka(rl.GetWorldToScreen2D(position.toRl(), camera.toRl()));
}

/// Converts a screen position to a world position based on the given camera.
@trusted
Vec2 toWorldPosition(Vec2 position, Camera camera) {
    return toPopka(rl.GetScreenToWorld2D(position.toRl(), camera.toRl()));
}

/// Returns the default Popka font. This font should not be freed.
@trusted
Font engineFont() {
    auto result = rl.GetFontDefault().toPopka();
    result.runeSpacing = 1;
    result.lineSpacing = 14;
    return result;
}

/// Returns an absolute path to the assets folder.
IStr assetsPath() {
    return engineState.assetsPath.items;
}

IStr toAssetsPath(IStr path) {
    return pathConcat(assetsPath, path).pathFormat();
}

/// Loads a text file from the assets folder and returns its contents as a slice.
/// The slice can be safely used until this function is called again.
/// Can handle both forward slashes and backslashes in file paths.
Result!IStr loadTempText(IStr path) {
    auto fault = readTextIntoBuffer(path.toAssetsPath(), engineState.tempText);
    return Result!IStr(engineState.tempText.items, fault);
}

Result!LStr loadRawText(IStr path) {
    return readText(path.toAssetsPath());
}

/// Loads a text file from the assets folder and returns its contents as a list.
/// Can handle both forward slashes and backslashes in file paths.
Result!TextId loadText(IStr path) {
    if (engineState.resources.textNames.length == 0) {
        engineState.resources.textNames.append(LStr());
        engineState.resources.texts.append(LStr());
    }

    foreach (id; engineState.resources.textNames.ids) {
        if (engineState.resources.textNames[id] == path) {
            return Result!TextId(TextId(id));
        }
    }

    auto result = loadRawText(path);
    if (result.isSome) {
        engineState.resources.textNames.append(LStr(path));
        return Result!TextId(TextId(engineState.resources.texts.append(result.unwrap())));
    } else {
        return Result!TextId(Fault.cantFind);
    }
}

/// Loads an image file (PNG) from the assets folder.
/// Can handle both forward slashes and backslashes in file paths.
@trusted
Result!Texture loadRawTexture(IStr path) {
    auto value = rl.LoadTexture(path.toAssetsPath().toCStr().unwrapOr()).toPopka();
    return Result!Texture(value, value.isEmpty.toFault(Fault.cantFind));
}

Result!TextureId loadTexture(IStr path) {
    if (engineState.resources.textureNames.length == 0) {
        engineState.resources.textureNames.append(LStr());
        engineState.resources.textures.append(Texture());
    }

    foreach (id; engineState.resources.textureNames.ids) {
        if (engineState.resources.textureNames[id] == path) {
            return Result!TextureId(TextureId(id));
        }
    }

    auto result = loadRawTexture(path);
    if (result.isSome) {
        engineState.resources.textureNames.append(LStr(path));
        return Result!TextureId(TextureId(engineState.resources.textures.append(result.unwrap())));
    } else {
        return Result!TextureId(Fault.cantFind);
    }
}

/// Loads a font file (TTF) from the assets folder.
/// Can handle both forward slashes and backslashes in file paths.
@trusted
Result!Font loadRawFont(IStr path, uint size, const(dchar)[] runes = []) {
    auto value = rl.LoadFontEx(path.toAssetsPath().toCStr().unwrapOr(), size, cast(int*) runes.ptr, cast(int) runes.length).toPopka();
    if (value.data.texture.id == engineFont.data.texture.id) {
        value = Font();
    }
    return Result!Font(value, value.isEmpty.toFault(Fault.cantFind));
}

Result!FontId loadFont(IStr path, uint size, const(dchar)[] runes = []) {
    if (engineState.resources.fontNames.length == 0) {
        engineState.resources.fontNames.append(LStr());
        engineState.resources.fonts.append(Font());
    }

    foreach (id; engineState.resources.fontNames.ids) {
        if (engineState.resources.fontNames[id] == path) {
            return Result!FontId(FontId(id));
        }
    }

    auto result = loadRawFont(path, size, runes);
    if (result.isSome) {
        return Result!FontId(FontId(engineState.resources.fonts.append(result.unwrap())));
    } else {
        return Result!FontId(Fault.cantFind);
    }
}

/// Loads a sound file (WAV, OGG, MP3) from the assets folder.
/// Can handle both forward slashes and backslashes in file paths.
@trusted
Result!Sound loadRawSound(IStr path) {
    auto value = Sound();
    if (path.endsWith(".wav")) {
        value.data = rl.LoadSound(path.toAssetsPath().toCStr().unwrapOr());
    } else {
        value.data = rl.LoadMusicStream(path.toAssetsPath().toCStr().unwrapOr());
    }
    return Result!Sound(value, value.isEmpty.toFault(Fault.cantFind));
}

Result!SoundId loadSound(IStr path) {
    if (engineState.resources.soundNames.length == 0) {
        engineState.resources.soundNames.append(LStr());
        engineState.resources.sounds.append(Sound());
    }

    foreach (id; engineState.resources.soundNames.ids) {
        if (engineState.resources.soundNames[id] == path) {
            return Result!SoundId(SoundId(id));
        }
    }

    auto result = loadRawSound(path);
    if (result.isSome) {
        return Result!SoundId(SoundId(engineState.resources.sounds.append(result.unwrap())));
    } else {
        return Result!SoundId(Fault.cantFind);
    }
}

@trusted
Result!Viewport loadRawViewport(int width, int height) {
    auto value = rl.LoadRenderTexture(width, height).toPopka();
    return Result!Viewport(value, value.isEmpty.toFault());
}

/// Saves a text file to the assets folder.
/// Can handle both forward slashes and backslashes in file paths.
Fault saveText(IStr path, IStr text) {
    return writeText(path.toAssetsPath(), text);
}

void freeResources() {
    engineState.resources.free();
}

/// Opens a window with the given size and title.
/// You should avoid calling this function manually.
@trusted
void openWindow(int width, int height, IStr title = "Popka") {
    if (rl.IsWindowReady) {
        return;
    }
    rl.SetConfigFlags(rl.FLAG_WINDOW_RESIZABLE | rl.FLAG_VSYNC_HINT);
    rl.SetTraceLogLevel(rl.LOG_ERROR);
    rl.InitWindow(width, height, title.toCStr().unwrapOr());
    rl.InitAudioDevice();
    rl.SetExitKey(rl.KEY_NULL);
    rl.SetTargetFPS(60);
    engineState.backgroundColor = gray2;
    engineState.fullscreenState.lastWindowWidth = width;
    engineState.fullscreenState.lastWindowHeight = height;
}

/// Updates the window every frame with the given loop function.
/// This function will return when the loop function returns true.
/// You should avoid calling this function manually.
@trusted
void updateWindow(bool function(float dt) updateFunc) {
    static bool function(float _dt) @trusted @nogc nothrow _updateFunc;

    @trusted @nogc nothrow
    static bool _updateWindow() {
        // Begin drawing.
        if (isResolutionLocked) {
            rl.BeginTextureMode(engineState.viewport.toRl());
        } else {
            rl.BeginDrawing();
        }
        rl.ClearBackground(engineState.backgroundColor.toRl());

        // The main loop.
        auto result = _updateFunc(deltaTime);
        engineState.tickCount = (engineState.tickCount + 1) % typeof(engineState.tickCount).max;

        // End drawing.
        if (isResolutionLocked) {
            auto minSize = engineState.viewport.size;
            auto maxSize = windowSize;

            auto ratio = maxSize / minSize;
            auto minRatio = min(ratio.x, ratio.y);

            auto targetSize = minSize * Vec2(minRatio);
            auto targetPosition = maxSize * Vec2(0.5f) - targetSize * Vec2(0.5f);

            rl.EndTextureMode();
            rl.BeginDrawing();
            rl.ClearBackground(rl.Color(0, 0, 0, 255));
            rl.DrawTexturePro(
                engineState.viewport.toRl().texture,
                rl.Rectangle(0.0f, 0.0f, minSize.x, -minSize.y),
                rl.Rectangle(
                    floor(targetPosition.x),
                    floor(targetPosition.y),
                    ratio.x == minRatio ? targetSize.x : floor(targetSize.x),
                    ratio.y == minRatio ? targetSize.y : floor(targetSize.y),
                ),
                rl.Vector2(0.0f, 0.0f),
                0.0f,
                rl.Color(255, 255, 255, 255),
            );
            rl.EndDrawing();
        } else {
            rl.EndDrawing();
        }

        // Main viewport code.
        if (engineState.viewport.isLocking) {
            engineState.viewport.free();
            engineState.viewport.data = loadRawViewport(engineState.viewport.targetWidth, engineState.viewport.targetHeight).unwrapOr();
        } else if (engineState.viewport.isUnlocking) {
            engineState.viewport.free();
        }

        // Fullscreen code to fix a bug on Linux.
        if (engineState.fullscreenState.isToggleTimerRunning) {
            engineState.fullscreenState.updateToggleTimer();
            if (engineState.fullscreenState.hasToggleTimerEnded) {
                if (isFullscreen) {
                    rl.ToggleFullscreen();
                    rl.SetWindowSize(
                        engineState.fullscreenState.lastWindowWidth,
                        engineState.fullscreenState.lastWindowHeight,
                    );
                    rl.SetWindowPosition(
                        cast(int) (screenWidth * 0.5f - engineState.fullscreenState.lastWindowWidth * 0.5f),
                        cast(int) (screenHeight * 0.5f - engineState.fullscreenState.lastWindowHeight * 0.5f),
                    );
                } else {
                    rl.ToggleFullscreen();
                }
            }
        }

        return result;
    }

    // Maybe bad idea, but makes life of no-attribute people easier.
    _updateFunc = cast(bool function(float _dt) @trusted @nogc nothrow) updateFunc;
    engineState.flags.isUpdating = true;

    version(WebAssembly) {
        static void _updateWindowWeb() {
            if (_updateWindow()) {
                engineState.flags.isUpdating = false;
                rl.emscripten_cancel_main_loop();
            }
        }
        rl.emscripten_set_main_loop(&_updateWindowWeb, 0, 1);
    } else {
        while (true) {
            if (rl.WindowShouldClose() || _updateWindow()) {
                engineState.flags.isUpdating = false;
                break;
            }
        }
    }
}

/// Closes the window.
/// You should avoid calling this function manually.
@trusted
void closeWindow() {
    if (!rl.IsWindowReady) {
        return;
    }
    
    engineState.free();
    rl.CloseAudioDevice();
    rl.CloseWindow();
}

/// Sets the window background color to the given color.
void setBackgroundColor(Color value) {
    engineState.backgroundColor = value;
}

@trusted
void setMasterVolume(float value) {
    rl.SetMasterVolume(value);
}

@trusted
float masterVolume() {
    return rl.GetMasterVolume();
}

/// Returns true if the resolution is locked.
bool isResolutionLocked() {
    return !engineState.viewport.isEmpty;
}

/// Locks the resolution to the given value.
@trusted
void lockResolution(int width, int height) {
    engineState.viewport.startLocking(width, height);
    if (!engineState.flags.isUpdating) {
        engineState.viewport.free();
        engineState.viewport.data = loadRawViewport(width, height).unwrap();
    }
}

/// Unlocks the resolution.
void unlockResolution() {
    engineState.viewport.startUnlocking();
    if (!engineState.flags.isUpdating) {
        engineState.viewport.free();
    }
}

void toggleResolution(int width, int height) {
    if (isResolutionLocked) {
        unlockResolution();
    } else {
        lockResolution(width, height);
    }
}

/// Returns true if the system cursor is hidden.
bool isCursorHidden() {
    return engineState.flags.isCursorHidden;
}

/// Hides the system cursor.
@trusted
void hideCursor() {
    engineState.flags.isCursorHidden = true;
    rl.HideCursor();
}

/// Shows the system cursor.
@trusted
void showCursor() {
    engineState.flags.isCursorHidden = false;
    rl.ShowCursor();
}

void toggleCursor() {
    if (isCursorHidden) {
        showCursor();
    } else {
        hideCursor();
    }
}

/// Returns true if the window is in fullscreen mode.
@trusted
bool isFullscreen() {
    return rl.IsWindowFullscreen();
}

/// Changes the state of the fullscreen mode of the window.
@trusted
void toggleFullscreen() {
    version(WebAssembly) {

    } else {
        // Fullscreen code to fix a bug on Linux.
        if (!isFullscreen) {
            engineState.fullscreenState.lastWindowWidth = windowWidth;
            engineState.fullscreenState.lastWindowHeight = windowHeight;
            rl.SetWindowPosition(0, 0);
            rl.SetWindowSize(screenWidth, screenHeight);
        }
        engineState.fullscreenState.startToggleTimer();
    }
}

/// Returns true if the drawing is done in a pixel perfect way.
bool isPixelPerfect() {
    return engineState.flags.isPixelPerfect;
}

/// Changes the state of the pixel perfect mode of the window.
void togglePixelPerfect() {
    engineState.flags.isPixelPerfect = !engineState.flags.isPixelPerfect;
}

@trusted
int screenWidth() {
    return rl.GetMonitorWidth(rl.GetCurrentMonitor());
}

@trusted
int screenHeight() {
    return rl.GetMonitorHeight(rl.GetCurrentMonitor());
}

Vec2 screenSize() {
    return Vec2(screenWidth, screenHeight);
}

@trusted
int windowWidth() {
    return rl.GetScreenWidth();
}

@trusted
int windowHeight() {
    return rl.GetScreenHeight();
}

Vec2 windowSize() {
    if (isFullscreen) {
        return screenSize;
    } else {
        return Vec2(windowWidth, windowHeight);
    }
}

int resolutionWidth() {
    if (isResolutionLocked) {
        return engineState.viewport.width;
    } else {
        return windowWidth;
    }
}

int resolutionHeight() {
    if (isResolutionLocked) {
        return engineState.viewport.height;
    } else {
        return windowHeight;
    }
}

Vec2 resolution() {
    return Vec2(resolutionWidth, resolutionHeight);
}

@trusted
Vec2 mouseScreenPosition() {
    if (isResolutionLocked) {
        auto window = windowSize;
        auto minRatio = min(window.x / engineState.viewport.size.x, window.y / engineState.viewport.size.y);
        auto targetSize = engineState.viewport.size * Vec2(minRatio);
        // We use touch because it works on desktop, web and mobile.
        return Vec2(
            (rl.GetTouchX() - (window.x - targetSize.x) * 0.5f) / minRatio,
            (rl.GetTouchY() - (window.y - targetSize.y) * 0.5f) / minRatio,
        );
    } else {
        return Vec2(rl.GetTouchX(), rl.GetTouchY());
    }
}

Vec2 mouseWorldPosition(Camera camera) {
    return mouseScreenPosition.toWorldPosition(camera);
}

@trusted
float mouseWheel() {
    return rl.GetMouseWheelMove();
}

@trusted
int fps() {
    return rl.GetFPS();
}

@trusted
double elapsedTime() {
    return rl.GetTime();
}

long elapsedTickCount() {
    return engineState.tickCount;
}

@trusted
float deltaTime() {
    return rl.GetFrameTime();
}

@trusted
Vec2 deltaMouse() {
    return toPopka(rl.GetMouseDelta());
}

@trusted
Vec2 measureTextSize(Font font, IStr text, DrawOptions options = DrawOptions()) {
    if (font.isEmpty || text.length == 0) {
        return Vec2();
    }
    auto result = Vec2();
    auto tempByteCounter = 0; // Used to count longer text line num chars.
    auto byteCounter = 0;
    auto textWidth = 0.0f;
    auto tempTextWidth = 0.0f; // Used to count longer text line width.
    auto textHeight = font.size;

    auto letter = 0; // Current character.
    auto index = 0; // Index position in texture font.
    auto i = 0;
    while (i < text.length) {
        byteCounter += 1;

        auto next = 0;
        letter = rl.GetCodepointNext(&text[i], &next);
        index = rl.GetGlyphIndex(font.data, letter);
        i += next;
        if (letter != '\n') {
            if (font.data.glyphs[index].advanceX != 0) {
                textWidth += font.data.glyphs[index].advanceX;
            } else {
                textWidth += font.data.recs[index].width + font.data.glyphs[index].offsetX;
            }
        } else {
            if (tempTextWidth < textWidth) {
                tempTextWidth = textWidth;
            }
            byteCounter = 0;
            textWidth = 0;
            textHeight += font.lineSpacing;
        }
        if (tempByteCounter < byteCounter) {
            tempByteCounter = byteCounter;
        }
    }
    if (tempTextWidth < textWidth) {
        tempTextWidth = textWidth;
    }
    result.x = floor(tempTextWidth * options.scale.x + ((tempByteCounter - 1) * font.runeSpacing * options.scale.x));
    result.y = floor(textHeight * options.scale.y);
    return result;
}

@trusted
bool isPressed(char key) {
    return rl.IsKeyPressed(toUpper(key));
}

@trusted
bool isPressed(Keyboard key) {
    return rl.IsKeyPressed(key);
}

@trusted
bool isPressed(Mouse key) {
    return rl.IsMouseButtonPressed(key);
}

@trusted
bool isPressed(Gamepad key, int id = 0) {
    return rl.IsGamepadButtonPressed(id, key);
}

@trusted
bool isDown(char key) {
    return rl.IsKeyDown(toUpper(key));
}

@trusted
bool isDown(Keyboard key) {
    return rl.IsKeyDown(key);
}

@trusted
bool isDown(Mouse key) {
    return rl.IsMouseButtonDown(key);
}

@trusted
bool isDown(Gamepad key, int id = 0) {
    return rl.IsGamepadButtonDown(id, key);
}

@trusted
bool isReleased(char key) {
    return rl.IsKeyReleased(toUpper(key));
}

@trusted
bool isReleased(Keyboard key) {
    return rl.IsKeyReleased(key);
}

@trusted
bool isReleased(Mouse key) {
    return rl.IsMouseButtonReleased(key);
}

@trusted
bool isReleased(Gamepad key, int id = 0) {
    return rl.IsGamepadButtonReleased(id, key);
}

Vec2 wasd() {
    auto result = Vec2();
    if (Keyboard.a.isDown || Keyboard.left.isDown) {
        result.x = -1.0f;
    }
    if (Keyboard.d.isDown || Keyboard.right.isDown) {
        result.x = 1.0f;
    }
    if (Keyboard.w.isDown || Keyboard.up.isDown) {
        result.y = -1.0f;
    }
    if (Keyboard.s.isDown || Keyboard.down.isDown) {
        result.y = 1.0f;
    }
    return result;
}

@trusted
void playSound(Sound sound) {
    if (sound.isEmpty) {
        return;
    }

    if (sound.isSound) {
        rl.PlaySound(sound.data.get!(rl.Sound)());
    } else {
        rl.PlayMusicStream(sound.data.get!(rl.Music)());
    }
}

@trusted
void updateSound(Sound sound) {
    if (sound.isEmpty) {
        return;
    }

    if (sound.isMusic) {
        rl.UpdateMusicStream(sound.data.get!(rl.Music)());
    }
}

@trusted
void pauseSound(Sound sound) {
    if (sound.isEmpty) {
        return;
    }

    if (sound.isSound) {
        rl.PauseSound(sound.data.get!(rl.Sound)());
    } else {
        rl.PauseMusicStream(sound.data.get!(rl.Music)());
    }
}

@trusted
void resumeSound(Sound sound) {
    if (sound.isEmpty) {
        return;
    }

    if (sound.isSound) {
        rl.ResumeSound(sound.data.get!(rl.Sound)());
    } else {
        rl.ResumeMusicStream(sound.data.get!(rl.Music)());
    }
}

@trusted
void stopSound(Sound sound) {
    if (sound.isEmpty) {
        return;
    }

    if (sound.isSound) {
        rl.StopSound(sound.data.get!(rl.Sound)());
    } else {
        rl.StopMusicStream(sound.data.get!(rl.Music)());
    }
}

@trusted
void drawRect(Rect area, Color color = white) {
    if (isPixelPerfect) {
        rl.DrawRectanglePro(area.floor().toRl(), rl.Vector2(0.0f, 0.0f), 0.0f, color.toRl());
    } else {
        rl.DrawRectanglePro(area.toRl(), rl.Vector2(0.0f, 0.0f), 0.0f, color.toRl());
    }
}

void drawVec2(Vec2 point, float size, Color color = white) {
    drawRect(Rect(point, size, size).centerArea, color);
}

@trusted
void drawCirc(Circ area, Color color = white) {
    if (isPixelPerfect) {
        rl.DrawCircleV(area.position.floor().toRl(), area.radius, color.toRl());
    } else {
        rl.DrawCircleV(area.position.toRl(), area.radius, color.toRl());
    }
}

@trusted
void drawLine(Line area, float size, Color color = white) {
    if (isPixelPerfect) {
        rl.DrawLineEx(area.a.floor().toRl(), area.b.floor().toRl(), size, color.toRl());
    } else {
        rl.DrawLineEx(area.a.toRl(), area.b.toRl(), size, color.toRl());
    }
}

@trusted
void drawTexture(Texture texture, Vec2 position, Rect area, DrawOptions options = DrawOptions()) {
    if (texture.isEmpty) {
        return;
    } else if (area.size.x <= 0.0f || area.size.y <= 0.0f) {
        return;
    }

    auto target = Rect(position, area.size * options.scale.abs());
    auto flip = options.flip;
    if (options.scale.x < 0.0f && options.scale.y < 0.0f) {
        flip = opposite(flip, Flip.xy);
    } else if (options.scale.x < 0.0f) {
        flip = opposite(flip, Flip.x);
    } else if (options.scale.y < 0.0f) {
        flip = opposite(flip, Flip.y);
    }
    final switch (flip) {
        case Flip.none: break;
        case Flip.x: area.size.x *= -1.0f; break;
        case Flip.y: area.size.y *= -1.0f; break;
        case Flip.xy: area.size *= Vec2(-1.0f); break;
    }

    auto origin = options.origin == Vec2() ? target.origin(options.hook) : options.origin;
    if (isPixelPerfect) {
        rl.DrawTexturePro(
            texture.data,
            area.floor().toRl(),
            target.floor().toRl(),
            origin.floor().toRl(),
            options.rotation,
            options.color.toRl(),
        );
    } else {
        rl.DrawTexturePro(
            texture.data,
            area.toRl(),
            target.toRl(),
            origin.toRl(),
            options.rotation,
            options.color.toRl(),
        );
    }
}

void drawTexture(TextureId texture, Vec2 position, Rect area, DrawOptions options = DrawOptions()) {
    drawTexture(texture.getOr(), position, area, options);
}

void drawTexture(Texture texture, Vec2 position, DrawOptions options = DrawOptions()) {
    drawTexture(texture, position, Rect(texture.size), options);
}

void drawTexture(TextureId texture, Vec2 position, DrawOptions options = DrawOptions()) {
    drawTexture(texture.getOr(), position, options);
}

@trusted
void drawRune(Font font, Vec2 position, dchar rune, DrawOptions options = DrawOptions()) {
    if (font.isEmpty) {
        return;
    }

    auto rect = toPopka(rl.GetGlyphAtlasRec(font.data, rune));
    auto origin = options.origin == Vec2() ? rect.origin(options.hook) : options.origin;
    rl.rlPushMatrix();
    if (isPixelPerfect) {
        rl.rlTranslatef(position.x.floor(), position.y.floor(), 0.0f);
    } else {
        rl.rlTranslatef(position.x, position.y, 0.0f);
    }
    rl.rlRotatef(options.rotation, 0.0f, 0.0f, 1.0f);
    rl.rlScalef(options.scale.x, options.scale.y, 1.0f);
    if (isPixelPerfect) {
        rl.rlTranslatef(-origin.x.floor(), -origin.y.floor(), 0.0f);
    } else {
        rl.rlTranslatef(-origin.x, -origin.y, 0.0f);
    }
    rl.DrawTextCodepoint(font.data, rune, rl.Vector2(0.0f, 0.0f), font.size, options.color.toRl());
    rl.rlPopMatrix();
}

void drawRune(FontId font, Vec2 position, dchar rune, DrawOptions options = DrawOptions()) {
    drawRune(font.getOr(), position, rune, options);
}

@trusted
void drawText(Font font, Vec2 position, IStr text, DrawOptions options = DrawOptions()) {
    if (font.isEmpty || text.length == 0) {
        return;
    }

    // TODO: Make it work with negative scale values.
    auto origin = Rect(measureTextSize(font, text)).origin(options.hook);
    rl.rlPushMatrix();
    if (isPixelPerfect) {
        rl.rlTranslatef(floor(position.x), floor(position.y), 0.0f);
    } else {
        rl.rlTranslatef(position.x, position.y, 0.0f);
    }
    rl.rlRotatef(options.rotation, 0.0f, 0.0f, 1.0f);
    rl.rlScalef(options.scale.x, options.scale.y, 1.0f);
    if (isPixelPerfect) {
        rl.rlTranslatef(floor(-origin.x), floor(-origin.y), 0.0f);
    } else {
        rl.rlTranslatef(-origin.x, -origin.y, 0.0f);
    }
    auto textOffsetY = 0.0f; // Offset between lines (on linebreak '\n').
    auto textOffsetX = 0.0f; // Offset X to next character to draw.
    auto i = 0;
    while (i < text.length) {
        // Get next codepoint from byte string and glyph index in font.
        auto codepointByteCount = 0;
        auto codepoint = rl.GetCodepointNext(&text[i], &codepointByteCount);
        auto index = rl.GetGlyphIndex(font.data, codepoint);
        if (codepoint == '\n') {
            textOffsetY += font.lineSpacing;
            textOffsetX = 0.0f;
        } else {
            if (codepoint != ' ' && codepoint != '\t') {
                auto runeOptions = DrawOptions();
                runeOptions.color = options.color;
                drawRune(font, Vec2(textOffsetX, textOffsetY), codepoint, runeOptions);
            }
            if (font.data.glyphs[index].advanceX == 0) {
                textOffsetX += font.data.recs[index].width + font.runeSpacing;
            } else {
                textOffsetX += font.data.glyphs[index].advanceX + font.runeSpacing;
            }
        }
        // Move text bytes counter to next codepoint.
        i += codepointByteCount;
    }
    rl.rlPopMatrix();
}

void drawText(FontId font, Vec2 position, IStr text, DrawOptions options = DrawOptions()) {
    drawText(font.getOr(), position, text, options);
}

void drawDebugText(IStr text, Vec2 position = Vec2(8.0f), DrawOptions options = DrawOptions()) {
    drawText(engineFont, position, text, options);
}

mixin template runGame(alias readyFunc, alias updateFunc, alias finishFunc, int width = 960, int height = 540, IStr title = "Popka") {
    version (D_BetterC) {
        extern(C)
        void main(int argc, immutable(char)** argv) {
            engineState.assetsPath.append(
                pathConcat(argv[0].toStr().pathDir, "assets")
            );
            engineState.tempText.reserve(8192);
            openWindow(width, height);
            readyFunc();
            updateWindow(&updateFunc);
            finishFunc();
            closeWindow();
        }
    } else {
        void main(string[] args) {
            engineState.assetsPath.append(
                pathConcat(args[0].pathDir, "assets")
            );
            engineState.tempText.reserve(8192);
            openWindow(width, height);
            readyFunc();
            updateWindow(&updateFunc);
            finishFunc();
            closeWindow();
        }
    }
}