import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class RewardsDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rewards Details"),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("Reward")
              .orderBy("RewardRequirement")
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot reward = snapshot.data.documents[index];
                    return Container(
                      child: Column(
                        children: [
                          Container(
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Image.network(
                                            reward['RewardIcon'],
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.27,
                                          ),
                                          Spacer(),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1.9,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  reward['RewardTitle'],
                                                  style:
                                                      TextStyle(fontSize: 25.0),
                                                  textAlign: TextAlign.center,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.star_rate,
                                                      color: Colors.yellow,
                                                    ),
                                                    Text(
                                                      " x ${reward['RewardRequirement']}",
                                                      style: TextStyle(
                                                          fontSize: 23.0),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  });
            }
            return SpinKitWave(
              color: Theme.of(context).accentColor,
            );
          }),
    );
  }
}
