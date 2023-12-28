const exercises = require('./database/exercises.js')
const records = require('./database/records.js')
const express = require('express')
const port = 8000
const app = express()


async function main() {

    const list = records.getByExerciseId('squad33.11').then((list) => {
        console.log(list)
    })

    app.get('/exercise/:id', (req, res) => {
        console.log(req.params)
        res.send('exercise ' + req.params.id)
    })

    app.get('/exercise', (req, res) => {
        res.send({
            id : "1",
            name : "12"
        })
    })

    app.post('/exercise', (req, res) => {
        res.status(201).send('Success')
    })

    app.listen(port, () => {
        console.log(`Listening on ${ port }`)
    })
}

main()
