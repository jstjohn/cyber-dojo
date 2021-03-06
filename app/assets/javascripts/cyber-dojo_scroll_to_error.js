/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";

  var getAllRegexMatches = function(string,regex) {
    var matches = [];
    var match;
    while (match = regex.exec(string)) {
      matches.push(match);
    }
    return matches;
  };

  //- - - - - - - - - - - - - - - - - - - -

  var regexFor = function(s) {
    var filenamePattern = '([a-zA-Z0-9_\.]+)';
    var lineNumberPattern = '([0-9]+)';
    s = s.replace('{F}',filenamePattern);
    s = s.replace('{L}',lineNumberPattern);
    return new RegExp(s, 'g');
  };

  //- - - - - - - - - - - - - - - - - - - -

  var getFileLocations = function(string,spec) {
    var locations = [];
    for (var i = 0; i < spec.length; i += 3) {
      var regex = regexFor(spec[i+0]);
      var fileIndex = spec[i+1];
      var lineIndex = spec[i+2];
      getAllRegexMatches(string,regex).map(function(match) {
        var filename = match[fileIndex];
        var lineNumber = match[lineIndex];
        locations.push([filename,lineNumber]);
      });
    }
    return locations;
  };

  //- - - - - - - - - - - - - - - - - - - -

  var getFirstMatch = function(spec) {
    var output = cd.fileContentFor('output').val();
    var matches = getFileLocations(output, spec);
    var filenames = cd.filenames();
    for (var i = 0; i < matches.length; i++) {
      var filename = matches[i][0];
      if (cd.inArray(filename, filenames)) {
        return matches[i];
      }
    }
    return undefined;
  };

  //- - - - - - - - - - - - - - - - - - - -

  var blink = function(line) {
    var twoSeconds = 2000;
    // Colors are hard-wired. Saving them
    // and then resetting can fail with
    // rapid repeated Alt+g keystrokes.
    var color      = '#BFBFBF';
    var background = '#7A7A7A';

    line.css('color', background);
    line.css('background', color);
    setTimeout(function() {
      line.css('color', color);
      line.css('background', background);
    }, twoSeconds);
  };

  //- - - - - - - - - - - - - - - - - - - -

  var getSpec = function() {
    var colour = cd.currentTrafficLightColour();
    if (colour === 'amber') {
      return cd.amberGotoLineSpec();
    }
    if (colour === 'red') {
      return cd.redGotoLineSpec();
    }
    return undefined;
  };

  //- - - - - - - - - - - - - - - - - - - -

  cd.scrollToError = function() {

    return; // work in progress

    var spec = getSpec();
    if (spec === undefined) { return; }
    var match = getFirstMatch(spec);
    if (match === undefined) { return; }

    var filename = match[0];
    var lineNumber = match[1];

    var content = cd.fileContentFor(filename);
    var numbers = cd.lineNumbersFor(filename);

    var line = $('#' + lineNumber, numbers);
    var downFromTop = 150;
    var instantly = 0;

    cd.loadFile(filename);

    // line-numbers is not directly scrollable but animate works!
    numbers.animate({
      // scroll the line-number into view
      scrollTop: '+=' + (line.offset().top - downFromTop) + 'px'
      }, instantly, function() {
        // align the content to the line-number
        content.scrollTop(numbers.scrollTop());
        blink(line);
      });
  };

  return cd;
})(cyberDojo || {}, $);
