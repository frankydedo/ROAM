class Task {
  String id;
  String category;
  String? robotName;
  String? fleetName;
  String state;
  String startTime;
  String? estimatedDuration;
  String completionPerc;

  Task({
    required this.id,
    required this.category,
    required this.robotName,
    required this.fleetName,
    required this.state,
    required this.startTime,
    required this.estimatedDuration,
    required this.completionPerc
  });

  String getIdFirstHalf(){
    List<String> halfs = id.split('-');
    return halfs[0];
  }

  String getIdSecondHalf(){
    List<String> halfs = id.split('-');
    return halfs[1];
  }

  @override
  String toString() {
    return 'Task(id: $id, category: $category, robotName: $robotName, fleetName: $fleetName, state: $state, startTime: $startTime, estimatedDuration: $estimatedDuration, completionPerc: $completionPerc)';
  }
}
