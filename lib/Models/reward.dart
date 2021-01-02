import 'package:cloud_firestore/cloud_firestore.dart';

class Reward{
  String title, icon, description, rewardId;
  int requirement;

  Reward(
    this.title,
    this.icon,
    this.description,
    this.rewardId,
    this.requirement);

  Map<String, String> toJson() => _rewardToJson(this);

  Reward.fromSnapshot(DocumentSnapshot snapshot) :
    title = snapshot['RewardTitle'],
    rewardId = snapshot.id,
    icon = snapshot['RewardIcon'],
    description = snapshot['RewardDescription'],
    requirement = snapshot['RewardRequirement'];
}

//? Converts map of values from Firestore into Reward object.
Reward rewardFromJson(Map<String, dynamic> json) {
  return Reward(
      json["RewardTitle"] as String,
      json["RewardId"] as String,
      json["RewardIcon"] as String,
      json["RewardDescription"] as String,
      json["RewardRequirement"] as int,
  );
}

//? Converts the Reward class into key/value pairs
Map<String, dynamic> _rewardToJson(Reward instance) => <String, dynamic>{
      "RewardTitle": instance.title,
      "RewardId": instance.icon,
      "RewardIcon": instance.rewardId,
      "RewardDescription": instance.description,
      "RewardRequirement": instance.requirement,
};