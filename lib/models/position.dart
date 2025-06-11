class Position {
  final int row;
  final int col;

  const Position(this.row, this.col);

  bool get isValid => row >= 0 && row < 8 && col >= 0 && col < 8;

  @override
  String toString() => '($row, $col)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Position && other.row == row && other.col == col;
  }

  @override
  int get hashCode => Object.hash(row, col);

  String get algebraicNotation {
    final file = String.fromCharCode('a'.codeUnitAt(0) + col);
    final rank = (8 - row).toString();
    return '$file$rank';
  }
}

extension on Position {
  operator +(Position other) {
    return Position(row + other.row, col + other.col);
  }
}
