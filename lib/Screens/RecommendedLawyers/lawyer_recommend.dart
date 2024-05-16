import 'package:legalassistance/Packages/packages.dart';
import 'package:legalassistance/Screens/ChatSection/new_chat_screen.dart';
// Import Firestore package

class LawyerRecommend extends StatefulWidget {
  final String? category;

  const LawyerRecommend({Key? key, this.category}) : super(key: key);

  @override
  State<LawyerRecommend> createState() => _LawyerRecommendState();
}

class _LawyerRecommendState extends State<LawyerRecommend> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Recommended Lawyers'),
        ),
        body: StreamBuilder(
            stream: streamFunction.getUserDataStream(),
            builder: ((context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                final userData = snapshot.data;
                if (userData!['block']) {
                  return Scaffold(
                    body: Center(
                      child:
                          Text(LocalesData.blockStatement.getString(context)),
                    ),
                  );
                } else {
                  return SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .where('role', isEqualTo: 'lawyer')
                            .where('approved', isEqualTo: true)
                            .where('category',
                                isEqualTo:
                                    widget.category) // Apply category filter
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (snapshot.data!.docs.isEmpty) {
                            return Center(
                              child: Text(
                                  'No matching lawyers found for the category: ${widget.category}'),
                            );
                          }
                          if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          }
                          final users = snapshot.data?.docs ?? [];
                          return GridView.builder(
                            physics: const BouncingScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              childAspectRatio: 0.8,
                              crossAxisCount: 2,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                            ),
                            itemCount: users.length,
                            itemBuilder: (context, index) {
                              final user = users[index];
                              return buildLawyerCard(user);
                            },
                          );
                        },
                      ),
                    ),
                  );
                }
              }
            })));
  }

  Widget buildLawyerCard(DocumentSnapshot user) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[200],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[300],
                backgroundImage: NetworkImage(user['picture']),
              ),
            ),
            Flexible(
              child: Center(
                child: Text(
                  '${user['firstname']} ${user['lastname']}',
                  // Your text style
                ),
              ),
            ),
            Center(
              child: Text(
                'City:${user['city']}',
                // Your text style
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      backgroundColor: Colors.white,
                      context: context,
                      builder: (context) {
                        debugPrint(user.id);
                        return lawyerProfile(
                          user['picture'],
                          user['firstname'],
                          user['lastname'],
                          user['category'],
                          user['experience'],
                          user['bio'],
                          user.id,
                        );
                      },
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Contact Lawyer',
                        // Your text style
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  lawyerProfile(String picture, String firstName, String lastName,
      String category, String experience, String bio, String lawyerId) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                        radius: 50,
                        backgroundColor: scaffoldColor,
                        backgroundImage: NetworkImage(picture)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Name : $firstName $lastName',
                          style: lawyerNameStyle,
                        ),
                        Text('Category: $category', style: lawyerNameStyle),
                        Text('Experience: $experience', style: lawyerNameStyle),
                      ],
                    )
                  ],
                ),
              ),
              Text('Bio: $bio', style: lawyerNameStyle),
              GestureDetector(
                onTap: () async {
                  screenFunction.popScreen(context);
                  screenFunction.nextScreen(
                      context,
                      NewChatScreen(
                        lawyerName: '$firstName $lastName',
                        lawyerId: lawyerId,
                        lawyerPicture: picture,
                        laymanId: FirebaseAuth.instance.currentUser!.uid,
                        lawyerEntry: false,
                        laymanName: '$userFirstName $userLastName',
                        laymanPicture: userProfilePic,
                      ));
                },
                child: Center(
                  child: Container(
                    alignment: Alignment.center,
                    width: 150,
                    decoration: BoxDecoration(
                      color: const Color(0xffCCCCCC),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Contact Lawyer',
                        style: lawyerNameStyle,
                      ),
                    ),
                  ),
                ),
              ),
            ]),
      ),
    );
  }
}
