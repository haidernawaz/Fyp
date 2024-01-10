import 'package:legalassistance/Packages/packages.dart';

class AllChatScreen extends StatefulWidget {
  const AllChatScreen({super.key});

  @override
  State<AllChatScreen> createState() => _AllChatScreenState();
}

class _AllChatScreenState extends State<AllChatScreen> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.sizeOf(context).height;
    var width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: showAppBar(context, 'ALL CHATS'),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
        child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: 20,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: GestureDetector(
                  onTap: () {
                    screenFunction.nextScreen(context, const ChatScreen());
                  },
                  child: Container(
                    height: height * 0.09,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xffD9D9D9)),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Mr.Tabish Amin'),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('recent message.....'),
                              Container(
                                height: 10,
                                width: 10,
                                decoration: BoxDecoration(
                                    color: appBarColor,
                                    borderRadius: BorderRadius.circular(50)),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }
}
