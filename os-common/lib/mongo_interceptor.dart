part of os_common;

/**
 * Retrieve and release a connection from the pool.
 */
@app.Interceptor(r'/.*')
mongoInterceptor(MongoPool pool) {

    //get a connection
    pool.getConnection().then((managedConnection) {

        //save the connection in the attributes map
        app.request.attributes["db"] = managedConnection.conn;

        app.chain.next(() {
            if (app.chain.error is ConnectionException) {
                //if a connection is lost, mark it as invalid, so the pool can reopen it
                //in the next request
                pool.releaseConnection(managedConnection, markAsInvalid: true);
            } else {
                //release the connection
                pool.releaseConnection(managedConnection);
            }
        });

    });
}
