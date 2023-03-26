abstract class AudioPlayerInterface {
  Future<void> play(String source);

  Future<void> download();
}
