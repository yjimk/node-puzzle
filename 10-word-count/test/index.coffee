assert = require 'assert'
WordCount = require '../lib'


helper = (input, expected, done) ->
  pass = false
  counter = new WordCount()

  counter.on 'readable', ->
    return unless result = this.read()
    assert.deepEqual result, expected
    assert !pass, 'Are you sure everything works as expected?'
    pass = true

  counter.on 'end', ->
    if pass then return done()
    done new Error 'Looks like transform fn does not work'

  counter.write input
  counter.end()


describe '10-word-count', ->

  it 'should count a single word', (done) ->
    input = 'test'
    expected = words: 1, lines: 1, characters: 4, byteLength: 4
    helper input, expected, done

  it 'should count words in a phrase', (done) ->
    input = 'this is a basic test'
    expected = words: 5, lines: 1, characters: 20, byteLength: 20
    helper input, expected, done

  it 'should count quoted characters as a single word', (done) ->
    input = '"this is one word!"'
    expected = words: 1, lines: 1, characters: 19, byteLength: 19
    helper input, expected, done

  it 'should count camel cased words as two words', (done) ->
    input = 'this camel has TwoHumps, this camel has oneHump'
    expected = words: 10, lines: 1, characters: 47, byteLength: 47
    helper input, expected, done

  it 'should count the number of lines', (done) ->
    input = 'this camel has TwoHumps, this camel has oneHump \n
            "this is one word!" \n
            this is a basic test \n
            test'
    expected = words: 20, lines: 4, characters: 99, byteLength: 99
    helper input, expected, done

  it 'should pass even for a long string', (done) ->
    input = 'Node.js is an open-source, cross-platform JavaScript runtime \n
            environment for developing a diverse variety of tools and \n
            applications. Although Node.js is not a JavaScript framework, \n
            many of its basic modules are written in JavaScript, and \n
            developers can write new modules in JavaScript.'
    expected = words: 49, lines: 5, characters: 293, byteLength: 293
    helper input, expected, done


  # !!!!!
  # Make the above tests pass and add more tests!
  # !!!!!
