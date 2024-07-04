import 'package:idial_day/models/target_data.dart';

abstract class ListTargetsCase {
  List<dynamic> getLastDataTargets();

  Future<List<dynamic>> saveListTargets(List<dynamic> items);

  Future<List<dynamic>> removeItem(String uid) ;

  Future<List<dynamic>> updateItem(TargetData el) ;
}

