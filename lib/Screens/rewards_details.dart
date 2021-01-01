import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RewardsDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rewards Details"),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("Reward").orderBy("RewardRequirement").snapshots(),
          builder: (context, snapshot) {
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
                                        Image.network(reward['RewardIcon']),
                                        Spacer(),
                                        Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                                              child: Center(child: Text(reward['RewardTitle'], style: TextStyle(fontSize: 25.0),)),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                                              child: Row(
                                                children: [
                                                  Icon(Icons.star_rate, color: Colors.yellow,),
                                                  Text(" x ${reward['RewardRequirement']}", style: TextStyle(fontSize: 23.0),),
                                                ],
                                              ),
                                            ),
                                          ],
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
          }),
    );
  }
}
