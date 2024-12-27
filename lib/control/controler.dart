import 'package:get/get.dart';
import 'package:iot/model/devicemodel.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:network_info_plus/network_info_plus.dart';

class IotControl extends GetxController {
  void up() {
    update();
  }

  @override
  void onInit() {
    super.onInit();
    // fetch();
  }

  Future<void> addUser() async {
    try {
      final response = await Supabase.instance.client.from('users').insert({
        'name': 'John Doe',
        'email': 'jobbssbhn@example.com',
        'password': 'password123',
        'phone': '1234567890',
        'secret': 'secret_key',
        'end_date': '2024-12-31T23:59:59Z',
      });

      print(response);
    } catch (e) {
      print('Error: ${e}');
    }
  }

  var users = <Map<String, dynamic>>[].obs;

  // دالة لجلب بيانات المستخدمين
  Future<void> fetchUsers() async {
    final response = await Supabase.instance.client.from('users').select();

    if (response.isNotEmpty) {
      // تخزين البيانات في القائمة إذا تم الجلب بنجاح
      users.value = List<Map<String, dynamic>>.from(response);
      print(users);
    } else {
      // معالجة الخطأ
      print('Error: ${response}');
    }
  }
}

// -------------------------كلاس التوثيق-----------------------
class Authserv extends GetxController {
  late final String email;
  RxBool hid = true.obs;
  final SupabaseClient _supabase = Supabase.instance.client;
  //sign in

  Future<AuthResponse> signInEmailPass(String email, String pass) async {
    return await _supabase.auth
        .signInWithPassword(password: pass, email: email);
  }

// signe up

  Future<AuthResponse> signupEmailPass(String email, String pass) async {
    return await _supabase.auth.signUp(password: pass, email: email);
  }

// signe oute

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

// get user email

  String? getcurntUserEmail() {
    final session = _supabase.auth.currentSession;
    final user = session?.user;
    return user?.email;
  }

// insert
  Future<PostgrestList> insertRow(String email, String name, String pass,
      String phone, String secrt, String date) async {
    return await _supabase.from("clients").insert({
      "email": email,
      "name": name,
      "password": pass,
      "phone": phone,
      "secret": secrt,
      "end": date
    }).select();
  }

  Future<Map<String, String>> getpass(String email) async {
    final List<Map> data = await _supabase
        .from('clients')
        .select("name , password")
        .eq('email', email);

    if (data.isNotEmpty) {
      return {"pass": data[0]["password"].toString()};
    } else {
      return {"auth": "incorect"};
    }
  }

  Future<Map<String, String>> Getsecret(String email, String sec) async {
    final List<Map> data = await _supabase
        .from('clients')
        .select("secret , password")
        .eq('email', email)
        .eq('secret', sec);

    if (data.isNotEmpty) {
      return {"pass": data[0]["password"].toString()};
    } else {
      return {"auth": "incorect"};
    }
  }

  var devicesList = <Devices>[].obs;

  Future<void> fetchDevices(String email) async {
    try {
      final response = await Supabase.instance.client
          .from('devices')
          .select('*')
          .eq('email', email) as List<dynamic>;

      // تحويل البيانات إلى قائمة من موديل Devices
      devicesList.value =
          response.map((device) => Devices.fromMap(device)).toList();
    } catch (error) {
      print('Error fetching devices: $error');
    }
  }

  // final database =
  //     Supabase.instance.client.from('devices')
  //     .select('*')
  //     .eq('email', 'asdff@gmail.com');

// Delete Device
  Future<void> DeletDevice(String mac) async {
    var resp = await _supabase.from('devices').delete().eq('mac', mac);
    print(resp);
  }

  @override
  void onInit() {
    super.onInit();
  }
}

// -------------------------كلاس  جلب الريليهات ---------------------------
class getrelays extends GetxController {
  var relaylst = <Rely>[].obs;
  final String mac;
  getrelays({required this.mac});
  Future<void> fetchDevices(String mac) async {
    try {
      final response = await Supabase.instance.client
          .from('relays')
          .select('*')
          .eq('mac', mac)
          .order('Rid', ascending: true) as List<dynamic>;

      relaylst.value = response.map((device) => Rely.fromMap(device)).toList();
    } catch (error) {
      print('Error fetching devices: $error');
    }
  }

// ------------------------------on real time
  final SupabaseClient _supabase = Supabase.instance.client;
  void subscribeToRealtimeUpdates(String mac) {
    _supabase
        .channel('public:relays')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'relays',
          filter: PostgresChangeFilter(
              type: PostgresChangeFilterType.eq,
              column: 'mac',
              value: mac), // استخدم mac كقيمة في الفلتر
          callback: (payload) {
            // طباعة التغيير
            print('Change received: ${payload.toString()}');

            // استخراج البيانات الجديدة من الـ payload
            var newData = payload.newRecord;

            // إذا كان الصف الجديد موجود، نقوم بتحديث أو إضافته
            if (payload.eventType == PostgresChangeEvent.insert) {
              // إضافة صف جديد
              relaylst.add(Rely.fromMap(newData));
            } else if (payload.eventType == PostgresChangeEvent.update) {
              // تحديث صف موجود
              relaylst.value = relaylst.map((relay) {
                if (relay.mac == newData['mac'] &&
                    relay.Rid == newData['Rid']) {
                  return Rely.fromMap(newData); // تحديث بيانات الـ relay
                }
                return relay;
              }).toList();
            }

            relaylst.refresh();
          },
        )
        .subscribe();
  }

// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future update_rel(int rid, String mac, String Rname, bool stat, bool shstat,
      String pic) async {
    await _supabase
        .from('relays')
        .update({
          'RelName': Rname,
          'state': stat,
          'shudelState': shstat,
          'pic': pic
        })
        .eq('Rid', rid)
        .eq('mac', mac);
  }

  // Function to update relay state
  void updateRelayState(int rid, String mac, bool newState) {
    // Find the relay by Rid and mac, then update the state
    final relay = relaylst.firstWhere((r) => r.Rid == rid && r.mac == mac);
    relay.updateState(newState);

    // Notify UI to update the relay state
    relaylst.refresh(); // Refresh the list to notify the UI
  }

  @override
  void onInit() {
    super.onInit();

    fetchDevices(mac);
    subscribeToRealtimeUpdates(mac);
  }
}

//------------------------كلاس معلومات الريليهات-----------------------------
class Rinfo extends GetxController {
  final SupabaseClient _supabase = Supabase.instance.client;
  RxString imm = "1.png".obs;

  Future upinfo(String name, String mac, int id, String img) async {
    await _supabase
        .from('relays')
        .update({"RelName": name, "pic": img})
        .eq('mac', mac)
        .eq('Rid', id)
        .select();
  }
}

// --------------------------------كلاس الجدولة--------------------------
class Schudeler extends GetxController {
  final String mac_dev;
  final int relay;
  Schudeler({required this.mac_dev, required this.relay});
  var shudel_list = <ShuModel>[].obs;
  final SupabaseClient _supabase = Supabase.instance.client;
  RxString start = '00:00'.obs;
  RxString end = '00:00'.obs;
  RxInt day = 1.obs;

  void resst() {
    start.value = '00:00';
    end.value = '00:00';
    day.value = 1;
  }

  Future insert_shudel(
      int Rid, String mac, String start, String end, int day) async {
    try {
      var resp = await _supabase.from('shudeltb').insert({
        'Rid': Rid,
        'mac': mac,
        'start': start,
        'end': end,
        'day_number': day
      }).select();

      print(resp);
    } catch (e) {
      print('-------');
      print(e);
      print('-------');
    }
    resst();
  }

// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future<void> fetch_shudel(String mac, int Rid) async {
    try {
      final rsep = await _supabase
          .from('shudeltb')
          .select('*')
          .eq("Rid", Rid)
          .eq("mac", mac)
          .order('day_number', ascending: true) as List<dynamic>;

      shudel_list.value =
          rsep.map((device) => ShuModel.fromMap(device)).toList();
    } catch (e) {}
  }

// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  void supscrip_shudel(String mac, int Rid) {
    _supabase
        .channel('public:shudeltb')
        .onPostgresChanges(
            event: PostgresChangeEvent.all,
            schema: 'public',
            table: 'shudeltb',
            filter: PostgresChangeFilter(
              type: PostgresChangeFilterType.eq,
              column: 'mac',
              value: mac,
            ),
            callback: (payload) {
              var newData = payload.newRecord;

              if (payload.eventType == PostgresChangeEvent.insert) {
                // إضافة صف جديد
                shudel_list.add(ShuModel.fromMap(newData));
              } else if (payload.eventType == PostgresChangeEvent.update) {
                // تحديث صف موجود
                shudel_list.value = shudel_list.map((shudl) {
                  if (shudl.mac == newData['mac'] &&
                      shudl.Rid == newData['Rid'] &&
                      shudl.uuid == newData['uuid']) {
                    return ShuModel.fromMap(newData); // تحديث بيانات الـ relay
                  }
                  return shudl;
                }).toList();
              }

              shudel_list.refresh();
            })
        .subscribe();
  }
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

  @override
  void onInit() {
    super.onInit();

    fetch_shudel(mac_dev, relay);
    supscrip_shudel(mac_dev, relay);
  }
}

// -----------------------------كلاس اضافة  بوردة جديدة-------------------

class Ndvice extends GetxController {
  WebSocketChannel? channel;
  RxBool cc = false.obs;
  String currentSSID = '';
  RxBool waitingForConnection = false.obs;
  bool onpage = true;
  Future<String> getWifiSSID() async {
    final NetworkInfo _networkInfo = NetworkInfo();
    String? wifiName = await _networkInfo.getWifiName();
    return wifiName ?? ""; // إرجاع SSID إذا كان متصلًا
  }

  void retryConnection() {
    Future.delayed(Duration(seconds: 5), () {
      print("Retrying connection...");
      checkWifiAndConnect();
    });
  }

  void checkWifiAndConnect() async {
    String ssid = await getWifiSSID();
    ssid = ssid.replaceAll('"', '');
    print(ssid);
    if (ssid == "gdmpk46241") {
      currentSSID = ssid;
      waitingForConnection.value = false;
      connectWebSocket(); // الاتصال بـ WebSocket
    } else {
      currentSSID = ssid;
      waitingForConnection.value = true;

      print("Not connected to the correct network (gdmpk46241). Waiting...");
      print("ssid is ${ssid}");
    }
  }

  // دالة للاتصال بـ WebSocket
  void connectWebSocket() {
    if (channel == null) {
      try {
        print("Attempting to connect to WebSocket...");
        channel =
            IOWebSocketChannel.connect(Uri.parse("ws://192.168.4.1:34656"));

        // مراقبة حالة الاتصال
        channel!.stream.listen(
          (message) {
            print("Connected successfully. Message received: $message");

            cc.value = true;
          },
          onError: (error) {
            print("Error during connection: $error");

            cc.value = false;
            if (onpage) {
              retryConnection();
            } // إعادة المحاولة عند الفشل
          },
          onDone: () {
            print("Connection closed.");

            cc.value = false;
            channel = null;
            if (onpage) {
              retryConnection();
            } // إعادة المحاولة عند انقطاع الاتصال
          },
          cancelOnError: true,
        );
      } catch (e) {
        print("Error connecting to WebSocket: $e");

        cc.value = false;
        if (onpage) {
          retryConnection();
        } // إعادة المحاولة عند الفشل
      }
    } else {
      print("Already connected to WebSocket.");
    }
  }

  // دالة لفصل الاتصال بـ WebSocket
  void disconnectWebSocket() {
    try {
      if (channel != null) {
        channel!.sink.close();
        channel = null;
        cc.value = false;
        print("WebSocket disconnected normally.");
      }
    } catch (e) {
      print("Error during disconnection: $e");
    } finally {}
  }

  @override
  void onInit() {
    onpage = true;
    checkWifiAndConnect();
    super.onInit();
  }

  @override
  void onClose() {
    onpage = false;
    disconnectWebSocket();
    super.onClose();
  }
}
