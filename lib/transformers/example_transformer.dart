import 'package:two_oss/model/class/example_class.dart';

/// Transformer for Example
/// 
/// This class is responsible for transforming each data type into the Example class.
class ExampleTransformer {
  Example fromJson(Map<String, dynamic> json) {
    return Example(
      json['name'] as String,
      json['content'] as String,
    );
  }
}