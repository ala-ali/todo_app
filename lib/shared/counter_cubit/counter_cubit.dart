import 'package:bloc/bloc.dart';
import 'counter_states.dart';


class CounterCubit extends Cubit<CounterStates>{
  CounterCubit() : super(CounterInitialState());
int count = 0;
  void incrementCount(){
    count++;
  }
  void decrementCount(){
    count--;
  }
}