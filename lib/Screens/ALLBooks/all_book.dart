import 'package:flutter/material.dart';
import 'package:legalassistance/Packages/packages.dart';

class AllBooks extends StatefulWidget {
  AllBooks({Key? key, required this.guestEntry});
  bool guestEntry;

  @override
  State<AllBooks> createState() => _AllBooksState();
}

class _AllBooksState extends State<AllBooks> {
  List<String> bookPaths = [
    'assets/books/admlaw.pdf',
    'assets/books/bermanlaw.pdf',
    'assets/books/blackletter.pdf',
    'assets/books/generallaw.pdf',
    'assets/books/law.pdf',
    'assets/books/ssrn.pdf'
  ];

  List<String> coverImages = [
    'assets/coverpages/admlaw.png',
    'assets/coverpages/blackletter.png',
    'assets/coverpages/genlaw.png',
    'assets/coverpages/law243.png',
    'assets/coverpages/lawandreligion.png',
    'assets/coverpages/ssrn.png'
  ];

  Stream<DocumentSnapshot> getUserDataStream() async* {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final userDoc =
          FirebaseFirestore.instance.collection('users').doc(currentUser.uid);
      yield* userDoc.snapshots();
    }
  }

  late TextEditingController _searchController;
  late Stream<QuerySnapshot> _booksStream;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _booksStream = FirebaseFirestore.instance.collection('books').snapshots();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.guestEntry ? guestEntryTrue() : guestEntryFalse();
  }

  Widget guestEntryTrue() {
    return Scaffold(
      appBar: showAppBar(
        context,
        LocalesData.books.getString(context),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _booksStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final books = snapshot.data!.docs;

                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                  ),
                  itemCount: books.length,
                  itemBuilder: (BuildContext context, int index) {
                    final book = books[index].data() as Map<String, dynamic>;
                    final coverPage = book['coverpage'];
                    final pdfLink = book['link'];
                    final bookName = book['name'];

                    return GestureDetector(
                      onTap: () {
                        screenFunction.nextScreen(
                          context,
                          PdfReadScreen(pdfPath: pdfLink),
                        );
                      },
                      child: Column(
                        children: [
                          Expanded(
                            child: Image.network(
                              coverPage,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            bookName,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget guestEntryFalse() {
    return StreamBuilder<DocumentSnapshot>(
      stream: getUserDataStream(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: showAppBar(
              context,
              LocalesData.books.getString(context),
            ),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          final userData = snapshot.data;
          if (userData!['block']) {
            return Scaffold(
              appBar: showAppBar(
                context,
                LocalesData.books.getString(context),
              ),
              body: const Center(
                child: Text(
                  'Your account has been blocked. Please contact admin for further details.',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          } else {
            return Scaffold(
              appBar: showAppBar(
                context,
                LocalesData.books.getString(context),
              ),
              body: Column(
                children: [
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: _booksStream,
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        }

                        final books = snapshot.data!.docs;

                        return GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10.0,
                            mainAxisSpacing: 10.0,
                          ),
                          itemCount: books.length,
                          itemBuilder: (BuildContext context, int index) {
                            final book =
                                books[index].data() as Map<String, dynamic>;
                            final coverPage = book['coverpage'];
                            final pdfLink = book['link'];
                            final bookName = book['name'];

                            return GestureDetector(
                              onTap: () {
                                screenFunction.nextScreen(
                                  context,
                                  PdfReadScreen(pdfPath: pdfLink),
                                );
                              },
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Image.network(
                                      coverPage,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    bookName,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }
        }
      },
    );
  }
}
