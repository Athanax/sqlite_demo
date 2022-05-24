import 'package:sqflite/sqflite.dart';
import 'package:sqlite_demo/config/variables.dart';
import 'package:sqlite_demo/data/models/User.dart';
import 'package:sqlite_demo/database/DatabaseHelper.dart';

class Builder {
  //
  String tableName;
  String? orderByStatement = null;
  List<Set<dynamic>> whereQuery = [];

  Builder({required this.tableName});

  Map<String, dynamic> find(int id) {
    return {};
  }

  Builder where({required String k, String op = '=', required dynamic v}) {
    whereQuery.add({k, op, v});
    print(whereQuery);
    return this;
  }

  Builder orderBy({required String column, required Order order}) {
    orderByStatement =
        "ORDER BY $column " + ((order == Order.ASC) ? "ASC" : "DESC");

    return this;
  }

  Future<List<Map<String, Object?>>> _constructSqlStatement() async {
    List whereArgs = [];
    String whereString = '';
    Database database = await DatabaseHelper.instance.database;
    for (Set needle in whereQuery) {
      whereString =
          whereString + needle.elementAt(0) + " " + needle.elementAt(1) + " ? ";
      whereArgs.add(needle.elementAt(2));
    }
    var res = await database.query('users',
        where: whereString, whereArgs: whereArgs, orderBy: orderByStatement);
    return res;
  }

  Future<int> add(User user) async {
    Database database = await DatabaseHelper.instance.database;
    return await database.insert('users', user.toJson());
  }

  Map<String, dynamic> first() {
    return userMap;
  }

  Map<String, dynamic> last() {
    return userMap;
  }

  Future<List<Map<String, Object?>>> get() async {
    var b = await _constructSqlStatement();
    return b;
  }
}
