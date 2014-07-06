
# wintersmith-less

[less](http://lesscss.org) plugin for [wintersmith](https://github.com/jnordberg/wintersmith)

install:

`npm install wintersmith-less -g`
then add `wintersmith-less` to your plugins in the wintersmith config

# Configuration

Configuration parameters are red from config.less (defined in config.json).
These are passed to the less parser mostly unmodified to the less library

## Less configuration

* **path** - This contains the search path for less CSS.
  The directory of the source file is automatically added by this plugin
* **filename** - The name of the current file.
  Automatically set (and overwritten) by this plugin.

There are many more, have a look at the *bin/lessc* file in the less repo.
Somewhere on the top is a dict which mentions various variables.

## Variable injection

Wintersmith-less supports injection of variables,
these should be defined in config.less.vars and will
be passed to less.

Please note that these variables *do not* support any
kinds of transformation in the less compiler and can
only be used for text replacement.
This particularly includes math operations (plus, minus, …)
and URL transformations.

### Background

The less compiler has only basic support for variable injection:
In the last  stage of compilation (AST to CSS), less supports passing
a **variables** dictionary, which has to contain native LESS-AST
types ( **less.tree.whatever** ).
Wintersmith-less converts the values internally to **less.tree.Anonymous**
which is the type for *just paste this*.

If the given variable is allready such a type it will be inserted as-is,
without being wrapped in **less.tree.Anonymus**.
You can utilize this behavior by defining these types yourself:

1. Create a new plugin (js file)
2. Add this file to the **plugins array** in your **config.json**
3. Import less in your plugins
4. Implement the exports method in your plugin (have a look at other wintersmith plugins)
5. Set the config keys programatically in this plugin

The config-by-plugin method can also be used to provide meta information about the
enviroment, you could for instance save the sizes and locations of your images in
less variables.

