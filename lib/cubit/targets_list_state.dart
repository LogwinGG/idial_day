// ignore: constant_identifier_names
enum TargetsListStateType { LOADING, LOADED, ERROR }

class TargetsListState {
  final List<dynamic>? data;
  final TargetsListStateType type;
  final String? errorMessage;

   TargetsListState({required this.type, this.data, this.errorMessage})
      : assert(type != TargetsListStateType.ERROR || errorMessage != null,
  'errorMessage must not be null in error state');
}