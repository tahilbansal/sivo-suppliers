import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sivo_suppliers/models/environment.dart';

class FileUploadPage extends StatefulWidget {
  @override
  _FileUploadPageState createState() => _FileUploadPageState();
}

class _FileUploadPageState extends State<FileUploadPage> {
  bool isUploading = false;

  Future<void> uploadFile() async {
    try {
      // Allow user to pick a file
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'csv'],
      );

      if (result != null && result.files.single.bytes != null) {
        setState(() {
          isUploading = true;
        });

        // Get file data
        var fileBytes = result.files.single.bytes;
        var fileName = result.files.single.name;

        // Prepare the request
        var uri = Uri.parse('${Environment.appBaseUrl}/api/excel/upload'); // Replace with your backend URL
        var request = http.MultipartRequest('POST', uri);
        request.files.add(http.MultipartFile.fromBytes('file', fileBytes!, filename: fileName));

        // Send the request
        var response = await request.send();

        if (response.statusCode == 200) {
          var responseData = await response.stream.bytesToString();
          var decodedData = jsonDecode(responseData);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Upload successful: ${decodedData['message']}')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Upload failed: ${response.statusCode}')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No file selected')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Excel/CSV File'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              isUploading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: uploadFile,
                child: Text('Upload File'),
              ),
              SizedBox(height: 20),
              Text(
                'Allowed file types: .xlsx, .csv',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

