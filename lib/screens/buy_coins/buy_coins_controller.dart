import '../../config/app_config.dart';

class BuyCoinsController extends GetxController {
  final RxInt selectedIndex = (-1).obs;

  final RxList<Map<String, String>> coinOptions = [
    {'coins': '100', 'price': '\$2.00'},
    {'coins': '500', 'price': '\$5.00'},
    {'coins': '1000', 'price': '\$9.00'},
    {'coins': '3000', 'price': '\$24.00'},
    {'coins': '5000', 'price': '\$36.00'},
    {'coins': '10000', 'price': '\$80.00'},
    {'coins': '25000', 'price': '\$200.00'},
    {'coins': '50000', 'price': '\$375.00'},
    {'coins': '100000', 'price': '\$600.00'},
  ].obs;


  void selectIndex(int index) {
    print("Tapped index: $index");
    selectedIndex.value = index;
  }
}
