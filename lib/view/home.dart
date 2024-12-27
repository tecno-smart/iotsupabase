import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iot/auth/login.dart';
import 'package:iot/constant.dart';
import 'package:iot/control/controler.dart';
import 'package:iot/view/add_device.dart';
import 'package:iot/view/devinfo.dart';

class Home extends StatelessWidget {
  final box = GetStorage();
  Home({super.key});

  @override
  Widget build(BuildContext context) {
    final Authserv iot = Get.put(Authserv());
    String em = box.read('email');
    iot.fetchDevices(em);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Genral.grey2,
        title: Text("Smart iot"),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              iot.fetchDevices(em);
            },
            icon: Icon(Icons.refresh)),
        actions: [
          IconButton(
              onPressed: () {
                box.write("login", false);
                Get.to(() => Addpage());
              },
              icon: Icon(Icons.add)),
          IconButton(
              onPressed: () {
                box.write("login", false);
                Get.off(() => LoginPage());
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: Center(
          child: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          Obx(() {
            return Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: .9,
                    mainAxisSpacing: 10),
                itemCount: iot.devicesList.length,
                itemBuilder: (BuildContext context, int i) {
                  final device = iot.devicesList[i];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: InkWell(
                      onTap: () {
                        Get.to(
                            () => Rpage(board: device.name, macc: device.mac));
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Genral.grey2,
                            borderRadius: BorderRadius.circular(20)),
                        clipBehavior: Clip.hardEdge,
                        child: Column(children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text("Device : ",
                                      style: TextStyle(
                                          fontSize: 18, color: Genral.grey)),
                                  Text(
                                    "${i + 1}",
                                    style: TextStyle(
                                        fontSize: 18,
                                        decoration: TextDecoration.underline,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              IconButton(
                                  onPressed: () {
                                    Get.defaultDialog(
                                        title: "Delete Device",
                                        content: Row(
                                          children: [
                                            Text(" Are You Sure To Delete "),
                                            Text("[ ${device.name} ]"),
                                          ],
                                        ),
                                        onConfirm: () {
                                          iot.DeletDevice(device.mac);
                                          Get.back();
                                          iot.fetchDevices(em);
                                        },
                                        onCancel: () {});
                                  },
                                  icon: Icon(
                                    Icons.delete_forever,
                                    color: Colors.blue,
                                  )),
                            ],
                          ),
                          Expanded(
                              child: Image.asset(
                            'assets/iconapp/server.png',
                            height: 100,
                            width: 100,
                          )),
                          Row(
                            children: [
                              Text(
                                'Name : ',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Genral.grey),
                              ),
                              Text(device.name,
                                  style: TextStyle(
                                      fontSize: 19, color: Genral.iconcolor)),
                            ],
                          ),
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Mac : ',
                                    style: TextStyle(
                                        fontSize: 18, color: Genral.grey),
                                  ),
                                  Text(device.mac,
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Genral.backcolor))
                                ],
                              ),
                            ],
                          ),
                        ]),
                      ),
                    ),
                  );
                },
              ),
            );
          })
        ],
      )),
    );
  }
}
