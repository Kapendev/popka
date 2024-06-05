// Copyright 2024 Alexandros F. G. Kapretsos
// SPDX-License-Identifier: MIT

module popka.examples;

public import popka.examples.camera;
public import popka.examples.coins;
public import popka.examples.dialogue;
public import popka.examples.hello;
public import popka.examples.pong;

@safe @nogc nothrow:

void runEveryExample() {
    runHelloExample();
    runCoinsExample();
    runPongExample();
    runCameraExample();
    runDialogueExample();
}