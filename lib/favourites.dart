import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class Favourites extends StatefulWidget {
  @override
  _FavouritesState createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {

  List favouriteData = [];

  getFirestoreData() async{
    await Firestore.instance.collection('favourites').document('favouriteData').get().then((data){
      if(data.exists){
        favouriteData = data.data['favouriteData'];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favourites'),
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: FutureBuilder(
          future: getFirestoreData(),
          builder: (context, snap){
            if(snap.connectionState == ConnectionState.active){
              return Center(child: CupertinoActivityIndicator(),);
            }
            if(snap.connectionState == ConnectionState.done){
              return ListView.builder(
                itemCount: favouriteData.length,
                itemBuilder: (context, i){
                  return Column(
                    children: <Widget>[
                      ListTile(
                        leading: Image.network(favouriteData[i]['image']),
                        title: Text(favouriteData[i]['name']),
                      ),
                      Divider(),
                    ],
                  );
                },
              );
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
