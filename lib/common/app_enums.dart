enum ApiResultStatus {
  success("success"),
  failure("failure"),
  pending("pending");

  const ApiResultStatus(this.name);
  final String name;
}

enum PollAction {
  comment("comment"),
  detail("detail"),
  share("share"),
  like("like"),
  vote("vote");

  const PollAction(this.name);
  final String name;
}

enum TrackType {
  video("video"),
  audio("audio"),
  text("text");

  const TrackType(this.name);
  final String name;
}

enum PollType {
  POLL("poll"),
  PAID_POLL("paid_poll"),
  MULTIPLE("choices_multiple_rating");

  const PollType(this.name);
  final String name;
}
