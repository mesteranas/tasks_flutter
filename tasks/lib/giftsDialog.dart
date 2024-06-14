import 'package:test/jsonControl.dart';

import 'settings_handler.dart';
import 'createNewGift.dart';
import 'language.dart';
import 'package:flutter/material.dart';
class GiftsDialog extends StatefulWidget{
  Map<String,dynamic> tasks={"date":"","points":0,"tasks":[],"gifts":[]};
  GiftsDialog({Key?key , required this.tasks}):super(key:key);
  @override
  State<GiftsDialog> createState()=>_GiftsDialog(tasks);
}
class _GiftsDialog extends State<GiftsDialog>{
  var _=Language.translate;
  Map<String,dynamic> tasks={"date":"","points":0,"tasks":[],"gifts":[]};
  _GiftsDialog(this.tasks);
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title:Text(_("gifts")) ,
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(onPressed: () async{
              await Navigator.push(context, MaterialPageRoute(builder: (context)=>CreateNewGift(tasks)));
              setState(() {
                
              });

            }, child: Text(_("add"))),
            if (this.tasks["gifts"].isEmpty)
            ListTile(title: Text(_("no gifts !")),),
            for (var gift in this.tasks["gifts"]) ... [
            ListTile(title: Text(gift["name"] + _(" needs ") + gift["points"].toString() + _("points")),
                      onLongPress: () async{
            await showDialog(context: context, builder: (BuildContext context){
              return AlertDialog(
                title: Text(_("delete gift")),
                content: Center(
                  child: Column(
                    children: [
                      Text(_("would you like to delete this gift")),
                      ElevatedButton(onPressed: (){
                              this.tasks["gifts"].remove(gift);
            save(this.tasks);
            Navigator.pop(context);
                      }, child: Text(_("delete")))

                    ],
                  ),
                ),
              );
            });
            setState(() {
              
            });
          }),
            if(gift["pought"]==true)
            ListTile(title:Text(_("you bought it")))
            else           if (gift["points"]>this.tasks["points"])
            ListTile(title:Text(_("collect more points to buy it?")))

            else if (gift["pought"]==false)
                        ListTile(title: Text(_("buy"))
          ,onTap: () async{
            await showDialog(context: context, builder: (BuildContext context){
              return AlertDialog(
                title: Text(_("are you sure?")),
                content: Center(
                  child: ElevatedButton(child: Text(_("yeah")),
                    onPressed: (){
                      tasks["points"]-=gift["points"];
                      tasks["gifts"].remove(gift);
                      gift["pought"]=true;
                      tasks["gifts"].add(gift);
                      save(tasks);
                      Navigator.pop(context);
                    },

                  ),
                ),
              );
            });
            setState(() {
              
            });
          },)

          ],
          ]
        ),
      ),
    );
  }
}