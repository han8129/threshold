const exercises = require('./database/exercises.js')
const records = require('./database/records.js')
const express = require('express')
const port = 8000
const app = express()


async function main() {
    app.get('/exercises/:id', (req, res) => {
        exercises.getById(req.params.id)
            .then((exercise) => {
                res.json(exercise)
            })
    })

    app.get('/exercises', (req, res) => {
        exercises.getAll().then((exercises) =>
            {
                res.json(exercises)
            })
    })

    app.post('/exercises', express.json(), (req, res) => {
        console.log((req.body))

        exercises.insert(req.body).then((value) => {
            res.status(201).json({
                integer : value
            })
        })
    })

    app.get('/records/:exercise_id', async (req, res) => {
        records.getByExerciseId(req.params.exercise_id)
            .then((records) => {
                res.json(records)
            })
    })

    app.post('/records', express.json(), (req, res) => {
        records.insert(req.body).then((value) => {
            res.status(201).json({
                integer : value
            })
        })
    })

    app.listen(port, () => {
        console.log(`Listening on ${ port }`)
    })
}

main()
