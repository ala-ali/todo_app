abstract class TodoStates {}

class TodoInitialState extends TodoStates {}

class TodoChangeIndexOfNavBar extends TodoStates {}

class TodoChangeIconToEditState extends TodoStates {}

class TodoChangeIconToAddState extends TodoStates {}

class TodoLoadTasksState extends TodoStates {}

class TodoInsertErrorState extends TodoStates {
  final error ;
  TodoInsertErrorState(this.error);
}
