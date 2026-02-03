# LR-C

## What is this?
This is the patch that is required in order to use [LR-S](https://git.xeondev.com/LR/S).

## What does it do
First of all, it redirects all of the game requests to a local server. Second of all, it patches out the encryption, which LR-S doesn't implement ATM. As a bonus, it also disables the "censorship" mechanism (the one that makes character transparent when the camera is at certain angle.)

## Setup
You can get a prebuilt DLL for your game version in [releases](https://git.xeondev.com/LR/C/releases). If you don't want to use prebuilt binaries, you can compile it with `Zig 0.16.0-dev.2368`, running `zig build` will do the trick.

Next, you have to go to the game's directory and replace the `gfsdk.dll` file with the one you've got from this repository. That should be it, just run Endfield.exe. If a console with an ASCII art spawns, it works.
