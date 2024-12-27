import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iot/constant.dart';
import 'package:iot/control/controler.dart';
import 'package:iot/model/devicemodel.dart';
import 'package:iot/view/shudelpg.dart';
import 'package:iot/view/switch_editor.dart';

class Rpage extends StatelessWidget {
  Rpage({super.key, required this.board, required this.macc});
  final String macc;
  final editCont = Get.put(Rinfo());
  final String board;

  @override
  Widget build(BuildContext context) {
    final getrelays iot = Get.put(getrelays(mac: macc));
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Genral.grey2,
          centerTitle: true,
          title: Text(
            board,
            style: TextStyle(fontSize: 30),
          ),
        ),
        body: Obx(() {
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, mainAxisSpacing: 10),
            itemCount: iot.relaylst.length,
            itemBuilder: (BuildContext context, int index) {
              final Relay = iot.relaylst[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Container(
                  margin: EdgeInsets.only(top: 10),
                  key: ValueKey(Relay.Rid),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Relay.stat ? Genral.run : Genral.grey2,
                      borderRadius: BorderRadius.circular(20)),
                  clipBehavior: Clip.hardEdge,
                  child: Column(children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Name  :  ',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Genral.grey),
                              ),
                              Text(Relay.RelName,
                                  style: TextStyle(
                                      fontSize: 19, color: Genral.iconcolor)),
                            ],
                          ),
                          GestureDetector(
                            onDoubleTap: () {
                              Get.to(() => Shudel(
                                    rid: Relay.Rid,
                                    mac: Relay.mac,
                                  ));
                            },
                            onLongPress: () {
                              bool y;
                              y = Relay.shudelState;
                              iot.update_rel(Relay.Rid, Relay.mac,
                                  Relay.RelName, Relay.stat, !y, Relay.pic);
                            },
                            child: Icon(
                              Icons.alarm,
                              size: 30,
                              color: Relay.shudelState
                                  ? Colors.red
                                  : Genral.canvas,
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                        child: GestureDetector(
                      onLongPress: () {
                        editCont.imm.value = Relay.pic;
                        Get.to(() => SwEditor(
                              rr: DevEdit(
                                  name: Relay.RelName,
                                  mac: Relay.mac,
                                  img: Relay.pic,
                                  id: Relay.Rid),
                            ));
                      },
                      child: Image.asset(
                        'assets/other_icon/${Relay.pic}',
                        height: 100,
                        width: 100,
                      ),
                    )),
                    SizedBox(
                      height: 10,
                    ),
                    Relay.shudelState
                        ? Text(
                            "Shudel working",
                            style: TextStyle(color: Colors.red),
                          )
                        : Switch(
                            activeColor: Genral.maincolor,
                            activeTrackColor: Genral.iconcolor,
                            value: Relay.stat,
                            onChanged: (Value) {
                              iot.updateRelayState(Relay.Rid, Relay.mac, Value);

                              iot.update_rel(
                                  Relay.Rid,
                                  Relay.mac,
                                  Relay.RelName,
                                  Value,
                                  Relay.shudelState,
                                  Relay.pic);
                            })
                  ]),
                ),
              );
            },
          );
        }));
  }
}
