import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() async {
    test();
    setState(() {
      _counter++;
    });
  }

  void test() async {
    // List<User>? users = [];
    // users = User().where(k: 'name', v: 'wambua').get() as List<User>;
    // Builder buider = Builder(tableName: 'users');
    // var a = await buider.where(k: 'name', v: 'wambua').get();
    // print(a);
    // buider.add(User(id: 1, name: 'wambua'));
    Schema.create('users', [
      Field('id').numberic().primaryKey(),
      Field('firstname').text().nullable().unique(),
      Field('lastname').text().nullable(),
      Field('password').text().nullable(),
      Field('token').text().nullable(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class Grocery {
  final int? id;
  final String name;

  Grocery({this.id, required this.name});

  factory Grocery.fromMap(Map<String, dynamic> json) => Grocery(
        id: json['id'],
        name: json['name'],
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'groceries.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
          id INTEGER PRIMARY KEY,
          name TEXT
      )
      ''');
  }

  Future<List<Grocery>> getGroceries() async {
    Database db = await instance.database;
    var groceries = await db.query('groceries', orderBy: 'name');
    List<Grocery> groceryList = groceries.isNotEmpty
        ? groceries.map((c) => Grocery.fromMap(c)).toList()
        : [];
    return groceryList;
  }

  Future<int> add(Grocery grocery) async {
    Database db = await instance.database;
    return await db.insert('groceries', grocery.toMap());
  }

  Future<int> remove(int id) async {
    Database db = await instance.database;
    return await db.delete('groceries',
        where: 'id = ?&name = ?', whereArgs: [id, 'wambua']);
  }

  Future<int> update(Grocery grocery) async {
    Database db = await instance.database;
    return await db.update('groceries', grocery.toMap(),
        where: "id = ?", whereArgs: [grocery.id]);
  }
}

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

class User {
  late int id;
  String? name;

  User({required this.id, this.name});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}

Map<String, dynamic> userMap = {"id": 1, "name": "wambua"};

enum Order { ASC, DESC }

class Field {
  Field(this.name);
  String name;
  String _type = '';
  String _tableName = '';
  String _referenceFieldName = '';
  bool _isPrimaryKey = false;
  bool _canBeNull = false;
  bool _isUnique = false;
  bool _isForeign = false;
  var _defaultValue;

  Field text() {
    _type = 'TEXT';
    return this;
  }

  Field integer() {
    _type = 'INTEGER';
    return this;
  }

  Field numberic() {
    _type = 'NUMERIC';
    return this;
  }

  Field real() {
    _type = 'REAL';
    return this;
  }

  Field boolean() {
    _type = 'BOOLEAN';
    return this;
  }

  Field blob() {
    _type = 'BLOB';
    return this;
  }

  Field nullable() {
    _canBeNull = true;
    return this;
  }

  Field primaryKey() {
    _isPrimaryKey = true;
    return this;
  }

  Field unique() {
    _isUnique = true;
    return this;
  }

  Field foreign() {
    _isForeign = true;
    return this;
  }

  Field references(String fieldName) {
    _referenceFieldName = fieldName;
    return this;
  }

  Field on(String tableName) {
    _tableName = tableName;
    return this;
  }

  Field setDefaultValue(var value) {
    _defaultValue = value;
    return this;
  }

  String build() {
    if (_isForeign) {
      return 'FOREIGN KEY ($name) REFERENCES $_tableName ($_referenceFieldName) ';
    }
    return '$name $_type ' +
        (_isPrimaryKey ? "PRIMARY KEY " : " ") +
        (_isUnique ? " UNIQUE " : "") +
        (_canBeNull ? "" : " NOT NULL ") +
        (_defaultValue != null ? "DEFAULT " + _defaultValue : "") +
        "";
  }
}

class Schema {
  static Future<void> create(String tableName, List<Field> fields) async {
    // List<String> fieldStrings = [];
    String createTableStatement = 'ALTER TABLE ' + tableName + '(';

    for (var field in fields) {
      // fieldStrings.add(field.build());

      createTableStatement = createTableStatement +
          " " +
          field.build() +
          (field == fields.last ? "" : ",");
    }
    createTableStatement = createTableStatement + ")";
    Database database = await DatabaseHelper.instance.database;
    // database.execute("DROP TABLE IF EXISTS " + tableName);
    database.execute(createTableStatement);
  }
}
