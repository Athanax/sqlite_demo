import 'package:hive/hive.dart';

part 'car.g.dart';

@HiveType(typeId: 1)
class Car extends HiveObject {
  @HiveField(0)
  String? model;

  @HiveField(1)
  int? cc;

  @HiveField(2)
  int? year;

  Car({this.model, this.cc, this.year});

  Car.fromJson(Map<String, dynamic> json) {
    model = json['model'];
    cc = json['cc'];
    year = json['year'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['model'] = model;
    data['cc'] = cc;
    data['year'] = year;
    return data;
  }
}
