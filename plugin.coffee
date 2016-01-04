less = require 'less'
path = require 'path'
minimatch = require 'minimatch'
async = require 'async'
fs = require 'fs'

module.exports = (env, callback) ->

  options = env.config.less ? {}

  if env.mode is 'preview' and !options.sourceMap?
    options.sourceMap =
      sourceMapFileInline: true
      outputSourceFiles: true

  exclude = options.exclude ? []
  delete options['excluded']

  class LessPlugin extends env.ContentPlugin

    constructor: (@filepath, @source) ->

    getFilename: ->
      @filepath.relative.replace /less$/, 'css'

    isExcluded: ->
      path.basename(@filepath.relative)[0] is '_' or
        true in (minimatch(@filepath.relative, pattern) for pattern in exclude)

    getView: ->
      if @isExcluded()
        return 'none'
      return (env, locals, contents, templates, callback) ->
        opts = {}
        env.utils.extend opts, options
        opts.paths = [path.dirname(@filepath.full)]
        opts.filename = @filepath.relative
        less.render @source, opts, (error, result) ->
          if error?
            callback error
            return
          callback null, new Buffer result.css

    getPluginInfo: ->
      if @isExcluded()
        return 'excluded'
      else
        super()

  LessPlugin.fromFile = (filepath, callback) ->
    fs.readFile filepath.full, (error, buffer) ->
      if error
        callback error
      else
        callback null, new LessPlugin filepath, buffer.toString()

  env.registerContentPlugin 'styles', '**/*.less', LessPlugin
  callback()
