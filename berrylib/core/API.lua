---@meta API

-- THlib export these API into global space
-- THlib 将这些 API 导出到全局

-- Function documentation made by RulHolos.

---base class of all classes
---@class lstg.object
---@field x number x position
---@field y number y position
---@field dx number x position difference from last update (read-only)
---@field dy number y position difference from last update (read-only)
---@field rot number Object orientation in degrees.
---@field omiga number Angular velocity of orientation.
---@field timer integer Frame timer.
---@field vx number x velocity.
---@field vy number y velocity.
---@field ax number x acceleration.
---@field ay number y acceleration.
---@field layer number Render layer. (see lib/Lobject.lua)
---@field group number Collision group. (see lib/Lobject.lua)
---@field hide boolean If true, the object will not be rendered.
---@field bound boolean If false, the object will not be taken into account for boundary checks.
---@field navi boolean If true, the object's `rot` will be updated according to velocity.
---@field colli boolean If false, the object will not be taken into account for collision checks.
---@field status "del"|"kill"|"normal" The current status of the object.
---@field hscale number Horizontal scale.
---@field vscale number Vertical scale.
---@field class any Class of the object.
---@field a number x collision.
---@field b number y collision.
---@field rect boolean If true, the collision box will be rectangular. Otherwise; circular or oval.
---@field img string Name of the renderable resource on the object.
---@field ani integer Animation timer (read_only)
---@field is_class boolean Always true.
---@field init fun(...)
---@field del fun(...)
---@field frame fun(...)
---@field render fun(...)
---@field kill fun(...)

---Represents a color object in ARGB format. Range is [0, 255]
---@class lstg.Color
---@overload fun(argb:number) : lstg.Color
---@overload fun(a:number, r:number, g:number, b:number)
---@field a number alpha component
---@field r number red component
---@field g number green component
---@field b number blue component
---@field ARGB fun(self:lstg.Color) : number, number, number, number Returns a, r, g, b components respectively
---@operator add(lstg.Color) : lstg.Color Adds two colors and returns the result.
---@operator sub(lstg.Color) : lstg.Color Substracts two colors and returns the result.
---@operator mul(lstg.Color) : lstg.Color Multiplies two colors together and returns the result.
---@operator div(lstg.Color) : lstg.Color Divides two colors together and returns the result.
---@alias Color lstg.Color

---Represents a random number generator class using the WELL512 algorithm.
---@class RNG
---@field Seed fun(self:RNG, seed:number) Sets the seed. Should be in range [0, 2^32-1].
---@field GetSeed fun(self:RNG) : number Returns the current seed.
---@field Int fun(self:RNG, min:integer, max:integer) : integer Returns a random integer in range [min, max]. `min` shouldn't be bigger than `max`.
---@field Float fun(self:RNG, min:number, max:number) : number Returns a random float in range [min, max]. `min` shouldn't be bigger than `max`.
---@field Sign fun(self:RNG) : number Returns either 1 or -1 randomly.

---Represents a Bent Laser object.
---@class BentLaserData
---@field Update fun(self:BentLaserData, obj:any, length:number, width:number, deactive:boolean?) Add a new node to a bent laser. It's position will be `(obj.x, obj.y)`
---@field UpdatePositionByList fun(...) Undocumented
---@field Release fun() Legacy function, obsolete in Sub. Does nothing.
---@field Render fun(self:BentLaserData, texName:string, blend:BlendMode, color:lstg.Color, texLeft:number, texTop:number, texWidth:number, texHeight:number, scale:number) Render a bent laser with specified parameters.
---@field CollisionCheck fun(self:BentLaserData, x:number, y:number, rot:number?, a:number?, b:number?, rect:boolean?) : boolean Checks for collision with a fake game object. Returns true if colliding. Optional circle colliders.
---@field BoundCheck fun(self:BentLaserData) : boolean Check if all nodes positions are in the range set by `SetBound()`. Returns true if all of the laser is inside bounds.

---Represents a Stop Watch object, useful for timers for example.
---@class StopWatch
---@field Reset fun() : self Reset the stopwatch to 0.
---@field Pause fun() : self Pauses the stopwatch
---@field Resume fun() : self Resumes the stopwatch
---@field GetElapsed fun() : number Returns the elapsed time (in seconds).

---Represents the engine file manager.
---@class lstg.FileManager
---@field LoadArchive fun(path:string, password:string?) Loads an zip/rar archive from a path with an optional password.
---@field UnloadArchive fun(path:string) Unloads a zip/rar archive from a path.
---@field UnloadAllArchive fun() Unloads all loaded archives.
---@field ArchiveExist fun(path:string) : boolean Returns true if the specified archive exists.
---@field GetArchive fun(path:string) : any Gets the archive specified by the path.
---@field EnumArchives fun() : table Enumerates all the archives currently loaded.
---@field EnumFiles fun(search_path:string, extension:string?, include_archives:boolean?) : table<string> Enumerates and returns all the files paths matching the extension in `search_path`.
---@field EnumFilesEx fun(search_path:string, extension:string?) : table<string> Enumerated and returns all the files matching the extension in `search_path` including archives.
---@field FileExist fun(path:string, all:boolean?) : boolean Returns `true` if the file exists at `path` .
---@field FindFiles fun(search_path:string, extension:string?) Same as `EnumFiles` but for archives.
---@field AddSearchPath fun(path:string) Adds a path to allow the engine to search source files in.
---@field RemoveSearchPath fun(path:string) Removes a path to allow the engine to search source files in.
---@field ClearSearchPath fun() Removes all the search paths stored in the engine. Not recommended.
---@field SetCurrentDirectory fun(path:string) Sets the current working directory. Crashes if the directory doesn't exist.
---@field GetCurrentDirectory fun() : string Returns the current working directory.
---@field CreateDirectory fun(path:string) Creates a directory at the specified path.
---@field RemoveDirectory fun(path:string) Deletes the directory and all its content.
---@field DirectoryExists fun(path:string) : boolean Returns true if the specified directory exists.

---@alias ResourceType
---| 1 Texture
---| 2 Sprite
---| 3 Animation
---| 4 Music
---| 5 SoundEffect
---| 6 Particle
---| 7 SpriteFont
---| 8 TTF
---| 9 Shader
---| 10 Model

---@alias SamplerState "point+wrap"|"point+clamp"|"linear+wrap"|"linear+clamp"
---@alias LogLevel
---| 0 debug
---| 1 info
---| 2 warn
---| 3 error
---| 4 fatal

---Represents MAINLY the engine-defined API functions and classes. (Warning: hot garbage smell)
---@class lstg
---@field args string Arguments passed from the CLI.
---@field FileManager lstg.FileManager
---@field BoxCheck fun(object:lstg.object, left:number, right:number, bottom:number, top:number) : boolean Checks if position of `object` is in the given rect.
---@field ColliCheck fun(object:lstg.object, other:lstg.object) : boolean Checks if two objects are intersecting.
---@field Angle fun(a:lstg.object, b:lstg.object) : number Retuns angle between the line connecting two objects in degrees.
---@field Angle fun(x1:number, y1:number, x2:number, y2:number) : number Returns angle between the line connection two points in degrees.
---@field Dist fun(a:lstg.object, b:lstg.object) : number Returns distance between two objects.
---@field Dist fun(x1:number, y1:number, x2:number, y2:number) : number Returns distance between two points.
---@field GetV fun(object:lstg.object) : number, number Returns magnitude (speed) and direction (in degrees) of the object velocity.
---@field SetV fun(object:lstg.object, magnitude:number, direction:number, updateRot:boolean?) Set magnitude (speed) and direction (in degrees) of the object velocity. Will update `rot` if `updateRot` is `true`.
---@field GetAttr fun(...) Basically __index
---@field SetAttr fun(...) Basically __newindex
---@field DefaultRenderFunc fun(object:lstg.object) Performs the default render function for a game object.
---@field SetImgState fun(object:lstg.object, blend:BlendMode, a:number, r:number, g:number, b:number) Set parameters of the renderable resource bind to `object`. Also see `SetImageState`
---@field SetParState fun(object:lstg.object, blend:BlendMode, a:number, r:number, g:number, b:number) Set parameters of the renderable particules bind to `object`.
---@field ParticleStop fun(object:lstg.object) Stop particle emitter on `object`
---@field ParticleFire fun(object:lstg.object) Start particle emitter on `object`
---@field ParticleGetn fun(object:lstg.object) : number Returns the current particle count on `object`
---@field ParticleGetEmission fun(object:lstg.object) : number Returns the particle emit frequency on `object` (count per second). Particle emitter will always step by 1/60 seconds.
---@field ParticleSetEmission fun(object:lstg.object, count:number) Set the particle emit frequency on `object` (count per second).
---@field GetSuperPause fun(...) Undocumented
---@field SetSuperPause fun(...) Undocumented
---@field AddSuperPause fun(...) Undocumented
---@field GetCurrentSuperPause fun(...) Undocumented
---@field SetWorldFlag fun(n:integer) Set the current world mask.
---@field IsSameWorld fun(a:lstg.object, b:lstg.object) : boolean Checks if two objects are in the same world.
---@field SetActiveWorlds fun(mask:integer) Set a flag for masking allowed active worlds (64 max).
---@field GetActiveWorlds fun() : integer Returns the current active world bitmask.
---@field SetResLoadInfo fun(active:boolean) Activate or deactivate logging for loading resources.
---@field CreateResourcePool fun(name:string) Creates a resource pool for loading resource. Can be used in `SetResourceStatus` and `RemoveResource`.
---@field RemoveResourcePool fun(name:string) Deletes a resource pool and frees all the resources created in its scope.
---@field SetResourceStatus fun(pool:string) Set a scope pool for loading resources.
---@field GetResourceStatus fun() : string Returns the current scope pool for loading resources.
---@field LoadTexture fun(name:string, path:string, mipmap:boolean?) Loads a texture resource from a file.
---@field LoadImage fun(name:string, tex_name:string, x:number, y:number, width:number, height:number, a:number?, b:number?, rect:boolean?) Loads an image from a texture with optional collision parameters.
---@field LoadAnimation fun(name:string, tex_name:string, x:number, y:number, width:number, height:number, columns:integer, rows:integer, interval:integer, a:number?, b:number?, rect:boolean?) Loads an animation from a texture with optional collision parameters.
---@field LoadPS fun(name:string, def_file:string, img_name:string, a:number?, b:number?, rect:boolean?) Loads a HGE particle from a file with optional collision parameters.
---@field LoadSound fun(name:string, path:string) Loads a sound resource from a file.
---@field LoadMusic fun(name:string, path:string, loop_end:number, loop_duration:number) Loads a music resource. Supports WAV and OGG. OGG format is recommended.
---@field LoadFont fun(name:string, def_file:string, bind_tex:string?, mipmap:boolean?) Loads a texture font resource. Supports HGE and fancy2d formats. For HGE, provide `bind_tex` for the image file.
---@field LoadTTF fun(name:string, path:string, width:number, height:number?) Loads a TTF font resource. `width` specifies the font size.
---@field LoadFX fun(name:string, path:string) Loads a shader resource. The shader format should be `hlsl`.
---@field LoadModel fun(name:string, path:string) Loads a model. Supported formats are `gltf`, `glb`.
---@field CreateRenderTarget fun(name:string, width:number?, height:number?) Creates a render target. Will be treated as a texture resource.
---@field Color lstg.Color
---@field RemoveResource fun(poolType:string) Clears a resource pool. If a resource is in use, it will not be freed until it's not used anymore.
---@field RemoveResource fun(poolType:string, resType:ResourceType, name:string) Removes a resource from a pool. If a resource is in use, it will not be freed until it's not used anymore.
---@field CheckRes fun(resType:ResourceType, name:string) : string Returns name of the pool where a resource is located. Usually used to check if a resource exists.
---@field EnumRes fun(resType:ResourceType) : table, table Returns array of all the resource names in `global` and `stage` pools respectively.
---@field ParticleSystemData fun(...) Undocumented
---@field SetImageState fun(name:string, blendmode:BlendMode, color:lstg.Color?, color2:lstg.Color?, color3:lstg.Color?, color4:lstg.Color?) Sets the parameters of an image or texture resource.
---@field SetImageCenter fun(name:string, x:number, y:number) Sets center of an image or texture resource, relative to its top-left corner.
---@field SetAnimationState fun(name:string, blendmode:BlendMode, color:lstg.Color?) Sets the parameters of an animation resource.
---@field SetAnimationCenter fun(name:string, x:number, y:number) Sets center of an image or texture resource, relative to its top-left corner.
---@field SetAnimationScale fun(name:string, scale:number) Sets the scale of an animation resource.
---@field GetAnimationScale fun(name:string) : number Returns the scale of an animation resource.
---@field Render fun(name:string, x:number, y:number, rot:number?, hscale:number?, vscale:number?, z:number?) Renders an image or texture resource to the screen.
---@field SetFontState fun(name:string, blendmode:BlendMode, color:lstg.Color?) Sets the state of a HGE font.
---@field CacheTTFString fun(...) Undocumented
---@field PlaySound fun(name:string, volume:number, pan:number?) Play a sound effect. Volume is in [0, 1] range. Pan specifies the channel balance in range [-1, 1].
---@field StopSound fun(name:string) Stops a playing sound effect.
---@field PauseSound fun(name:string) Pauses a sound effect.
---@field ResumeSound fun(name:string) Resumes a sound effect.
---@field MeshData fun(...) Undocumented
---@field sin fun(ang:number) : number
---@field cos fun(ang:number) : number
---@field asin fun(v:number) : number
---@field acos fun(v:number) : number
---@field tan fun(ang:number) : number
---@field atan fun(ang:number) : number
---@field atan2 fun(y:number, x:number) : number
---@field SaveTexture fun(name:string, path:string) Saves a texture to a file.
---@field BeginScene fun() Starts drawing the scene and enabled the rendering context.
---@field EndScene fun() Ends drawing the scene and ends the rendering context.
---@field RenderClear fun(color:lstg.Color) Clears the screen with the specified color. Will also clear the z-buffer if it's enabled.
---@field SetViewport fun(left:number, right:number, bottom:number, top:number) Set viewport. Will affect clipping and rendering.
---@field SetScissorRect fun(left:number, right:number, bottom:number, top:number) Enables the Scrissor Rect. Will affect clipping and rendering.
---@field SetOrtho fun(left:number, right:number, bottom:number, top:number) Set the orthogonal projection.
---@field SetPerspective fun(eyeX:number, eyeY:number, eyeZ:number, atX:number, atY:number, atZ:number, upX:number, upY:number, upZ:number, fovy:number, aspect:number, zn:number, zf:number) Sets the 3D perspective.
---@field Render4V fun(name:string, x1:number, y1:number, z1:number, x2:number, y2:number, z2:number, x3:number, y3:number, z3:number, x4:number, y4:number, z4:number) Renders an image in specified vertex position.
---@field Render4V fun(name:string, ...) Renders an image in specified vertex position.
---@field RenderAnimation fun(name:string, ani_timer:number, x:number, y:number, rot:number?, hscale:number?, vscale:number?, z:number?) Renders an animation.
---@field RenderTexture fun(...) Undocumented
---@field RenderMesh fun(...) Undocumented
---@field RenderModel fun(name:string, x:number, y:number, z:number, roll:number, pitch:number, yaw:number, sx:number, sy:number, sz:number) Renders a model in 3d space. `roll`, `pitch` and `yaw` are in degrees. `sx`, `sy`, `sz` are scale factors.
---@field SetFog fun() Clears the fog
---@field SetFog fun(near:number, far:number, color:lstg.Color?) Set fog effect.
---@field SetZBufferEnable fun(enabled:integer) Enables the ZBuffer.
---@field ClearZBuffer fun(enabled:integer) Clears the ZBuffer.
---@field PushRenderTarget fun(name:string) Push a render target into the stack. Following rendering will be applied to the render texture.
---@field PopRenderTarget fun() Pops the last render target off the stack, resume normal rendering execution.
---@field PopRenderTarget fun(name:string)Pops the given render target off the stack, resume normal rendering execution.
---@field PostEffect fun(name:string, fx_name:string, sampler_type:number, blend:BlendMode, args:table?, args2:table?) Applies a post effect (shader) and renders the result. Values in args will be passed to the shaders. Partially undocumented.
---@field SetTextureSamplerState fun(name:string, sampler_state:SamplerState) Sets the given texture sampler state.
---@field GetVersionNumber fun() : integer, integer, integer Returns the current engine version number in <MAJOR, MINOR, PATCH> order.
---@field GetVersionName fun() : string Returns the current engine version name.
---@field SetWindowed fun(isWindowed:boolean) Tells the engine to render the window in windowed if `true`. Otherwise; will be in exclusive fullscreen.
---@field SetFPS fun(fps:number) Sets the targeted FPS count. Default is 60.
---@field GetFPS fun() : number Returns the current FPS count.
---@field SetVsync fun(isEnable:boolean) Tells the engine to enable or disable VSync (if supported)
---@field SetResolution fun(width:integer, height:integer) Sets the size of the game window. Default is 640x480.
---@field Log fun(level:LogLevel, message:string) Logs the given text with the given log level.
---@field SystemLog fun(text:string) Logs the given text with INFO level.
---@field Print fun(...) Logs all arguments into separate lines with INFO level.
---@field DoFile fun(path:string, working_dir:string?) Executes the lua script at the given path. Crashes is the file doesn't exist, failed to compile or execute.
---@field LoadTextFile fun(path:string, packname:string?) : string Loads a text file and returns its content. If packname is given, will search into a zip.
---@field ChangeVideoMode fun(width:integer, height:integer, windowed:boolean, vsync:boolean) : boolean Changes the display parameters. Returns true if success. Otherwise; false, and restore last parameters.
---@field ChangeVideoMode fun(width:integer, height:integer, video_mode:'windowed'|'fullscreen'|'borderless', vsync:boolean) : boolean Changes the display parameters. FLUX ONLY.
---@field EnumResolutions fun() : table<integer, integer, number, number> Enumerates built-in resolutions. Returns a table of <width, height, refresh rate numerator, refresh rate denominator>.
---@field EnumGPUs fun() : table<string> Returns a table of the current used GPUs. Why would you want to use this?
---@field GetMouseState fun(button:number) : boolean Checks if the mouse button is pressed. 0/1/2 corresponds to left/middle/right.
---@field GetMousePosition fun() : number, number Gets the mouse position in pixels relative to the bottom left of the window.
---@field GetMouseWheelDelta fun() : integer Returns the last mouse wheel delta.
---@field GetLastKey fun() : number Returns the code of the last pressed key.
---@field AfterFrame fun() Update following properties of all objects: timer, ani_timer. Deletes objects marked as `del` or `kill`. Do not invoke.
---@field New fun(class:any, ...) : any Creates a new game object with properties and returns it.
---@field CollisionCheck fun(A:number, B:number) : boolean Performs the collision check between two object groups ids and performs the colli() callback. (see lib/Lobject.lua). !! Do not invoke in coroutines !!
---@field Kill fun(object:any) Kills an object. Similar to `Del(obj)`
---@field Del fun(object:any) Deletes an object. Similar to `Kill(obj)`
---@field IsValid fun(object:any) : boolean Returns `true` if the object is not dead or killed. Otherwise; `false`.
---@field BoundCheck fun() Do boundary checks on all objects. Marks them as `del` if they're out of bounds. !! Do not invoke in coroutines !!
---@field Execute fun(path:string, arguments:string?, directory:string?, wait:boolean?) : boolean Executes an external program at path with optional arguments. Returns true on success. !! Dangerous !!
---@field FindFiles fun(...) Undocumented 
---@field Snapshot fun(file_path:string) Takes a screenshot of the window and saves it to the file path as a PNG file.
---@field ExtractRes fun(path:string, target:string) Extract files in a pack to the specified path. Will throw an error if failed for any reason.
---@field LoadPack fun(path:string, password:string?) Loads a zip file at `path` with an optional password. Will throw an error if failed for any reason.
---@field UnloadPack fun(path:string) Unloads a zip file at `path` that was already loaded in memory. Will NOT throw an error if failed for any reason.
---@field MessageBox fun(title:string, text:string, flags:integer) : integer Shows a MessageBox on screen. Uses the Win32 MessageBox API for flags.
---@field SetBGMVolume fun(volume:number) Sets the global volume factor. Doesn't affect playing musics.
---@field SetBGMVolume fun(name:string, volume:number) Sets the volume of the specified music resource.
---@field GetMusicState fun(name:string) : "paused"|"playing"|"stopped" Returns the status of a music resource.
---@field ResumeMusic fun(name:string) Resumes a music.
---@field PauseMusic fun(name:string) Pauses a music.
---@field StopMusic fun(name:string) Stops a music.
---@field PlayMusic fun(name:string, volume:number?, position:number?) Plays a music with an optional volume in range [0, 1] and starting position in seconds.
---@field SetSEVolume fun(volume:number) Sets the global volume factor. Doesn't affect playing sound effects.
---@field SetSEVolume fun(name:string, volume:number) Sets the volume of the specified sound effect resource.
---@field GetSoundState fun(name:string) : "paused"|"playing"|"stopped" Returns the status of a sound effect resource.
---@field GetImageScale fun(name:string) : number Returns the scale of the specified image resource.
---@field SetImageScale fun(name:string, scale:number) Sets the scale of the specified image resource.
---@field SetImageScale fun(scale:number) Sets the global scale of image resources.
---@field GetTextureSize fun(name:string) : number, number Returns the width and height of a texture resource.
---@field IsRenderTarget fun(name:string) : boolean Returns true if the given texture is a render target texture.
---@field RenderTTF fun(name:string, text:string, left:number, right:number, bottom:number, top:number, format:integer, color:lstg.Color, scale:number?) Renders a text with a TTF font.
---@field RenderText fun(name:string, text:string, x:number, y:number, scale:number?, align:integer?) Renders a text with a HGE font.
---@field RenderRect fun(name:string, left:number, right:number, bottom:number, top:number) Renders an image in the specified rectangle. Z coordinates will be `0.5`.
---@field RenderGroupCollider fun(group:number, color:lstg.Color) Render all the collider of the given group with a specified color.
---@field DrawCollider fun() Render all the colliders of all groups of all objects with builtin colors.
---@field GetKeyState fun(code:number) Check if the key corresponding to `code` (based on VK_CODE defined by Windows) is currently pressed.
---@field GetnObj fun() : number Returns the game object count.
---@field ObjFrame fun() Peforms the position, acceleration and rotation of all game objects. !! Do not invoke in coroutines !!
---@field ObjRender fun() Renders all the game objects. Will invoke render() one by one. Objects with smaller `layer` will be rendered first. !! Do not invoke in coroutines !!
---@field SetBound fun(left:number, right:number, bottom:number, top:number) Set screen boundaries for all game objects. 
---@field GetBound fun(): number, number, number, number Returns the current set world bounds in order: left, right, bottom, top. Flux only.
---@field UpdateXY fun() Updates the dx, dy, lastx, lasty and rot (when navi is `true`) of all game objects. !! Do not invoke in coroutines !!
---@field ResetPool fun() Deletes all game objects marked to be deleted or killed immediately.
---@field ObjList fun(group:number) : function Returns an iterator that goes through all objects in a group.
---@field GetWorldFlag fun() : integer Returns the current world flag.
---@field SetTitle fun(title:string) Changes the game title.
---@field SetSplash fun(enabled) If `true`, will display the mouse when hovering the game window.
---@field BentLaserData fun() : BentLaserData Creates a BentLaserData object.
---@field Rand fun() : RNG Creates a RNG object.
---@field StopWatch fun() : StopWatch Creates a StopWatch object.
---@field GetLocalAppDataPath fun() : string Returns the path to %localappdata%
---@field GetRoamingAppDataPath fun() : string Returns thep ath to %appdata%

---------------------------------------
---All of these represents modules that can be loaded, usualy from "modern" Sub functions.
---------------------------------------

---Represents a Vector2. Load using `local vector2 = require("lstg.Vector2")`
---
---Note: Vectors are not serializable.
---@class lstg.Vector2
---@field create fun(x:number, y:number) : lstg.Vector2 Creates a vector2 and returns it.
---@field length fun(self:lstg.Vector2) : number Returns the length of the vector.
---@field angle fun(self:lstg.Vector2) : number Returns the angle of the vector.
---@field normalize fun(self:lstg.Vector2) : lstg.Vector2 Changes this vector to it's normalized values.
---@field normalized fun(self:lstg.Vector2) : lstg.Vector2 Copy this vector and create a new one with normalized values.
---@field dot fun(self:lstg.Vector2, other:lstg.Vector2) : number Returns the dot product of this and another vector.

---Represents a Vector3. Load using `local vector3 = require("lstg.Vector3")`
---Note: Vectors are not serializable.
---@class lstg.Vector3
---@field create fun(x:number, y:number, z:number) : lstg.Vector3 Creates a vector3 and returns it.
---@field length fun(self:lstg.Vector3) : number Returns the length of the vector.
---@field angle fun(self:lstg.Vector3) : number Returns the angle of the vector.
---@field normalize fun(self:lstg.Vector3) : lstg.Vector3 Changes this vector to it's normalized values.
---@field normalized fun(self:lstg.Vector3) : lstg.Vector3 Copy this vector and create a new one with normalized values.
---@field dot fun(self:lstg.Vector3, other:lstg.Vector3) : number Returns the dot product of this and another vector.

---Represents a Vector4. Load using `local vector4 = require("lstg.Vector4")`
---
---Note: Vectors are not serializable.
---@class lstg.Vector4
---@field create fun(x:number, y:number, z:number, w:number) : lstg.Vector4 Creates a vector4 and returns it.
---@field length fun(self:lstg.Vector4) : number Returns the length of the vector.
---@field angle fun(self:lstg.Vector4) : number Returns the angle of the vector.
---@field normalize fun(self:lstg.Vector4) : lstg.Vector4 Changes this vector to it's normalized values.
---@field normalized fun(self:lstg.Vector4) : lstg.Vector4 Copy this vector and create a new one with normalized values.
---@field dot fun(self:lstg.Vector4, other:lstg.Vector4) : number Returns the dot product of this and another vector.


---Represents a FileSystemWatcher at the specified path. Load using `local fsw = require("lstg.FileSystemWatcher")`
---@class lstg.FileSystemWatcher
---@field read fun(self:lstg.FileSystemWatcher, files_data:table<string, lstg.FileSystemWatcher.FileAction>) : boolean Fills the given table with data. Returns true if an even was read. Otherwise; false.
---@field close fun(self:lstg.FileSystemWatcher) Closes the fsw and destroys it.
---@field create fun(path:string) : lstg.FileSystemWatcher Creates a FileSystemWatcher instance.

---Represents a clipboard helper. Load using `local clipboard = require("lstg.Clipboard")`
---@class lstg.Clipboard
---@field hasText fun() : boolean Returns true if the clipboard contains text and isn't empty.
---@field getText fun() : string Gets the string currently existing in the clipboard.
---@field setText fun(string) Push a string into the clipboard.

---Represents the screens connected to the Graphics Card. Load using `local window = require("lstg.Display")`
---@class lstg.Display
---@field getAll fun() : table<lstg.Display>
---@field getPrimary fun() : lstg.Display
---@field getNearestFromWindow fun() : lstg.Display !! Will crash !! Not implemented in Sub.
---@field getFriendlyName fun(self:lstg.Display) : string Returns the friendly name of the monitor.
---@field getSize fun(self:lstg.Display) : lstg.Display.Size Returns the screen size.
---@field getPosition fun(self:lstg.Display) : lstg.Display.Position Returns the screen position in Windows.
---@field getRect fun(self:lstg.Display) : lstg.Display.Rect Returns the screen rect size.
---@field getWorkAreaSize fun(self:lstg.Display) : lstg.Display.Size Returns the work area of the screen.
---@field getWorkAreaPosition fun(self:lstg.Display) : lstg.Display.Position Returns the position of the work area of the screen.
---@field getWorkAreaRect fun(self:lstg.Display) : lstg.Display.Rect Returns the rect of the screen's work area.
---@field isPrimary fun(self:lstg.Display) : boolean Returns true if the screen is the primary screen in Windows. Otherwise; false.
---@field getDisplayScale fun(self:lstg.Display) : number Returns the scale of the screen display set in Windows.

---@class lstg.Display.Size
---@field width number
---@field height number

---@class lstg.Display.Position
---@field x number
---@field y number

---@class lstg.Display.Rect
---@field left number
---@field top number
---@field right number
---@field bottom number

---------------------------------------

BoxCheck = lstg.BoxCheck
ColliCheck = lstg.ColliCheck
Angle = lstg.Angle
Dist = lstg.Dist
GetV = lstg.GetV
SetV = lstg.SetV
GetAttr = lstg.GetAttr
SetAttr = lstg.SetAttr
DefaultRenderFunc = lstg.DefaultRenderFunc
SetImgState = lstg.SetImgState
SetParState = lstg.SetParState
ParticleStop = lstg.ParticleStop
ParticleFire = lstg.ParticleFire
ParticleGetn = lstg.ParticleGetn
ParticleGetEmission = lstg.ParticleGetEmission
ParticleSetEmission = lstg.ParticleSetEmission
GetSuperPause = lstg.GetSuperPause
SetSuperPause = lstg.SetSuperPause
AddSuperPause = lstg.AddSuperPause
GetCurrentSuperPause = lstg.GetCurrentSuperPause
SetWorldFlag = lstg.SetWorldFlag
IsSameWorld = lstg.IsSameWorld
SetActiveWorlds = lstg.SetActiveWorlds
GetActiveWorlds = lstg.GetActiveWorlds
SetResLoadInfo = lstg.SetResLoadInfo
CreateResourcePool = lstg.CreateResourcePool
RemoveResourcePool = lstg.RemoveResourcePool
SetResourceStatus = lstg.SetResourceStatus
GetResourceStatus = lstg.GetResourceStatus
LoadTexture = lstg.LoadTexture
LoadImage = lstg.LoadImage
LoadAnimation = lstg.LoadAnimation
LoadPS = lstg.LoadPS
LoadSound = lstg.LoadSound
LoadMusic = lstg.LoadMusic
LoadFont = lstg.LoadFont
LoadTTF = lstg.LoadTTF
LoadFX = lstg.LoadFX
LoadModel = lstg.LoadModel
CreateRenderTarget = lstg.CreateRenderTarget
Color = lstg.Color
RemoveResource = lstg.RemoveResource
CheckRes = lstg.CheckRes
EnumRes = lstg.EnumRes
ParticleSystemData = lstg.ParticleSystemData
SetImageState = lstg.SetImageState
SetImageCenter = lstg.SetImageCenter
SetAnimationCenter = lstg.SetAnimationCenter
SetAnimationScale = lstg.SetAnimationScale
GetAnimationScale = lstg.GetAnimationScale
SetAnimationState = lstg.SetAnimationState
Render = lstg.Render
SetFontState = lstg.SetFontState
CacheTTFString = lstg.CacheTTFString
PlaySound = lstg.PlaySound
StopSound = lstg.StopSound
PauseSound = lstg.PauseSound
ResumeSound = lstg.ResumeSound
MeshData = lstg.MeshData
---@diagnostic disable lowercase-global
sin = lstg.sin
cos = lstg.cos
tan = lstg.tan
asin = lstg.asin
acos = lstg.acos
atan = lstg.atan
atan2 = lstg.atan2
---@diagnostic enable lowercase-global
SaveTexture = lstg.SaveTexture
BeginScene = lstg.BeginScene
EndScene = lstg.EndScene
RenderClear = lstg.RenderClear
SetViewport = lstg.SetViewport
SetScissorRect = lstg.SetScissorRect
SetOrtho = lstg.SetOrtho
SetPerspective = lstg.SetPerspective
Render4V = lstg.Render4V
RenderAnimation = lstg.RenderAnimation
RenderTexture = lstg.RenderTexture
RenderMesh = lstg.RenderMesh
RenderModel = lstg.RenderModel
SetFog = lstg.SetFog
SetZBufferEnable = lstg.SetZBufferEnable
ClearZBuffer = lstg.ClearZBuffer
PushRenderTarget = lstg.PushRenderTarget
PopRenderTarget = lstg.PopRenderTarget
PostEffect = lstg.PostEffect
SetTextureSamplerState = lstg.SetTextureSamplerState
GetVersionNumber = lstg.GetVersionNumber
GetVersionName = lstg.GetVersionName
SetWindowed = lstg.SetWindowed
SetFPS = lstg.SetFPS
GetFPS = lstg.GetFPS
SetVsync = lstg.SetVsync
SetResolution = lstg.SetResolution
Log = lstg.Log
SystemLog = lstg.SystemLog
Print = lstg.Print
DoFile = lstg.DoFile
LoadTextFile = lstg.LoadTextFile
ChangeVideoMode = lstg.ChangeVideoMode
EnumResolutions = lstg.EnumResolutions
EnumGPUs = lstg.EnumGPUs
GetMouseState = lstg.GetMouseState
GetMousePosition = lstg.GetMousePosition
GetMouseWheelDelta = lstg.GetMouseWheelDelta
GetLastKey = lstg.GetLastKey
AfterFrame = lstg.AfterFrame
New = lstg.New
CollisionCheck = lstg.CollisionCheck
Kill = lstg.Kill
Del = lstg.Del
IsValid = lstg.IsValid
BoundCheck = lstg.BoundCheck
Execute = lstg.Execute
FindFiles = lstg.FindFiles
ExtractRes = lstg.ExtractRes
UnloadPack = lstg.UnloadPack
LoadPack = lstg.LoadPack
MessageBox = lstg.MessageBox
SetBGMVolume = lstg.SetBGMVolume
GetMusicState = lstg.GetMusicState
ResumeMusic = lstg.ResumeMusic
PauseMusic = lstg.PauseMusic
StopMusic = lstg.StopMusic
PlayMusic = lstg.PlayMusic
SetSEVolume = lstg.SetSEVolume
GetSoundState = lstg.GetSoundState
GetImageScale = lstg.GetImageScale
SetImageScale = lstg.SetImageScale
GetTextureSize = lstg.GetTextureSize
IsRenderTarget = lstg.IsRenderTarget
RenderRect = lstg.RenderRect
Snapshot = lstg.Snapshot
RenderTTF = lstg.RenderTTF
RenderText = lstg.RenderText
RenderGroupCollider = lstg.RenderGroupCollider
DrawCollider = lstg.DrawCollider
GetKeyState = lstg.GetKeyState
GetnObj = lstg.GetnObj
ObjFrame = lstg.ObjFrame
ObjRender = lstg.ObjRender
SetBound = lstg.SetBound
GetBound = lstg.GetBound
UpdateXY = lstg.UpdateXY
ResetPool = lstg.ResetPool
ObjList = lstg.ObjList
GetWorldFlag = lstg.GetWorldFlag
SetTitle = lstg.SetTitle
SetSplash = lstg.SetSplash
BentLaserData = lstg.BentLaserData
Rand = lstg.Rand
StopWatch = lstg.StopWatch
GetLocalAppDataPath = lstg.GetLocalAppDataPath
GetRoamingAppDataPath = lstg.GetRoamingAppDataPath

-- Undocumented API, still in experimental
-- 未公开的 API，还处于实验状态

---@diagnostic disable undefined-field

GetSEVolume = lstg.GetSEVolume
SetSESpeed = lstg.SetSESpeed
GetSESpeed = lstg.GetSESpeed
NextObject = lstg.NextObject -- Internal/内部方法
ResetObject = lstg.ResetObject
SetBGMLoop = lstg.SetBGMLoop
GetBGMSpeed = lstg.GetBGMSpeed
SetBGMSpeed = lstg.SetBGMSpeed
GetBGMVolume = lstg.GetBGMVolume
GetMusicFFT = lstg.GetMusicFFT
SetTexturePreMulAlphaState = lstg.SetTexturePreMulAlphaState
ObjTable = lstg.ObjTable -- Internal/内部方法

-- Completely deprecated API, are empty function, undocumented.
-- 彻底废弃的 API，已经是空函数

IsInWorld = lstg.IsInWorld
GetCurrentObject = lstg.GetCurrentObject
UpdateSound = lstg.UpdateSound
PostEffectApply = lstg.PostEffectApply
PostEffectCapture = lstg.PostEffectCapture
ShowSplashWindow = lstg.ShowSplashWindow

---@diagnostic enable undefined-field