import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_project/features/posts/controllers/posts_controller.dart';
import 'package:task_project/features/posts/general_variables.dart';
import 'package:task_project/features/posts/states/states.dart';
import 'package:task_project/features/posts/widgets/new_post.dart';
import 'package:task_project/features/posts/widgets/post_widget.dart';
class AllPosts extends StatefulWidget {
  const AllPosts({super.key});

  @override
  State<AllPosts> createState() => _AllPostsState();
}

class _AllPostsState extends State<AllPosts> {

  @override
  void initState() {
    GeneralVariables.postsController = PostsController.getInstance();
    GeneralVariables.postsController.getPosts();
    Firebase.initializeApp();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar:  AppBar(
        title: const Text("All Posts"),
        actions: [
          IconButton(onPressed: () {
            GeneralVariables.postsController.getPosts(refreshlatestPosts: true);
          },
            icon: const Icon(Icons.refresh),
          )
        ],
      ),

      body: SizedBox(
        width: Get.width,
        height: Get.height,
        child: GetBuilder<PostsController>(
          init: GeneralVariables.postsController,
          builder: (controller) {
            if(controller.currentState is LoadingPostsForFirstTimeState) {
              return const Center(child: CircularProgressIndicator(),);
            }
            else{

            return Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: [
                  PostsListWidget(controller),
                  UpdatingRefreshIndicatorWidget(controller)
                ],
              ),
            );
            }
          },
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Get.to(const NewPost());
        },
        child: const Icon(Icons.post_add_rounded,color: Colors.white,),
      ),

    );
  }
}

class UpdatingRefreshIndicatorWidget extends StatelessWidget {
  final PostsController controller;
  const UpdatingRefreshIndicatorWidget(this.controller,{super.key});

  @override
  Widget build(BuildContext context) {
    return  controller.currentState is LoadingPostsState ? const Center(child: CircularProgressIndicator(),) : const SizedBox();
  }
}
class PostsListWidget extends StatelessWidget {
  final PostsController controller;
  final ScrollController listController = ScrollController();

   PostsListWidget(this.controller,{super.key});
  @override
  Widget build(BuildContext context) {

    initilizeListenerForTheEndOfTheVisiblePosts();


    return  Expanded(
      child: RefreshIndicator(
        onRefresh: () => GeneralVariables.postsController.getPosts(refreshlatestPosts: true),
        child: ListView.builder(
          itemCount: controller.posts.length,
          addAutomaticKeepAlives: true,
          itemBuilder: (context, index) => PostWidget(controller.posts[index]),
          padding: const EdgeInsets.only(bottom: 5),
          controller: listController,
        ),
      ),
    );
  }

  void initilizeListenerForTheEndOfTheVisiblePosts() {
    if(!listController.hasListeners) {
      listController.addListener(() {
        if(listController.position.atEdge &&listController.position.pixels!=0) {
          GeneralVariables.postsController.getPosts();
        }
      });
    }
  }
}

