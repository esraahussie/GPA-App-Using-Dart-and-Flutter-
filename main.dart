import 'package:flutter/material.dart';

void main() {
  runApp(StudentGradesApp());
}

class StudentGradesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Grades Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      home: GradesHomePage(),
    );
  }
}

class GradesHomePage extends StatefulWidget {
  @override
  _GradesHomePageState createState() => _GradesHomePageState();
}

class _GradesHomePageState extends State<GradesHomePage> {
  List<Map<String, dynamic>> subjects = [];

  final TextEditingController nameController = TextEditingController();
  final TextEditingController gradeController = TextEditingController();
  final TextEditingController hoursController = TextEditingController();

  double gradeToGPA(double grade) {
    if (grade >= 90) return 4.0;
    if (grade >= 85) return 3.7;
    if (grade >= 80) return 3.3;
    if (grade >= 75) return 3.0;
    if (grade >= 70) return 2.7;
    if (grade >= 65) return 2.3;
    if (grade >= 60) return 2.0;
    if (grade >= 50) return 1.0;
    return 0.0;
  }

  double get gpa {
    if (subjects.isEmpty) return 0.0;

    double totalGPA = 0.0;
    double totalHours = 0.0;

    for (var subject in subjects) {
      final grade = subject['grade'];
      final hours = subject['hours'];
      final subjectGPA = gradeToGPA(grade);

      if (grade > 0) {
        totalGPA += subjectGPA * hours;
        totalHours += hours;
      }
    }

    return totalHours > 0 ? totalGPA / totalHours : 0.0;
  }

  void _addSubject() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add New Subject"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Subject Name'),
            ),
            TextField(
              controller: gradeController,
              decoration: InputDecoration(labelText: 'Grade (0 - 100)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: hoursController,
              decoration: InputDecoration(labelText: 'Credit Hours'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              nameController.clear();
              gradeController.clear();
              hoursController.clear();
              Navigator.pop(context);
            },
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              final name = nameController.text.trim();
              final grade = double.tryParse(gradeController.text.trim());
              final hours = double.tryParse(hoursController.text.trim());

              if (name.isNotEmpty &&
                  grade != null &&
                  hours != null &&
                  grade >= 0 &&
                  grade <= 100 &&
                  hours > 0) {
                setState(() {
                  subjects.add({
                    'name': name,
                    'grade': grade,
                    'hours': hours,
                  });
                });
                nameController.clear();
                gradeController.clear();
                hoursController.clear();
                Navigator.pop(context);
              }
            },
            child: Text("Add"),
          ),
        ],
      ),
    );
  }

  Color getGradeColor(double grade) {
    if (grade >= 85) return Colors.pink.shade700;
    if (grade >= 60) return Colors.pink.shade300;
    return Colors.red.shade300;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Student Grades Tracker"),
        centerTitle: true,
        backgroundColor: Colors.pink,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // GPA Display
            Card(
              color: Colors.pink.shade50,
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(Icons.school, size: 32, color: Colors.pink),
                    SizedBox(width: 12),
                    Text(
                      "GPA: ${gpa.toStringAsFixed(2)} / 4.0",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            // Subjects List
            Expanded(
              child: subjects.isEmpty
                  ? Center(child: Text("No subjects added yet."))
                  : ListView.builder(
                      itemCount: subjects.length,
                      itemBuilder: (context, index) {
                        final subject = subjects[index];
                        final subjectGPA = gradeToGPA(subject['grade']);

                        return Card(
                          elevation: 3,
                          margin: EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: getGradeColor(subject['grade']),
                              child: Text(
                                subject['grade'].toStringAsFixed(0),
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            title: Text(subject['name']),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Credit Hours: ${subject['hours']}"),
                                Text(
                                    "GPA for this subject: ${subjectGPA.toStringAsFixed(1)}"),
                              ],
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  subjects.removeAt(index);
                                });
                              },
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addSubject,
        backgroundColor: Colors.pink,
        child: Icon(Icons.add),
        tooltip: 'Add Subject',
      ),
    );
  }
}
