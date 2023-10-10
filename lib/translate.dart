import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:gsheets/gsheets.dart';

/// This should be run from the base of the app, so you can just click Run|Debug
/// but then if you run it from command line, it will be
/// dart lib/translate.dart
Future<void> translate({
  required Map<String, dynamic> translationCredentials,
  required String translationSheetId,
  String? dir,
}) async {
  /// Assign the gsheets credentials
  final gsheets = GSheets(translationCredentials);

  /// Get all of tabs/sheets at the stated location
  final ss = await gsheets.spreadsheet(translationSheetId);

  final Map<String, String> fileStrings = {};
  final Map<String, Map<String, dynamic>> langs = {};

  /// For each tab in the sheets
  for (var sheet in ss.sheets) {
    var sheetStrings = await downloadSheets(sheet);
    if (sheetStrings != null) {
      fileStrings[sheetStrings.first] = sheetStrings.last;
    }
  }

  for (var file in fileStrings.keys) {
    /// Print the name to keep track
    print(file);

    /// Read the file's contents
    var newFile = fileStrings[file];

    /// Convert the contents to a list of rows
    final rows =
        CsvToListConverter().convert(newFile, fieldDelimiter: '\t', eol: '\n');

    if (rows.isNotEmpty) {
      for (var i = 3; i < rows[0].length; i++) {
        langs[rows[0][i]] = {};
      }
      for (var i = 0; i < rows.length; i++) {
        for (var j = 3; j < rows[i].length; j++) {
          langs[rows[0][j]]?[rows[i][0].toString()] = rows[i][j].toString();
          // first row for English: no description set
          // all other rows: add a description / additional field
          if (rows[0][j] == 'en' && i != 0) {
            langs[rows[0][j]]
                ?['@${rows[i][0]}'] = {"description": rows[i][2].toString()};
          }
        }
      }
    }
  }
  JsonEncoder jsonEncoder = JsonEncoder.withIndent('    ');
  for (var k in langs.keys) {
    writeFile('app_$k.arb', jsonEncoder.convert(langs[k]), dir);
  }
}

Future<List<String>?> downloadSheets(Worksheet sheet) async {
  /// Start with an empty string
  var string = '';

  /// Read all of the values for all of the rows, values is a list of rows
  var values = (await sheet.values.allRows());

  /// For each row, evaluate its values
  for (var v in values) {
    /// Join the values of each cell together separated by tabs
    string += v.join('\t');

    /// Separate each line with a carriage return
    string += '\n';
  }

  return ['${sheet.title.replaceAll('/', '_')}.tsv', string];
}

Future<void> writeFile(String fileName, String content, [String? dir]) async {
  var newFileName = '${dir ?? "lib/l10n"}/$fileName';
  if (!(await File(newFileName).exists())) {
    await File(newFileName).create(recursive: true);
  }
  await File(newFileName).writeAsString(content);
}
