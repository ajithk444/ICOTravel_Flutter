import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class User {
  final int id;
  final String name;
  final int votes;
  final String address;
  final String email;
  final int routeId;
  final bool isActive;
  final int mobile;
  final GeoFirePoint location;

  final DocumentReference reference;

  User.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['id'] != null),
        assert(map['name'] != null),
        assert(map['votes'] != null),
        assert(map['address'] != null),
        assert(map['email'] != null),
        assert(map['routeId'] != null),
        assert(map['isActive'] != null),
        assert(map['mobile'] != null),
        assert(map['location'] != null),
        id = map['id'],
        name = map['name'],
        votes = map['votes'],
        address = map['address'],
        email = map['email'],
        isActive = map['isActive'],
        mobile = map['mobile'],
        routeId = map['routeId'],
        location = map['location'];

  User.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "User<$name:$votes>";
}
