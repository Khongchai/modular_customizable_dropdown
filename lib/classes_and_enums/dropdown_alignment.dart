class DropdownAlignment {
  final double x;
  final double y;

  const DropdownAlignment(this.x, this.y);

  static const DropdownAlignment topLeft = DropdownAlignment(-1, -1);
  static const DropdownAlignment topCenter = DropdownAlignment(0, -1);
  static const DropdownAlignment topRight = DropdownAlignment(1, -1);
  static const DropdownAlignment centerLeft = DropdownAlignment(-1, 0);
  static const DropdownAlignment center = DropdownAlignment(0, 0);
  static const DropdownAlignment centerRight = DropdownAlignment(1, 0);
  static const DropdownAlignment bottomLeft = DropdownAlignment(-1, 1);
  static const DropdownAlignment bottomCenter = DropdownAlignment(0, 1);
  static const DropdownAlignment bottomRight = DropdownAlignment(1, 1);
}
