import 'package:equatable/equatable.dart';

abstract class StudentLessonEvent extends Equatable {
  const StudentLessonEvent();

  @override
  List<Object> get props => [];
}

class GetSubjectData extends StudentLessonEvent {
  final String studentId;
  final String classId;


  const GetSubjectData({required this.studentId,required this.classId});

  @override
  List<Object> get props => [studentId,classId];
}
class GetLessonRecordData extends StudentLessonEvent {
  final String studentId;
  final String subjectId;


  const GetLessonRecordData({required this.studentId,required this.subjectId,});

  @override
  List<Object> get props => [studentId,subjectId];
}



