import 'package:flutter/material.dart';
import 'package:idial_day/cubit/targets_list_cubit.dart';
import 'package:idial_day/models/target_data.dart';
import 'package:idial_day/screens/details_target_screen.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class TargetCart extends StatelessWidget {
   TargetsListCubit cubit;
   TargetData el;
   BuildContext  context;
   AnimationController animationController;

   TargetCart({Key? key, required this.el, required this.context, required this.cubit, required this.animationController}) : super(key: key);


  static DateTime now = DateTime.now();
  DateTime dateNow =  DateTime(now.year, now.month, now.day);

  getColor(String redLine) {
    DateTime resDate = DateFormat('dd.MM.yyyy').parse(redLine);
    var resultCompare = dateNow.compareTo(resDate);
    if(el.isDone == true) return null;
    if(resDate.compareTo(dateNow.add( const Duration(days: 1))) == 0) return  Colors.orangeAccent.withOpacity(0.9);
    if (resultCompare == 0) {
      return const Color.fromRGBO(255, 0, 0, 0.6);
    } else if(resultCompare == 1) {
      return const Color.fromRGBO(50, 0, 0, 1);
    }   else if(resultCompare == -1){
      return Colors.green.withOpacity(0.4);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(width: 5,color: Colors.black12),
          bottom: BorderSide(width: 5,color: Colors.black26)),
      ),
      child: ListTile(
        onTap: ()=> showDialog(context: context,
            builder: (context) => AlertDialog(
              actionsOverflowAlignment: OverflowBarAlignment.start,
              insetPadding:  EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.34),
              actions: [
                if(el.isDone == false) Container(

                  child: TextButton(
                    child: const Text('Выполнено!', style: TextStyle(color: Colors.cyanAccent)),
                    onPressed: (){
                      cubit.updateTarget(TargetData(uid: el.uid,redLine: el.redLine,title: el.title,reward: el.reward,punishment: el.punishment,isDone: true));
                      Navigator.pop(context);
                      ///запуск Анимации
                      animationController.forward().whenCompleteOrCancel(() {
                        animationController.reset();
                      });
                    },
                  ),
                ),
                TextButton(
                  child: const Text('Изменить', style: TextStyle(color: Colors.cyanAccent)),
                  onPressed: (){
                    Navigator.pop(context);
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => DetailsTargetScreen(el: el, cubit: cubit),),
                    );
                  },
                ),
                TextButton(
                  child: const Text('Удалить', style: TextStyle(color: Colors.cyanAccent)),
                  onPressed: (){
                    cubit.rmTarget(uid: el.uid!);
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  child: const Text('Отмена', style: TextStyle(color: Colors.cyanAccent)),
                  onPressed: ()=> Navigator.pop(context),
                ),
              ],
            )
        ),

        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${el.title}'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (el.reward != '')
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text('Награда: ${el.reward!}'),
                    ),
                  ),
                if (el.punishment != '')
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0,left: 8.0),
                      child: Text( 'Наказание:  ${el.punishment!}'),
                    ),
                  ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                el.isDone == true? Row(
                  children: const [
                    Text('Выполненно', style: TextStyle(color: Colors.green)),
                    Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Icon(Icons.done_all_outlined, color: Colors.green,),
                    ),
                  ],
                ):const SizedBox(),
                if (el.redLine != '')
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 5),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: getColor(el.redLine!),
                          borderRadius: const BorderRadius.all( Radius.circular(20)),
                        ),
                        child: Text( el.redLine!, style: TextStyle(color: Colors.white70))),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
