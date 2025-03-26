import 'package:camify_travel_app/model/client/booking_model.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';

const String CLIENT_BOX = "CLIENT_BOX";
ValueNotifier<List<PackageClient>> clientNotifier = ValueNotifier([]);

class PackageFunctions {
  static Future<void> addClient(PackageClient client) async {
    final box = Hive.box<PackageClient>('CLIENT_BOX');
    await box.put(client.phone, client);
    clientNotifier.value = box.values.toList();
    print('Client added: ${client.name}, Total: ${box.length}');
  }

  static Future<void> updateClient(
    String phone,
    PackageClient updatedClient,
  ) async {
    final box = Hive.box<PackageClient>('CLIENT_BOX');
    await box.put(phone, updatedClient);
    clientNotifier.value = box.values.toList();
    print('Client updated: ${updatedClient.name}');
  }

  static Future<void> deleteClient(String phone) async {
    final box = Hive.box<PackageClient>('CLIENT_BOX');
    await box.delete(phone);
    clientNotifier.value = box.values.toList();
    print('Client deleted, Total: ${box.length}');
  }

  static List<PackageClient> getClients() {
    final box = Hive.box<PackageClient>('CLIENT_BOX');
    return box.values.toList();
  }
}
