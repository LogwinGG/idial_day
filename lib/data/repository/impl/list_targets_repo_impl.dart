import 'package:hive/hive.dart';
import 'package:idial_day/data/repository/interface/list_targets_repo.dart';



class ListTargetsRepoImpl extends ListTargetsRepo {
  static const boxKey = 'listTargets';

  final Box box;

  ListTargetsRepoImpl(this.box);

  @override
  List<dynamic> getLastDataTargets() => box.get(boxKey) ?? [];

  @override
  Future<List<dynamic>> saveListTargets(List<dynamic> items) async {
    await box.put(boxKey, items);
    return items;
  }



}