use BitArrays.BitArray32;
module WordFrequency {
  proc frequency(document : string, word : string) : BitArray32 {
    var wordMatch = new BitArray32(document.numCodepoints);

    var i = 0;
    for wordLetter in word.items() {
      var letterMatch = BitArray32(document.numCodepoints);
      forall j in {0..#document.numCodepoints} {
        letterMatch.set(j, document.item(j) == wordLetter);
      }
      letterMatch >>= i;
      wordMatch &= letterMatch;

      i += 1;
    }

  }

  proc main() {
    var document = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce laoreet mauris sit amet augue aliquet tincidunt. Nunc ac velit lorem. Quisque molestie at massa in ultrices. Donec vitae odio in nunc faucibus venenatis nec vel mi. Pellentesque facilisis dui vitae mauris dapibus, quis convallis magna dignissim. Duis placerat a magna sit amet ornare. Suspendisse hendrerit vehicula tincidunt. Sed a laoreet nibh. Proin sed nisl rutrum lacus tristique tincidunt. Pellentesque euismod pulvinar magna ac facilisis. Praesent eu pharetra nunc. In auctor justo ipsum, at sollicitudin libero accumsan a. Etiam nisi quam, sodales eget felis non, faucibus efficitur lectus. Sed commodo imperdiet augue, a scelerisque lacus mattis nec. Duis condimentum viverra nisi a sollicitudin.

Proin scelerisque vel sapien nec ultrices. Donec sit amet lacus cursus, egestas est id, tristique ligula. Donec pulvinar leo at turpis varius scelerisque. Suspendisse vehicula mi ut ornare blandit. Etiam tincidunt gravida gravida. Mauris nec lacus sit amet mauris tempus laoreet id finibus ipsum. Proin vestibulum dolor aliquam urna suscipit tincidunt.

Nullam quam orci, feugiat id feugiat nec, viverra a augue. Sed in molestie elit, sit amet lacinia urna. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas maximus tortor enim, quis condimentum diam faucibus id. Vivamus aliquet mauris ac dolor accumsan, id varius justo sollicitudin. Ut venenatis non ex vitae ullamcorper. Etiam rutrum vulputate elit, eget commodo risus mattis sit amet. Etiam eleifend at leo sed varius. Etiam interdum feugiat neque in commodo. Nullam interdum ligula ut tortor viverra iaculis. Nam congue dui eget congue tristique.

Sed sed est facilisis, tristique felis in, convallis lectus. Suspendisse tempus nisi non nulla fringilla varius. Etiam eget pulvinar ante, eget bibendum diam. Phasellus fermentum molestie urna eu eleifend. Proin finibus lorem quam, a eleifend neque interdum vulputate. Vestibulum ut lorem quis tellus vestibulum gravida. Ut nisi arcu, dignissim sed dolor ac, dignissim mattis orci. Duis sed ante tortor. Nullam venenatis non quam non sodales. Sed lobortis consectetur massa. Ut nec pulvinar est. Suspendisse nulla nibh, vulputate sagittis est non, malesuada scelerisque sem. Quisque nec eros ex.

Sed hendrerit sit amet orci rutrum egestas. In sed lorem quis justo venenatis pulvinar et at massa. Cras vel nulla ornare, tincidunt purus sed, consequat ipsum. Proin pellentesque, mi sit amet tincidunt pretium, tortor sem dapibus magna, sed laoreet est lectus at nulla. Nunc at posuere turpis. Morbi aliquet diam a ullamcorper lobortis. Vestibulum bibendum pharetra libero, eu euismod lectus semper id. Donec eu bibendum nulla.";
    var word = "sit ";

    var matches = frequency(document, word);
    for (isMatch, letterIndex) in zip(matches, 1..) do
      if isMatch then
        writeln("word %s was found at index %d" word, letterIndex);

    writeln(document);
  }
}