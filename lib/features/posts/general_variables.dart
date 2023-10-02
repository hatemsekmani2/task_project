import 'controllers/posts_controller.dart';
import 'models/AllPostResponse.dart';

class GeneralVariables {
  static int currentPageNumber = 1;
  static String getAllPostsUrl = 'api/posts/v1/all?page=$currentPageNumber';
  static PostsController postsController = PostsController.getInstance();
}