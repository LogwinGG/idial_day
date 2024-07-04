import 'package:flutter/material.dart';
import 'package:idial_day/components/date_input_field.dart';
import 'package:idial_day/cubit/targets_list_cubit.dart';
import 'package:idial_day/models/target_data.dart';

// ignore: must_be_immutable
class DetailsTargetScreen extends StatefulWidget {
  TargetData? el;
  TargetsListCubit cubit;

  DetailsTargetScreen({Key? key, this.el, required this.cubit}) : super(key: key);

  @override
  _DetailsTargetScreenState createState() => _DetailsTargetScreenState();
}

class _DetailsTargetScreenState extends State<DetailsTargetScreen> {

  TargetsListCubit get cubit => widget.cubit;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleC = TextEditingController();
  final TextEditingController _redLineC = TextEditingController();
  final TextEditingController _textRewardC = TextEditingController();
  final TextEditingController _textPunishmentC = TextEditingController();
  bool _isDone = false;

  @override
  void initState() {
    super.initState();
    if(widget.el != null){
      _titleC.text = widget.el!.title!;
      _redLineC.text = widget.el!.redLine!;
      _textRewardC.text = widget.el!.reward!;
      _textPunishmentC.text = widget.el!.punishment!;
      _isDone = widget.el!.isDone ?? false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _titleC,
              style: TextStyle(color: Colors.white),
              maxLines: 3,
              decoration:  const InputDecoration(
                helperMaxLines: 3,
                labelText: 'Задача или список'
              ),
              validator: (value) {
                if (value == '') {
                  return 'Заполните поле';
                } else {
                  return null;
                }
              },
            ),
            DateInputField(
              controller: _redLineC,
              title: 'Red Line',
            ),
            TextFormField(
              controller: _textRewardC,
              style: TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                  labelText: 'Награда'
              ),
            ),
            TextFormField(
              controller: _textPunishmentC,
              style: TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                  labelText: 'Наказание'
              ),
            ),
            CheckboxListTile(
              activeColor: Colors.black ,
              checkColor: Colors.orange,
              title: _isDone ? const Text('Выполненно') : const Text('Пока цель не достигнута(', style: TextStyle(color: Colors.cyanAccent)),
              secondary: const Icon(Icons.tag_faces),
              selected: _isDone,
              selectedTileColor: Colors.lightBlue,
              visualDensity: VisualDensity.compact,
              enableFeedback: true,
              value: _isDone,
              onChanged: (_) {
                setState(() {
                  _isDone = _isDone? false:true;
                });
              },
            ),
            if(widget.el == null) MaterialButton(child: const Text('Создать'),
                onPressed: _create
            )
            else MaterialButton(
              child:  const Text('Обновить'),
              onPressed: _update,
            )
          ],
        ),
      ));
  }

  void _create() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      cubit.addTarget(TargetData(uid: DateTime.now().millisecondsSinceEpoch.toString(),title: _titleC.text,reward: _textRewardC.text,punishment: _textPunishmentC.text, redLine: _redLineC.text, isDone: _isDone));
      _formKey.currentState!.reset();
      Navigator.pop(context);
    }
  }

  void _update() {
    if (_formKey.currentState!.validate() ) {
      _formKey.currentState!.save();
      var el = widget.el!;
      if(el.title!.trim() != _titleC.text.trim() || el.reward!.trim() != _textRewardC.text.trim() || el.punishment!.trim() != _textPunishmentC.text.trim() || el.redLine != _redLineC.text || el.isDone != _isDone ) {
        cubit.updateTarget(
            TargetData(uid: el.uid,
              title: _titleC.text.trim(),
              reward: _textRewardC.text.trim(),
              punishment: _textPunishmentC.text.trim(),
              redLine: _redLineC.text,
              isDone: _isDone
            ));
      }
      _formKey.currentState!.reset();
      Navigator.pop(context);
    }
  }
}
