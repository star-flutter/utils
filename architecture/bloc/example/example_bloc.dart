import '../bloc_provider.dart';
import 'package:equatable/equatable.dart';

class BlocExample extends BlocBase<BlocExampleStates> {

  int _clickCount = 0;

  @override
  BlocExampleStates initialData() {
    _loadInitialData();
    return BlocExampleLoadingState();
  }

  void _loadInitialData() async {
    await Future.delayed(Duration(seconds: 2));
    updateState(BlocExampleDataState(_clickCount));
  }

  void onIncrementButtonClick() {
    _clickCount++;
    updateState(BlocExampleDataState(_clickCount));
  }
}

abstract class BlocExampleStates extends Equatable {
  @override
  List<Object> get props => [];
}
class BlocExampleLoadingState extends BlocExampleStates {}
class BlocExampleDataState extends BlocExampleStates {
  final int clickCount;

  BlocExampleDataState(this.clickCount);

  @override
  List<Object> get props => [clickCount];
}