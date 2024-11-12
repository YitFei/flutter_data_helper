import 'package:data_helper/src/mt_data_rows.dart';

class MTDataRow<T> {
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
