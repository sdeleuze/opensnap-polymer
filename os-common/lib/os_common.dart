library os_common;

import 'dart:convert';
import 'package:collection/equality.dart';
import "package:redstone_mapper/mapper.dart";
import "package:redstone_mapper_mongo/metadata.dart";

part 'user.dart';
part 'snap.dart';

Function listEq = const ListEquality().equals;