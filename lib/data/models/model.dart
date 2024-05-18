/// Base class for models
abstract class Model {
  Model();

  /// Override this function to convert the model into map
  Map<String, dynamic> toMap();

  /// Override this function to convert map to model
  factory Model.fromMap(Map<String, dynamic> map) {
    throw UnimplementedError('fromMap() must be implemented by subclasses');
  }
}
