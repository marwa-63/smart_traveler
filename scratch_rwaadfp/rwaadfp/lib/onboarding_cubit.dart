import 'package:flutter_bloc/flutter_bloc.dart';

class OnboardingCubit extends Cubit<int> {
  OnboardingCubit() : super(0);

  void next() {
    if (state < 2) {
      emit(state + 1);
    }
  }

  void previous() {
    if (state > 0) {
      emit(state - 1);
    }
  }

  void skip() {
    emit(2);
  }

  void updateIndex(int index) {
    emit(index);
  }
}
