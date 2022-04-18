import 'package:get/get.dart';

class FilterController extends GetxController implements GetxService {
  FilterController();

  double _priceLower;
  double _priceHigher;
  double _distLower;
  double _distHigher;
  double _selpriceLower = 0;
  double _selpriceHigher = 1000;
  double _seldistLower;
  double _seldistHigher;
  SortMode _sortMode = SortMode.Distance;
  SortMode _selected = SortMode.Distance;
  List<bool> _activeFilters = [false, false];
  List<String> _filters = ["Top Rated", "Trending now"];
  bool _isSet = false;

  bool get isSet => _isSet;
  List<bool> get activeFilters => _activeFilters;
  List<String> get filters => _filters;
  SortMode get selectedIndex => _selected;
  double get priceLower => _priceLower;
  double get priceHigher => _priceHigher;
  double get distLower => _distLower;
  double get distHigher => _distHigher;
  double get selpriceLower => _selpriceLower;
  double get selpriceHigher => _selpriceHigher;
  double get seldistLower => _seldistLower;
  double get seldistHigher => _seldistHigher;
  SortMode get sortMode => _sortMode;

  void setSelectedIndex(SortMode index) {
    _selected = index;
    update();
  }

  void setFilter(index, value) {
    _activeFilters[index] = value;
    update();
  }

  void setPrice(double lower, double higher) {
    _selpriceLower = lower;
    _selpriceHigher = higher;
    update();
  }

  void setFilters() {
    _priceLower = _selpriceLower;
    _priceHigher = _selpriceHigher;
    _distLower = _seldistLower;
    _distHigher = _seldistHigher;
    _sortMode = _selected;
    _isSet = true;
    update();
  }

  void clearFilters() {
    _priceHigher = 1000;
    _priceLower = 0;
    _distHigher = 10;
    _distLower = 0;
    _sortMode = SortMode.Distance;
    _isSet = false;
    update();
  }
}

enum SortMode {
  CostAsc,
  CostDesc,
  Rating,
  Distance,
}
