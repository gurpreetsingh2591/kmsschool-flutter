import 'package:get/get.dart';

class ListController extends GetxController {
  RxInt selectedIndex = 0.obs;

  void selectIndex(int index) {
    selectedIndex.value = index;
  }

  RxList<Map<String, String>> languages=<Map<String, String>>[].obs;

  void setLanguages(List<Map<String, String>> newLanguages) {
    languages.assignAll(newLanguages);
  }

}