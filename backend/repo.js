const redis = require( 'redis' );

async function client()
{
    const command = await redis.createClient()
        .on('error', err => console.log('Redis Client Error', err))
        .connect();

    var arr = Array.from( command.scanIterator())
    return arr
}

module.export = {client}
