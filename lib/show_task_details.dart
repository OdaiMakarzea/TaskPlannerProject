
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:odaiproject/class.dart';

import 'local_database.dart';

class TaskDetails extends StatefulWidget {
  final TaskModel task;
  const TaskDetails({Key? key, required this.task}) : super(key: key);

  @override
  State<TaskDetails> createState() => _TaskDetailsState();
}

class _TaskDetailsState extends State<TaskDetails> {

  SqlDb sqlDb = SqlDb();

  List<SubTaskModel> subTaskList = [];

  TextEditingController controller = TextEditingController();

  fetchData() async {
    subTaskList.clear();
    List response = await sqlDb.readData("SELECT * FROM 'sub_task' where sub_task_taskid = ${widget.task.taskId}");
    setState(() {
      subTaskList.addAll(response.map((e) => SubTaskModel.fromJson(e)));
    });
    // int reponse = await sqlDb.deleteData("DELETE FROM task where task_id = 1 ");
    //print(reponse);
  }

  @override
  void initState() {
    // TODO: implement initState
    print(subTaskList.length);
    fetchData();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    DateTime durationStart = DateTime.now();
    DateTime durationEnd = DateFormat('EEE, MMM d, ''yyyy').parse(widget.task.taskDate!);
    String DateDay = durationEnd.day.toString() ;
    String? DateMonth = widget.task.taskDate;

    var differenceInDays = durationEnd.difference(durationStart).inDays;


    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(
          color: Colors.black, // <-- SEE HERE
        ),
        backgroundColor: Colors.white70,
        title: Row(
          children: const [
            Text("inbox", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),),
            Icon(Icons.keyboard_arrow_down,color: Colors.black26)
          ],
        ),
        actions:  [
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert),color: Colors.black,),
        ],
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.40,
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  Icon(Icons.push_pin,color: Colors.grey,size: 25,),
                  Icon(Icons.menu,color: Colors.grey,size: 25,),
                  Icon(Icons.lock_clock,color: Colors.grey,size: 25,),
                  Icon(Icons.browse_gallery,color: Colors.grey,size: 25,),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.40,
              height: 50,
              padding: const EdgeInsets.only(right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  Icon(Icons.subdirectory_arrow_left,color: Colors.grey,size: 25,),
                  SizedBox(width: 5,),
                  Icon(Icons.subdirectory_arrow_right,color: Colors.grey,size: 25,),
                  SizedBox(width: 10,),
                  Icon(Icons.arrow_downward,color: Colors.grey,size: 25,),
                ],
              ),
            ),
          ],
        ),
      ),
      body: subTaskList.isEmpty ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:  [
            const Text("There is no Sub Task for this Task! please add one..",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
            const SizedBox(height: 10,),
            const Text("Add Sub Task:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
            const SizedBox(height: 10,),
            TextFormField(
              controller: controller,
              decoration: const InputDecoration(
                  hintText: "Type Task name here",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 10)
              ),
            ),
            const SizedBox(height: 10,),
            Row(
              children: [
                Expanded(child: Container(
                  color: Colors.teal,
                  child: MaterialButton(
                    textColor: Colors.white,
                    onPressed: () async {
                      if(controller.text.isNotEmpty) {
                        int response = await sqlDb.insertData("INSERT INTO 'sub_task' ('sub_task_title', 'sub_task_check', 'sub_task_taskid') VALUES ('${controller.text}', 0 , ${widget.task.taskId})");
                        print("Response after add is: $response");
                        fetchData();
                        controller.clear();
                        setState(() {});
                      }
                    },
                    child: Text("Done"),
                  ),
                ))
              ],
            )


          ],
        ),)
          : ListView(
        shrinkWrap: true,
       // physics: NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 10),
        children:  <Widget>[
          ListTile(
            title: Text(" ${differenceInDays + 1} days later, ${DateMonth?.substring(4, 8)} $DateDay", style: const TextStyle(color: Colors.indigoAccent),),
            leading: const Icon(Icons.dvr_sharp),
            trailing: const Icon(Icons.flag_rounded),

          ),
          const SizedBox(height: 10,),
           Text("${widget.task.taskTitle}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 32),),
          const SizedBox(height: 20,),

          const Text("Description", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: Colors.grey),),

            ...List.generate(subTaskList.length   , (index) =>

                CheckboxListTile(
                  value: subTaskList[index].subTaskCheck == 0 ? false : true,
                  title: Text("${subTaskList[index].subTaskTitle}"),
                  secondary: const Icon(Icons.menu,color: Colors.grey,size: 25,),
                  controlAffinity: ListTileControlAffinity.leading,
                  onChanged: (value) {

                  },
                  activeColor: Colors.blue,
                  checkColor: Colors.black,
                ) //: SizedBox.shrink()
            ),
          const SizedBox(height: 10,),
          const Text("Add Sub Task:",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
          const SizedBox(height: 10,),
          TextFormField(
            controller: controller,
            decoration: const InputDecoration(
                hintText: "Type Task name here",
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 10)
            ),
          ),
          const SizedBox(height: 10,),
          Row(
            children: [
              Expanded(child: Container(
                color: Colors.teal,
                child: MaterialButton(
                  textColor: Colors.white,
                  onPressed: () async {
                    if(controller.text.isNotEmpty) {
                      int response = await sqlDb.insertData("INSERT INTO 'sub_task' ('sub_task_title', 'sub_task_check', 'sub_task_taskid') VALUES ('${controller.text}', 0 , ${widget.task.taskId})");
                      print("Response after add is: $response");
                      fetchData();
                      controller.clear();
                      setState(() {});
                    }
                  },
                  child: const Text("Done"),
                ),
              ))
            ],
          )


        ],
      ),
    );
  }
}
