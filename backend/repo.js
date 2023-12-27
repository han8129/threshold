const redis = require( 'redis' )
const table = "exercise"

module.exports = class ExerciseRepository {
    constructor(client) {
        this.client = client
    }

    async getAll() {
        // idx:bicycle "*" RETURN 2 __key, price
        return Array.from( await this.client.sendCommand(
            ['scan', '0', 'match', 'exercise:*']
        ))[1]

    }
}

