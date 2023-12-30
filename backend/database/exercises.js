const { connection } = require( './../redis_service.js')
const table = "exercises"
const columnName = 'name'
const columnSets = 'sets'
const columnRestMinutes = 'rest_minutes'
const columnReps = 'reps'

module.exports = {
    async getAll() {
        const redis = await connection()
        const keys = Array.from(await redis.sendCommand(
            ['scan', '0', 'match', `${table}:*`]
        ))[1]

        return await Promise.all(
            keys.map( async (e) => {
                const id = e.substr(table.length + 1,)
                const exercise = await redis.hGetAll(e)

                return {
                    id : id,
                    name : exercise.name,
                    sets : exercise.sets,
                    rest_minutes : exercise.rest_minutes,
                    reps : exercise.reps
                }
            })
        )
    }

    ,async insert(exercise) {
        const redis = await connection()

        const id = exercise.id
        delete exercise.id

        return await redis.hSet(
            `${table}:${id}`, exercise
        )
    }

    ,async update(id, properties) {
        const redis = await connection()

        return await redis.hSet(
            `${table}:${id}`, properties
        )
    }

    ,async getById(id) {
        const redis = await connection()

        const exercise = await redis.hGetAll(`${table}:${id}`)
        return {
            name : exercise.name,
            sets : exercise.sets,
            rest_minutes : exercise.rest_minutes,
            reps : exercise.reps
        }
    }

    ,async delete(id) {
        const redis = await connection()

        return await redis.sendCommand(
            [
                'HDEL', `${table}:${id}`,
                columnName ,
                columnSets,
                columnRestMinutes,
                columnReps
            ]
        )
    }
}

