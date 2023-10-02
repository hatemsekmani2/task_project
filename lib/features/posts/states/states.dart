abstract class PostsStates {
  const PostsStates();
}

class InitialPostsState extends PostsStates {
  const InitialPostsState();
}

class LoadingPostsForFirstTimeState extends PostsStates {
  const LoadingPostsForFirstTimeState();
}

class LoadingPostsState extends PostsStates {
  const LoadingPostsState();
}

class PostsFinishedLoadingState extends PostsStates {
  const PostsFinishedLoadingState();
}
class PostsErrorLoadingState extends PostsStates {
  const PostsErrorLoadingState();
}