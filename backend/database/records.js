const { connection } = require( './../redis_service.js')
const table = "records"

module.exports = {
    async getByExerciseId(id) {
        const redis = await connection()
        const keys = Array.from(await redis.sendCommand(
            ['scan', '0', 'match', `${table}:*`]
        ))[1]

        return await Promise.all(
            keys.map( async (e) => {
                const id = e.substr(table.length + 1,)
                const record = await redis.hGetAll(e)

                return ({
                    id : record.id,
                    exercise_id : id,
                    date : record.date,
                    duration : record.duration,
                    note : record.note
                })
            })
            .filter(async (record) => await record.exercise_id == id)
        )
    }

    ,async insert(record) {
        const redis = await connection()

        return await redis.hSet(
            `${table}:${record.id}`,
            {
                exercise_id : record.id,
                date : record.date,
                duration : record.duration,
                note : record.note
            }
        )
    }
}

