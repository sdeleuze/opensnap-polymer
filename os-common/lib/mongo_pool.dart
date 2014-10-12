part of os_common;

/**
 * A MongoDB connection pool
 *
 */
class MongoPool extends ConnectionPool<Db> {

    String uri;

    MongoPool(String this.uri, [int poolSize=5]) : super(poolSize);

    @override
    void closeConnection(Db conn) {
        conn.close();
    }

    @override
    Future<Db> openNewConnection() {
        var conn = new Db(uri);
        return conn.open().then((_) => conn);
    }
}


