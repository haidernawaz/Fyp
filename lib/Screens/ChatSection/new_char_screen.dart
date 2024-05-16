import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:intl/intl.dart';
import 'package:legalassistance/Packages/packages.dart';

class NewChatScreen extends StatefulWidget {
  NewChatScreen(
      {super.key,
      required this.lawyerName,
      required this.lawyerId,
      required this.lawyerPicture,
      required this.laymanId,
      required this.lawyerEntry,
      required this.laymanName,
      required this.laymanPicture});
  String lawyerName;
  String lawyerId;
  String lawyerPicture;
  String laymanId;
  bool lawyerEntry;
  String laymanName;
  String laymanPicture;

  @override
  State<NewChatScreen> createState() => _NewChatScreenState();
}

class _NewChatScreenState extends State<NewChatScreen> {
  // define two user
  ChatUser layman = ChatUser(id: '1', firstName: '');
  ChatUser lawyer = ChatUser(id: '2', firstName: '');
  // current user
  // user you are chatting with
  // list of chat messages
  List<ChatMessage> chatMessages = <ChatMessage>[];

  @override
  void initState() {
    super.initState();
    // Fetch initial chat messages
    //fetchChatMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBar(
        context,
        widget.lawyerEntry ? widget.laymanName : widget.lawyerName,
      ),
      body: StreamBuilder<DocumentSnapshot>(
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
                  child: Text(LocalesData.blockStatement.getString(context)),
                ),
              );
            } else {
              return StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('chat')
                    .doc('${widget.lawyerId}_${widget.laymanId}')
                    .collection('messages')
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    // Convert each message document to ChatMessage object and add to chatMessages list
                    chatMessages = snapshot.data!.docs.map((doc) {
                      Map<String, dynamic> data =
                          doc.data() as Map<String, dynamic>;
                      return ChatMessage(
                        text: data['message'],
                        user: data['senderid'] == widget.lawyerId
                            ? lawyer
                            : layman,
                        createdAt: DateTime.parse(data['createdAt']),
                      );
                    }).toList();
                    return DashChat(
                      currentUser: widget.lawyerEntry ? lawyer : layman,
                      onSend: sendMessage,
                      messages: chatMessages,
                      inputOptions: InputOptions(
                        alwaysShowSend: false,
                        cursorStyle: CursorStyle(color: appBarColor!),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              );
            }
          }
        }),
      ),
    );
  }

  // Function to send the message
  sendMessage(ChatMessage message) async {
    // Send message to Firestore
    await addChatData(
      widget.lawyerId,
      widget.laymanId,
      widget.lawyerPicture,
      widget.laymanPicture,
      widget.lawyerName,
      widget.laymanName,
      message.text,
    );
  }

  // Function to add data to the 'chat' collection
  Future<void> addChatData(
    String lawyerId,
    String laymanId,
    String lawyerPicture,
    String laymanPicture,
    String lawyerName,
    String laymanName,
    String message,
  ) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Create a document reference for the chat
      DocumentReference chatDocRef =
          firestore.collection('chat').doc('${lawyerId}_$laymanId');

      // Set the data for the chat document
      await chatDocRef.set({
        'lawyerid': lawyerId,
        'laymanid': laymanId,
        'lawyerpicture': lawyerPicture,
        'laymanpicture': laymanPicture,
        'lawyername': lawyerName,
        'laymanname': laymanName,
        'recentmessage': message
      });

      // Create a sub collection reference for messages inside the chat document
      DocumentReference messagesCollectionRef =
          chatDocRef.collection('messages').doc(getCurrentDateTime());

      // Add a sample message to the messages sub collection
      await messagesCollectionRef.set({
        'senderid': FirebaseAuth.instance.currentUser!.uid,
        'message': message,
        'createdAt': getCurrentDateTime()
        // Example picture URL
      });

      print(
          'Data added to the chat collection and messages sub collection successfully.');
    } catch (error) {
      print('Error adding data to chat collection: $error');
    }
  }

  String getCurrentDateTime() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    return formattedDate;
  }

  // void fetchChatMessages() async {
  //   debugPrint('getting old chats');
  //   try {
  //     FirebaseFirestore firestore = FirebaseFirestore.instance;
  //     String chatId = '${widget.lawyerId}_${widget.laymanId}';
  //     // Query messages sub collection
  //     QuerySnapshot messagesSnapshot = await firestore
  //         .collection('chat')
  //         .doc(chatId)
  //         .collection('messages')
  //         .orderBy('createdAt', descending: true)
  //         .get();

  //     // Convert each message document to ChatMessage object and add to chatMessages list
  //     chatMessages = messagesSnapshot.docs.map((doc) {
  //       Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
  //       return ChatMessage(
  //         text: data['message'],
  //         user: data['senderid'] == widget.lawyerId ? lawyer : layman,
  //         createdAt: DateTime.parse(data['createdAt']),
  //       );
  //     }).toList();

  //     setState(() {});
  //   } catch (error) {
  //     print('Error fetching chat messages: $error');
  //   }
  // }
}
