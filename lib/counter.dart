import 'package:hive/hive.dart';

part 'counter.g.dart';


@HiveType(typeId:0)
class Counter {
  @HiveField(0)
  String title;
  @HiveField(1)
  int count;

  Counter({
    this.title,
    this.count,
  });
}

List<Counter> counterList = [];
