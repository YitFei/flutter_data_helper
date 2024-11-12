import 'dart:collection';
import 'package:mt_data_helper/src/mt_data_row.dart';

typedef RowAddedCallback<E> = void Function(MTDataRow<E> row);
typedef RowRemovedCallback<E> = void Function(MTDataRow<E> row);
typedef RowModifiedCallback<E> = void Function(
    String columnName, MTDataRow<E> row);

class RowModification<E> {
  final String columnName;
  final MTDataRow<E> row;

  RowModification(this.columnName, this.row);
}

class MTDataRows<E> extends ListBase<MTDataRow<E>> {
  final List<MTDataRow<E>> _innerList;
  final bool fullRows;

  final RowAddedCallback<E>? onRowAdded;
  final RowRemovedCallback<E>? onRowRemoved;
  final RowModifiedCallback<E>? onRowModified;

  MTDataRows(
    this._innerList, {
    this.fullRows = false,
    this.onRowAdded,
    this.onRowRemoved,
    this.onRowModified,
  });

  List<int> get _activeIndices {
    List<int> indices = [];
    for (int i = 0; i < _innerList.length; i++) {
      if (fullRows) {
        indices.add(i);
      } else {
        if (_innerList[i].rowState != RowState.deleted) {
          indices.add(i);
        }
      }
    }
    return indices;
  }

  @override
  int get length => _activeIndices.length;

  @override
  set length(int newLength) {
    throw UnimplementedError('Setting length is not supported');
  }

  @override
  MTDataRow<E> operator [](int index) {
    int actualIndex = _activeIndices[index];
    return _innerList[actualIndex];
  }

  @override
  void operator []=(int index, MTDataRow<E> value) {
    throw UnsupportedError(
        'Cannot replace the entire row. Modify fields instead.');
    // int actualIndex = _activeIndices[index];
    // _innerList[actualIndex] = value;
    // value.rowState = RowState.modified;
    // onRowModified?.call(_innerList[actualIndex]., value);
  }

  @override
  void add(MTDataRow<E> element) {
    element.onModified = (colName, row) {
      onRowModified?.call(colName, row);
    };
    _innerList.add(element);
    element.rowState = RowState.added;
    onRowAdded?.call(element);
  }

  @override
  void insert(int index, MTDataRow<E> element) {
    if (index < 0 || index > length) {
      throw RangeError.index(index, this, 'index');
    }
    if (index == length) {
      add(element);
    } else {
      int actualIndex = _activeIndices[index];
      _innerList.insert(actualIndex, element);
      element.rowState = RowState.added;
      onRowAdded?.call(element);
    }
  }

  @override
  MTDataRow<E> removeAt(int index) {
    int actualIndex = _activeIndices[index];
    MTDataRow<E> row = _innerList[actualIndex];
    row.rowState = RowState.deleted;
    onRowRemoved?.call(row);
    return row;
  }

  @override
  bool remove(Object? element) {
    if (element is MTDataRow<E>) {
      int index = indexOf(element);
      if (index != -1) {
        removeAt(index);
        return true;
      }
    }
    return false;
  }

  @override
  void clear() {
    for (var row in _innerList) {
      row.rowState = RowState.deleted;
      onRowRemoved?.call(row);
    }
    _innerList.clear();
  }

  @override
  Iterator<MTDataRow<E>> get iterator {
    return _activeIndices.map((i) => _innerList[i]).iterator;
  }
}
