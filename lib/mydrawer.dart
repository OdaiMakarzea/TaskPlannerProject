import 'package:flutter/material.dart';
import 'package:odaiproject/class.dart';
import 'package:odaiproject/tasks_list_page.dart';

class MyDrawer extends StatefulWidget {
  final List<TaskModel> tasks;
  MyDrawer({Key? key, required this.tasks}) : super(key: key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  final String userName = "Odai Makharza";

  late List<TaskModel> myTasks;

   List drawerNames = [
    {
      "name": "Today",
      "icon": Icon(Icons.date_range_outlined),
      "noticount": '0',
    },
    {
      "name": "Inbox",
      "icon": Icon(Icons.inbox),
      "noticount": "0",
    },
    {
      "name": "Welcome",
      "icon": Icon(Icons.waves),
      "noticount": '8',
    },
    {
      "name": "Work",
      "icon": Icon(Icons.work),
      "noticount": '0',
    },
    {
      "name": "Personal",
      "icon": Icon(Icons.home),
      "noticount": '0',
    },
    {
      "name": "Shopping",
      "icon": Icon(Icons.shopping_cart),
      "noticount": '0',
    },
    {
      "name": "Wish List",
      "icon": Icon(Icons.animation),
      "noticount": '0',
    },
    {
      "name": "Birthday",
      "icon": Icon(Icons.cake),
      "noticount": '0',
    },
  ];

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      myTasks = widget.tasks;
      drawerNames[1]['noticount'] = "${widget.tasks.length}";
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 350,
      child: Container(
        // width: 150,
        color: Colors.white10,
        child: ListView(children:  [
          Container(
            alignment: Alignment.center,
            color: Colors.indigoAccent,
            height: 100,
            child:  ListTile(
              title: Text(userName, style: TextStyle(fontSize: 18,color: Colors.white,fontWeight: FontWeight.w700),),
              leading: CircleAvatar(
                  backgroundColor: Colors.purple,
                  radius: 25,
                  child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Text(userName.substring(0,1),style: TextStyle(fontSize: 18,color: Colors.white,fontWeight: FontWeight.w700),),
                        Positioned(
                          bottom: 15,
                          left: 15,
                          child: Icon(Icons.star,color: Colors.white,),
                        )
                      ]
                  )
              ),
              trailing: Container(
                alignment: Alignment.center,
                width: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(Icons.search,color: Colors.white,),
                    Icon(Icons.notifications,color: Colors.white,),
                    Icon(Icons.settings,color: Colors.white,),
                  ],
                ),
              ) ,
            ),
          ),
          ...List.generate(drawerNames.length, (index) => ListTile(
            onTap: () => drawerNames[index]['name'] == "Inbox" ? Navigator.of(context).push(MaterialPageRoute(builder: (builder) => TasksListPage(tasks: myTasks,))) : "null",
            title: Text(drawerNames[index]['name'],style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),),
            leading: drawerNames[index]['icon'],
            trailing: drawerNames[index]['noticount'] == '0' ?  null : Text(drawerNames[index]['noticount']),
          ),),

        ],),
      ),
    );
  }
}

