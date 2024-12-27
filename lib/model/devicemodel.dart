class Devices {
  String name;
  String mac;
  String email;
  Devices({required this.name, required this.mac, required this.email});
  factory Devices.fromMap(Map<String, dynamic> map) {
    return Devices(
        name: map['name'] as String,
        mac: map['mac'] as String,
        email: map['email'] as String);
  }

  // Map<String, dynamic> tomap() {
  //   return {'name': name, 'mac': mac, 'email': email};
  // }
}

class Rely {
  String mac;
  String RelName;
  int Rid;
  bool stat;
  bool shudelState;
  String pic;
  Rely(
      {required this.mac,
      required this.RelName,
      required this.Rid,
      required this.stat,
      required this.shudelState,
      required this.pic});
  factory Rely.fromMap(Map<String, dynamic> map) {
    return Rely(
        RelName: map['RelName'] as String,
        mac: map['mac'] as String,
        Rid: map['Rid'] as int,
        stat: map['state'] as bool,
        shudelState: map['shudelState'] as bool,
        pic: map['pic'] as String);
  }

  Map<String, dynamic> tomap() {
    return {
      'RelName': RelName,
      'mac': mac,
      ' Rid': Rid,
      'state': stat,
      'shudelState': shudelState,
      'pic': pic
    };
  }

  void updateState(bool newState) {
    if (stat != newState) {
      stat = newState;
    }
  }
}

class DevEdit {
  int? id;
  String name;
  String mac;
  String img;

  DevEdit({
    required this.name,
    required this.mac,
    required this.img,
    required this.id,
  });
}

class ShuModel {
  int? Rid;
  String mac;
  String start;
  String end;
  int? day;
  String uuid;
  ShuModel({
    required this.Rid,
    required this.mac,
    required this.start,
    required this.end,
    required this.day,
    required this.uuid,
  });

  factory ShuModel.fromMap(Map<String, dynamic> map) {
    return ShuModel(
        Rid: map['Rid'] as int,
        mac: map['mac'] as String,
        start: map['start'] as String,
        end: map['end'] as String,
        day: map['day_number'] as int,
        uuid: map['uuid'] as String);
  }
}
