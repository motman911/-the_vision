import 'dart:io';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

Future<void> sendEmail(String name, File? pdfFile, File passport,
    File personalPhoto, File certificateFront, File? certificateBack,
    {String? phone, String? whatsapp, String? email, String? country}) async {
  String username = 'skstechnologies.eld@gmail.com';
  String password = 'okbezijhpyyylgth'; // App password

  final smtpServer = gmail(username, password);

  // نص HTML منسق للرسالة
  final htmlMessage = """
  <h2>بيانات الطالب</h2>
  <p><strong>الاسم:</strong> $name</p>
  ${phone != null && phone.isNotEmpty ? '<p><strong>رقم الهاتف:</strong> $phone</p>' : ''}
  <p><strong>رقم الواتساب:</strong> $whatsapp</p>
  ${email != null && email.isNotEmpty ? '<p><strong>البريد الإلكتروني:</strong> $email</p>' : ''}
  ${country != null ? '<p><strong>الجنسية:</strong> $country</p>' : ''}
  <p><strong>الملفات المرفقة:</strong></p>
  <ul>
    <li>جواز السفر</li>
    <li>صورة شخصية</li>
    <li>شهادة أمام</li>
    ${certificateBack != null ? '<li>شهادة خلف</li>' : ''}
    ${pdfFile != null ? '<li>PDF</li>' : ''}
  </ul>
  """;

  final message = Message()
    ..from = Address(username, 'The Vision App')
    ..recipients.add(username)
    ..subject = 'New Submission from $name'
    ..html = htmlMessage
    ..attachments = [
      FileAttachment(passport),
      FileAttachment(personalPhoto),
      FileAttachment(certificateFront),
      if (certificateBack != null) FileAttachment(certificateBack),
      if (pdfFile != null) FileAttachment(pdfFile),
    ];

  try {
    await send(message, smtpServer);
  } on MailerException catch (e) {
    throw Exception('Failed to send email: $e');
  }
}
