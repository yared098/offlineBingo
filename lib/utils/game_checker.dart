import 'package:audioplayers/audioplayers.dart';

String getBingoPrefix(int number) {
  if (number >= 1 && number <= 15) return 'b';
  if (number >= 16 && number <= 30) return 'i';
  if (number >= 31 && number <= 45) return 'n';
  if (number >= 46 && number <= 60) return 'g';
  if (number >= 61 && number <= 75) return 'o';
  return '';
}


final AudioPlayer _audioPlayer = AudioPlayer();

Future<void> playBingoSound(int number) async {
  final prefix = getBingoPrefix(number);
  final file = 'assets/sounds/${prefix}${number}.ogg';

  try {
    await _audioPlayer.stop(); // Stop any currently playing sound
    await _audioPlayer.play(AssetSource(file.replaceFirst('assets/', '')));
  } catch (e) {
    print('Error playing sound: $e');
  }
}
