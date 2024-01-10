import 'package:legalassistance/Packages/packages.dart';

class RecommendedLayerScreen extends StatefulWidget {
  const RecommendedLayerScreen({super.key});

  @override
  State<RecommendedLayerScreen> createState() => _RecommendedLayerScreenState();
}

class _RecommendedLayerScreenState extends State<RecommendedLayerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          showAppBar(context, LocalesData.recommendedLayers.getString(context)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            physics: const BouncingScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 0.8,
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10),
            itemCount: 10,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: textFieldColor,
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: scaffoldColor,
                        ),
                      ),
                      Flexible(
                        child: Text(
                          'Mr.Tabish Ameen khan',
                          style: lawyerNameStyle,
                        ),
                      ),
                      Text(
                        'Exp: 4 years',
                        style: lawyerExpStyle,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Center(
                          child: GestureDetector(
                            onTap: () {
                              screenFunction.nextScreen(
                                context,
                                const ChatScreen(),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Color(0xffCCCCCC),
                                  borderRadius: BorderRadius.circular(10)),
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
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
