import 'package:mt_data_helper/src/mt_data_row.dart';
import 'package:mt_data_helper/src/mt_data_rows.dart';
import 'package:mt_data_helper/src/mt_datatable.dart';
import 'package:mt_data_helper/src/printing.dart';

extension DeepCopyList on List<Map<String, dynamic>> {
  // `Map.from()` creates a new Map for each map, thus replicating all key-value pairs.
  List<Map<String, dynamic>> deepCopy() {
    return map((map) => Map<String, dynamic>.from(map)).toList();
  }

  // `List.from()` creates a new list but reuses the map references from the original list.
  List<Map<String, dynamic>> shallowCopy() {
    return List<Map<String, dynamic>>.from(this);
  }
}

abstract class DeepCopyable<T> {
  T copyWith();
}

extension CopyList<T extends DeepCopyable<T>> on List<T> {
  // `Map.from()` creates a new Map for each map, thus replicating all key-value pairs.
  List<T> deepCopy() {
    return map((element) => element.copyWith()).toList();
  }

  // `List.from()` creates a new list but reuses the map references from the original list.
  List<T> shallowCopy() {
    return List<T>.from(this);
  }
}

extension MTDataRowCopyList<T> on List<MTDataRow<T>> {
  MTDatatable<T> toDatatable() {
    return MTDatatable()..load(this);
  }

  List<MTDataRow<T>> deepCopy() {
    if (this is List<MTDataRow<Map<String, dynamic>>>) {
      return map((element) {
        var data = (element.data as Map<String, dynamic>);
        return MTDataRow(data: Map<String, dynamic>.from(data) as T);
      }).toList();
    } else if (this is List<MTDataRow<DeepCopyable<T>>>) {
      return map((element) {
        var data = (element.data as DeepCopyable<T>);
        return MTDataRow(data: data.copyWith());
      }).toList();
    } else {
      throw ("Unsupported type for deep copy");
    }
  }

  List<MTDataRow<T>> shallowCopy() {
    return List<MTDataRow<T>>.from(this);
  }
}
