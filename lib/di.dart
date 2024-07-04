import 'package:hive/hive.dart';
import 'package:idial_day/data/repository/impl/list_targets_repo_impl.dart';
import 'package:idial_day/data/repository/interface/list_targets_repo.dart';
import 'package:idial_day/models/target_data.dart';
import 'package:idial_day/use_cases/impl/list_targets_case_impl.dart';
import 'package:idial_day/use_cases/interfaces/list_targets_case.dart';
import 'package:path_provider/path_provider.dart';

class DI {
  static DI? instance;
  late ListTargetsRepo listTargetsRepo;
  late ListTargetsCase listTargetsCase;

  DI._();

  static DI getInstance(){
    return instance ?? (instance = DI._());
  }

  Future<void> init() async {
    final directory = await getApplicationSupportDirectory();
    Hive
      ..init(directory.path)
      ..registerAdapter(TargetDataAdapter());
    listTargetsRepo = ListTargetsRepoImpl(await Hive.openBox('listTargets'));
    listTargetsCase = ListTargetsCaseImpl(listTargetsRepo);
  }
}