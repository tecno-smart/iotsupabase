import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iot/control/controler.dart';
import 'package:lottie/lottie.dart';
import 'package:iot/constant.dart';

class Addpage extends StatelessWidget {
  final controler = Get.put(Ndvice());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Setup new device"),
        centerTitle: true,
        backgroundColor: Genral.grey,
        foregroundColor: Genral.contaner,
        actions: [],
      ),
      body: Center(
        child: Obx(
          () => controler.cc.value
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    StreamBuilder(
                      stream: controler.channel?.stream ?? Stream.empty(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Lottie.asset('assets/iconapp/animation.json',
                              width: 200, height: 200);
                        } else if (snapshot.hasData) {
                          print("Received data: ${snapshot.data}");
                          return Text(snapshot.data.toString());
                        } else {
                          return Lottie.asset('assets/iconapp/animation.json',
                              width: 200, height: 200);
                        }
                      },
                    ),
                    ElevatedButton(
                      onPressed: () => print("eslam"),
                      child: Text("Add user"),
                    ),
                    ElevatedButton(
                      onPressed: () => controler.disconnectWebSocket(),
                      child: Text("Disconnect"),
                    )
                  ],
                )
              : controler.waitingForConnection.value
                  ? Column(
                      children: [
                        ElevatedButton(
                          onPressed: controler.checkWifiAndConnect,
                          child: Text("Waiting for correct network..."),
                        ),
                        Lottie.asset('assets/iconapp/animation.json',
                            width: 200, height: 200),
                      ],
                    )
                  : Column(
                      children: [
                        ElevatedButton(
                          onPressed: controler.checkWifiAndConnect,
                          child:
                              Text("Connect to device (waiting for network)"),
                        ),
                        Lottie.asset('assets/iconapp/animation.json',
                            width: 200, height: 200),
                      ],
                    ),
        ),
      ),
    );
  }
}
