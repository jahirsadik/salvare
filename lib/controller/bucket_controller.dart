import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:salvare/database/database_paths.dart';
import 'package:salvare/database/firestore_db.dart';
import 'package:salvare/model/bucket.dart';
import 'package:flutter/foundation.dart';
import 'package:crypto/crypto.dart';

class BucketController {
  int totalBuckets = 0;
  void addBucket(Bucket bucket) {}

  void addBucketDummy() async {
    try {
      // fetch total number of buckets and update totalBuckets
      List<Bucket>? userBucketList = await FireStoreDB().fetchUserBucketList();
      totalBuckets = userBucketList == null ? 0 : userBucketList.length;
      debugPrint(
          "${FirebaseAuth.instance.currentUser!.email} has total $totalBuckets buckets");
      if (totalBuckets < DatabasePaths.userMaxBucket) {
        Bucket _bucket = Bucket.unlaunched(
            md5
                .convert(utf8.encode(
                    FirebaseAuth.instance.currentUser!.uid.toString() +
                        DateTime.now().toString()))
                .toString(),
            'bucket1',
            FirebaseAuth.instance.currentUser!.uid);
        FireStoreDB().addBucketDB(
            _bucket, FirebaseAuth.instance.currentUser!.uid.toString());
        totalBuckets++;
      } else {
        debugPrint("Max number of buckets exceeded");
        // TODO show toast
      }
    } catch (err) {
      debugPrint("error in add bucket dummy {$err}");
    }
  }

  void addUserToBucketDummy() async {
    try {
      Timer(Duration(seconds: 5), () async {
        print("Yeah, this line is printed after 3 seconds");
        List<Bucket>? userBucketList =
            await FireStoreDB().fetchUserBucketList();
        totalBuckets = userBucketList == null ? 0 : userBucketList.length;

        debugPrint(
            "${FirebaseAuth.instance.currentUser!.email} has total $totalBuckets buckets");
        if (totalBuckets == 0) {
          debugPrint("can't add bucket as no bucket exists");
        } else {
          FireStoreDB().addUserToBucketDB(
              userBucketList!.first, "68oiCcs9aDQOaZvd6mtHResXBfj2");
          // also add bucket for added user
          debugPrint(
              "Adding uid: 68oiCcs9aDQOaZvd6mtHResXBfj2 to bucket with id: ${userBucketList.first.id}");
          List<Bucket>? ust = await FireStoreDB().fetchUserBucketList();
          FireStoreDB().addBucketDB(ust!.first, "68oiCcs9aDQOaZvd6mtHResXBfj2");
        }
      });
    } catch (err) {
      debugPrint("error in add user to bucket dummy {$err}");
    }
  }
}