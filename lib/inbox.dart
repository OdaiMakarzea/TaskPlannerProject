import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:odaiproject/class.dart';
import 'package:odaiproject/local_database.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'mydrawer.dart';

class InboxPage extends StatefulWidget {
  const InboxPage({Key? key}) : super(key: key);

  @override
  State<InboxPage> createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> {
/*
  List<String> subTasks = [
    "Chapter 1",
    "Chapter 2",
    "Chapter 3",
  ];*/

  /*List<Map<String,dynamic>> tasks = [
    {
      "Title": "Go to the Gym",
      "date": DateFormat('EEE, MMM d, ''yyyy').format(DateTime.utc(2022,12,20)),
      "checked": false,
      "subtask": [
        "Chapter 1",
        "Chapter 2",
        "Chapter 3",
      ]
    },
    {
      "Title": "Coding",
      "date": DateFormat('EEE, MMM d, ''yyyy').format(DateTime.utc(2022,12,15)),
      "checked": false,
      "subtask": [
        "Chapter 1",
        "Chapter 2",
        "Chapter 3",
      ]

    },
    {
      "Title": "Swimming",
      "date": DateFormat('EEE, MMM d, ''yyyy').format(DateTime.utc(2022,12,10)),
      "checked": false,
      "subtask": [
        "Chapter 1",
        "Chapter 2",
        "Chapter 3",
      ]
    },
  ];*/
 // List<Map<String,dynamic>> tasksCompleted = [];
  final PanelController _pc = PanelController();
  bool openPanel = false;

  TextEditingController controller = TextEditingController();

  SqlDb sqlDb = SqlDb();
  
  List<TaskModel> taskList = [];
  List<TaskModel> tasksCompleted = [];
  
  fetchData() async {
    List response = await sqlDb.readData("SELECT * FROM 'task'");
    taskList.clear();
    setState(() {
      taskList.addAll(response.map((e) => TaskModel.fromJson(e)));
    });
    print(response);
    //int reponse = await sqlDb.deleteData("DELETE FROM task where task_id = 5 ");
    //print(reponse);
  }

  @override
  void initState() {
    // TODO: implement initState
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Visibility(
        visible: openPanel ? false : true,
        child: FloatingActionButton(
          heroTag: "Button1",
          onPressed: () {
            _pc.open();
          },
          child: const Icon(Icons.add),
        ),
      ),
      drawer: MyDrawer(tasks: taskList),
      appBar: AppBar(title: const Text("Inbox Page")),
      body: SlidingUpPanel(
        renderPanelSheet: false,
        backdropEnabled: true,
        minHeight: 10,
        maxHeight: 100,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),
        controller: _pc,
        onPanelClosed: () {
          setState(() {
            openPanel = false;
          });
        },
        onPanelOpened: () {
          setState(() {
            openPanel = true;
          });
        },
        panel: Container(
          color: Colors.white,
          child: Column(
            children: [
              TextFormField(
                controller: controller,
                decoration: const InputDecoration(
                    hintText: "Type Task name here",
                  border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 10)
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: Container(padding: const EdgeInsets.only(left: 10),child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Icon(Icons.calendar_today_rounded,color: Colors.grey,size: 20,),
                      Icon(Icons.flag_rounded,color: Colors.grey,size: 20,),
                      Icon(Icons.file_copy_rounded,color: Colors.grey,size: 20,),
                      Icon(Icons.save_outlined,color: Colors.grey,size: 20,),
                      Text("Inbox",style: TextStyle(color: Colors.grey),)
                    ],
                  ))),
                  const VerticalDivider(width: 1.0),
                  Expanded(child: Container(padding: const EdgeInsets.only(right: 5),alignment: Alignment.topLeft,
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                          decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(icon: Icon(Icons.arrow_forward,size: 30,),color: Colors.white,
                            onPressed: () {

                              DatePicker.showDatePicker(context,
                                showTitleActions: true,
                                maxTime: DateTime(2099, 12, 31),
                                theme: DatePickerTheme(
                                    headerColor: Colors.indigo.shade200,
                                    backgroundColor: Colors.indigo.shade100,
                                    itemStyle: const TextStyle(
                                        color: Colors.indigo,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),

                                    doneStyle: const TextStyle(color: Colors.indigo, fontSize: 20),
                                    cancelStyle: const TextStyle(color: Colors.blueGrey, fontSize: 20)

                                ),
                                onConfirm: (date) async {

                                    String myDate = DateFormat('EEE, MMM d, ''yyyy').format(DateTime.utc(date.year,date.month,date.day));
                                    int response = await sqlDb.insertData("INSERT INTO 'task' ('task_title', 'task_date', 'task_check') VALUES ('${controller.text}', '$myDate' , 0)");
                                    print("Response after add is: $response");
                                    fetchData();
                                    _pc.close();
                                    controller.clear();
                                    setState(() {});

                                  },
                              );
                            },)),
                    ],
                  ))),
                ],
              ),
            ],
          ),
        ),
        body: taskList.isEmpty ? const Center(child: Text("There is no Task please add one..",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),textAlign: TextAlign.center,),) : ListView(
          children: [
            Container(
              padding: const EdgeInsets.all(1),
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                border: Border.all(color: Colors.black,width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListView(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: [
                  Row(
                    children: [
                      Container(color: Colors.red,),
                      Container(color: Colors.blue,),
                    ],
                  ),
                  ...List.generate(taskList.length  , (index) =>
                    taskList[index].taskCheck == 0 ?
                    CheckboxListTile(
                          value: taskList[index].taskCheck == 0 ? false : true,
                          title: Text("${taskList[index].taskTitle}"),
                          secondary: Text("${taskList[index].taskDate}",style: const TextStyle(color: Colors.blue),),
                          controlAffinity: ListTileControlAffinity.leading,
                          onChanged: (value) {
                            setState(() {
                              taskList[index].taskCheck = value == true ? 1 : 0;
                              tasksCompleted.add(TaskModel.fromJson({
                                "task_title": taskList[index].taskTitle,
                                "task_date": taskList[index].taskDate,
                                "task_check": 1
                              }));
                            });
                          },
                          activeColor: Colors.blue,
                          checkColor: Colors.black,
                        ) : const SizedBox.shrink()
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(1),
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black,width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListView(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(child: Container(padding: const EdgeInsets.only(left: 10),child: const Text("COMPLETED",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold),))),
                      const VerticalDivider(width: 1.0),
                      Expanded(child: Container(alignment: Alignment.centerRight,child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text("${tasksCompleted.length}"),
                          const Icon(Icons.arrow_downward),
                        ],
                      ))),
                    ],
                  ),

                  ...List.generate(tasksCompleted.length, (index) =>  CheckboxListTile(
                      value: false,//taskList[index].taskCheck == 0 ? false : true,
                      enabled: false,
                      title: Text("${tasksCompleted[index].taskTitle}"),
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (value) {
                        setState(() {
                          taskList[index].taskCheck = value as int?;
                        });
                      },
                      activeColor: Colors.blue,
                      checkColor: Colors.black,
                    ),
                   ),
                ],
              ),
            ),
          ],
      ),
      ),
    );
  }
}



