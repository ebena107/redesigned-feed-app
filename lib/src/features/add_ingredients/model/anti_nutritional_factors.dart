/// Anti-nutritional factors that limit ingredient inclusion rates
///
/// These compounds can negatively affect animal performance and health
/// when present above certain thresholds.
class AntiNutritionalFactors {
  final num? glucosinolatesMicromolG;
  final num? cyanogenicGlycosidesPpm;
  final num? tanninsPpm;
  final num? phyticAcidPpm;
  final num? trypsinInhibitorTuG;

  const AntiNutritionalFactors({
    this.glucosinolatesMicromolG,
    this.cyanogenicGlycosidesPpm,
    this.tanninsPpm,
    this.phyticAcidPpm,
    this.trypsinInhibitorTuG,
  });

  /// Creates an instance from JSON
  factory AntiNutritionalFactors.fromJson(Map<String, dynamic> json) {
    return AntiNutritionalFactors(
      glucosinolatesMicromolG: json['glucosinolates_micromol_g'] as num?,
      cyanogenicGlycosidesPpm: json['cyanogenic_glycosides_ppm'] as num?,
      tanninsPpm: json['tannins_ppm'] as num?,
      phyticAcidPpm: json['phytic_acid_ppm'] as num?,
      trypsinInhibitorTuG: json['trypsin_inhibitor_tu_g'] as num?,
    );
  }

  /// Converts this instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'glucosinolates_micromol_g': glucosinolatesMicromolG,
      'cyanogenic_glycosides_ppm': cyanogenicGlycosidesPpm,
      'tannins_ppm': tanninsPpm,
      'phytic_acid_ppm': phyticAcidPpm,
      'trypsin_inhibitor_tu_g': trypsinInhibitorTuG,
    };
  }

  /// Creates a copy with some fields replaced
  AntiNutritionalFactors copyWith({
    num? glucosinolatesMicromolG,
    num? cyanogenicGlycosidesPpm,
    num? tanninsPpm,
    num? phyticAcidPpm,
    num? trypsinInhibitorTuG,
  }) {
    return AntiNutritionalFactors(
      glucosinolatesMicromolG:
          glucosinolatesMicromolG ?? this.glucosinolatesMicromolG,
      cyanogenicGlycosidesPpm:
          cyanogenicGlycosidesPpm ?? this.cyanogenicGlycosidesPpm,
      tanninsPpm: tanninsPpm ?? this.tanninsPpm,
      phyticAcidPpm: phyticAcidPpm ?? this.phyticAcidPpm,
      trypsinInhibitorTuG: trypsinInhibitorTuG ?? this.trypsinInhibitorTuG,
    );
  }

  @override
  String toString() {
    return 'AntiNutritionalFactors(glucosinolates: $glucosinolatesMicromolG, '
        'cyanogenicGlycosides: $cyanogenicGlycosidesPpm, tannins: $tanninsPpm)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AntiNutritionalFactors &&
        other.glucosinolatesMicromolG == glucosinolatesMicromolG &&
        other.cyanogenicGlycosidesPpm == cyanogenicGlycosidesPpm &&
        other.tanninsPpm == tanninsPpm &&
        other.phyticAcidPpm == phyticAcidPpm &&
        other.trypsinInhibitorTuG == trypsinInhibitorTuG;
  }

  @override
  int get hashCode {
    return Object.hash(
      glucosinolatesMicromolG,
      cyanogenicGlycosidesPpm,
      tanninsPpm,
      phyticAcidPpm,
      trypsinInhibitorTuG,
    );
  }
}
