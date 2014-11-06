part of os_common_server;

@app.Interceptor(r'/.*')
mongoInterceptor(Db db) {
  if (db.state != State.OPEN) {
    db.open().then((_) {
      app.request.attributes["db"] = db;
      app.chain.next();
    });
  } else {
    app.request.attributes["db"] = db;
    app.chain.next();
  }
}
