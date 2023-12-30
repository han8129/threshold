const { connection } = require( './../redis_service.js')
const table = "records"
const columnExerciseId = 'exercise_id'
const columnDate = 'date'
const columnDuration = 'duration'
const columnNote = 'note'

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
        const id = record.id
        delete record.id

        return await redis.hSet( `${table}:${id}`, record)
    }

    ,async delete(id) {
        const redis = await connection()

        return await redis.sendCommand( [
            'HDEL', `${table}:${id}`,
            columnExerciseId,
            columnDate,
            columnDuration,
            columnNote
        ])
    }
}

