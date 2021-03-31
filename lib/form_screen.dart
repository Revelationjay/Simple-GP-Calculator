import 'package:calc/model/CourseModel.dart';
import 'package:flutter/material.dart';

class FormScreen extends StatefulWidget {
  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  int _formCount = 5;

  String Gp = "";

  Map<String, int> _gradeDropDownItems = {
    'A': 5,
    'B': 4,
    'C': 3,
    'D': 2,
    'E': 1,
    'F': 0,
    'Missing Script': 0
  };

  final _formKey = GlobalKey<FormState>();

  List<CourseModel> courses = [];

  _initCourses() {
    for (int i = 0; i < _formCount; i++) {
      courses.add(CourseModel());
    }
  }

  @override
  void initState() {
    super.initState();
    _initCourses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[900],
        title: Text('GP Calculator'),
        centerTitle: true,
        actions: [
          IconButton(
              icon: Icon(Icons.add_circle_outline),
              onPressed: () {
                setState(() {
                  _formCount++;
                  courses.add(CourseModel());
                });
              }),
          IconButton(
              icon: Icon(Icons.remove_circle_outline),
              onPressed: () {
                setState(() {
                  if (_formCount > 1) {
                    _formCount--;
                    courses.removeLast();
                  }
                });
              })
        ],
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: [
              SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: _formCount,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              keyboardType: TextInputType.text,
                              validator: (val) =>
                                  val.length <= 3 ? "Entry too short" : null,
                              onChanged: (val) => courses[index].courseCode = val,
                              decoration: InputDecoration(
                                labelText: 'Course Code',
                                hintText: 'Enter Course code here',
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            flex: 3,
                            child: DropdownButtonFormField<String>(
                              value: courses[index].grade,
                              validator: (val) =>
                                  val == null ? "Select grade" : null,
                              icon: Icon(Icons.arrow_drop_down),
                              hint: Text(
                                "Grade",
                                overflow: TextOverflow.ellipsis,
                              ),
                              onChanged: (String grade) {
                                setState(() {
                                  courses[index].grade = grade;
                                });
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                ),
                              ),
                              items: _gradeDropDownItems.keys
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              keyboardType: TextInputType.number,
                              // maxLength: 2,
                              validator: (val) => int.tryParse(val) == null
                                  ? "Invalid entry"
                                  : null,
                              onChanged: (val) =>
                                  courses[index].unitLoad = int.tryParse(val),
                              decoration: InputDecoration(
                                labelText: 'Unit Load',
                                hintText: 'Enter Unit Load here',
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (!_formKey.currentState.validate()) return;

                          double totalUnitLoad = 0;
                          double totalGradePoint = 0;

                          for (int i = 0; i < courses.length; i++) {
                            CourseModel course = courses[i];
                            totalUnitLoad = totalUnitLoad + course.unitLoad;
                            totalGradePoint = totalGradePoint +
                                (course.unitLoad * getGradePoint(course.grade));
                          }
                          print("total unit load: " + totalUnitLoad.toString());
                          print("total grade point: " +
                              totalGradePoint.toString());

                          double gp = totalGradePoint / totalUnitLoad;
                          setState(() {
                            Gp = gp.toStringAsFixed(2);
                          });

                          _showDialog(totalCourseLoad: totalUnitLoad);
                        },
                        child: Text('Calculate'),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          _formKey.currentState.reset();
                          for(int i =0 ; i< courses.length; i++)
                          setState(() {
                            courses[i].grade = null;
                          });
                        },
                        child: Text('Reset'),
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.amber[800]),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  void _showDialog({double totalCourseLoad}) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 60, vertical: 80),
        child: Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              Text(
                "Total Units: " + totalCourseLoad.toString(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Your GP:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 60),
              Text(
                '$Gp',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Spacer(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Okay',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int getGradePoint(String v) {
    switch (v) {
      case 'A':
        return 5;
        break;
      case 'B':
        return 4;
        break;
      case 'C':
        return 3;
        break;
      case 'D':
        return 2;
        break;
      case 'E':
        return 1;
        break;
      case 'F':
        return 0;
        break;
      case 'Missing Script':
        return 0;
        break;
      default:
        throw Exception("Value not known");
    }
  }
}
