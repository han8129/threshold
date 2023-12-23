const http = require('http')
const {client} = require('./repo')
const {json} = require('express')
var Exercise = require('./model/exercise.js')

const exercise = new Exercise("squad", 3, 3, 1, "squad33.01")
const server = http.createServer()
server.on('request', (req, rest) => {
    rest.writeHead(200, {"content-type":"application/json"})
    rest.write(JSON.stringify(exercise))
    rest.end("")
})

server.listen(8000)
