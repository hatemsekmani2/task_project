

import 'package:flutter/material.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:video_player/video_player.dart';
import '../models/AllPostResponse.dart';
class PostWidget extends StatefulWidget {
  final Items item;
  const PostWidget(this.item,{super.key});

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> with AutomaticKeepAliveClientMixin{
  @override
  Widget build(BuildContext context) {
    return  Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 3,
      shadowColor: Colors.black26,
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(

            leading: ClipRRect(
         
              borderRadius: BorderRadius.circular(500),
              child: Image.network("https://i.pinimg.com/originals/f1/0f/f7/f10ff70a7155e5ab666bcdd1b45b726d.jpg",width: 35,height: 35,),
            ),
            title: Text(widget.item.model!.name??"",style: const TextStyle(color: Colors.black54,fontSize: 12),),
            subtitle: Text((widget.item.model!.createdAt??"").replaceAll("T", " On ").replaceAll(".000000Z", ""),style: const TextStyle(color: Colors.grey,fontSize: 10),),

          ),
          (widget.item.content !=null && widget.item.content!="") ? Container(
            padding: const EdgeInsets.fromLTRB(70, 16, 16, 16),
            child: Text(widget.item.content??"",style: const TextStyle(color: Colors.black87,fontSize: 12),textAlign: TextAlign.start,),
          ) : const SizedBox(),
         (widget.item.media??[]).isNotEmpty? Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(vertical: 16,horizontal: 16),
            child: widget.item.media![0].mediaType == "Image"?
            PostImage(widget.item.media![0],(widget.item.id??0).toInt()):  PostVideo(widget.item.media![0].srcUrl??""),
          ) : const SizedBox(),

           ReactionsAndCommentsCount(widget.item),
          const ReactionAndCommentAndShareWidget()


        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class PostVideo extends StatefulWidget {
  final String url;
  const PostVideo(this.url,{super.key});

  @override
  _PostVideoState createState() => _PostVideoState();
}

class _PostVideoState extends State<PostVideo> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(
        widget.url))
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });


  }

  @override
  Widget build(BuildContext context) {
    return  Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(vertical: 16,horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10)
      ),
      child: _controller.value.isInitialized
          ? AspectRatio(
        aspectRatio: _controller.value.aspectRatio,

        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            VideoPlayer(_controller,),
            Positioned(bottom: 0,child: IconButton(
              padding: const EdgeInsets.symmetric(vertical: 2.5),
              onPressed: () {
                setState(() {
                  _controller.value.isPlaying
                      ? _controller.pause()
                      : _controller.play();
                });
              },
              icon: Icon(
                _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,color: Colors.black,
                size: 30,

              ),
            ))
          ],
        ),
      )
          : Row(
             mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.ondemand_video,color: Colors.grey,),
              Text("Loading Video...",style: TextStyle(color:  Colors.grey,fontSize: 12)),
            ],
          ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}


class PostImage extends StatefulWidget {
  final Media image;
  final int id;
  const PostImage(this.image, this.id,{super.key});

  @override
  _PostImageState createState() => _PostImageState();
}
/*
***important***********************
*
here we used the library 'cached_network_image' to save images offline
* *********
 */
class _PostImageState extends State<PostImage> {

  @override
  Widget build(BuildContext context) {
    return  ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child:   CachedNetworkImage(
        imageUrl : widget.image.srcUrl??"",
        placeholder: (context, url) => const Center(child: Text("Loading ...",style: TextStyle(color:  Colors.grey,fontSize: 12))),
        errorWidget: (context, error, stackTrace) => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.broken_image_rounded,color: Colors.grey[500],),
            Center(child: Text("Error with ${widget.image.mediaType} Viewing",style: const TextStyle(color: Colors.grey,fontSize: 12),),)
          ],
        ),),
    ) ;
  }

}

class ReactionAndCommentAndShareWidget extends StatefulWidget {
  const ReactionAndCommentAndShareWidget({super.key});

  @override
  State<ReactionAndCommentAndShareWidget> createState() => _ReactionAndCommentAndShareWidgetState();
}

class _ReactionAndCommentAndShareWidgetState extends State<ReactionAndCommentAndShareWidget> {
  @override
  Widget build(BuildContext context) {
    return  Row(
      children: [
        Expanded(

            child:TextButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [

                  Text("Share",style: TextStyle(color: Colors.grey,fontSize: 15),),
                  Icon(Icons.share,color: Colors.grey,size: 12,),
                ],
              ),
              onPressed: (){
              },
            )),
        Container(
          width: 2,
          height: 20,
          color: Colors.grey,
        ),
        Expanded(

            child:TextButton(
              child:Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [

                  Text("Comment",style: TextStyle(color: Colors.grey,fontSize: 15),),
                  Icon(Icons.comment,color: Colors.grey,size: 12,),

                ],
              ),
              onPressed: (){
              },
            )),
        Container(
          width: 2,
          height: 20,
          color: Colors.grey,
        ),
        Expanded(
          child: ReactionButton(onReactionChanged: (reaction){},

              initialReaction: Reaction(icon: Image.asset("images/ic_like.png",height: 30,),value: 0),reactions: [
                Reaction(icon: Padding(padding: const EdgeInsets.all(5),child: Image.asset("images/ic_like_fill.png",height: 30,)), value: 1),
                Reaction(icon: Padding(padding: const EdgeInsets.all(5),child: Image.asset("images/love2.png",width: 30,height: 30,)), value: 2),
                Reaction(icon: Padding(padding: const EdgeInsets.all(5),child: Image.asset("images/haha2.png",width: 30,height: 30,)), value: 3),
                Reaction(icon: Padding(padding: const EdgeInsets.all(5),child: Image.asset("images/angry2.png",width: 30,height: 30,)), value: 4),
                Reaction(icon: Padding(padding: const EdgeInsets.all(5),child: Image.asset("images/wow2.png",width: 30,height: 30)), value: 5),
                Reaction(icon: Padding(padding: const EdgeInsets.all(5),child: Image.asset("images/sad2.png",width: 30,height: 30,)), value: 6),

              ]),
        )
      ],
    );
  }
}

class ReactionsAndCommentsCount extends StatefulWidget {
  final Items item;
  const ReactionsAndCommentsCount(this.item,{super.key});

  @override
  State<ReactionsAndCommentsCount> createState() => _ReactionsAndCommentsCountState();
}

class _ReactionsAndCommentsCountState extends State<ReactionsAndCommentsCount> {
  @override
  Widget build(BuildContext context) {
    return  Container(
      padding: const EdgeInsets.only(left: 16,bottom: 5),
      child: Row(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(padding: const EdgeInsets.symmetric(horizontal: 2),child: Text(widget.item.interactionsCountTypes!.like.toString(),style: const TextStyle(color: Colors.grey,fontSize: 12),),),

              Image.asset('images/ic_like_fill.png',height: 15,),
            ],
          ),
          const SizedBox(width: 2.5,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(padding: const EdgeInsets.symmetric(horizontal: 2),child: Text(widget.item.interactionsCountTypes!.love.toString(),style: const TextStyle(color: Colors.grey,fontSize: 12),),),

              Image.asset('images/love2.png',height: 15,),
            ],
          ),
          const SizedBox(width: 2.5,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(padding: const EdgeInsets.symmetric(horizontal: 2),child: Text(widget.item.interactionsCountTypes!.haha.toString(),style: const TextStyle(color: Colors.grey,fontSize: 12),),),

              Image.asset('images/haha2.png',height: 15,),
            ],
          ),
          const SizedBox(width: 2.5,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(padding: const EdgeInsets.symmetric(horizontal: 2),child: Text(widget.item.interactionsCountTypes!.wow.toString(),style: const TextStyle(color: Colors.grey,fontSize: 12),),),

              Image.asset('images/wow2.png',height: 15,),
            ],
          ),
          const SizedBox(width: 2.5,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(padding: const EdgeInsets.symmetric(horizontal: 2),child: Text(widget.item.interactionsCountTypes!.sad.toString(),style: const TextStyle(color: Colors.grey,fontSize: 12),),),

              Image.asset('images/sad2.png',height: 15,),
            ],
          ),
          const SizedBox(width: 2.5,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(padding: const EdgeInsets.symmetric(horizontal: 2),child: Text(widget.item.interactionsCountTypes!.angry.toString(),style: const TextStyle(color: Colors.grey,fontSize: 12),),),

              Image.asset('images/angry2.png',height: 15,),
            ],
          ),
        ],
      ),
    );
  }
}


