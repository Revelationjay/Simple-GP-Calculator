class CourseModel {
  String courseCode;
  String grade;
  int unitLoad;

  CourseModel({this.courseCode, this.grade, this.unitLoad});

  @override
  String toString(){
    return "Course: $courseCode, $grade, $unitLoad";
  }
}