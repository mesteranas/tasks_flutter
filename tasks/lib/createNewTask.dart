import 'package:flutter/material.dart';
import 'package:test/jsonControl.dart';
import 'settings_handler.dart';
import 'language.dart';
class CreateNewTask extends StatelessWidget{
  Map<String,dynamic> tasks={"date":"","points":0,"tasks":[],"gifts":[]};
  var _=Language.translate;
  TextEditingController name=TextEditingController();
  TextEditingController points=TextEditingController();
  CreateNewTask(this.tasks);
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(_("new task")),
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
              int taskPoints=int.parse(points.text)??0;
              tasks["tasks"].add({"name":name.text,"points":taskPoints,"type":0,"count":0});
              save(tasks);
              Navigator.pop(context);
            }, child: Text(_("add")))
          ],
        ),
      ),
    );
  }
}