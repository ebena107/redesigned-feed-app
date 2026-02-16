/// Feed production stages/types for different animal types
/// Based on NRC, FAO, and INRA standards
enum FeedType {
  starter('Starter'),
  grower('Grower'),
  finisher('Finisher'),

  maintenance('Maintenance'),

  gestating('Gestating'),
  lactating('Lactating'),

  preStarter('Pre-starter'),
  layer('Layer'),

  breeder('Breeder');

  const FeedType(this.label);

  final String label;

  /// Animal Type IDs (RECOMMENDED STANDARD)
  ///
  /// 1 = Pig
  /// 2 = Poultry Broiler
  /// 3 = Rabbit
  /// 4 = Dairy Cattle
  /// 5 = Beef Cattle
  /// 6 = Sheep
  /// 7 = Goat
  /// 8 = Fish Tilapia
  /// 9 = Fish Catfish
  ///
  static List<FeedType> forAnimalType(int animalTypeId) {
    switch (animalTypeId) {
      /// Pig
      case 1:
        return [
          FeedType.preStarter,
          FeedType.starter,
          FeedType.grower,
          FeedType.finisher,
          FeedType.gestating,
          FeedType.lactating,
          FeedType.maintenance,
        ];

      /// Poultry broiler
      case 2:
        return [
          FeedType.preStarter,
          FeedType.starter,
          FeedType.grower,
          FeedType.finisher,
        ];

      /// Rabbit
      case 3:
        return [
          FeedType.starter,
          FeedType.grower,
          FeedType.maintenance,
          FeedType.gestating,
          FeedType.lactating,
        ];

      /// Dairy cattle
      case 4:
        return [
          FeedType.maintenance,
          FeedType.gestating,
          FeedType.lactating,
        ];

      /// Beef cattle
      case 5:
        return [
          FeedType.starter,
          FeedType.grower,
          FeedType.finisher,
          FeedType.maintenance,
        ];

      /// Sheep
      case 6:
        return [
          FeedType.starter,
          FeedType.grower,
          FeedType.maintenance,
          FeedType.gestating,
          FeedType.lactating,
        ];

      /// Goat
      case 7:
        return [
          FeedType.starter,
          FeedType.grower,
          FeedType.maintenance,
          FeedType.gestating,
          FeedType.lactating,
        ];

      /// Fish (Tilapia, Catfish)
      case 8:
      case 9:
        return [
          FeedType.starter,
          FeedType.grower,
          FeedType.finisher,
        ];

      default:
        return [FeedType.maintenance];
    }
  }
}
