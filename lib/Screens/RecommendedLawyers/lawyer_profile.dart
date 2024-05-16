import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LawyerProfileScreen extends StatelessWidget {
  final String lawyerId;

  const LawyerProfileScreen({Key? key, required this.lawyerId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future:
          FirebaseFirestore.instance.collection('users').doc(lawyerId).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text('No data available'));
        }

        final profileData = snapshot.data!;
        final firstName = profileData['firstname'];
        final lastName = profileData['lastname'];
        final city = profileData['city'];
        final experience = profileData['experience'];
        final category = profileData['category'];
        final pictureUrl = profileData[
            'picture']; // Assuming the picture field stores the URL of the image

        return _buildBottomSheet(context, firstName, lastName, city, experience,
            category, pictureUrl);
      },
    );
  }

  Widget _buildBottomSheet(
      BuildContext context,
      String firstName,
      String lastName,
      String city,
      String experience,
      String category,
      String? pictureUrl) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (pictureUrl != null && pictureUrl.isNotEmpty)
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(pictureUrl),
              ),
            const SizedBox(height: 16),
            Text(
              'Name: $firstName $lastName',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('City: $city', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Experience: $experience',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Category: $category', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }
}
