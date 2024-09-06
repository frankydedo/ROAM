class Robot {
  String name;
  String fleet;
  String status;
  String location;
  double batteryLevel;

  Robot({
    required this.name,
    required this.fleet,
    required this.status,
    required this.location,
    required this.batteryLevel,
  });

  @override
  String toString() {
    return 'Robot(name: $name, fleet: $fleet, status: $status, location: $location, batteryLevel: $batteryLevel)';
  }
}
