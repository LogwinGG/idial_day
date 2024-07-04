import 'package:idial_day/data/repository/interface/list_targets_repo.dart';
import 'package:idial_day/models/target_data.dart';
import 'package:idial_day/use_cases/interfaces/list_targets_case.dart';

class ListTargetsCaseImpl extends ListTargetsCase {
   final ListTargetsRepo _listTargetsRepo;

  ListTargetsCaseImpl(this._listTargetsRepo);


  @override
  List<dynamic> getLastDataTargets() => _listTargetsRepo.getLastDataTargets();

  @override
  Future<List<dynamic>> saveListTargets(List<dynamic> items) => _listTargetsRepo.saveListTargets(items);

  @override
  Future<List<dynamic>> removeItem(String uid) async{
       var list = _listTargetsRepo.getLastDataTargets() ;
       list.removeWhere((item) => item.uid == uid);
       return await _listTargetsRepo.saveListTargets(list);
  }

  @override

  Future<List<dynamic>> updateItem(TargetData el) async{
    var list = _listTargetsRepo.getLastDataTargets() ;
    for(var item in list) {
      if(item.uid == el.uid)  {
        item.title = el.title;
        item.reward = el.reward;
        item.punishment = el.punishment;
        item.redLine = el.redLine;
        item.isDone = el.isDone;
      }
    }
    return await _listTargetsRepo.saveListTargets(list);
  }

}