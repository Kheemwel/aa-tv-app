/// Image of the back part of the card
const String defaultCard = 'assets/memory card game - back.png';

/// List of all the images of the front part of cards
const List<String> cards = [
  'assets/memory card - diamond.png',
  'assets/memory card - flower.png',
  'assets/memory card - heart.png',
  'assets/memory card - hourglass.png',
];

/// Duplicate the cards for matching and shuffle it
List<String> multipliedCards() {
  const multi = 3;
  int multiplier = multi  * 2;
  List<String> multiCards = [];
  for (var card in cards) {
    for (var i = 0; i < multiplier; i++) {
      multiCards.add(card);
    }
  }

  return multiCards..shuffle();
}
