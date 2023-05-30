
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';




final nameFieldController = Provider.autoDispose.family<TextEditingController, String?>((ref, value) =>TextEditingController(text: value));
final proteinFieldController = Provider.autoDispose.family<TextEditingController, String?>((ref, value) =>TextEditingController(text: value));
final fatFieldController = Provider.autoDispose.family<TextEditingController, String?>((ref, value) =>TextEditingController(text: value));
final fiberFieldController = Provider.autoDispose.family<TextEditingController, String?>((ref, value) =>TextEditingController(text: value));
final calciumFieldController = Provider.autoDispose.family<TextEditingController, String?>((ref, value) =>TextEditingController(text: value));
final phosphorousFieldController = Provider.autoDispose.family<TextEditingController, String?>((ref, value) =>TextEditingController(text: value));
final lyzineFieldController = Provider.autoDispose.family<TextEditingController, String?>((ref, value) =>TextEditingController(text: value));
final methionineFieldController = Provider.autoDispose.family<TextEditingController, String?>((ref, value) =>TextEditingController(text: value));
final priceFieldController = Provider.autoDispose.family<TextEditingController, String?>((ref, value) =>TextEditingController(text: value));
final quantityFieldController = Provider.autoDispose.family<TextEditingController, String?>((ref, value) =>TextEditingController(text: value));
final energyFieldController = Provider.autoDispose.family<TextEditingController, String?>((ref, value) =>TextEditingController(text: value));
final adultPigFieldController = Provider.autoDispose.family<TextEditingController, String?>((ref, value) =>TextEditingController(text: value));
final growPigFieldController = Provider.autoDispose.family<TextEditingController, String?>((ref, value) =>TextEditingController(text: value));
final poultryFieldController = Provider.autoDispose.family<TextEditingController, String?>((ref, value) =>TextEditingController(text: value));
final fishFieldController = Provider.autoDispose.family<TextEditingController, String?>((ref, value) =>TextEditingController(text: value));
final ruminantFieldController = Provider.autoDispose.family<TextEditingController, String?>((ref, value) =>TextEditingController(text: value));
final rabbitFieldController = Provider.autoDispose.family<TextEditingController, String?>((ref, value) =>TextEditingController(text: value));
