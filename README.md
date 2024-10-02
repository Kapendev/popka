# Parin

Parin is a lightweight and beginner-friendly 2D game engine for the D programming language.
It focuses on providing a simple foundation for building 2D games.

```d
import parin;

void ready() {
    lockResolution(320, 180);
}

bool update(float dt) {
    drawDebugText("Hello world!", Vec2(8));
    return false;
}

void finish() { }

mixin runGame!(ready, update, finish);
```

> [!WARNING]  
> This is alpha software. Use it only if you are very cool.

## Supported Platforms

* PC: Windows, Linux, macOS
* Web

## Games Made With Parin

* [Clean & Haunted](https://kapendev.itch.io/clean-haunted)
* [Runani](https://kapendev.itch.io/runani)
* [A Short Metamorphosis](https://kapendev.itch.io/a-short-metamorphosis)

## Installation

This guide shows how to install Parin and its dependencies using DUB.
While DUB simplifies the process, Parin itself doesn't require DUB.

Parin has the following dependencies:

* [Joka](https://github.com/Kapendev/joka): A simple nogc utility library.
* [raylib](https://github.com/raysan5/raylib): A simple graphics library.

### Installation Steps

Create a new folder and run inside the following commands:

```bash
dub init -n
dub run parin:setup
```

The final line modifies the default app.d and dub.json files, downloads raylib, and creates the necessary folders for Parin to function properly. The following folders will be created:

* assets: This folder is used to store game assets.
* web: This folder is used for exporting to the web.

Once the installation is complete, run the following command:

```bash
dub run
```

If everything is set up correctly, a window will appear showing the message "Hello world!".

## Documentation

For an initial understanding, the [examples](examples) folder can be a good starting point.
For a more detailed overview, check the [TOUR.md](TOUR.md) file.

## Attributes and BetterC Support

This project offers support for the `@safe` attribute and aims for good compatibility with BetterC.
If you encounter errors with BetterC, try using the `-i` flag.

## Web Support

To export a game to the web, the game must be compatible with BetterC.
The [web](web) folder contains a helper script to assist with the web export process.

It can be used with DUB by running the following command:

```bash
dub run parin:web
```

## Alternative Game Development Libraries

While Parin provides a good game development experience in D, it might not fit everyone's needs.
Here are some other notable alternatives to consider:

* [raylib-d](https://github.com/schveiguy/raylib-d)
* [HipremeEngine](https://github.com/MrcSnm/HipremeEngine)
* [PixelPerfectEngine](https://github.com/ZILtoid1991/pixelperfectengine)
* [Godot-DLang](https://github.com/godot-dlang/godot-dlang)

## Note

I add things to Parin when I need them.

## License

The project is released under the terms of the MIT License.
Please refer to the LICENSE file.
