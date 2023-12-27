const ExerciseRepository = require('./repo.js')
var Exercise = require('./model/exercise.js')
const express = require('express')
const redis = require('redis')
const port = 8000

const app = express()

function error(status, msg) {
  var err = new Error(msg);
  err.status = status;
  return err;
}

app.get('/exercise/:id', (req, res) => {
    console.log(req.params)
    res.send('exercise ' + req.params.id)
})

app.get('/exercise', (req, res) => {
    console.log("req")
    res.send({
        id : "1",
        name : "12"
    })
})

app.listen(port, () => {
    console.log(`Listening on ${ port }`)
})

const client = redis.createClient().connect().then(value => {
    const exerciseRepo = new ExerciseRepository(value)
     exerciseRepo.getAll().then(data => {
         for (key of data)
         {
             console.log(key)
         }
    })
})

