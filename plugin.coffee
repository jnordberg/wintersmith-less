less = require 'less'
path = require 'path'
async = require 'async'
fs = require 'fs'

module.exports = (env, callback) ->

  class LessPlugin extends env.ContentPlugin

    constructor: (@filepath, @source) ->

    getFilename: ->
      @filepath.relative.replace /less$/, 'css'

    getView: ->
      return (env, locals, contents, templates, callback) ->
        options = env.config.less or {}
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
