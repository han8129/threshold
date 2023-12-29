const { connection } = require( './../redis_service.js')
const table = "exercises"

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

                return ({
                    id : id,
                    name : exercise.name,
                    sets : exercise.sets,
                    rest_minutes : exercise.rest_minutes,
                    reps : exercise.reps
                })
            })
        )
    }

    ,async insert(exercise) {
        const redis = await connection()
        //console.log(JSON.parse(exercise))
        return await redis.hSet(
            `${table}:${exercise.id}`,
            {
                name : exercise.name,
                sets : exercise.sets,
                rest_minutes : exercise.rest_minutes,
                reps : exercise.reps
            }
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
}

