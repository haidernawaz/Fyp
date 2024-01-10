import 'package:legalassistance/Packages/packages.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.sizeOf(context).height;
    var width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: showAppBar(context, 'Lawyer Name'),
      backgroundColor: scaffoldColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20.0, left: 10, right: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Align(
                      alignment: FractionalOffset.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Container(
                          width: width * 0.6,
                          height: height * 0.06,
                          decoration: BoxDecoration(
                            color: appBarColor!.withOpacity(0.3),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: FractionalOffset.topRight,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 5.0),
                        child: Container(
                          width: width * 0.6,
                          height: height * 0.06,
                          decoration: BoxDecoration(
                            color: appBarColor!.withOpacity(0.3),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
              SizedBox(
                height: height * 0.07,
                child: TextField(
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.send,
                        color: Colors.black,
                      ),
                    ),
                    hintText: LocalesData.askQuery.getString(context),
                    hintStyle: textFieldStyle,
                    filled: true,
                    fillColor: textFieldColor,
                    enabledBorder:
                        const OutlineInputBorder(borderSide: BorderSide.none),
                    disabledBorder:
                        const OutlineInputBorder(borderSide: BorderSide.none),
                    focusedBorder:
                        const OutlineInputBorder(borderSide: BorderSide.none),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
