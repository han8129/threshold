const exercises = require('./database/exercises.js')
const records = require('./database/records.js')
const express = require('express')
const port = 80
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

    app.post('/records', express.json(), async (req, res) => {
        const updatedFields = await records.insert(req.body)

        res.status(201).json({
            integer : updatedFields
        })
    })


    app.delete('/exercises/:id', async (req, res) => {
        const updatedFields = await exercises.delete(req.params.id)

        res.status(201).json({
            integer : updatedFields
        })
    })

    app.put('/exercises/:id', express.json(), async (req, res) => {
        const updatedFields = await exercises.update(req.params.id, req.body)

        console.log(updatedFields)
        res.status(201).json({
            integer : updatedFields
        })
    })

    app.get('/records/:exercise_id', async (req, res) => {
        records.getByExerciseId(req.params.exercise_id)
            .then((records) => {
                res.json(records)
            })
    })

    records.getByExerciseId('id')

    app.listen(port, () => {
        console.log(`Listening on ${ port }`)
    })

}

main()
