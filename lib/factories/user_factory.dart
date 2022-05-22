import 'package:hive/hive.dart';
import 'package:sqlite_demo/models/car.dart';
import 'package:sqlite_demo/models/user.dart';

class UserFactory {
  late var _box;

  UserFactory() {
    _initHive();
  }

  void _initHive() async {
    Hive.registerAdapter(UserAdapter());
    Hive.registerAdapter(CarAdapter());
    _box = await Hive.openBox<User>('users');
    // await _box.clear();
  }

  Future<User> create(User user) async {
    await user.save();
    return user;
  }

  Future<List<User>> index() async {
    return _box.values;
  }
}
