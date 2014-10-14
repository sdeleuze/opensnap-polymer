part of os_common_server;

class Encode {
    const Encode();
}

class Decode {
    const Decode();
}

ObjectMapper(app.Manager manager) {

    manager.addParameterProvider(Decode, (metadata, type, handlerName, paramName, req, injector) {
        if (req.bodyType != app.JSON) {
            throw new app.RequestException(
                "ObjectMapper plugin - $handlerName", "content-type must be 'application/json'");
        }

        ClassMirror clazz = reflectClass(type);
        InstanceMirror obj = clazz.newInstance(const Symbol("fromJson"), [req.body]);
        return obj.reflectee;
    });

    manager.addResponseProcessor(Encode, (metadata, handlerName, value, injector) {
        if (value == null) {
            return value;
        }
        return value.toJson();
    });

}
