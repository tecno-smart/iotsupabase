import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iot/constant.dart';
import 'package:iot/control/controler.dart';

class Shudel extends StatelessWidget {
  Shudel({super.key, required this.rid, required this.mac});

  final int rid;
  final String mac;

  final List<String> dd = [
    "الاثنين",
    "الثلاثاء",
    "الاربعاء",
    "الخميس",
    "الجمعة",
    "السبت",
    "الاحد"
  ];
  @override
  Widget build(BuildContext context) {
    final Schudeler control = Get.put(Schudeler(mac_dev: mac, relay: rid));

    return Scaffold(
      appBar: AppBar(
        title: Text("جدولة التشغيل و الايقاف "),
      ),
      body: Column(
        children: [
          ElevatedButton(
              style: ButtonStyle(
                  minimumSize: WidgetStatePropertyAll(Size(250, 50))),
              onPressed: () {
                fun_pg_add(context);
              },
              child: Text(
                "+",
                style: TextStyle(fontSize: 30),
              )),
          Obx(
            () => Expanded(
              child: ListView.builder(
                itemCount: control.shudel_list.length,
                itemBuilder: (BuildContext context, int index) {
                  final sh = control.shudel_list[index];
                  return CardN(
                      day: dd[sh.day! - 1], start: sh.start, end: sh.end);
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<dynamic> fun_pg_add(BuildContext context) {
    final control = Get.put(Schudeler(mac_dev: mac, relay: rid));
    return Get.defaultDialog(
      title: "جدولة جديدة",
      content: Column(
        children: [
          Text(
            "daye : ",
            style: TextStyle(fontSize: 20),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
                color: Genral.run, borderRadius: BorderRadius.circular(20)),
            width: 150.0,
            child: Obx(
              () => DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                dropdownColor: Genral.run,
                value: control.day.value,
                items: [
                  DropdownMenuItem(child: Text("الاثنين"), value: 1),
                  DropdownMenuItem(child: Text("الثلاثاء"), value: 2),
                  DropdownMenuItem(child: Text("الاربعاء"), value: 3),
                  DropdownMenuItem(child: Text("الخميس"), value: 4),
                  DropdownMenuItem(child: Text("الجمعة"), value: 5),
                  DropdownMenuItem(child: Text("السبت"), value: 6),
                  DropdownMenuItem(child: Text("الاحد"), value: 7),
                ],
                onChanged: (value) {
                  if (value != null) {
                    // تأكد أن القيمة ليست null
                    control.day.value = value;
                    print("You selected $value");
                  }
                },
              )),
            ),
          ),
          Row(
            children: [
              Text("Start time : ", style: TextStyle(fontSize: 20)),
              InkWell(
                onTap: () async {
                  TimeOfDay? selectedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay(hour: 0, minute: 0));
                  if (selectedTime != null) {
                    final formattedTime = selectedTime.format(context);
                    control.start.value = formattedTime;
                    print(formattedTime);
                  }
                },
                child: Obx(() => Text(
                      control.start.value,
                      style: TextStyle(fontSize: 20),
                    )),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Text("End time : ", style: TextStyle(fontSize: 20)),
              InkWell(
                onTap: () async {
                  TimeOfDay? selectedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay(hour: 0, minute: 0));
                  if (selectedTime != null) {
                    final formattedTime = selectedTime.format(context);
                    control.end.value = formattedTime;
                    print(formattedTime);
                  }
                },
                child: Obx(() =>
                    Text(control.end.value, style: TextStyle(fontSize: 20))),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
      onConfirm: () {
        control.insert_shudel(rid, mac, control.start.value, control.end.value,
            control.day.value);
        Get.back();
      },
    );
  }
}

class CardN extends StatelessWidget {
  const CardN({
    super.key,
    required this.day,
    required this.start,
    required this.end,
  });
  final String day;
  final String start;
  final String end;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
        key: Key("eslam"),
        direction: DismissDirection.startToEnd,
        background: Container(
          color: Colors.red,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: const Icon(
            Icons.delete,
            color: Colors.white,
          ),
          alignment: Alignment.centerLeft,
        ),
        // secondaryBackground: Container(
        //   color: Colors.green,
        //   padding: const EdgeInsets.symmetric(horizontal: 20),
        //   child: const Icon(
        //     Icons.archive,
        //     color: Colors.white,
        //   ),
        //   alignment: Alignment.centerRight,
        // ),
        child: Card(
          child: ListTile(
            title: Text(day),
            trailing: Icon(Icons.edit),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    Text("Start : "),
                    Text(start),
                  ],
                ),
                Row(
                  children: [
                    Text("End : "),
                    Text(end),
                  ],
                ),
              ],
            ),
            leading: Icon(
              Icons.alarm,
              size: 50,
            ),
          ),
        ));
  }
}
