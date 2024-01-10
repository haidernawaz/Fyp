import 'package:flutter/material.dart';
import 'package:legalassistance/CustomWidgets/app_bar.dart';

class ProfileCompletionScreen extends StatefulWidget {
  @override
  _ProfileCompletionScreenState createState() =>
      _ProfileCompletionScreenState();
}

class _ProfileCompletionScreenState extends State<ProfileCompletionScreen> {
  int currentStep = 0;

  // Dummy data to represent user profile information
  String city = '';
  String licenseId = '';
  String cnic = '';
  String address = '';
  List<String> licenseImages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBar(context, 'Update Profile'),
      body: Stepper(
        currentStep: currentStep,
        onStepContinue: () {
          // Handle logic when the user clicks the continue button
          if (currentStep == 0) {
            // Validate and save level 1 data
            if (city.isNotEmpty &&
                licenseId.isNotEmpty &&
                cnic.isNotEmpty &&
                address.isNotEmpty) {
              // Save data and move to the next step
              currentStep += 1;
            } else {
              // Show an error message or prompt the user to fill in all details
            }
          } else if (currentStep == 1) {
            // Validate and save level 2 data (e.g., license images)
            if (licenseImages.isNotEmpty) {
              // Save data and move to the next step
              currentStep += 1;
            } else {
              // Show an error message or prompt the user to upload license images
            }
          } else if (currentStep == 2) {
            // Validate and save level 3 data (if needed)
            // Move to the next step or complete the process
            // You can add additional logic based on your requirements
          }

          setState(() {});
        },
        onStepCancel: () {
          // Handle logic when the user clicks the cancel button
          if (currentStep > 0) {
            currentStep -= 1;
            setState(() {});
          }
        },
        steps: [
          Step(
            title: Text('Level 1'),
            content: Column(
              children: [
                TextField(
                  onChanged: (value) {
                    city = value;
                  },
                  decoration: InputDecoration(labelText: 'City'),
                ),
                TextField(
                  onChanged: (value) {
                    licenseId = value;
                  },
                  decoration: InputDecoration(labelText: 'License ID'),
                ),
                TextField(
                  onChanged: (value) {
                    cnic = value;
                  },
                  decoration: InputDecoration(labelText: 'CNIC'),
                ),
                TextField(
                  onChanged: (value) {
                    address = value;
                  },
                  decoration: InputDecoration(labelText: 'Address'),
                ),
              ],
            ),
          ),
          Step(
            title: Text('Level 2'),
            content: Column(
              children: [
                // You can add UI elements for level 2 data collection here
                // For example, an image picker to upload license images
              ],
            ),
          ),
          const Step(
            title: Text('Level 3'),
            content: Column(
              children: [
                // You can add UI elements for level 3 data collection here
                // For example, additional information or documents
              ],
            ),
          ),
        ],
      ),
    );
  }
}
