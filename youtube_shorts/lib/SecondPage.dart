import 'package:flutter/material.dart';
import 'VideoPlayerWidget.dart';
import 'video.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class SecondPage extends StatefulWidget {
  final List<Video> videos;
  int currentIndex;
  int currentPage;

  SecondPage({
    required this.videos,
    required this.currentIndex,
    required this.currentPage,
  });

  @override
  SecondPageState createState() => SecondPageState();
}

class SecondPageState extends State<SecondPage> {
   late PageController pageController;
  int currentPageValue = 0;

  @override
  void initState() {
    super.initState();
    currentPageValue = widget.currentPage;
     pageController = PageController(initialPage: widget.currentIndex);
  }

  Future<List<Video>> fetchVideos() async {
    final response = await http.get(Uri.parse('https://internship-service.onrender.com/videos?page=$currentPageValue'));

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

  @override
  void dispose() {
     pageController.dispose();
    super.dispose();
  }

  Widget buildVideoThumbnail(int index) {
    final video = widget.videos[index];
    return Container(
        margin: const EdgeInsets.all(2.0),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(video.thumbnail),
            fit: BoxFit.cover,
          ),
        ),
      );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text("Video Page"),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: PageView.builder(
          controller: pageController,
          scrollDirection: Axis.vertical,
          itemCount: widget.videos.length,
          onPageChanged: (index) {
            setState(() {
              widget.currentIndex = index;
            });
          },
          itemBuilder: (BuildContext context, int index) {
            if (index == widget.videos.length - 2) {

              currentPageValue++;
              fetchVideos().then((videoList) {
                setState(() {
                  widget.videos.addAll(videoList);
                });
              });
            }

            final video = widget.videos[index];
            return VideoPlayerWidget(video: video);
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.black,
        child: Container(
          height: 50.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
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
