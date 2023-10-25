import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:kmschool/bloc/event/get_snack_menu_event.dart';

import '../../data/api/ApiService.dart';
import '../event/login_event.dart';
import '../event/student_lesson_event.dart';
import '../state/common_state.dart';

class StudentLessonBloc extends Bloc<StudentLessonEvent, CommonState> {
  StudentLessonBloc() : super(InitialState()) {
    on<GetSubjectData>(_onGetSubjectData);
    on<GetLessonRecordData>(_onGetLessonRecordData);
  }

  Future<void> _onGetSubjectData(
      GetSubjectData event, Emitter<CommonState> emit) async {
    // Handle the Get User Data event
    emit(LoadingState());

    try {
      dynamic getUserData = await ApiService().getSubjectListList(event.studentId,event.classId);
      // Process the API response
      // Emit a success state
      if (kDebugMode) {
        print(getUserData);
      }
      emit(SuccessState(getUserData));
    } catch (error) {
      // Emit a failure state
      emit(FailureState(error.toString()));
    }
  }

  Future<void> _onGetLessonRecordData(
      GetLessonRecordData event, Emitter<CommonState> emit) async {
    // Handle the Get User Data event
    emit(LoadingState());

    try {
      dynamic getUserData = await ApiService().getLessonRecordList(event.studentId,event.subjectId);
      // Process the API response
      // Emit a success state
      if (kDebugMode) {
        print(getUserData);
      }
      emit(SuccessState(getUserData));
    } catch (error) {
      // Emit a failure state
      emit(FailureState(error.toString()));
    }
  }

// Other methods and event handlers...
}
