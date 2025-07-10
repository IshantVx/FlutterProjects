import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class videoPlayer extends StatefulWidget {
  const videoPlayer({super.key});

  @override
  State<videoPlayer> createState() => _videoPlayerState();
}

class _videoPlayerState extends State<videoPlayer> {

  late YoutubePlayerController _controller;
  List<String> videoId = [];
  String? selectedVideoId;

  Future<void> fetchVideos() async {
    final snapshot = await FirebaseFirestore.instance.collection('Videos').get();
    List<String> ids =[];
    for (var doc in snapshot.docs) {
      final List<dynamic> videoList = doc['videoId'];
      ids.addAll(videoList.map((e) => e.toString()));
    }
    setState(() {
      videoId = ids;
      log(videoId.toString());
      if (videoId.isNotEmpty) {
        selectedVideoId = videoId.first;
        _controller.loadVideoById(videoId: selectedVideoId!);
      }
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchVideos();
    _controller = YoutubePlayerController(
      params: YoutubePlayerParams(
        mute: false,
        showControls: true,
        showFullscreenButton: true,
      ),
    );
    _controller = YoutubePlayerController.fromVideoId(
      videoId: 'LtNbLer31fg',
      autoPlay: false,
      params: const YoutubePlayerParams(showFullscreenButton: true),
    );
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              YoutubePlayer(
                controller: _controller,
                aspectRatio: 16 / 9,
              ),
              Container(
                height: 200,
                width: 400,
                child: GridView.builder(
                  padding: EdgeInsets.all(8),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 16 / 9,
                  ),
                  itemCount: videoId.length,
                  itemBuilder: (context, index) {
                    final video = videoId[index];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedVideoId = video;
                          log(selectedVideoId.toString());
                          _controller.loadVideoById(videoId: selectedVideoId!);
                        });
                      },
                      child: Column(
                        children: [
                          Expanded(
                            child: Image.network(
                              "https://img.youtube.com/vi/${videoId[index]}/hqdefault.jpg",
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        )
    );
  }
}
