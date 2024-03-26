import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:legalassistance/Packages/packages.dart';

class ProfileCompletionScreen extends StatefulWidget {
  String userID;
  int userLevel;
  ProfileCompletionScreen(
      {super.key, required this.userID, required this.userLevel});
  @override
  _ProfileCompletionScreenState createState() =>
      _ProfileCompletionScreenState();
}

class _ProfileCompletionScreenState extends State<ProfileCompletionScreen> {
  TextEditingController cityController = TextEditingController();
  TextEditingController cnicNumberController = TextEditingController();
  TextEditingController lawyerIdController = TextEditingController();
  TextEditingController lawyerCategoryController = TextEditingController();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<String> licenseImages = [];

  // data required for lawyer + layman
  // step 1
  String city = '';
  String? profilePic;

  // step 2
  String cnicNumber = '';
  String? cnicPicture;
  // step 3
  String lawyerId = '';
  String? lawyerIdPicture;
  final ImagePicker picker = ImagePicker();
  bool uploading = false;

  String userRole = '';

  bool? profileCompleted;
  int level = 0;
  fetchUserData() async {
    var currentUser = FirebaseAuth.instance.currentUser!;
    var firestore = FirebaseFirestore.instance;
    DocumentSnapshot userSnapshot =
        await firestore.collection('users').doc(currentUser.uid).get();
    setState(() {
      userRole = userSnapshot['role'];

      profileCompleted = userSnapshot['profileCompleted'];
      level = userSnapshot['level'];
    });

    print(
        '${userSnapshot['firstname']},${userSnapshot['lastname']},${userSnapshot['role']},${userSnapshot['phoneNumber']},${userSnapshot['profileCompleted']},${userSnapshot['level']}');
  }

  @override
  void initState() {
    fetchUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBar(context, 'Update Profile'),
      body: userRole == 'lawyer' && level == 3 ||
              userRole == 'layman' && level == 1
          ? const Center(
              child: Text(' your profile is completed'),
            )
          : Stack(
              children: [
                Stepper(
                  currentStep: level,
                  onStepContinue: () {
                    // Handle logic when the user clicks the continue button
                    if (level == 0) {
                      // Validate and save level 1 data
                      if (cityController.text.isNotEmpty &&
                          profilePic!.isNotEmpty) {
                        // Save data and move to the next step
                        uploadStep1();
                      } else {
                        message(context,
                            'Please provide city name and picture to continue');
                      }
                    } else if (level == 1) {
                      if (cnicNumberController.text.isNotEmpty &&
                          cnicPicture != null) {
                        uploadStep2();
                      } else if (cnicNumberController.text.length > 13) {
                        message(context,
                            'Dont use dashes / provide valid cnic number');
                      } else {
                        message(context,
                            'Please provide Cnic Number and Cnic Picture to continue');
                      }
                    } else if (level == 2) {
                      if (lawyerIdController.text.isNotEmpty &&
                          lawyerCategoryController.text.isNotEmpty &&
                          lawyerIdPicture != null) {
                        uploadStep3();
                      } else {
                        message(context,
                            'Please provide Id number , id picture and category to continue');
                      }
                    }

                    setState(() {});
                  },
                  steps: [
                    Step(
                      title: Text('Level 1'),
                      content: Column(
                        children: [
                          textField(cityController, TextInputType.emailAddress,
                              'City'),
                          profilePic != null
                              ? Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: appBarColor!)),
                                  height: 200,
                                  width: double.infinity,
                                  child: Stack(
                                    alignment: Alignment.topLeft,
                                    children: [
                                      Image.file(
                                        File(profilePic!),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            profilePic = null;
                                          });
                                        },
                                        child: Container(
                                          height: 40,
                                          width: 60,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.black,
                                          ),
                                          child: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              : picturePicker('Profile Picture', 'profilePic')
                        ],
                      ),
                    ),
                    Step(
                      title: Text('Level 2'),
                      content: Column(
                        children: [
                          textField(cnicNumberController, TextInputType.number,
                              'Cnic Number'),
                          cnicPicture != null
                              ? Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: appBarColor!)),
                                  height: 200,
                                  width: double.infinity,
                                  child: Stack(
                                    alignment: Alignment.topLeft,
                                    children: [
                                      Image.file(
                                        File(cnicPicture!),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            cnicPicture = null;
                                          });
                                        },
                                        child: Container(
                                          height: 40,
                                          width: 60,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.black,
                                          ),
                                          child: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              : picturePicker('Cnic Picture', 'cnicPicture')
                        ],
                      ),
                    ),
                    Step(
                      title: const Text('Level 3'),
                      content: Column(
                        children: [
                          textField(lawyerIdController,
                              TextInputType.emailAddress, 'Lawyer Id Number'),
                          textField(lawyerCategoryController,
                              TextInputType.emailAddress, 'Lawyer Category'),
                          lawyerIdPicture != null
                              ? Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: appBarColor!)),
                                  height: 200,
                                  width: double.infinity,
                                  child: Stack(
                                    alignment: Alignment.topLeft,
                                    children: [
                                      Image.file(
                                        File(lawyerIdPicture!),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            lawyerIdPicture = null;
                                          });
                                        },
                                        child: Container(
                                          height: 40,
                                          width: 60,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.black,
                                          ),
                                          child: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              : picturePicker(
                                  'Lawyer Id Picture', 'lawyerIdPicture')
                        ],
                      ),
                    ),
                  ],
                ),
                if (uploading)
                  Center(
                    child: CircularProgressIndicator(
                      color: appBarColor,
                    ),
                  )
                else
                  const SizedBox()
              ],
            ),
    );
  }

  textField(TextEditingController controller, TextInputType? keyboardType,
      String? hintText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Color(0xFF64379F)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Color(0xFF27104E),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Color(0xFF27104E),
            ),
          ),
        ),
      ),
    );
  }

  picturePicker(String title, String? variable) {
    return GestureDetector(
      onTap: () async {
        print(variable);
        variable == 'cnicPicture'
            ? _pickCnicImage(ImageSource.gallery)
            : variable == 'profilePic'
                ? _pickProfileImage(ImageSource.gallery)
                : _pickLawyerIdImage(ImageSource.gallery);
      },
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: appBarColor!)),
        height: 60,
        width: double.infinity,
        child: Text(
          title,
          style: textFieldStyle,
        ),
      ),
    );
  }

  Future<void> _pickProfileImage(ImageSource source) async {
    final XFile? image = await picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        profilePic = image.path;
      });
      print(profilePic);
    }
  }

  Future<void> _pickLawyerIdImage(ImageSource source) async {
    final XFile? image = await picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        lawyerIdPicture = image.path;
      });
      print(lawyerIdPicture);
    }
  }

  Future<void> _pickCnicImage(ImageSource source) async {
    final XFile? image = await picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        cnicPicture = image.path;
      });
      print(cnicPicture);
    }
  }

  uploadStep1() async {
    setState(() {
      uploading = true;
    });
    try {
      String imagePath =
          'profile_images/${widget.userID}/${DateTime.now().millisecondsSinceEpoch}.png';
      Reference storageReference = _storage.ref().child(imagePath);
      await storageReference.putFile(File(profilePic!));
      String downloadURL = await storageReference.getDownloadURL();
      userRole == 'layman'
          ? await _firestore.collection('users').doc(widget.userID).update({
              'city': cityController.text,
              'picture': downloadURL,
              'level': 1,
              'profileCompleted': true,
            })
          : await _firestore.collection('users').doc(widget.userID).update({
              'city': cityController.text,
              'picture': downloadURL,
              'level': 1
            });
      setState(() {
        uploading = false;
      });
      userRole == 'layman'
          ? message(
              context, 'your profile is completed you can exit this screen now')
          : message(context, 'Details successfully uploaded');
      userRole == 'lawyer' ? widget.userLevel += 1 : null;
    } catch (e) {
      debugPrint(e.toString());
      setState(() {
        uploading = false;
      });
    }
  }

  uploadStep2() async {
    setState(() {
      uploading = true;
    });
    try {
      String imagePath =
          'cnicPictures/${widget.userID}/${DateTime.now().millisecondsSinceEpoch}.png';
      Reference storageReference = _storage.ref().child(imagePath);
      await storageReference.putFile(File(cnicPicture!));
      String downloadURL = await storageReference.getDownloadURL();
      await _firestore.collection('users').doc(widget.userID).update({
        'cnicNumber': cnicNumberController.text,
        'cnicPicture': downloadURL,
        'level': 2
      });
      setState(() {
        uploading = false;
      });
      message(context, 'Details successfully uploaded');
      widget.userLevel += 1;
      Navigator.pop(context);
    } catch (e) {
      debugPrint(e.toString());
      setState(() {
        uploading = false;
      });
    }
  }

  uploadStep3() async {
    setState(() {
      uploading = true;
    });
    try {
      String imagePath =
          'lawyerIdPictures/${widget.userID}/${DateTime.now().millisecondsSinceEpoch}.png';
      Reference storageReference = _storage.ref().child(imagePath);
      await storageReference.putFile(File(lawyerIdPicture!));
      String downloadURL = await storageReference.getDownloadURL();
      await _firestore.collection('users').doc(widget.userID).update({
        'category': lawyerCategoryController.text,
        'lawyerId': lawyerIdController.text,
        'lawyerIdPicture': downloadURL,
        'level': 3,
        'profileCompleted': true,
      });
      setState(() {
        uploading = false;
      });
      message(context,
          'You can leave this screen you profile is under approval by admin');
    } catch (e) {
      debugPrint(e.toString());
      setState(() {
        uploading = false;
      });
    }
  }
}
