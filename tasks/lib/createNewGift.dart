import 'package:flutter/material.dart';
import 'package:test/jsonControl.dart';
import 'settings_handler.dart';
import 'language.dart';
class CreateNewGift extends StatelessWidget{
  Map<String,dynamic> tasks={"date":"","points":0,"tasks":[],"gifts":[]};
  var _=Language.translate;
  TextEditingController name=TextEditingController();
  TextEditingController points=TextEditingController();
  CreateNewGift(this.tasks);
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(_("new gift")),
      ),
      body: Center(
        child: Column(
          children: [
            TextFormField(
              controller: name,
              decoration: InputDecoration(label: Text(_("name")))
              ,keyboardType: TextInputType.text,textInputAction: TextInputAction.next,
            ),
            TextFormField(controller: points,
            decoration: InputDecoration(label: Text(_("points"))),
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,),
            ElevatedButton(onPressed: (){
              int taskPoints=int.parse(points.text)??1;
              tasks["gifts"].add({"name":name.text,"points":taskPoints,"pought":false});
              save(tasks);
              Navigator.pop(context);
            }, child: Text(_("add"))),
          ],
        ),
      ),
    );
  }
}