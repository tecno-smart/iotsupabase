import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iot/constant.dart';
import 'package:iot/control/controler.dart';
import 'package:iot/model/devicemodel.dart';

class SwEditor extends StatelessWidget {
  SwEditor({super.key, required this.rr})
      : _name = TextEditingController(text: rr.name);
  final TextEditingController _name;
  final editCont = Get.put(Rinfo());
  final DevEdit rr;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Editor"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                editCont
                    .upinfo(_name.text, rr.mac, rr.id!, editCont.imm.value)
                    .then((val) {
                  if (val == null) {
                    Get.back();
                  }
                });
              },
              icon: Icon(Icons.save))
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              "Rename Switch: ",
              style: TextStyle(fontSize: 18),
            ),
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width - 80,
                  height: 50,
                  child: TextField(
                    controller: _name,
                    decoration: InputDecoration(
                      label: Text(rr.name),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      prefixIcon: Icon(Icons.device_hub),
                    ),
                  ),
                ),
              ),
              Container(
                  padding: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                      color: Genral.grey2,
                      borderRadius: BorderRadius.circular(10)),
                  height: 50,
                  width: 70,
                  child: Obx(
                    () => Image.asset(
                      "assets/other_icon/${editCont.imm}",
                      height: 50,
                      width: 50,
                    ),
                  ))
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              "Select image icon : ",
              style: TextStyle(fontSize: 18),
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  mainAxisSpacing: 3,
                  crossAxisSpacing: 3,
                  childAspectRatio: .8),
              itemCount: 35,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () => editCont.imm.value = "${index}.png",
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Genral.grey2),
                    child: Column(
                      children: [
                        Expanded(
                            child: Image.asset(
                          "assets/other_icon/${index}.png",
                          height: 60,
                          width: 60,
                        ))
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
