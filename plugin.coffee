less = require 'less'
path = require 'path'
async = require 'async'
fs = require 'fs'

#
# Map function for dictionarys:
# Iterate over each K/V-pair of the dict
# and return a new dict in which the values
# are the return value of the function:
#
# mapD {a:1,b:2,c:3,d:"v"}, (k,v) -> v*2
# ==> {a:2,b:4,c:6,d:NaN}
mapD = (d,f) ->
  r = {}
  for k,v of d
    r[k] = f k, v
  r

# Generate a shallow copy of the argument
# Returns an empty dict for numbers,null and undef
clone = (d) ->
  mapD d, (k,v)->v
module.exports = (env, callback) ->

  class LessPlugin extends env.ContentPlugin

    constructor: (@filepath, @source) ->

    getFilename: ->
      @filepath.relative.replace /less$/, 'css'

    getView: ->
      return (env, locals, contents, templates, callback) ->
        options = clone env.config.less
        options.filename = @filepath.relative
        options.paths = [path.dirname(@filepath.full)]
        # less throws errors all over the place...
        async.waterfall [
          (callback) ->
            try
              parser = new less.Parser options
              callback null, parser
            catch error
              callback error
          (parser, callback) =>
            try
              parser.parse @source, callback
            catch error
              callback error
          (root, callback) ->
            try
              result = root.toCSS options
              callback null, new Buffer result
            catch error
              callback error
        ], callback

  LessPlugin.fromFile = (filepath, callback) ->
    fs.readFile filepath.full, (error, buffer) ->
      if error
        callback error
      else
        callback null, new LessPlugin filepath, buffer.toString()

  env.registerContentPlugin 'styles', '**/*.less', LessPlugin
  callback()
