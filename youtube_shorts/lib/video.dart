class Video {
  final String postId;
  final String title;
  final String description;
  final String mediaUrl;
  final String thumbnail;
  final String hyperlink;
  final String placeholderUrl;
  final String creatorName;
  final String creatorHandle;
  final String creatorPicUrl;
  final int reactionCount;
  final bool hasVoted;
  final int commentCount;
  final bool isCommentingAllowed;

  Video({
    required this.postId,
    required this.title,
    required this.description,
    required this.mediaUrl,
    required this.thumbnail,
    required this.hyperlink,
    required this.placeholderUrl,
    required this.creatorName,
    required this.creatorHandle,
    required this.creatorPicUrl,
    required this.reactionCount,
    required this.hasVoted,
    required this.commentCount,
    required this.isCommentingAllowed,
  });
}
