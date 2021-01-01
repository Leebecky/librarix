import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:librarix/Custom_Widget/buttons.dart';
import 'package:librarix/Custom_Widget/custom_alert_dialog.dart';
import 'package:librarix/Models/borrow.dart';
import 'package:librarix/Models/reward.dart';
import 'package:librarix/Models/user.dart';
import 'package:librarix/Screens/rewards_details.dart';

class Rewards extends StatefulWidget {
  final Reward reward;
  const Rewards({Key key, this.reward}) : super(key: key);

  @override
  _RewardsState createState() => _RewardsState();
}

class _RewardsState extends State<Rewards> {
  //List<Borrow> snapshot;
  List<Borrow> records = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rewards"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 150.0),
        child: Container(
          child: Column(
            children: [
              GestureDetector(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Image.network(
                            "https://webstockreview.net/images/clipart-present-transparent-background-6.png",
                            width: 170,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 30.0, bottom: 30.0),
                            child: Row(
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.08,
                                ),
                                AutoSizeText(
                                    "Click me to know your reading level!",
                                    maxLines: 5,
                                    style: TextStyle(fontSize: 20.0)),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  onTap: () async => {
                        records = await borrowedRecords(),
                        if (records.length > 40)
                          {
                            generalAlertDialog(context,
                                title: "Bibliophile",
                                imageContent: Image(
                                    image: AssetImage(
                                        'assets/Rewards/bibliophile.png')))
                          }
                        else if (records.length > 30 && records.length <= 40)
                          {
                            generalAlertDialog(context,
                                title: "Scholar",
                                imageContent: Image(
                                    image: AssetImage(
                                        'assets/Rewards/scholar.png')))
                          }
                        else if (records.length > 20 && records.length <= 30)
                          {
                            generalAlertDialog(context,
                                title: "Bookworm",
                                imageContent: Image(
                                    image: AssetImage(
                                        'assets/Rewards/bookworm.png')))
                          }
                        else if (records.length > 10 && records.length <= 20)
                          {
                            generalAlertDialog(context,
                                title: "Book Lover",
                                imageContent: Image(
                                    image: AssetImage(
                                        'assets/Rewards/book_lover.png')))
                          }
                        else if (records.length > 3 && records.length <= 10)
                          {
                            generalAlertDialog(context,
                                title: "Avid Reader",
                                imageContent: Image(
                                    image: AssetImage(
                                        'assets/Rewards/avid_reader.png')))
                          }
                        else if (records.length == 3)
                          {
                            generalAlertDialog(context,
                                title: "Just Starting Out",
                                imageContent: Image(
                                    image: AssetImage(
                                        'assets/Rewards/just_starting_out.png')))
                          }
                        else if (records.length < 3)
                          {
                            generalAlertDialog(context,
                                title:
                                    "You don't have any achievements yet. Try your best to unlock it!",
                                imageContent: Image.network(
                                  "https://assets.stickpng.com/images/580b57fcd9996e24bc43c4b9.png",
                                  width: 170,
                                ))
                          }
                      }),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 100),
                  child: CustomOutlineButton(
                    buttonText: "Rewards Details",
                    onClick: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return RewardsDetails();
                    })),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //? Checks how many books have been borrowed by the users
  Future<List<Borrow>> borrowedRecords() async {
    ActiveUser user =
        await myActiveUser(docId: FirebaseAuth.instance.currentUser.uid);
    List<Borrow> allBorrows = await getUserBorrowRecords(user.userId);
    if (allBorrows.isNotEmpty) {
      return allBorrows
          .where((record) =>
              record.status == "Borrowed" || record.status == "Returned")
          .toList();
    }
    return allBorrows;
  }
}
