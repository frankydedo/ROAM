import 'package:fleet_manager/models/Project.dart';
import 'package:fleet_manager/models/Robot.dart';
import 'package:fleet_manager/models/Task.dart';
import 'package:flutter/material.dart';

class ProjectProvider extends ChangeNotifier {

  List<Project> projects = [
    Project(
        name: "Office",
        liveTime: 4863, //1h 21min 3sec
        tasks: [
          Task(
            id: "A000",
            destination: "room1",
            robot: Robot(name: "Dog1", fleet: "dogs_fleet1", type: "Zoomorphous",status: "Working",location: "L1",batteryLevel: 98.5,),
            type: "Delivery",
            state: "Active",
            date: DateTime.now(),
            start: DateTime.now(),
            end: DateTime.now().add(const Duration(minutes: 20)),
            completionPerc: 1,
          ),
          Task(
            id: "A001",
            destination: "room1",
            robot: Robot(name: "Dog1", fleet: "dogs_fleet1", type: "Zoomorphous",status: "Working",location: "L1",batteryLevel: 98.5,),
            type: "Delivery",
            state: "Queued",
            date: DateTime.now(),
            start: DateTime.now(),
            end: DateTime.now().add(const Duration(minutes: 20)),
            completionPerc: 31,
          ),
          Task(
            id: "A002",
            destination: "room1",
            robot: Robot(name: "Dog1", fleet: "dogs_fleet1", type: "Zoomorphous",status: "Working",location: "L1",batteryLevel: 98.5,),
            type: "Delivery",
            state: "Completed",
            date: DateTime.now(),
            start: DateTime.now(),
            end: DateTime.now().add(const Duration(minutes: 20)),
            completionPerc: 100,
          ),


          Task(
            id: "A000",
            destination: "room1",
            robot: Robot(name: "Dog1", fleet: "dogs_fleet1", type: "Zoomorphous",status: "Working",location: "L1",batteryLevel: 98.5,),
            type: "Delivery",
            state: "Aborted",
            date: DateTime.now(),
            start: DateTime.now(),
            end: DateTime.now().add(const Duration(minutes: 20)),
            completionPerc: 1,
          ),
          // Task(
          //   id: "A001",
          //   destination: "room1",
          //   robot: Robot(name: "Dog1", fleet: "dogs_fleet1", type: "Zoomorphous",status: "Working",location: "L1",batteryLevel: 98.5,),
          //   type: "Delivery",
          //   state: "Active",
          //   date: DateTime.now(),
          //   start: DateTime.now(),
          //   end: DateTime.now().add(const Duration(minutes: 20)),
          //   completionPerc: 31,
          // ),
          // Task(
          //   id: "A002",
          //   destination: "room1",
          //   robot: Robot(name: "Dog1", fleet: "dogs_fleet1", type: "Zoomorphous",status: "Working",location: "L1",batteryLevel: 98.5,),
          //   type: "Delivery",
          //   state: "Active",
          //   date: DateTime.now(),
          //   start: DateTime.now(),
          //   end: DateTime.now().add(const Duration(minutes: 20)),
          //   completionPerc: 99,
          // ),

          //           Task(
          //   id: "A000",
          //   destination: "room1",
          //   robot: Robot(name: "Dog1", fleet: "dogs_fleet1", type: "Zoomorphous",status: "Working",location: "L1",batteryLevel: 98.5,),
          //   type: "Delivery",
          //   state: "Active",
          //   date: DateTime.now(),
          //   start: DateTime.now(),
          //   end: DateTime.now().add(const Duration(minutes: 20)),
          //   completionPerc: 1,
          // ),
          // Task(
          //   id: "A001",
          //   destination: "room1",
          //   robot: Robot(name: "Dog1", fleet: "dogs_fleet1", type: "Zoomorphous",status: "Working",location: "L1",batteryLevel: 98.5,),
          //   type: "Delivery",
          //   state: "Active",
          //   date: DateTime.now(),
          //   start: DateTime.now(),
          //   end: DateTime.now().add(const Duration(minutes: 20)),
          //   completionPerc: 31,
          // ),
          // Task(
          //   id: "A002",
          //   destination: "room1",
          //   robot: Robot(name: "Dog1", fleet: "dogs_fleet1", type: "Zoomorphous",status: "Working",location: "L1",batteryLevel: 98.5,),
          //   type: "Delivery",
          //   state: "Active",
          //   date: DateTime.now(),
          //   start: DateTime.now(),
          //   end: DateTime.now().add(const Duration(minutes: 20)),
          //   completionPerc: 99,
          // ),

        ],
        robots: [
          Robot(
            name: "Dog1",
            fleet: "dogs_fleet1",
            type: "Zoomorphous",
            currentTaskID: "A000",
            status: "Working",
            location: "L1",
            batteryLevel: 98.5,
          ),
          Robot(
            name: "Dog2",
            fleet: "dogs_fleet1",
            type: "Zoomorphous",
            currentTaskID: null,
            status: "Idle",
            location: "L1",
            batteryLevel: 28.5,
          ),
          Robot(
            name: "Dog3",
            fleet: "dogs_fleet1",
            type: "Zoomorphous",
            currentTaskID: null,
            status: "Charging",
            location: "L1",
            batteryLevel: 8.5,
          )
        ],
      ),

      Project(
        name: "Airport",
        liveTime: 2512, //0h 41min 52sec
        tasks: [
          Task(
            id: "B000",
            destination: "room1",
            robot: Robot(name: "Dog2", fleet: "dogs_fleet2", type: "Zoomorphous",status: "Working",location: "L1",batteryLevel: 96.2,),
            type: "Delivery",
            state: "Active",
            date: DateTime.now(),
            start: DateTime.now(),
            end: DateTime.now().add(const Duration(minutes: 20)),
            completionPerc: 13,
          )
        ],
        robots: [
          Robot(
            name: "Dog2",
            fleet: "dogs_fleet2",
            type: "Zoomorphous",
            currentTaskID: "B000",
            status: "Working",
            location: "L1",
            batteryLevel: 96.2,
          )
        ],
      ),

      // --------------------------------------------

      // Project(
      //   name: "Airport",
      //   liveTime: 2512, //0h 41min 52sec
      //   tasks: [
      //     Task(
      //       id: "B000",
      //       destination: "room1",
      //       robot: Robot(name: "Dog2", fleet: "dogs_fleet2", type: "Zoomorphous",status: "Working",location: "L1",batteryLevel: 96.2,),
      //       type: "Delivery",
      //       state: "Active",
      //       date: DateTime.now(),
      //       start: DateTime.now(),
      //       end: DateTime.now().add(const Duration(minutes: 20)),
      //       completionPerc: 13,
      //     )
      //   ],
      //   robots: [
      //     Robot(
      //       name: "Dog2",
      //       fleet: "dogs_fleet2",
      //       type: "Zoomorphous",
      //       currentTask: Task(
      //         id: "B000",
      //         destination: "room1",
      //         robot: Robot(name: "Dog2", fleet: "dogs_fleet2", type: "Zoomorphous",status: "Working",location: "L1",batteryLevel: 96.2,),
      //         type: "Delivery",
      //         state: "Active",
      //         date: DateTime.now(),
      //         start: DateTime.now(),
      //         end: DateTime.now().add(const Duration(minutes: 20)),
      //         completionPerc: 13,
      //       ),
      //       status: "Working",
      //       location: "L1",
      //       batteryLevel: 96.2,
      //     )
      //   ],
      // ),

      // Project(
      //   name: "Airport",
      //   liveTime: 2512, //0h 41min 52sec
      //   tasks: [
      //     Task(
      //       id: "B000",
      //       destination: "room1",
      //       robot: Robot(name: "Dog2", fleet: "dogs_fleet2", type: "Zoomorphous",status: "Working",location: "L1",batteryLevel: 96.2,),
      //       type: "Delivery",
      //       state: "Active",
      //       date: DateTime.now(),
      //       start: DateTime.now(),
      //       end: DateTime.now().add(const Duration(minutes: 20)),
      //       completionPerc: 13,
      //     )
      //   ],
      //   robots: [
      //     Robot(
      //       name: "Dog2",
      //       fleet: "dogs_fleet2",
      //       type: "Zoomorphous",
      //       currentTask: Task(
      //         id: "B000",
      //         destination: "room1",
      //         robot: Robot(name: "Dog2", fleet: "dogs_fleet2", type: "Zoomorphous",status: "Working",location: "L1",batteryLevel: 96.2,),
      //         type: "Delivery",
      //         state: "Active",
      //         date: DateTime.now(),
      //         start: DateTime.now(),
      //         end: DateTime.now().add(const Duration(minutes: 20)),
      //         completionPerc: 13,
      //       ),
      //       status: "Working",
      //       location: "L1",
      //       batteryLevel: 96.2,
      //     )
      //   ],
      // ),

      // Project(
      //   name: "Airport",
      //   liveTime: 2512, //0h 41min 52sec
      //   tasks: [
      //     Task(
      //       id: "B000",
      //       destination: "room1",
      //       robot: Robot(name: "Dog2", fleet: "dogs_fleet2", type: "Zoomorphous",status: "Working",location: "L1",batteryLevel: 96.2,),
      //       type: "Delivery",
      //       state: "Active",
      //       date: DateTime.now(),
      //       start: DateTime.now(),
      //       end: DateTime.now().add(const Duration(minutes: 20)),
      //       completionPerc: 13,
      //     )
      //   ],
      //   robots: [
      //     Robot(
      //       name: "Dog2",
      //       fleet: "dogs_fleet2",
      //       type: "Zoomorphous",
      //       currentTask: Task(
      //         id: "B000",
      //         destination: "room1",
      //         robot: Robot(name: "Dog2", fleet: "dogs_fleet2", type: "Zoomorphous",status: "Working",location: "L1",batteryLevel: 96.2,),
      //         type: "Delivery",
      //         state: "Active",
      //         date: DateTime.now(),
      //         start: DateTime.now(),
      //         end: DateTime.now().add(const Duration(minutes: 20)),
      //         completionPerc: 13,
      //       ),
      //       status: "Working",
      //       location: "L1",
      //       batteryLevel: 96.2,
      //     )
      //   ],
      // ),

      // Project(
      //   name: "Airport",
      //   liveTime: 2512, //0h 41min 52sec
      //   tasks: [
      //     Task(
      //       id: "B000",
      //       destination: "room1",
      //       robot: Robot(name: "Dog2", fleet: "dogs_fleet2", type: "Zoomorphous",status: "Working",location: "L1",batteryLevel: 96.2,),
      //       type: "Delivery",
      //       state: "Active",
      //       date: DateTime.now(),
      //       start: DateTime.now(),
      //       end: DateTime.now().add(const Duration(minutes: 20)),
      //       completionPerc: 13,
      //     )
      //   ],
      //   robots: [
      //     Robot(
      //       name: "Dog2",
      //       fleet: "dogs_fleet2",
      //       type: "Zoomorphous",
      //       currentTask: Task(
      //         id: "B000",
      //         destination: "room1",
      //         robot: Robot(name: "Dog2", fleet: "dogs_fleet2", type: "Zoomorphous",status: "Working",location: "L1",batteryLevel: 96.2,),
      //         type: "Delivery",
      //         state: "Active",
      //         date: DateTime.now(),
      //         start: DateTime.now(),
      //         end: DateTime.now().add(const Duration(minutes: 20)),
      //         completionPerc: 13,
      //       ),
      //       status: "Working",
      //       location: "L1",
      //       batteryLevel: 96.2,
      //     )
      //   ],
      // ),

      // Project(
      //   name: "Airport",
      //   liveTime: 2512, //0h 41min 52sec
      //   tasks: [
      //     Task(
      //       id: "B000",
      //       destination: "room1",
      //       robot: Robot(name: "Dog2", fleet: "dogs_fleet2", type: "Zoomorphous",status: "Working",location: "L1",batteryLevel: 96.2,),
      //       type: "Delivery",
      //       state: "Active",
      //       date: DateTime.now(),
      //       start: DateTime.now(),
      //       end: DateTime.now().add(const Duration(minutes: 20)),
      //       completionPerc: 13,
      //     )
      //   ],
      //   robots: [
      //     Robot(
      //       name: "Dog2",
      //       fleet: "dogs_fleet2",
      //       type: "Zoomorphous",
      //       currentTask: Task(
      //         id: "B000",
      //         destination: "room1",
      //         robot: Robot(name: "Dog2", fleet: "dogs_fleet2", type: "Zoomorphous",status: "Working",location: "L1",batteryLevel: 96.2,),
      //         type: "Delivery",
      //         state: "Active",
      //         date: DateTime.now(),
      //         start: DateTime.now(),
      //         end: DateTime.now().add(const Duration(minutes: 20)),
      //         completionPerc: 13,
      //       ),
      //       status: "Working",
      //       location: "L1",
      //       batteryLevel: 96.2,
      //     )
      //   ],
      // ),

      // Project(
      //   name: "Airport",
      //   liveTime: 2512, //0h 41min 52sec
      //   tasks: [
      //     Task(
      //       id: "B000",
      //       destination: "room1",
      //       robot: Robot(name: "Dog2", fleet: "dogs_fleet2", type: "Zoomorphous",status: "Working",location: "L1",batteryLevel: 96.2,),
      //       type: "Delivery",
      //       state: "Active",
      //       date: DateTime.now(),
      //       start: DateTime.now(),
      //       end: DateTime.now().add(const Duration(minutes: 20)),
      //       completionPerc: 13,
      //     )
      //   ],
      //   robots: [
      //     Robot(
      //       name: "Dog2",
      //       fleet: "dogs_fleet2",
      //       type: "Zoomorphous",
      //       currentTask: Task(
      //         id: "B000",
      //         destination: "room1",
      //         robot: Robot(name: "Dog2", fleet: "dogs_fleet2", type: "Zoomorphous",status: "Working",location: "L1",batteryLevel: 96.2,),
      //         type: "Delivery",
      //         state: "Active",
      //         date: DateTime.now(),
      //         start: DateTime.now(),
      //         end: DateTime.now().add(const Duration(minutes: 20)),
      //         completionPerc: 13,
      //       ),
      //       status: "Working",
      //       location: "L1",
      //       batteryLevel: 96.2,
      //     )
      //   ],
      // ),

      // --------------------------------------------

  ];

  // ProjectProvider() {
  //   _tasks1 = [
  //     Task(
  //       id: "A000",
  //       destination: "room1",
  //       robot: Robot(name: "Dog1", fleet: "dogs_fleet1", type: "Anthropomorphous",currentTask: _tasks1[0],status: "Working",location: "L1",batteryLevel: 98.5,),
  //       type: "Delivery",
  //       state: "Active",
  //       date: DateTime.now(),
  //       start: DateTime.now(),
  //       end: DateTime.now().add(const Duration(minutes: 20)),
  //       completionPerc: 1,
  //     )
  //   ];

  //   projects = [
  //     Project(
  //       name: "Office",
  //       startingTime: DateTime.now(),
  //       tasks: List.from(_tasks1),
  //       robots: [
  //         Robot(
  //           name: "Dog1",
  //           fleet: "dogs_fleet1",
  //           type: "Anthropomorphous",
  //           currentTask: _tasks1[0],
  //           status: "Working",
  //           location: "L1",
  //           batteryLevel: 98.5,
  //         )
  //       ],
  //     )
  //   ];
  // }

  void addNewTask (Project p, Task t){
    p.addTask(t);
    notifyListeners();
  }

  void removeTask (Project p, Task t){
    p.removeTask(t);
    notifyListeners();
  }

  void refreshLiveTime (Project p, int sec){
    p.refreshLiveTime(sec);
  }
}
