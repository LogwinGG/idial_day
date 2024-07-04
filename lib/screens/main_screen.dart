import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idial_day/cubit/targets_list_cubit.dart';
import 'package:idial_day/cubit/targets_list_state.dart';
import 'package:idial_day/models/target_data.dart';
import 'package:idial_day/screens/components/target_cart.dart';
import 'package:idial_day/screens/details_target_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  final TargetsListCubit cubit = TargetsListCubit();
  late AnimationController _lottieAnimationController;
  DateTimeRange? _selectedDateRange;

  @override
  void initState() {
    _lottieAnimationController = AnimationController(vsync: this);
    super.initState();
  }
  @override
  void dispose() {
    _lottieAnimationController.dispose();
    super.dispose();
  }

  bool _filterDone = false;
  String _dropdownFilter = 'Все';
  List<dynamic> filterCommon (List<dynamic> list){
    var _bufList = list;
    if(!_filterDone) {
      list = _bufList;
    } else {
      list = list.where((element) => element.isDone).toList();
    }

    var __bufList = list;
    switch(_dropdownFilter) {
      case 'За месяц':
        list = list.where((el) {
          TargetData _el = el;
          DateTime _data =  DateTime.now();
          if(_el.redLine != null && _el.redLine != '') _data = DateFormat('dd.MM.yyyy').parse(_el.redLine!);
          if(
          _data.isAfter(DateTime.utc(DateTime.now().year,DateTime.now().month, 0)) &&
              _data.isBefore(DateTime.utc(DateTime.now().year,DateTime.now().month+1, 0))
          ){ return true;}
          else {return false;}
        }).toList() ;
        break;

      case 'За год':
        list = list.where((el) {
          TargetData _el = el;
          DateTime _data =  DateTime.now();
          if(_el.redLine != null && _el.redLine != '') _data = DateFormat('dd.MM.yyyy').parse(_el.redLine!);
          if(
          _data.isAfter(DateTime.utc(DateTime.now().year,1, 0)) &&
              _data.isBefore(DateTime.utc(DateTime.now().year+1,1, 0))
          ){ return true;}
          else {return false;}
        }).toList();
        break;
      case 'Все':
        list = __bufList;
        break;
    }

    if(_selectedDateRange != null){
      list = list.where((el) {
        TargetData _el = el;
        DateTime _data;
        if(_el.redLine != null && _el.redLine != '') _data = DateFormat('dd.MM.yyyy').parse(_el.redLine!);
        else _data =  DateTime.now();
        if(
          _data.isAfter(_selectedDateRange!.start.subtract(Duration(days: 1))) &&
          _data.isBefore(_selectedDateRange!.end.add(Duration(days: 1)))
        ){ return true;}
        else {return false;}
      }).toList();
    }
    
    return list;
  }

    Future<void> _showDateRangePicker(BuildContext context) async {
     final DateTimeRange? result = await showDateRangePicker(
       firstDate: DateTime(2020, 1, 1),
       lastDate: DateTime(DateTime.now().year + 11),
       context: context,
       initialDateRange: _selectedDateRange,
       helpText: 'Выбери диапазон ',
       cancelText: 'Отмена',
       confirmText: 'Продолжить',
       saveText: 'Выбрать',

    );

    if (result != null) {
      setState(() {
        _selectedDateRange = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.purple, Colors.orange])),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Colors.black,
          actions: [
            if (_selectedDateRange != null) Center(child: Text(DateFormat('dd.MM.yyyy').format(_selectedDateRange!.start)+' - '+DateFormat('dd.MM.yyyy').format(_selectedDateRange!.end))),
            if (_selectedDateRange != null) IconButton(onPressed: (){
              setState(() {
                _selectedDateRange = null;
              });
            }, icon: const Icon(Icons.highlight_remove_outlined)) ,
            DropdownButton<String>(
              value: _dropdownFilter,
              items: const <DropdownMenuItem<String>>[
                 DropdownMenuItem(
                  value: 'За месяц',
                  child: Text('За месяц', style: TextStyle(color: Colors.cyanAccent),),
                ),
                 DropdownMenuItem(
                  value: 'За год',
                  child: Text('За год', style: TextStyle(color: Colors.cyanAccent),),
                ),
                 DropdownMenuItem(
                  value: 'Все',
                  child: Text('Все', style: TextStyle(color: Colors.white70),),
                ),
              ],
              onChanged: (String? value){
                setState(() {
                  _dropdownFilter = value!;
                });
              }
            ),
            IconButton(onPressed:(){ _showDateRangePicker(context);}, icon: Icon(Icons.calendar_month)),
            IconButton(
            icon: Icon(Icons.done_all_outlined,color: _filterDone?  Colors.green : null ),
            onPressed: (){
              setState(() {
                _filterDone = _filterDone? false:true;
              });
            },)
          ],
        ),
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              Lottie.asset(
                'assets/fireworks.json',
                controller: _lottieAnimationController,
                onLoaded: (composition) {
                  _lottieAnimationController.duration = const Duration(seconds: 4);
                }
              ),
              BlocConsumer<TargetsListCubit, TargetsListState>(
                  bloc: cubit,
                  listener: (context, state) {},
                  builder: (context, state) {
                    switch (state.type) {
                      case TargetsListStateType.LOADING:
                        return const Center(child: CircularProgressIndicator());
                      case TargetsListStateType.LOADED:
                        var _list = filterCommon(state.data!);

                        return ReorderableListView.builder(
                          itemCount: _list.length,
                          itemBuilder: (BuildContext context, int index) {
                            return TargetCart(key: Key('$index'),el: _list[index], context: context, cubit: cubit, animationController: _lottieAnimationController);
                          },
                          onReorder: (int oldIndex, int newIndex) {
                            if (oldIndex < newIndex) {
                              newIndex -= 1;
                            }
                            var item = _list.removeAt(oldIndex);
                            _list.insert(newIndex, item);
                            if(_list[oldIndex] != _list[newIndex]) cubit.updateTarget(_list[0]);
                          },
                        );
                      case TargetsListStateType.ERROR:
                        return Center(child: Text('${state.errorMessage}'),);
                    }
                  }),
            ],
          ),
        ),
        persistentFooterButtons: [
          FloatingActionButton(
            backgroundColor:  const Color.fromRGBO(255, 160, 100, 1),
            child: const Icon(Icons.add_circle,size: 56 ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => DetailsTargetScreen(cubit: cubit),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
