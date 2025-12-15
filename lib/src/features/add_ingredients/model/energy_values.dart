/// Energy values for different animal species
///
/// All values in kcal/kg dry matter.
/// Supports DE (Digestible Energy), ME (Metabolizable Energy),
/// and NE (Net Energy) for various animal species.
class EnergyValues {
  final num? dePig;
  final num? mePig;
  final num? nePig;
  final num? mePoultry;
  final num? meRuminant;
  final num? meRabbit;
  final num? deSalmonids;

  const EnergyValues({
    this.dePig,
    this.mePig,
    this.nePig,
    this.mePoultry,
    this.meRuminant,
    this.meRabbit,
    this.deSalmonids,
  });

  /// Creates an instance from JSON
  factory EnergyValues.fromJson(Map<String, dynamic> json) {
    return EnergyValues(
      dePig: json['de_pig'] as num?,
      mePig: json['me_pig'] as num?,
      nePig: json['ne_pig'] as num?,
      mePoultry: json['me_poultry'] as num?,
      meRuminant: json['me_ruminant'] as num?,
      meRabbit: json['me_rabbit'] as num?,
      deSalmonids: json['de_salmonids'] as num?,
    );
  }

  /// Converts this instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'de_pig': dePig,
      'me_pig': mePig,
      'ne_pig': nePig,
      'me_poultry': mePoultry,
      'me_ruminant': meRuminant,
      'me_rabbit': meRabbit,
      'de_salmonids': deSalmonids,
    };
  }

  /// Creates a copy with some fields replaced
  EnergyValues copyWith({
    num? dePig,
    num? mePig,
    num? nePig,
    num? mePoultry,
    num? meRuminant,
    num? meRabbit,
    num? deSalmonids,
  }) {
    return EnergyValues(
      dePig: dePig ?? this.dePig,
      mePig: mePig ?? this.mePig,
      nePig: nePig ?? this.nePig,
      mePoultry: mePoultry ?? this.mePoultry,
      meRuminant: meRuminant ?? this.meRuminant,
      meRabbit: meRabbit ?? this.meRabbit,
      deSalmonids: deSalmonids ?? this.deSalmonids,
    );
  }

  @override
  String toString() {
    return 'EnergyValues(dePig: $dePig, mePig: $mePig, nePig: $nePig, '
        'mePoultry: $mePoultry, meRuminant: $meRuminant)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EnergyValues &&
        other.dePig == dePig &&
        other.mePig == mePig &&
        other.nePig == nePig &&
        other.mePoultry == mePoultry &&
        other.meRuminant == meRuminant &&
        other.meRabbit == meRabbit &&
        other.deSalmonids == deSalmonids;
  }

  @override
  int get hashCode {
    return Object.hash(
      dePig,
      mePig,
      nePig,
      mePoultry,
      meRuminant,
      meRabbit,
      deSalmonids,
    );
  }
}
