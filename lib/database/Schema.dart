import 'package:sqflite/sqflite.dart';
import 'package:sqlite_demo/database/DatabaseHelper.dart';
import 'package:sqlite_demo/database/Field.dart';

class Schema {
  static Future<void> create(String tableName, List<Field> fields) async {
    // List<String> fieldStrings = [];
    Database database = await DatabaseHelper.instance.database;
    bool tableExists = await Schema._checkIfTableExists(tableName, database);

    String createTableStatement = tableExists
        ? 'ALTER TABLE ' + tableName + ' '
        : 'CREATE TABLE ' + tableName + '(';

    for (var field in fields) {
      // fieldStrings.add(field.build());
      if (tableExists) {
        bool columnExists =
            await Schema._checkIfColumnExists(database, tableName, field.name);

        if (!columnExists) {
          database
              .execute(createTableStatement + " ADD COLUMN " + field.build());
        }
      } else {
        createTableStatement = createTableStatement +
            " " +
            field.build() +
            (field == fields.last ? "" : ",");
      }
    }
    createTableStatement = createTableStatement + ")";
    // database.execute("DROP TABLE IF EXISTS " + tableName);
    if (!tableExists) {
      database.execute(createTableStatement);
    }
  }

  static Future<bool> _checkIfTableExists(
      String tableName, Database database) async {
    List result = await database.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='$tableName'");
    if (result.isNotEmpty) {
      return true;
    }
    return false;
  }

  static Future<bool> _checkIfColumnExists(
      Database database, String tableName, String columnName) async {
    try {
      await database.rawQuery("SELECT $columnName FROM $tableName LIMIT 1");
      return true;
    } on DatabaseException catch (_) {
      return false;
    }
  }
}
