
class Robot{

  String name;
  String fleet;
  String type;
  String? currentTaskID;
  String status;
  String location;
  double batteryLevel;
  
  Robot({
    required this.name,
    required this.fleet,
    required this.type,
    this.currentTaskID,
    required this.status,
    required this.location,
    required this.batteryLevel
  });

  void setName (String newName){
    name = newName;
  }

  void setFleet (String newFleet){
    fleet = newFleet;
  }

  void setTask (String newTaskID){
    currentTaskID = newTaskID;
  }

  void setStatus (String newStatus){
    status = newStatus;
  }

  void setLocation (String newLocation){
    location = newLocation;
  }

  void setBatteryLevel (double newBatteryLevel){
    batteryLevel = newBatteryLevel;
  }

}