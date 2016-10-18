through2 = require 'through2'

module.exports = ->
  words = 0
  lines = 1
  characters = 0
  byteLength = 0

  transform = (chunk, encoding, cb) ->
    byteLength = Buffer.byteLength(chunk, 'utf8')
    characters = chunk.length
    # Match all double quote encapsulated expressions
    words += (chunk.match(/"(?:[^"\\]|\\.)*"/g) || []).length
    # Remove matched double quote expressions from the chunk
    chunk = chunk.replace(/"(?:[^"\\]|\\.)*"/g, '')
    if chunk.length == 0 then return cb()
    # Strip all non A-Z, a-z, 0-9 characters
    chunk = chunk.replace(/[^a-zA-Z0-9\s]+/g, '')
    # Insert a space into camel cased words
    chunk = chunk.replace(/(?!^)(?=[A-Z])/g, ' ')
    # Strip any double spaces
    chunk = chunk.replace(/ +(?= )/g,'')
    tokens = chunk.split(' ')
    lines = chunk.split(/\r\n|\r|\n/).length
    words += tokens.length
    return cb()

  flush = (cb) ->
    this.push {words, lines, characters, byteLength}
    this.push null
    return cb()

  return through2.obj transform, flush
