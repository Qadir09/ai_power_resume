import 'package:ai_power_resume/resume_model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ResumePdfExporter {
  static Future<void> export(ResumeModel resume) async {
    final pdf = pw.Document();

    final sectionTitleStyle = pw.TextStyle(
      fontSize: 16,
      fontWeight: pw.FontWeight.bold,
      color: PdfColors.blueGrey800,
    );
    final baseTextStyle = pw.TextStyle(fontSize: 12, color: PdfColors.grey800);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        build: (pw.Context context) {
          return pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // LEFT SIDEBAR
              pw.Container(
                width: 150,
                color: PdfColors.grey200,
                padding: const pw.EdgeInsets.all(12),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    // Profile placeholder (initials)
                    pw.Container(
                      width: 80,
                      height: 80,
                      decoration: pw.BoxDecoration(
                        shape: pw.BoxShape.circle,
                        color: PdfColors.blueGrey300,
                      ),
                      alignment: pw.Alignment.center,
                      child: pw.Text(
                        _getInitials(resume.name),
                        style: pw.TextStyle(
                          fontSize: 24,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.white,
                        ),
                      ),
                    ),
                    pw.SizedBox(height: 16),

                    pw.Align(
                      alignment: pw.Alignment.centerLeft,
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text('Contact', style: sectionTitleStyle),
                          pw.SizedBox(height: 4),
                          pw.Text(
                            'Email: ${resume.email}',
                            style: baseTextStyle,
                          ),
                          pw.Text(
                            'Phone: ${resume.phone}',
                            style: baseTextStyle,
                          ),
                          if (resume.linkedin.isNotEmpty) ...[
                            pw.SizedBox(height: 4),
                            pw.Text('LinkedIn:', style: baseTextStyle),
                            pw.UrlLink(
                              destination: resume.linkedin,
                              child: pw.Text(
                                resume.linkedin,
                                style: pw.TextStyle(
                                  fontSize: 10,
                                  color: PdfColors.blue,
                                  decoration: pw.TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                          pw.SizedBox(height: 20),

                          pw.Text('Skills', style: sectionTitleStyle),
                          pw.SizedBox(height: 8),
                          pw.Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children:
                                resume.skills.map((skill) {
                                  return pw.Container(
                                    padding: const pw.EdgeInsets.symmetric(
                                      vertical: 4,
                                      horizontal: 6,
                                    ),
                                    decoration: pw.BoxDecoration(
                                      color: PdfColors.blueGrey100,
                                      borderRadius: pw.BorderRadius.circular(4),
                                    ),
                                    child: pw.Text(
                                      skill,
                                      style: pw.TextStyle(
                                        fontSize: 10,
                                        color: PdfColors.blueGrey800,
                                      ),
                                    ),
                                  );
                                }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              pw.SizedBox(width: 20),

              // MAIN CONTENT
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      resume.name,
                      style: pw.TextStyle(
                        fontSize: 26,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.blueGrey900,
                      ),
                    ),
                    pw.Divider(color: PdfColors.grey),
                    pw.SizedBox(height: 10),

                    pw.Text('Career Objective', style: sectionTitleStyle),
                    pw.SizedBox(height: 4),
                    pw.Text(resume.objective, style: baseTextStyle),
                    pw.SizedBox(height: 20),

                    pw.Text('Experience', style: sectionTitleStyle),
                    pw.SizedBox(height: 4),
                    pw.Text(resume.experience, style: baseTextStyle),
                    pw.SizedBox(height: 20),

                    // Manually Added Education Section
                    pw.Text('Education', style: sectionTitleStyle),
                    pw.SizedBox(height: 8),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.only(bottom: 8),
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(
                                'B.Sc in Computer Science',
                                style: pw.TextStyle(
                                  fontSize: 14,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                              pw.Text(
                                'XYZ University • 2022',
                                style: baseTextStyle,
                              ),
                            ],
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.only(bottom: 8),
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(
                                'High School',
                                style: pw.TextStyle(
                                  fontSize: 14,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                              pw.Text(
                                'ABC School • 2018',
                                style: baseTextStyle,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  static String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }
}
