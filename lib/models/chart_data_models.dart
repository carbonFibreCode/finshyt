class ChartData {
  final String label;
  final double primaryValue;
  final double? secondaryValue;

  ChartData({required this.label, required this.primaryValue, this.secondaryValue,});
}

enum ChartType { singleBar, doubleBar}