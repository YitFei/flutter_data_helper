// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:collection';
import 'package:mt_data_helper/src/list_extension.dart';
import 'package:mt_data_helper/src/mt_data_row.dart';
import 'package:mt_data_helper/src/mt_data_rows.dart';

class MTDatatable<E> {
  final List<MTDataRow<E>> _rows = [];
  late MTDataRows<E> _rowsWrapper;
  MTDataRows<E> get rows => _rowsWrapper;

  UnmodifiableListView<MTDataRow<E>> get fullRows =>
      UnmodifiableListView(MTDataRows(_rows, fullRows: true));

  final StreamController<MTDataRow<E>> _rowAddedController =
      StreamController.broadcast();
  final StreamController<MTDataRow<E>> _rowDeletedController =
      StreamController.broadcast();
  final StreamController<RowModification<E>> _rowModifiedController =
      StreamController.broadcast();

  // Exposed Streams
  Stream<MTDataRow<E>> get onRowAdded => _rowAddedController.stream;
  Stream<MTDataRow<E>> get onRowDeleted => _rowDeletedController.stream;
  Stream<RowModification<E>> get onRowModified => _rowModifiedController.stream;

  MTDatatable() {
    _loadRowsWrapper();
  }

  void load(List<MTDataRow<E>> rows) {
    this.rows.addAll(rows.map((row) => row..rowState = RowState.unchanged));
  }

  void _loadRowsWrapper() {
    _rowsWrapper = MTDataRows<E>(
      _rows,
      onRowAdded: _handleRowAdded,
      onRowRemoved: _handleRowRemoved,
      onRowModified: _handleRowModified,
    );
  }

  void dispose() {
    _rowAddedController.close();
    _rowDeletedController.close();
    _rowModifiedController.close();
  }

  void _handleRowAdded(MTDataRow<E> row) => _rowAddedController.add(row);

  void _handleRowRemoved(MTDataRow<E> row) => _rowDeletedController.add(row);

  void _handleRowModified(String columnName, MTDataRow<E> row) =>
      _rowModifiedController.add(RowModification(columnName, row));

  //* Features
  set newRow(MTDataRow<E> row) => rows.add(row);

  MTDatatable<E> deepCopy() {
    return rows.deepCopy().toDatatable();
  }

  MTDatatable<E> shallowCopy() {
    return rows.shallowCopy().toDatatable();
  }

  void acceptChanges() {
    for (var row in rows) {
      row.endEdit();
    }
  }

  void clear() {
    rows.clear();
  }

  RowChanges<E> getChanges() {
    List<MTDataRow<E>> inserted = [];
    List<MTDataRow<E>> updated = [];
    List<MTDataRow<E>> deleted = [];

    inserted = fullRows.where((dr) => dr.rowState == RowState.added).toList();
    updated = fullRows.where((dr) => dr.rowState == RowState.modified).toList();
    deleted = fullRows.where((dr) => dr.rowState == RowState.deleted).toList();

    return RowChanges(inserted: inserted, updated: updated, deleted: deleted);
  }
}

class RowChanges<T> {
  List<MTDataRow<T>> inserted;
  List<MTDataRow<T>> updated;
  List<MTDataRow<T>> deleted;

  RowChanges({
    required this.inserted,
    required this.updated,
    required this.deleted,
  });
}
