part of os_common;

@app.Interceptor(r'/.*')
mongoInterceptor(MongoPool pool) {
  pool.getConnection().then((managedConnection) {
    app.request.attributes["db"] = managedConnection.conn;
    app.chain.next(() {
      if (app.chain.error is ConnectionException) {
        pool.releaseConnection(managedConnection, markAsInvalid: true);
      } else {
        pool.releaseConnection(managedConnection);
      }
    });
  });
}
