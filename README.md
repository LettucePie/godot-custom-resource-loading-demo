## Resource Loader Demo

This Demo Project is made to show 3 methods of how someone might want to \
metabolize and setup their Custom Resource Objects. More often than not, \
people making Role Play or collectible games will encounter issues with \
the Godot Workflow. Specifically the process between setting up stats or \
basic metadata onto objects/assets.

#### Example

You have a game where a character can use 20 different pieces of equipment. \
You now have the challenge where you want to connect together:

 - Equipment Name
 - Equipment Model
 - Equipment Store Price
 - Equipment Inventory Icon
 - Equipment Stats (Damage or Armor)
 - Equipment Abilities
 - etc.

Depending on your game structure, you can get by making 20 individual scenes, \
each with an "Equipment" Script attached that reveals these stats to the \
inspector with an `@export` flag. However you may also have an extremely \
modular game that doesn't require such individually unique setup. In that \
situation you could either make a Data Table (such as a JSON file) or use \
the Custom Resource Objects. Those work by making an empty script, then \
extending a Resource and setting a `class_name` value. Now you have data \
structures which can be instantiated and edited without needing to open and \
save entire scene files.

### Where this demo comes in

Once you find yourself with 20 or more of these Custom Resource Objects or \
unique swappable scenes, you have the task now of putting them onto SOMETHING. \
The logical go-to is to create an `@export var list : Array` to hold onto them. \
This quickly becomes problematic. Godot (as lovely and beautiful as it is) has \
a strange amount of difficulty when it comes to setting up Arrays of objects \
in the inspector.

So here is this Project. My own self study turned tutorial on Resource Loading. \
I urge you to explore the code and tinker around to learn how my 3 methods work. \

#### JSON Method

With this method you don't have to actually make Custom Resource Objects or \
unique swappable scenes. Instead you connect everything together through \
reference within the dictionary structs in a JSON file. I'm sure there are \
efficient ways of making and editing JSON files, I just used the text editor \
within Godot. Then you can use the `JSON.parse` functions in Godot to break \
down and rebuild your data. It's work, and it can become a chore if you make \
large changes to the file-structure you're referring too.

#### Packed Custom Resource Method

This method is most likely going to the thing that brought you here. I have \
had so many issues using this. From my Resource Objects being completely wiped \
clean, to all of them duplicating into being just the same one with different \
file names. While being the most forward, direct, and absolute way of getting \
your Resource Objects into a workable list; **it. just. sucks.**

#### Unpacked Custom Resource Method

The third option I've settled on and perhaps my preferred. You get to have fun \
making all of those Custom Resource Objects and unique swappable scenes; with \
no punishment. The biggest drawback is the impact on performance, as this \
method requires `editor/export/convert_text_resources_to_binary` be set \
`false` in the Project Settings.
