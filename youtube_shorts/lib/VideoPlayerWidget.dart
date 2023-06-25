import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'video.dart';

class VideoPlayerWidget extends StatefulWidget {
  final Video video;

  const VideoPlayerWidget({Key? key, required this.video}) : super(key: key);

  @override
  VideoPlayerWidgetState createState() => VideoPlayerWidgetState();
}

class VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController videoPlayerController;
  late ChewieController chewieController;
  bool isVisible = false;
  bool isVideoLoading = true;
  bool isVideoInitialized = false;

  @override
  void initState() {
    super.initState();

    videoPlayerController = VideoPlayerController.network(widget.video.mediaUrl);
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoPlay: false,
      looping: true,
      allowPlaybackSpeedChanging: false,
      allowFullScreen: true,
      showControls: false,
      autoInitialize: false,
    );

    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    if (!isVideoInitialized) {
      await videoPlayerController.initialize();
      setState(() {
        isVideoInitialized = true;
      });
    }

    if (mounted) {
      setState(() {
        isVideoLoading = false;
        videoPlayerController.play();
      });
    }
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key(widget.video.postId),
      onVisibilityChanged: (visibilityInfo) {
        if (mounted) {
          setState(() {
            isVisible = visibilityInfo.visibleFraction > 0.5;
          });
        }
      },
      child: Container(
        color: Colors.black,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {


            return Stack(
              children: [
                if (isVideoInitialized && isVisible)
                  Container(
                    color: Colors.black,
                    child: Chewie(
                      controller: chewieController,
                    ),
                  ),
                if (!isVideoInitialized || (isVisible && isVideoLoading))
                  Container(
                    color: Colors.black,
                    child: Image.network(
                      widget.video.thumbnail,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                if (isVideoLoading)
                  Center(
                    child: CircularProgressIndicator(),
                  ),
                if (isVisible && !isVideoLoading)
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.video.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          widget.video.creatorName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                if (isVisible && !isVideoLoading)
                  Positioned(
                    bottom: 100,
                    right: 15,
                    child: Column(
                      children: [
                        IconButton(
                          onPressed: () {
                            // Handle like button action
                          },
                          icon: const Icon(Icons.favorite, color: Colors.white, size: 45),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            widget.video.reactionCount.toString(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),

                        IconButton(
                          onPressed: () {
                            // Handle comment button action
                          },
                          icon: const Icon(Icons.comment, color: Colors.white, size: 45),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            widget.video.commentCount.toString(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),

                        IconButton(
                          onPressed: () {
                            // Handle share button action
                          },
                          icon: const Icon(Icons.share, color: Colors.white, size: 40),
                        ),
                      ],
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
