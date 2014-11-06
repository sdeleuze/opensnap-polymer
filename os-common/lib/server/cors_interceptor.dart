part of os_common_server;

@app.Interceptor(r'/.*')
void corsInterceptor() {
  if (app.request.method == 'OPTIONS') {
    //overwrite the current response and interrupt the chain.
    app.response = new shelf.Response.ok(null, headers: _CORS_HEADERS);
    app.chain.interrupt();
  } else {
    //process the chain and wrap the response
    app.chain.next(() => app.response.change(headers: _CORS_HEADERS));
  }
}

const _CORS_HEADERS = const {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'Content-Type',
  'Access-Control-Allow-Methods': 'POST, GET, DELETE, OPTIONS',
  'Access-Control-Max-Age': '1728000'
};
