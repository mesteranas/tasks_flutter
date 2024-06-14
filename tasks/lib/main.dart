import 'giftsDialog.dart';
import 'createNewTask.dart';
import 'jsonControl.dart';
import 'settings.dart';
import 'package:flutter/widgets.dart';

import 'language.dart';
import 'package:http/http.dart' as http;
import 'viewText.dart';
import 'app.dart';
import 'contectUs.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() async{
  await WidgetsFlutterBinding.ensureInitialized();
  await Language.runTranslation();
  runApp(test());
}
class test extends StatefulWidget{
  const test({Key?key}):super(key:key);
  @override
  State<test> createState()=>_test();
}
class _test extends State<test>{
  var _=Language.translate;
  TextEditingController AchieveNumberControler=TextEditingController();
  Map<String,dynamic> tasks={"date":"","points":0,"tasks":[],"gifts":[]};
  String date="";
  int doneTasks=0;
  _test();
  void initState(){
    super.initState();
    loadTasks();
  }
  Future <void> loadTasks()async{
    doneTasks=0;
    tasks=await get();
        for (var task in tasks["tasks"]){
      if (task["type"] == 1){
        doneTasks+=1;
      }
    }

    DateTime now=DateTime.now();
    date="${now.year}/${now.month}/${now.day}";
    if (tasks["date"] !=date){
      tasks["date"]=date;
      tasks["points"]=0;
      for(var gift in tasks["gifts"]){
        tasks["gifts"].remove(gift);
        gift["pought"]=false;
        tasks["gifts"].add(gift);
      }
      for (var task in tasks["tasks"]){
        tasks["tasks"].remove(task);
        task["type"]=0;
        tasks["tasks"].add(task);
      }

      save(tasks);
    }

    setState(() {
      
    });
  }
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      locale: Locale(Language.languageCode),
      title: App.name,
      themeMode: ThemeMode.system,
      home:Builder(builder:(context) 
    =>Scaffold(
      appBar:AppBar(
        title: const Text(App.name),), 
        drawer: Drawer(
          child:ListView(children: [
          DrawerHeader(child: Text(_("navigation menu"))),
          ListTile(title:Text(_("settings")) ,onTap:() async{
            await Navigator.push(context, MaterialPageRoute(builder: (context) =>SettingsDialog(this._) ));
            setState(() {
              
            });
          } ,),
          ListTile(title: Text(_("contect us")),onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>ContectUsDialog(this._)));
          },),
          ListTile(title: Text(_("donate")),onTap: (){
            launch("https://www.paypal.me/AMohammed231");
          },),
  ListTile(title: Text(_("visite project on github")),onTap: (){
    launch("https://github.com/mesteranas/"+App.appName);
  },),
  ListTile(title: Text(_("license")),onTap: ()async{
    String result;
    try{
    http.Response r=await http.get(Uri.parse("https://raw.githubusercontent.com/mesteranas/" + App.appName + "/main/LICENSE"));
    if ((r.statusCode==200)) {
      result=r.body;
    }else{
      result=_("error");
    }
    }catch(error){
      result=_("error");
    }
    Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewText(_("license"), result)));
  },),
  ListTile(title: Text(_("about")),onTap: (){
    showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(title: Text(_("about")+" "+App.name),content:Center(child:Column(children: [
        ListTile(title: Text(_("version: ") + App.version.toString())),
        ListTile(title:Text(_("developer:")+" mesteranas")),
        ListTile(title:Text(_("description:") + App.description))
      ],) ,));
    });
  },)
        ],) ,),
        body:Container(alignment: Alignment.center
        ,child: Column(children: [
          ElevatedButton(onPressed: () async{
            await Navigator.push(context, MaterialPageRoute(builder: (context)=>GiftsDialog(tasks: tasks,)));
            setState(() {
              
            });

          }, child: Text(_("gifts"))),
          ListTile(title: Text(_("date:") + date),),
          ListTile(title:Text(_("points") + tasks["points"].toString()) ,),
          ListTile(title: Text(_("you ended") + doneTasks.toString() + _(" tasks from") + tasks["tasks"].length.toString() + _("tasks")),),
          ElevatedButton(onPressed: () async{
            await Navigator.push(context, MaterialPageRoute(builder: (context)=>CreateNewTask(tasks)));
            setState(() {
              
            });
          }, child: Text(_("add new task"))),
          if (tasks["tasks"].isEmpty)
            ListTile(title:Text(_("no tasks!"))),
          for (var task in tasks["tasks"]) ...[
          ListTile(title:Text(task["name"]),
          onLongPress: () async{
            await showDialog(context: context, builder: (BuildContext context){
              return AlertDialog(
                title: Text(_("delete task")),
                content: Center(
                  child: Column(
                    children: [
                      Text(_("would you like to delete this task")),
                      ElevatedButton(onPressed: (){
                              tasks["points"]-=task["count"]*task["points"];
                              tasks["tasks"].remove(task);
            save(tasks);
            Navigator.pop(context);
                      }, child: Text(_("delete")))

                    ],
                  ),
                ),
              );
            });
            setState(() {
              
            });
          },),
          if (task["type"]==1)
          ListTile(title:Text(_("you made  ") + task["count"].toString() + _(" from it")) ,)
          else if(task["type"]==2)
          ListTile(title:Text(_("you don't made it")), )
          else if(task["type"]==0)
          Column(
            children: [
          ListTile(title: Text(_("i made it")),
          onTap: () async{

            await showDialog(context: context, builder: (BuildContext context){
              return AlertDialog(
                title: Text(_("are you end this task?")),
                content: Center(
                  child: Column(
                    children: [
                    ListTile(title:Text(_("how do you achieve ?"))),
                    TextFormField(controller: AchieveNumberControler,keyboardType: TextInputType.number),
                    ElevatedButton(onPressed: (){
                      tasks["tasks"].remove(task);
                      task["type"]=1;
                      int Count=int.parse(AchieveNumberControler.text)??1;
                      task["count"]=Count;
                      tasks["points"]+=Count*task["points"];
                      tasks["tasks"].add(task);
                      save(tasks);
                      Navigator.pop(context);

                    }, child: Text(_("done")))
                    ],
                  ),
                ),
              );
            });
            setState(() {
              
            });
          },),
          ListTile(title: Text(_("you didn't make it"))
          ,onTap: () async{
            await showDialog(context: context, builder: (BuildContext context){
              return AlertDialog(
                title: Text(_("are you sure?")),
                content: Center(
                  child: ElevatedButton(child: Text(_("yeah")),
                    onPressed: (){
                      tasks["tasks"].remove(task);
                      task["type"]=2;
                      tasks["tasks"].add(task);
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
            ])
          ],
    ])),)));
  }
}
