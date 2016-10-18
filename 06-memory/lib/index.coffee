fs = require('fs')
readline = require('readline')
stream = require('stream')

exports.countryIpCounter = (countryCode, cb) ->
  return cb() unless countryCode

  fs.readFile "#{__dirname}/../data/geo.txt", 'utf8', (err, data) ->
    if err then return cb err

    inStream = fs.createReadStream(__dirname + '/../data/geo.txt', 'utf8')
    outStream = new stream
    rl = readline.createInterface(inStream, outStream)
    counter = 0

    # On EOL event, split the line by tab and increment the counter
    rl.on 'line', (line) ->
      line = line.split('\t')
      # GEO_FIELD_MIN, GEO_FIELD_MAX, GEO_FIELD_COUNTRY
      # line[0],       line[1],       line[3]
      if line[3] == countryCode then counter += +line[1] - +line[0]
      return

    # At the end of the stream trigger the callback with the counter value
    rl.on 'close', ->
      cb null, counter
      return
