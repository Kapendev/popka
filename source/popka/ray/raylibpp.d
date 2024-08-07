// Copyright 2024 Alexandros F. G. Kapretsos
// SPDX-License-Identifier: MIT

/// The raylibpp module contains helper functions to reduce some raylib boilerplate.

module popka.ray.raylibpp;

import popka.ray.raylib;

alias drawPixel                        = DrawPixel;
alias drawPixel                        = DrawPixelV;

alias drawLine                         = DrawLine;
alias drawLine                         = DrawLineV;
alias drawLine                         = DrawLineEx;
alias drawLineStrip                    = DrawLineStrip;
alias drawLineBezier                   = DrawLineBezier;

alias drawCircle                       = DrawCircle;
alias drawCircle                       = DrawCircleGradient;
alias drawCircle                       = DrawCircleV;
alias drawCircleSector                 = DrawCircleSector;
alias drawCircleSectorLines            = DrawCircleSectorLines;
alias drawCircleLines                  = DrawCircleLines;
alias drawCircleLines                  = DrawCircleLinesV;

alias drawEllipse                      = DrawEllipse;
alias drawEllipseLines                 = DrawEllipseLines;

alias drawRing                         = DrawRing;
alias drawRingLines                    = DrawRingLines;

alias drawRectangle                    = DrawRectangle;
alias drawRectangle                    = DrawRectangleV;
alias drawRectangle                    = DrawRectangleRec;
alias drawRectangle                    = DrawRectanglePro;
alias drawRectangleGradientV           = DrawRectangleGradientV;
alias drawRectangleGradientH           = DrawRectangleGradientH;
alias drawRectangleGradient            = DrawRectangleGradientEx;
alias drawRectangleLines               = DrawRectangleLines;
alias drawRectangleLines               = DrawRectangleLinesEx;
alias drawRectangleRounded             = DrawRectangleRounded;
alias drawRectangleRoundedLines        = DrawRectangleRoundedLines;

alias drawTriangle                     = DrawTriangle;
alias drawTriangleLines                = DrawTriangleLines;
alias drawTriangleFan                  = DrawTriangleFan;
alias drawTriangleStrip                = DrawTriangleStrip;
alias drawPoly                         = DrawPoly;
alias drawPolyLines                    = DrawPolyLines;
alias drawPolyLines                    = DrawPolyLinesEx;

alias drawSplineLinear                 = DrawSplineLinear;
alias drawSplineBasis                  = DrawSplineBasis;
alias drawSplineCatmullRom             = DrawSplineCatmullRom;
alias drawSplineBezierQuadratic        = DrawSplineBezierQuadratic;
alias drawSplineBezierCubic            = DrawSplineBezierCubic;
alias drawSplineSegmentLinear          = DrawSplineSegmentLinear;
alias drawSplineSegmentBasis           = DrawSplineSegmentBasis;
alias drawSplineSegmentCatmullRom      = DrawSplineSegmentCatmullRom;
alias drawSplineSegmentBezierQuadratic = DrawSplineSegmentBezierQuadratic;
alias drawSplineSegmentBezierCubic     = DrawSplineSegmentBezierCubic;

alias drawTexture = DrawTexture;
alias drawTexture = DrawTextureV;
alias drawTexture = DrawTextureEx;
alias drawTexture = DrawTextureRec;
alias drawTexture = DrawTexturePro;
alias drawTexture = DrawTextureNPatch;

alias drawFPS = DrawFPS;

@trusted @nogc nothrow
void drawText(const(char)[] text, float posX, float posY, float fontSize, Color color) {
    drawText(GetFontDefault(), text, Vector2(posX, posY), Vector2(0.0f, 0.0f), 0.0f, fontSize, 2.0f, color);
}

@trusted @nogc nothrow
void drawText(Font font, const(char)[] text, Vector2 position, float fontSize, float spacing, Color tint) {
    drawText(font, text, position, Vector2(0.0f, 0.0f), 0.0f, fontSize, spacing, tint);
}

@trusted @nogc nothrow
void drawText(Font font, const(char)[] text, Vector2 position, Vector2 origin, float rotation, float fontSize, float spacing, Color tint) {
    static char[1024] buffer = void;

    auto text2 = buffer[];
    foreach (i, c; text) {
        text2[i] = c;
    }
    text2[text.length] = '\0';

    DrawTextPro(font, text2.ptr, position, origin, rotation, fontSize, spacing, tint);
}

alias drawText = DrawTextCodepoint;

@trusted @nogc nothrow
void drawText(Font font, const(int)[] codepoints, Vector2 position, float fontSize, float spacing, Color tint) {
    DrawTextCodepoints(font, codepoints.ptr, cast(int) codepoints.length, position, fontSize, spacing, tint);
}

@trusted @nogc nothrow
float measureText(const(char)[] text, float fontSize) {
    return measureText(GetFontDefault(), text, fontSize, 2.0f).x;
}

@trusted @nogc nothrow
Vector2 measureText(Font font, const(char)[] text, float fontSize, float spacing) {
    static char[1024] buffer = void;

    auto text2 = buffer[];
    foreach (i, c; text) {
        text2[i] = c;
    }
    text2[text.length] = '\0';

    return MeasureTextEx(font, text2.ptr, fontSize, spacing);
}

alias drawLine3D          = DrawLine3D;
alias drawPoint3D         = DrawPoint3D;
alias drawCircle3D        = DrawCircle3D;

alias drawTriangle3D      = DrawTriangle3D;
alias drawTriangleStrip3D = DrawTriangleStrip3D;

alias drawCube            = DrawCube;
alias drawCube            = DrawCubeV;
alias drawCubeWires       = DrawCubeWires;
alias drawCubeWires       = DrawCubeWiresV;

alias drawSphere          = DrawSphere;
alias drawSphere          = DrawSphereEx;
alias drawSphereWires     = DrawSphereWires;

alias drawCylinder        = DrawCylinder;
alias drawCylinder        = DrawCylinderEx;
alias drawCylinderWires   = DrawCylinderWires;
alias drawCylinderWires   = DrawCylinderWiresEx;

alias drawCapsule         = DrawCapsule;
alias drawCapsuleWires    = DrawCapsuleWires;
alias drawPlane           = DrawPlane;
alias drawRay             = DrawRay;
alias drawGrid            = DrawGrid;

alias drawModel           = DrawModel;
alias drawModel           = DrawModelEx;
alias drawModelWires      = DrawModelWires;
alias drawModelWires      = DrawModelWiresEx;

alias drawBoundingBox     = DrawBoundingBox;

alias drawBillboard       = DrawBillboard;
alias drawBillboard       = DrawBillboardRec;
alias drawBillboard       = DrawBillboardPro;

alias drawMesh            = DrawMesh;
alias drawMeshInstanced   = DrawMeshInstanced;

void updateWindow(alias loopFunc)() {
    version(WebAssembly) {
        static void __loopFunc() {
            loopFunc();
        }
        emscripten_set_main_loop(&__loopFunc, 0, 1);
    } else {
        while (true) {
            if (WindowShouldClose || loopFunc()) {
                break;
            }
        }
    }
}

mixin template addRayStart(alias startFunc) {
    version (D_BetterC) {
        extern(C)
        void main(int argc, immutable(char)** argv) {
            @trusted @nogc nothrow
            static string __helper(immutable(char)* strz) {
                size_t length = 0;
                while (strz[length] != '\0') {
                    length += 1;
                }
                return strz[0 .. length];
            }
            startFunc(__helper(argv[0]));
        }
    } else {
        void main(string[] args) {
            startFunc(args[0]);
        }
    }
}

version (WebAssembly) {
    @nogc nothrow extern(C)
    void emscripten_set_main_loop(void* ptr, int fps, int loop);
    @nogc nothrow extern(C)
    void emscripten_cancel_main_loop();
}
