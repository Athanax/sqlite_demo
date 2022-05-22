import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sqlite_demo/factories/user_factory.dart';
import 'package:sqlite_demo/models/user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
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
    UserFactory factory = UserFactory();
    User usr = User.fromJson({
      "name": "John",
      "age": 30,
      "car": {"model": "John", "cc": 30, "year": 2000}
    });
    factory.create(usr);

    // print(factory.index());
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


    // List<User>? users = [];
    // users = User().where(k: 'name', v: 'wambua').get() as List<User>;
    // Builder buider = Builder(tableName: 'users');
    // var a = await buider.where(k: 'name', v: 'wambua').get();
    // print(a);
    // buider.add(User(id: 1, name: 'wambua'));
    // Schema.create('users', [
    //   Field('id').numberic().primaryKey(),
    //   Field('firstname').text().nullable().unique(),
    //   Field('lastname').text().nullable(),
    //   Field('password').text().nullable(),
    //   Field('token').text().nullable(),
    // ]);