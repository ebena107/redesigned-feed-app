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

  breeder('Breeder'),
  early(
      'Early'), // Early lactation (peak), breeding buck/bull, growing ewe/doeling

  micro('Micro'), // Micro fry (hatchery 0-2g tilapia, 5-7 day catfish)
  fry('Fry'); // Fry transition (2-5g tilapia, 0.5-2g catfish)

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
          FeedType.preStarter, // Calf (6-8 weeks)
          FeedType.starter, // Weaned heifer (6-9 months)
          FeedType.grower, // Growing heifer (12-18 months)
          FeedType.finisher, // Pre-breeding heifer (18-24 months)
          FeedType.early, // Early lactation (peak milk)
          FeedType.lactating, // Mid/late lactation
          FeedType.gestating, // Late gestation (dry period)
        ];

      /// Beef cattle
      case 5:
        return [
          FeedType.preStarter, // Calf creep (70-150 lbs)
          FeedType.starter, // Young animal (150-300 lbs)
          FeedType.grower, // Growing (300-600 lbs)
          FeedType.finisher, // Finishing (600-1100 lbs)
          FeedType.early, // Breeding bull
          FeedType.gestating, // Pregnant cow
        ];

      /// Sheep
      case 6:
        return [
          FeedType.preStarter, // Lamb creep (birth-4 weeks)
          FeedType.starter, // Weaned lamb (4-8 weeks)
          FeedType.grower, // Growing lamb (8-16 weeks)
          FeedType.finisher, // Finishing lamb (16-20 weeks)
          FeedType.early, // Growing ewe (6-12 months)
          FeedType.maintenance, // Maintenance ewe/wether
          FeedType.gestating, // Late pregnant ewe (4-6 weeks)
          FeedType.lactating, // Lactating ewe (peak)
        ];

      /// Goat
      case 7:
        return [
          FeedType.preStarter, // Doeling creep (birth-2 months)
          FeedType.starter, // Young doeling (2-4 months)
          FeedType.grower, // Growing doeling (4-8 months)
          FeedType.finisher, // Replacement doeling (8-12 months)
          FeedType.early, // Breeding buck
          FeedType.maintenance, // Maintenance doe/wether
          FeedType.gestating, // Late pregnant doe (4-6 weeks)
          FeedType.lactating, // Lactating doe (peak)
        ];

      /// Fish (Tilapia)
      case 8:
        return [
          FeedType.micro, // Hatchery (0-2g), 40 µm particles
          FeedType.fry, // Transition (2-5g), 100-150 µm particles
          FeedType.preStarter, // Nursery (5-10g), transition to 370 µm
          FeedType.starter, // Juvenile (10-50g), 37-41% CP
          FeedType.grower, // Growing (50-100g), 28-32% CP
          FeedType.finisher, // Market-size (100-200g), 23-27% CP
          FeedType.breeder, // Broodstock (200g+), 30-34% CP + carotenoids
          FeedType.maintenance, // Non-breeding ponds, 22-26% CP
        ];

      /// Fish (Catfish)
      case 9:
        return [
          FeedType.micro, // Micro fry (5-7 days), 20-40 µm particles
          FeedType.fry, // Fry stage (0.5-2g), 50-55% CP (HIGHEST!)
          FeedType.preStarter, // Fingerling transition (2-10g), 42-48% CP
          FeedType.starter, // Fingerling (10-50g), 37-46% CP
          FeedType.grower, // Growing (50-100g), 29.6-39.78% CP
          FeedType.finisher, // Market-size (100-300g), 25-35% CP
          FeedType.breeder, // Broodstock (300g+), 35-40% CP
        ];

      default:
        return [FeedType.maintenance];
    }
  }
}
