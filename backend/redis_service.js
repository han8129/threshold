const redis = require('redis')
let _redis

 const connection = async () => {
    if (null == _redis)
    {
        _redis = await redis.createClient().connect()
    }

    return _redis
}

module.exports = { connection }
