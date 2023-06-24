import 'package:flutter/material.dart';
import 'video.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'SecondPage.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  int currentPage = 0;
  List<Video> videos = [];
  List<Video> nextVideos = [];


  @override
  void initState() {
    super.initState();
    fetchVideos().then((videoList) {
      setState(() {
        videos = videoList;
      });

    });
  }

  Future<List<Video>> fetchVideos() async {
    final response = await http.get(Uri.parse('https://internship-service.onrender.com/videos?page=$currentPage'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final data = jsonData['data'];
      final List<dynamic> videoList = data != null ? data['posts'] : [];

      return videoList.map(
            (json) => Video(
          postId: json['postId'] ?? '',
          title: json['submission']['title'] ?? '',
          description: json['submission']['description'] ?? '',
          mediaUrl: json['submission']['mediaUrl'] ?? '',
          thumbnail: json['submission']['thumbnail'] ?? '',
          hyperlink: json['submission']['hyperlink'] ?? '',
          placeholderUrl: json['submission']['placeholderUrl'] ?? '',
          creatorName: json['creator']['name'] ?? '',
          creatorHandle: json['creator']['handle'] ?? '',
          creatorPicUrl: json['creator']['pic'] ?? '',
          reactionCount: json['reaction']['count'] ?? 0,
          hasVoted: json['reaction']['voted'] ?? false,
          commentCount: json['comment']['count'] ?? 0,
          isCommentingAllowed: json['comment']['commentingAllowed'] ?? false,
        ),
      ).toList();
    } else {
      throw Exception('Failed to fetch videos');
    }
  }



  void playVideoFullScreen(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SecondPage(videos: videos, currentIndex: index, currentPage: currentPage,),
      ),
    );
  }

  Widget buildVideoThumbnail(int index) {
    final video = videos[index];
    return GestureDetector(
      onTap: () {
        playVideoFullScreen(index);
      },
      child: Container(
        margin: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(video.thumbnail),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget buildVideoList() {
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.547,
      ),
      itemCount: videos.length,
      itemBuilder: (BuildContext context, int index) {


        if (index == videos.length - 1) {

          currentPage++;
          fetchVideos().then((videoList) {
            setState(() {
              videos.addAll(videoList);
            });
          //  preLoadNextVideos();
          });
        }

        return buildVideoThumbnail(index);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height - kToolbarHeight - kBottomNavigationBarHeight,
              child: buildVideoList(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.black,
        child: SizedBox(
          height: 50.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.home, color: Colors.white),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.search, color: Colors.white),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.add_box, color: Colors.white),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.favorite_border, color: Colors.white),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.person, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
