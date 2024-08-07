import 'package:elite_jersey/Base de datos/db_helper.dart';
import 'package:elite_jersey/Base de datos/jersey.dart';
import 'package:get/get.dart';

class JerseyController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    getJerseys();
  }

  var jerseyList = <Jersey>[].obs;

  Future<int> addJersey({Jersey? jersey}) async {
    int result = await DBHelper.insertJersey(jersey);
    getJerseys();
    return result;
  }

  void getJerseys() async {
    List<Jersey> jerseys = await DBHelper.queryJerseys();
    jerseyList.assignAll(jerseys);
  }

  void deleteJersey(int id) async {
    await DBHelper.deleteJersey(id);
    getJerseys();
  }

  void updateJersey(Jersey jersey) async {
    await DBHelper.updateJersey(jersey);
    getJerseys();
  }
}
