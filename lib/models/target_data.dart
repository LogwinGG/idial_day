import 'package:hive/hive.dart';

part 'target_data.g.dart';


@HiveType(typeId: 0)
class TargetData extends HiveObject{

  @HiveField(0)
  String? uid;

  @HiveField(1)
  String? title;

  @HiveField(2)
  String? redLine;

  @HiveField(3)
  String? reward;

  @HiveField(4)
  String? punishment;

  @HiveField(5)
  bool? isDone = false;

  TargetData({
    this.uid,this.redLine,this.title,this.reward, this.punishment, this.isDone
});

}