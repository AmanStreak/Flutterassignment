import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterbeer/favourites.dart';
import 'package:http/http.dart' as http;
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String url = 'https://api.punkapi.com/v2/beers/';

  bool isLoading = false;

  List<Color> favouriteColors = [];

  List getColor = [];

  List favouriteData = [];

  List favouriteId = [];

  int removeId;

  Future changeFavouriteColor() async{
    print(favouriteColors);
    print(getColor);
    for(int xyz = 0; xyz < getColor.length; xyz++){
      print(getColor[xyz]);
      setState(() {
        favouriteColors[getColor[xyz] - 1] = Colors.pink;
      });
    }
  }


  @override
  void initState(){
    super.initState();
    getData();
//    getFirestoreData();
  }

  var data;

  getData() async{
    var response = await http.get(Uri.encodeFull(url));
    data = jsonDecode(response.body);
    favouriteColors = List.generate(data.length, ((int index){
      return Colors.black54;
    }));
    setState((){
      isLoading = true;
    });
    getFirestoreData();
  }

  sendDataToFirestore() async{
    await Firestore.instance.collection('favourites').document('favouriteData').setData({'favouriteIdList': favouriteId, 'favouriteData': favouriteData}).then((data){
      print('Task Completed');
    });
  }

  updateFireStoreData() async{
    await Firestore.instance.collection('favourites').document('favouriteData').updateData({'favouriteIdList': favouriteId, 'favouriteData': favouriteData}).then((data){
      print('Data Updated');
    });
  }

  getFirestoreData() async{
    await Firestore.instance.collection('favourites').document('favouriteData').get().then((data){
      if(data.exists){
        print('DATA exists');
        print(data.data['favouriteIdList']);
        getColor = data.data['favouriteIdList'];

        if(getColor.length != 0){
          favouriteData = data.data['favouriteData'];
          favouriteId = getColor;
          print('Fav $favouriteId');

          changeFavouriteColor();
        }
//      print(getColor);

//      print(favouriteColors.length);

        print('XMen');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('BeerApp')),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 18.0),
            child: GestureDetector(
                child: Icon(Icons.favorite),
            onTap: (){
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => Favourites(),

                    ),
                  );
            }),
          )
        ],
      ),
      body: isLoading? Container(

        child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, i){
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListBody(

                      children: <Widget>[
                        ListTile(

                          leading: Image.network(data[i]['image_url'], fit: BoxFit.cover,),
                          title: Text('${data[i]['name']}'),
                          trailing: GestureDetector(
                            child: Icon(Icons.favorite, color: favouriteColors[i],),
                            onTap: (){
                              setState((){
                                favouriteColors[i] = Colors.pink;
                              });
                              if(!favouriteId.contains(data[i]['id'])){
                                favouriteId.add(data[i]['id']);
                                favouriteData.add(
                                    {
                                      'name' : data[i]['name'],
                                      'image' : data[i]['image_url'],
                                      'id' : data[i]['id']
                                    }
                                );
                              }
                              sendDataToFirestore();



                            },
                            onDoubleTap: (){
                              setState((){
                                favouriteColors[i] = Colors.black54;
                              });
                              debugPrint('Hey $favouriteId');
                              print(data[i]['id']);
                              print(favouriteId[0]);
                              for(int z = 0; z< favouriteId.length; z++){
                                if(favouriteId[z] == data[i]['id']){
                                  removeId = z;
                                  print(removeId);
                                  break;
                                }
                              }
                              print(removeId);
                              print(removeId.runtimeType);
                              favouriteId.removeAt(removeId);
                              favouriteData.removeAt(removeId);
                              updateFireStoreData();
                              print(favouriteData);
                            },
                          ),
                        ),
                        Divider(),
                      ],
                    ),
                  );
                },
              ),
      ) : Center(child: CupertinoActivityIndicator()),
    );
  }
}
