library os_common_server;

import 'dart:mirrors';

import 'package:redstone/server.dart' as app;
import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart' as shelf;

part 'server/object_mapper.dart';
part 'server/mongo_interceptor.dart';
part 'server/cors_interceptor.dart';
