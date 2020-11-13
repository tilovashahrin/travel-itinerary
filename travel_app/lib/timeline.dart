import 'package:flutter/material.dart';
import 'like_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//tilova
class timeline_dataSource{
  static List<User> generateUsers(){
    return[
      User(
          avatar: CircleAvatar(
            backgroundColor: Colors.cyan[100],
            child: Text('CRR'),
          ),
          longName: 'Costa Rica Resort',
          shortName: '@CResort'
      ), //User
      User(
        avatar: CircleAvatar(
          backgroundColor: Colors.cyan[100],
          child: Text('PG'),
        ),
        longName: 'Paris Tour Guide',
        shortName: '@Official_ParisTourist',
      ),
    ];
  }
  static List<Tweet> generatePosts(){
    List<User> users = generateUsers();
    return[
      Tweet(
        image: Image.asset('images/Costa-Rica.jpg', width: 300.0),
        author: users[0],
        publishedDate: DateTime.now(),
        description: 'Set on a hill overlooking the beaches along the Gulf of Papagayo and Culebra Bay, this luxury resort is 35 km from Daniel Oduber Quirós International Airport.',
        numLikes: 10,
        numViews: 25,
      ),
      Tweet(
        image: Image.asset('images/paris.jpg', width: 300.0),
        author: users[1],
        publishedDate: DateTime.now(),
        description: 'France''s capital, is a major European city and a global center for art, fashion, gastronomy and culture. Its 19th-century cityscape is crisscrossed by wide boulevards and the River Seine. Beyond such landmarks as the Eiffel Tower and the 12th-century, Gothic Notre-Dame cathedral.',
        numLikes: 1100,
        numViews: 89,
      ),
    ];
  }
}

class User{
  CircleAvatar avatar;
  String longName;
  String shortName;

  User({this.avatar, this.longName, this.shortName});
}

class Tweet{
  User author;
  DateTime publishedDate;
  //String timeString;
  String description;
  int numViews;
  int numLikes;
  Image image;

  Tweet({this.author, this.publishedDate, this.description, this.numViews, this.numLikes, this.image});
}

class TweetWidget extends StatefulWidget{
  TweetWidget({Key, key, this.tweet}) : super(key: key);

  final Tweet tweet;

  @override
  _TweetWidgetState createState() => _TweetWidgetState(tweet: this.tweet);
}

class _TweetWidgetState extends State<TweetWidget>{
  Tweet tweet;
  String _selectedType = 'All';

  _TweetWidgetState({this.tweet});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5.0),
            child: tweet.author.avatar,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildAuthorRow(tweet),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                width: 320.0,
                child: Text(tweet.description, overflow: TextOverflow.ellipsis, maxLines: 8),
              ),
              Container(
                //image
                padding: EdgeInsets.all(10.0),
                child: tweet.image,
              ),
              _buildEngagementRow(tweet),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAuthorRow(Tweet tweet){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //author row
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            tweet.author.longName,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(tweet.author.shortName),
        ),
        // Container(
        //   padding: EdgeInsets.symmetric(horizontal: 10.0),
        //   child: Text(tweet.timeString),
        // ),
        Icon(Icons.expand_more, color: Colors.grey.shade500),
      ],
    );
  }

  Widget _buildEngagementRow(Tweet tweet){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildIconPair(Icon(Icons.remove_red_eye, color: Colors.grey.shade500), '${tweet.numViews}'),
        _buildLikeButton(context),
        //_buildIconPair(Icon(Icons.favorite_border, color: Colors.grey.shade500), '${tweet.numLikes}'),
        _buildIconPair(Icon(Icons.share, color: Colors.grey.shade500), null),

      ],
    );
  }

  Widget _buildIconPair(Icon icon, String text){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        children: [
          Container(padding: EdgeInsets.only(right: 5.0), child: icon),
          text == null ? Container() : Text(text),
        ],
      ),
    );
  }

  bool liked = false;
  _likePressed(){
    setState(() {
      liked = !liked;
      if(liked == true){
        tweet.numLikes += 1;
      }
      else{
        tweet.numLikes -= 1;
      }
      //Likes();
    });
  }

  Widget _buildLikeButton(BuildContext context) {
    return Container(
      child: Row(
        children: [
          IconButton(
            icon: Icon(liked ? Icons.favorite : Icons.favorite_border,
                color: liked ? Colors.red : Colors.grey.shade500),
            onPressed: ()=> _likePressed(),
          ),
          Container(padding: EdgeInsets.only(right: 1.0)),
          '${tweet.numLikes}' == null ? Container() : Text('${tweet.numLikes}'),
        ],
      ),
    );
  }

  Future<QuerySnapshot> getPosts() async{
    if (_selectedType == 'All') {
      return await FirebaseFirestore.instance.collection('posts').get();
    } else {
      return await FirebaseFirestore.instance
          .collection('posts')
          .where('type', isEqualTo: _selectedType)
          .get();
    }
  }
}