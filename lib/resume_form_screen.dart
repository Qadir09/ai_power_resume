import 'package:ai_power_resume/resume_form/pdf_exporter.dart';
import 'package:ai_power_resume/resume_model.dart';
import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import '../services/gemini_api_service.dart';

class ResumeFormScreen extends StatefulWidget {
  @override
  _ResumeFormScreenState createState() => _ResumeFormScreenState();
}

class _ResumeFormScreenState extends State<ResumeFormScreen> {
  final _formKey = GlobalKey<FormState>();
  ResumeModel resume = ResumeModel();
  bool isLoading = false;
  String aiSuggestion = "";

  void _getAISuggestions() async {
    setState(() => isLoading = true);
    final result = await GeminiApiService.getResumeSuggestions(resume);
    setState(() {
      aiSuggestion = result;
      isLoading = false;
    });
  }

  void _generatePDF() {
    ResumePdfExporter.export(resume);
  }

  void _logout() async {
    await FirebaseService.signOut();
    Navigator.pushReplacementNamed(context, '/');
  }

  Widget buildTextField({
    required String label,
    required Function(String) onChanged,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onChanged: onChanged,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("✨ AI Resume Builder"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [IconButton(onPressed: _logout, icon: Icon(Icons.logout))],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _generatePDF,
        label: Text("Export PDF"),
        icon: Icon(Icons.picture_as_pdf),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(
                "Personal Info",
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              buildTextField(
                label: "Full Name",
                onChanged: (val) => resume.name = val,
              ),
              buildTextField(
                label: "Email",
                onChanged: (val) => resume.email = val,
              ),
              buildTextField(
                label: "Phone",
                onChanged: (val) => resume.phone = val,
              ),

              SizedBox(height: 16),
              Text(
                "Resume Details",
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              buildTextField(
                label: "Skills (comma separated)",
                onChanged: (val) => resume.skills = val.split(','),
              ),
              buildTextField(
                label: "Experience",
                maxLines: 3,
                onChanged: (val) => resume.experience = val,
              ),
              buildTextField(
                label: "Career Objective",
                maxLines: 3,
                onChanged: (val) => resume.objective = val,
              ),
              buildTextField(
                label: "LinkedIn URL (optional)",
                onChanged: (val) => resume.linkedin = val,
              ),

              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _getAISuggestions,
                icon: Icon(Icons.lightbulb),
                label: Text("Get AI Suggestions"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              if (isLoading)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (aiSuggestion.isNotEmpty)
                Card(
                  color: Colors.teal.shade50,
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      "💡 AI Suggestion:\n$aiSuggestion",
                      style: TextStyle(fontSize: 14, color: Colors.green),
                    ),
                  ),
                ),

              SizedBox(height: 80), // for FAB space
            ],
          ),
        ),
      ),
    );
  }
}
