/// Amino acid profile for feed ingredients
///
/// Contains essential and semi-essential amino acids measured in g/kg dry matter.
/// Supports both total amino acids and SID (Standardized Ileal Digestible) values.
class AminoAcidsProfile {
  final num? lysine;
  final num? methionine;
  final num? cystine;
  final num? threonine;
  final num? tryptophan;
  final num? arginine;
  final num? isoleucine;
  final num? leucine;
  final num? valine;
  final num? histidine;
  final num? phenylalanine;

  const AminoAcidsProfile({
    this.lysine,
    this.methionine,
    this.cystine,
    this.threonine,
    this.tryptophan,
    this.arginine,
    this.isoleucine,
    this.leucine,
    this.valine,
    this.histidine,
    this.phenylalanine,
  });

  /// Creates an instance from JSON
  factory AminoAcidsProfile.fromJson(Map<String, dynamic> json) {
    return AminoAcidsProfile(
      lysine: json['lysine'] as num?,
      methionine: json['methionine'] as num?,
      cystine: json['cystine'] as num?,
      threonine: json['threonine'] as num?,
      tryptophan: json['tryptophan'] as num?,
      arginine: json['arginine'] as num?,
      isoleucine: json['isoleucine'] as num?,
      leucine: json['leucine'] as num?,
      valine: json['valine'] as num?,
      histidine: json['histidine'] as num?,
      phenylalanine: json['phenylalanine'] as num?,
    );
  }

  /// Converts this instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'lysine': lysine,
      'methionine': methionine,
      'cystine': cystine,
      'threonine': threonine,
      'tryptophan': tryptophan,
      'arginine': arginine,
      'isoleucine': isoleucine,
      'leucine': leucine,
      'valine': valine,
      'histidine': histidine,
      'phenylalanine': phenylalanine,
    };
  }

  /// Creates a copy with some fields replaced
  AminoAcidsProfile copyWith({
    num? lysine,
    num? methionine,
    num? cystine,
    num? threonine,
    num? tryptophan,
    num? arginine,
    num? isoleucine,
    num? leucine,
    num? valine,
    num? histidine,
    num? phenylalanine,
  }) {
    return AminoAcidsProfile(
      lysine: lysine ?? this.lysine,
      methionine: methionine ?? this.methionine,
      cystine: cystine ?? this.cystine,
      threonine: threonine ?? this.threonine,
      tryptophan: tryptophan ?? this.tryptophan,
      arginine: arginine ?? this.arginine,
      isoleucine: isoleucine ?? this.isoleucine,
      leucine: leucine ?? this.leucine,
      valine: valine ?? this.valine,
      histidine: histidine ?? this.histidine,
      phenylalanine: phenylalanine ?? this.phenylalanine,
    );
  }

  @override
  String toString() {
    return 'AminoAcidsProfile(lysine: $lysine, methionine: $methionine, '
        'cystine: $cystine, threonine: $threonine, tryptophan: $tryptophan)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AminoAcidsProfile &&
        other.lysine == lysine &&
        other.methionine == methionine &&
        other.cystine == cystine &&
        other.threonine == threonine &&
        other.tryptophan == tryptophan &&
        other.arginine == arginine &&
        other.isoleucine == isoleucine &&
        other.leucine == leucine &&
        other.valine == valine &&
        other.histidine == histidine &&
        other.phenylalanine == phenylalanine;
  }

  @override
  int get hashCode {
    return Object.hash(
      lysine,
      methionine,
      cystine,
      threonine,
      tryptophan,
      arginine,
      isoleucine,
      leucine,
      valine,
      histidine,
      phenylalanine,
    );
  }
}
