import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idial_day/cubit/targets_list_state.dart';
import 'package:idial_day/di.dart';
import 'package:idial_day/models/target_data.dart';

class TargetsListCubit extends Cubit<TargetsListState> {
  final listTargetsCases = DI.getInstance().listTargetsCase;

  TargetsListCubit() : super(TargetsListState(type: TargetsListStateType.LOADING)){
    emitState(type: TargetsListStateType.LOADED,data: listTargetsCases.getLastDataTargets() );
  }


  addTarget(TargetData newTarget) async{
    emitState(type: TargetsListStateType.LOADING);
    var list = listTargetsCases.getLastDataTargets();
    list.add(newTarget);
    final _saveValue = await listTargetsCases.saveListTargets(list);
    emitState(type: TargetsListStateType.LOADED,data: _saveValue );
  }

  rmTarget({required String  uid}) async{
    emitState(type: TargetsListStateType.LOADING);
    final _newList = await listTargetsCases.removeItem(uid);
    emitState(type: TargetsListStateType.LOADED,data: _newList );
  }

  updateTarget(TargetData updateEl) async{
    emitState(type: TargetsListStateType.LOADING);
    final _newList = await listTargetsCases.updateItem(updateEl);
    emitState(type: TargetsListStateType.LOADED,data: _newList );
  }

  emitState(
      {required TargetsListStateType type,
        List<dynamic>? data,
        String? errorMessage}) {
    emit(TargetsListState(type: type, data: data, errorMessage: errorMessage));
  }
}