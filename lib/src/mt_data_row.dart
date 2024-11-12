import 'package:mt_data_helper/src/mt_data_rows.dart';

class MTDataRow<T extends MTData> {
  RowState rowState;
  final T _data;
  T get data => _data;

  // set data(T newData) {
  //   _data = newData;
  //   if (rowState == RowState.unchanged) {
  //     rowState = RowState.modified;
  //   }
  // }

  MTDataRow({required T data, this.rowState = RowState.unchanged})
      : _data = data;

  RowModifiedCallback<T>? _onModified;

  set onModified(RowModifiedCallback<T> callback) {
    _onModified = callback;
  }

  dynamic operator [](String fieldName) {
    if (data is! Map<String, dynamic>) {
      throw "Only available Map<String,dynamic> type";
    }
    Map<String, dynamic> mapData = data as Map<String, dynamic>;
    if (!mapData.containsKey(fieldName)) {
      throw "$fieldName doesn't exists";
    }
    return mapData[fieldName];
  }

  void operator []=(String key, dynamic value) {
    var data = _data as Map<String, dynamic>;
    if (data[key] != value) {
      data[key] = value;
      if (rowState == RowState.unchanged) {
        rowState = RowState.modified;
      }

      _onModified?.call(key, this);
    }
  }

  void endEdit() {
    this.rowState = RowState.unchanged;
  }
}

enum RowState { added, modified, deleted, unchanged }

abstract class MTData {
  MTData fromMap(Map<String, dynamic> map);
  Map<String, dynamic> toMap();
  MTData copyWith();
}

class MTMap implements MTData, Map<String, dynamic> {
  final Map<String, dynamic> _data;

  MTMap(this._data);

  //* Implement the MTData interface
  @override
  Map<String, dynamic> toMap() {
    return _data;
  }

  @override
  MTData fromMap(Map<String, dynamic> map) {
    return MTMap(map);
  }

  @override
  MTMap copyWith({Map<String, dynamic>? data}) {
    return MTMap(data ?? _data);
  }

  factory MTMap.fromMap(Map<String, dynamic> map) {
    return MTMap(map);
  }

  // Implement Map<String, dynamic> methods by delegating to _data
  @override
  dynamic operator [](Object? key) => _data[key];

  @override
  void operator []=(String key, dynamic value) {
    _data[key] = value;
  }

  @override
  void addAll(Map<String, dynamic> other) {
    _data.addAll(other);
  }

  @override
  void addEntries(Iterable<MapEntry<String, dynamic>> newEntries) {
    _data.addEntries(newEntries);
  }

  @override
  Map<RK, RV> cast<RK, RV>() {
    return _data.cast<RK, RV>();
  }

  @override
  void clear() {
    _data.clear();
  }

  @override
  bool containsKey(Object? key) {
    return _data.containsKey(key);
  }

  @override
  bool containsValue(Object? value) {
    return _data.containsValue(value);
  }

  @override
  Iterable<MapEntry<String, dynamic>> get entries => _data.entries;

  @override
  void forEach(void Function(String key, dynamic value) action) {
    _data.forEach(action);
  }

  @override
  bool get isEmpty => _data.isEmpty;

  @override
  bool get isNotEmpty => _data.isNotEmpty;

  @override
  Iterable<String> get keys => _data.keys;

  @override
  int get length => _data.length;

  @override
  dynamic putIfAbsent(String key, dynamic Function() ifAbsent) {
    return _data.putIfAbsent(key, ifAbsent);
  }

  @override
  dynamic remove(Object? key) {
    return _data.remove(key);
  }

  @override
  void removeWhere(bool Function(String key, dynamic value) test) {
    _data.removeWhere(test);
  }

  @override
  dynamic update(String key, dynamic Function(dynamic value) update,
      {dynamic Function()? ifAbsent}) {
    return _data.update(key, update, ifAbsent: ifAbsent);
  }

  @override
  void updateAll(dynamic Function(String key, dynamic value) update) {
    _data.updateAll(update);
  }

  @override
  Iterable<dynamic> get values => _data.values;

  @override
  Map<K2, V2> map<K2, V2>(
      MapEntry<K2, V2> Function(String key, dynamic value) transform) {
    return _data.map<K2, V2>(transform);
  }
}
