class LessonRecord {
  String lessonplanid;
  String classid;
  String lessonstatus;
  String statusnew;
  String lessoname;


  LessonRecord({required this.lessonplanid,required this.classid,required this.lessonstatus,required this.statusnew,required this.lessoname,});

  factory LessonRecord.fromJson(Map<String, dynamic> json) {
    return LessonRecord(
      lessonplanid: json['lessonplanid'],
      classid: json['classid'],
      lessonstatus: json['lessonstatus'],
      statusnew: json['statusnew'],
      lessoname: json['lessoname'],
    );
  }
}

class LessonRecordResponse {
  int status;
  String message;
  List<LessonRecord> result;

  LessonRecordResponse({required this.status, required this.message, required this.result});

  factory LessonRecordResponse.fromJson(Map<String, dynamic> json) {
    var result = json['result'] as List;
    List<LessonRecord> lessonRecord = result.map((messageJson) {
      return LessonRecord.fromJson(messageJson);
    }).toList();

    return LessonRecordResponse(
      status: json['status'],
      message: json['message'],
      result: lessonRecord,
    );
  }
}