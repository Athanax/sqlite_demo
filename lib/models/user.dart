import 'package:hive/hive.dart';
import 'package:sqlite_demo/models/car.dart';

part 'user.g.dart';

@HiveType(typeId: 0)
class User extends HiveObject {
  @HiveField(0)
  String? name;

  @HiveField(1)
  int? age;

  @HiveField(2)
  Car? car;

  User({this.name, this.age, this.car});

  User.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    age = json['age'];
    car = Car.fromJson(json['car']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['age'] = age;
    data['car'] = car;
    return data;
  }
}
