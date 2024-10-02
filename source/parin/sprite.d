// ---
// Copyright 2024 Alexandros F. G. Kapretsos
// SPDX-License-Identifier: MIT
// Email: alexandroskapretsos@gmail.com
// Project: https://github.com/Kapendev/parin
// Version: v0.0.23
// ---

// TODO: Think about gaps in an atlas texture.
// TODO: Update all the doc comments here.

/// The `sprite` module provides a simple and flexible sprite.
module parin.sprite;

import parin.engine;

@safe:

struct SpriteAnimation {
    ubyte frameRow;
    ubyte frameCount = 1;
    ubyte frameSpeed = 6;
}

struct SpriteAnimationGroup2 {
    ubyte[2] frameRows;
    ubyte frameCount = 1;
    ubyte frameSpeed = 6;
    enum angleStep = 180.0f;

    @safe:

    SpriteAnimation pick(float angle) {
        auto id = (cast(int) round(snap(angle, angleStep) / angleStep)) % frameRows.length;
        return SpriteAnimation(frameRows[id], frameCount, frameSpeed);
    }
}

struct SpriteAnimationGroup4 {
    ubyte[4] frameRows;
    ubyte frameCount = 1;
    ubyte frameSpeed = 6;
    enum angleStep = 90.0f;

    @safe:

    SpriteAnimation pick(float angle) {
        // NOTE: This is a hack to make things look better in simple cases.
        auto hackAngle = cast(int) round(angle);
        if (hackAngle == 135) return SpriteAnimation(frameRows[1], frameCount, frameSpeed);
        if (hackAngle == -135) return SpriteAnimation(frameRows[3], frameCount, frameSpeed);

        auto id = (cast(int) round(snap(angle, angleStep) / angleStep)) % frameRows.length;
        return SpriteAnimation(frameRows[id], frameCount, frameSpeed);
    }
}

struct SpriteAnimationGroup8 {
    ubyte[8] frameRows;
    ubyte frameCount = 1;
    ubyte frameSpeed = 6;
    enum angleStep = 45.0f;

    @safe:

    SpriteAnimation pick(float angle) {
        auto id = (cast(int) round(snap(angle, angleStep) / angleStep)) % frameRows.length;
        return SpriteAnimation(frameRows[id], frameCount, frameSpeed);
    }
}

struct SpriteAnimationGroup16 {
    ubyte[16] frameRows;
    ubyte frameCount = 1;
    ubyte frameSpeed = 6;
    enum angleStep = 22.5f;

    @safe:

    SpriteAnimation pick(float angle) {
        auto id = (cast(int) round(snap(angle, angleStep) / angleStep)) % frameRows.length;
        return SpriteAnimation(frameRows[id], frameCount, frameSpeed);
    }
}

struct Sprite {
    int width;
    int height;
    ushort atlasLeft;
    ushort atlasTop;
    float frameProgress = 0.0f;
    SpriteAnimation animation;

    @safe:

    this(int width, int height, ushort atlasLeft, ushort atlasTop, SpriteAnimation animation = SpriteAnimation()) {
        this.width = width;
        this.height = height;
        this.atlasLeft = atlasLeft;
        this.atlasTop = atlasTop;
        this.animation = animation;
    }

    bool hasFirstFrame() {
        return frame == 0;
    }

    bool hasLastFrame() {
        return animation.frameCount != 0 ? (frame == animation.frameCount - 1) : true;
    }

    Vec2 size() {
        return Vec2(width, height);
    }

    int frame() {
        return cast(int) frameProgress;
    }

    void reset(int resetFrame = 0) {
        frameProgress = resetFrame;
    }

    void play(SpriteAnimation animation, bool canKeepFrame = false) {
        if (this.animation != animation) {
            if (!canKeepFrame) reset();
            this.animation = animation;
        }
    }

    void update(float dt) {
        if (animation.frameCount <= 1) return;
        frameProgress = fmod(frameProgress + animation.frameSpeed * dt, cast(float) animation.frameCount);
    }
}

void drawSprite(Texture texture, Sprite sprite, Vec2 position, DrawOptions options = DrawOptions()) {
    if (sprite.width == 0 || sprite.height == 0) return;

    auto top = sprite.atlasTop + sprite.animation.frameRow * sprite.height;
    auto gridWidth = max(texture.width - sprite.atlasLeft, 0) / sprite.width;
    auto gridHeight = max(texture.height - top, 0) / sprite.height;
    if (gridWidth == 0 || gridHeight == 0) {
        return;
    }
    auto row = sprite.frame / gridWidth;
    auto col = sprite.frame % gridWidth;
    auto area = Rect(sprite.atlasLeft + col * sprite.width, top + row * sprite.height, sprite.width, sprite.height);
    drawTextureArea(texture, area, position, options);
}

void drawSprite(TextureId texture, Sprite sprite, Vec2 position, DrawOptions options = DrawOptions()) {
    drawSprite(texture.getOr(), sprite, position, options);
}