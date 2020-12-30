abstract class BddStep {
  String get content;
}

abstract class SurfBddStep {
  List<String> get imports;
  String get content;
}