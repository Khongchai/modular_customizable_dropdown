class ClampResult {
  final double overflowCheckedHeight;
  final double topSubtract;
  final double bottomSubtract;

  const ClampResult({
    required this.overflowCheckedHeight,
    required this.topSubtract,
    required this.bottomSubtract,
  });
}
