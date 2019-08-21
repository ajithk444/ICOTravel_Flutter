import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fire_login/models/user.dart';
import 'package:flutter_fire_login/ui/liveMapScreen.dart';
import 'package:flutter_fire_login/ui/loginScreen.dart';
import 'package:flutter_fire_login/ui/mapScreen.dart';
import 'package:flutter_fire_login/ui/signup.dart';


class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.title}) : super(key: key);

  final String title;
  @override
  _HomeScreenState createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.group_add),
            onPressed: () => {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => SignUpPage()))
            },
          ),
          IconButton(
            icon: Icon(Icons.supervised_user_circle),
            onPressed: () => {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => LoginScreen()))
            },
          ),
          IconButton(
            icon: Icon(Icons.map),
            onPressed: () => {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => LiveMapScreen()))
            },
          )
        ],
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final record = User.fromSnapshot(data);
    return Padding(
      key: ValueKey(record.name),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Card(
          child: ListTile(
            leading: CircleAvatar(
              radius: 30.0,
              backgroundImage: NetworkImage(record.avatar),
              backgroundColor: Colors.transparent,
            ),

            // child: Image.network(record.avatar, fit: BoxFit.scaleDown)),
            //FlutterLogo(size: 56.0),
            title: Text(record.name),
            subtitle:
                Text(record.address), // + '\n' + record.mobile.toString()),
            trailing: Icon(Icons.more_vert),
             onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MapScreen(user: record),
              ),
            ),
          ),

          // ListTile(
          //   title: Text(record.name),
          //   trailing: Text(record.address.toString()),
          //   onTap: () => Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => MapScreen(),
          //     ),
          //   ),

          //print('$record.address')
          //record.reference.updateData({'votes': record.votes + 1}),

          // => Firestore.instance.runTransaction((transaction) async {
          //   final freshSnapshot = await transaction.get(record.reference);
          //   final fresh = Record.fromSnapshot(freshSnapshot);

          //   await transaction
          //       .update(record.reference, {'votes': fresh.votes + 1});
          // }),
        ),
      ),
    );
  }
}
