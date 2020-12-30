import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:bdd_widget_test/src/bdd_line.dart';
import 'package:bdd_widget_test/src/regex.dart';
import 'package:bdd_widget_test/src/step_file.dart';
import 'package:bdd_widget_test/src/step_generator.dart';
import 'package:path/path.dart' as p;

Future<String> generateFeatureDart(List<BddLine> lines, List<StepFile> steps, String path) async {
  final sb = StringBuffer();
  sb.writeln('// GENERATED CODE - DO NOT MODIFY BY HAND');
  sb.writeln('// ignore_for_file: unused_import, directives_ordering');
  sb.writeln('');
  sb.writeln("import 'package:flutter/material.dart';");
  sb.writeln("import 'package:flutter_test/flutter_test.dart';");
  sb.writeln("import 'package:integration_test/integration_test.dart';");
  sb.writeln('');

  for (final line in lines.takeWhile((value) => value.type != LineType.feature)) {
    if (line.rawLine != '#language: ru') {
      sb.writeln(line.rawLine);
    }
  }

  var importList = <String>{};
  for (final step in steps) {
    var import = await _findImport(step, path);
    if (import != '') {
      importList.add("import '${p.relative(import, from: p.join(p.dirname(p.dirname(path)), 'tests'))}';");
    }
  }
  sb.writeAll(importList, '\n');

  var testPath = p.join(p.dirname(p.dirname(path)), 'tests', '${p.basenameWithoutExtension(path)}_test.dart');
  sb.writeln('\n\n');
  sb.writeln('//flutter drive --driver=test_driver/app_test.dart --target=$testPath');
  sb.writeln('void main() {');
  sb.writeln('  IntegrationTestWidgetsFlutterBinding.ensureInitialized();');

  final features = splitWhen(
      lines.skipWhile((value) => value.type != LineType.feature), // skip header
          (e) => e.type == LineType.feature);

  for (final feature in features) {
    final backgroundOffset = _parseBackground(sb, feature);
    final afterOffset = _parseAfter(sb, feature);
    final offset = _calculateOffset(backgroundOffset, afterOffset);
    _parseFeature(sb, feature, offset);
  }
  sb.writeln('}');
  return sb.toString();
}


Future<String> _findImport(StepFile step, path) async {
  var stepsDir = p.join(p.dirname(p.dirname(path)), 'steps');
  var stepList = Directory(stepsDir).list(recursive: true, followLinks: false);
  var result = '';
  await for (var entity in stepList) {
    if (await FileSystemEntity.isFile(entity.path)) {
      var filename = entity.path;
      final file = await File(filename);
      final length = await file.length();
      if (length > 0) {
        await file.openRead().map(utf8.decode).transform(LineSplitter()).forEach((line) {
          var definition = functionDefinitionRegExp.stringMatch(line);
          if (definition == step.definition) {
            result = filename;
          }
        });
      }
    }
  }

  return result;
}

int _parseBackground(StringBuffer sb, List<BddLine> lines) =>
    _parseSetup(sb, lines, LineType.background, 'setUp');

int _parseAfter(StringBuffer sb, List<BddLine> lines) =>
    _parseSetup(sb, lines, LineType.after, 'tearDown');

int _calculateOffset(int backgroundOffset, int afterOffset) {
  if (backgroundOffset == -1 && afterOffset == -1) {
    return -1;
  }
  return max(backgroundOffset, afterOffset);
}

int _parseSetup(
    StringBuffer sb, List<BddLine> lines, LineType elementType, String title) {
  var offset = lines.indexWhere((element) => element.type == elementType);
  if (offset != -1) {
    sb.writeln('  $title(() async {');
    offset++;
    while (lines[offset].type == LineType.step) {
      sb.writeln('    await ${getStepMethodName(lines[offset].value)}();');
      offset++;
    }
    sb.writeln('  });');
  }
  return offset;
}

void _parseFeature(StringBuffer sb, List<BddLine> feature, int offset) {
  sb.writeln('  group(\'${feature.first.value}\', () {');

  final scenarios = splitWhen(
      feature.skip(offset == -1
          ? 1 // Skip 'Feature:'
          : offset), // or 'Backround:' / 'After:'
          (e) => e.type == LineType.scenario).toList();
  for (final scenario in scenarios) {
    _parseScenario(sb, scenario);
  }
  sb.writeln('  });');
}

void _parseScenario(StringBuffer sb, List<BddLine> scenario) {
  sb.writeln('    testWidgets(\'${scenario.first.value}\', (tester) async {');

  for (final step in scenario.skip(1)) {
    sb.writeln('      await ${getStepMethodCall(step.value)};');
  }

  sb.writeln('    });');
}

List<List<T>> splitWhen<T>(Iterable<T> original, bool Function(T) predicate) =>
    original.fold(<List<T>>[], (previousValue, element) {
      if (predicate(element)) {
        previousValue.add([element]);
      } else {
        previousValue.last.add(element);
      }
      return previousValue;
    });
