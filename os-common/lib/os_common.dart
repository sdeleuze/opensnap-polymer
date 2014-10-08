library os_common;

import 'dart:convert';
import 'package:collection/equality.dart';
import "package:redstone_mapper/mapper.dart";

part 'user.dart';
part 'snap.dart';

Function listEq = const ListEquality().equals;