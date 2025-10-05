# 🍓 BerryLib

Berrylib is a LuaSTG library designed to be compatible with the most recent version of [LuaSTG-Sub](https://github.com/Legacy-LuaSTG-Engine/LuaSTG-Sub) and [LuaSTG-Flux](https://github.com/RulHolos/LuaSTG-Flux)

Its main goal is to be a solid replacement for [THlib](https://github.com/Legacy-LuaSTG-Engine/Bundle-After-Ex-Plus) which is now starting to get old and got recently archived. I wanted a more modern approach to an engine I love to death.

---

## 📥 Installing

Download BerryLib [from the Releases page](https://github.com/RulHolos/BerryLib/releases), extract it in your project folder, at the root of your engine executable.

Or,

You can clone do `git clone --recurse-submodules https://github.com/RulHolos/BerryLib.git` in a cmd at the root of your engine executable, if you have git installed.

And... that's it!

## 📂 Library Structure

The structure of BerryLib is the following:

launch # Required by Sub and Flux to setup the engine for your game<br>
berrylib/<br>
├─ core/ # Core utilities, screen management, plugins, objects, input, signals, ...<br>
├─ lib/ # Your game contents, bosses, players, ...<br>
├─ doc/ (submodule) # API documentation for Sub and Flux<br>
├─ util/ # Utilities like tweens, std, toml, tasks, ...<br>
└─ main.lua # Second entry point after the launch file<br>
game/ # Created at first launch, contains all your games data<br>
└─ game folder or zip<br>
assets/ # Contains all your game assets (images, music, ...)<br>
plugins/ # Plugins loaded by BerryLib to help with development or other things.

## 🛠 Features

The main features of BerryLib are the following:
- **Tweens**: Chainable tweens with easing functions, yoyo, repeats and more.
- **Event-based behaviours**: The core behaviour of BerryLib is based on Events and listeners.

---

## 📜 License

MIT License

Free to use, modify and share and no copyrighted material!

**!! Warning !!**<br>
While the license of library itself is MIT, BerryLib contains assets from Ryannlib. A license text file is included in the library with the respective owners of every assets.