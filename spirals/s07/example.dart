import 'dart:html';
import 'dart:async';

const int INTERVAL = 10;
const int INCREMENT = 20; // move increment in pixels
const int SPEED = 4;
const String PLAYER_A_COLOR = 'brown';
const String PLAYER_B_COLOR = 'gray';

// http://api.dartlang.org/docs/bleeding_edge/dart_html/CSSStyleSheet.html
CssStyleSheet geometryStyleSheet;
// http://api.dartlang.org/docs/bleeding_edge/dart_html/CSSStyleRule.html
CssStyleRule circleStyleRule;
// http://api.dartlang.org/docs/bleeding_edge/dart_html/CSSStyleDeclaration.html
CssStyleDeclaration circleStyleDeclaration;

var pingPong = {
  'ball': {
    'speed': SPEED,
    'x'    : 195,
    'y'    : 100,
    'dx'   : 1,
    'dy'   : 1
  },
  'key': {
    'w'    : KeyCode.W,
    's'    : KeyCode.S,
    'up'   : KeyCode.UP,
    'down' : KeyCode.DOWN
  },
  'paddleA' : {
    'width'  : 20,
    'height' : 80,
    'left'   : 20,
    'top'    : 60,
    'score'  : 0
  },
  'paddleB' : {
    'width'  : 20,
    'height' : 80,
    'left'   : 360,
    'top'    : 80,
    'score'  : 0
  },
  'table' : {
    'width'      : 400,
    'height'     : 200
  }
};

String description() {
  return '''
    <p>
      The following links are learning resources.
    </p>
  ''';
}

String links() {
  return '''
    <ul class="target">
      <li>
        <a href="http://www.javascriptkit.com/dhtmltutors/externalcss.shtml">
          Changing external style sheets using the DOM
        </a>
      </li>
      <li>
        <a href="http://www.javascriptkit.com/domref/cssrule.shtml">
          DOM CSS Rule Object
        </a>
      </li>
      <li>
        <a href="http://www.howtocreate.co.uk/tutorials/javascript/domstylesheets">
          DOM Style Sheets
        </a>
      </li>
      <li>
        <a href=
"http://www.packtpub.com/html5-games-development-using-css-javascript-beginners-guide/book"
        >
          HTML5 Game Development by Example
        </a>
      </li>
    </ul>
  ''';
}

/*
String circleRule(int x, int y) {
  String rule = '''
    #circle {
      background: #27527b;
      position: absolute;
      width: 20px;
      height: 20px;
      left: ${x.toString()}px;
      top: ${y.toString()}px;
      border-radius: 10px;
    }
  ''';
  return rule;
}
*/

String rectangleARule(int top) {
  String rule = '''
    #rectangleA {
      background: brown;
      position: absolute;
      width: 20px;
      height: 80px;
      left: 20px;
      top: ${top.toString()}px;
    }
  ''';
  return rule;
}

String rectangleBRule(int top) {
  String rule = '''
    #rectangleB {
      background: #696969;
      position: absolute;
      width: 20px;
      height: 80px;
      left: 360px;
      top: ${top.toString()}px;
    }
  ''';
  return rule;
}

/*
updateCircleRule(int left, int top) {
  geometryStyleSheet.removeRule(0);
  geometryStyleSheet.insertRule(circleRule(left, top), 0);
}
*/

updateRectangleARule(int top) {
  geometryStyleSheet.removeRule(2);
  geometryStyleSheet.insertRule(rectangleARule(pingPong['paddleA']['top']), 2);
}

updateRectangleBRule(int top) {
  geometryStyleSheet.removeRule(3);
  geometryStyleSheet.insertRule(rectangleBRule(pingPong['paddleB']['top']), 3);
}

moveBall() {
  var ball = pingPong['ball'];
  var table = pingPong['table'];
  var paddleA = pingPong['paddleA'];
  var paddleB = pingPong['paddleB'];
  // check the table boundary
  // check the bottom edge
  if (ball['y'] + ball['speed'] * ball['dy'] > table['height']) {
    ball['dy'] = -1;
  }
  // check the top edge
  if (ball['y'] + ball['speed'] * ball['dy'] < 0) {
    ball['dy'] = 1;
  }
  // check the right edge
  if (ball['x'] + ball['speed'] * ball['dx'] > table['width']) {
    // player B lost
    paddleA['score']++;
    changeBallColor(PLAYER_A_COLOR);
    document.query('#scoreA').innerHtml = paddleA['score'].toString();
    // reset the ball;
    ball['x'] = 250;
    ball['y'] = 100;
    ball['dx'] = -1;
  }
  // check the left edge
  if (ball['x'] + ball['speed'] * ball['dx'] < 0) {
    // player A lost
    paddleB['score']++;
    changeBallColor(PLAYER_B_COLOR);
    document.query('#scoreB').innerHtml = paddleB['score'].toString();
    // reset the ball;
    ball['x'] = 150;
    ball['y'] = 100;
    ball['dx'] = 1;
  }

  ball['x'] += ball['speed'] * ball['dx'];
  ball['y'] += ball['speed'] * ball['dy'];

  // check the moving paddles
  // check the left paddle (A)
  if (ball['x'] + ball['speed'] * ball['dx'] <
      paddleA['left'] + paddleA['width']) {
    if (ball['y'] + ball['speed'] * ball['dy'] <=
        paddleA['top'] + paddleA['height'] &&
        ball['y'] + ball['speed'] * ball['dy'] >= paddleA['top']) {
      ball['dx'] = 1;
    }
  }
  // check the right paddle (B)
  if (ball['x'] + ball['speed'] * ball['dx'] >= paddleB['left']) {
    if (ball['y'] + ball['speed'] * ball['dy'] <=
        paddleB['top'] + paddleB['height'] &&
        ball['y'] + ball['speed'] * ball['dy'] >= paddleB['top']) {
      ball['dx'] = -1;
    }
  }
  // update a position of the ball
  //updateCircleRule(ball['x'], ball['y']);
  changeBallPosition(ball['x'], ball['y']);
}

onKeyDown(e) {
  var paddleA = pingPong['paddleA'];
  var paddleB = pingPong['paddleB'];
  var key = pingPong['key'];
  if (e.keyCode == key['w']) {
    paddleA['top'] = paddleA['top'] - INCREMENT;
    // update the left rectangle (A) rule
    updateRectangleARule(paddleA['top']);
  } else if (e.keyCode == key['s']) {
    paddleA['top'] = paddleA['top'] + INCREMENT;
    // update the left rectangle (A) rule
    updateRectangleARule(paddleA['top']);
  } else if (e.keyCode == key['up']) {
    paddleB['top'] = paddleB['top'] - INCREMENT;
    // update the right rectangle (B) rule
    updateRectangleBRule(paddleB['top']);
  } else if (e.keyCode == key['down']) {
    paddleB['top'] = paddleB['top'] + INCREMENT;
    // update the right rectangle (B) rule
    updateRectangleBRule(paddleB['top']);
  }
}

examineCss() {
  // examining the geometry style sheet
  // http://www.howtocreate.co.uk/tutorials/javascript/domstylesheets
  // http://www.javascriptkit.com/dhtmltutors/externalcss.shtml

  // http://api.dartlang.org/docs/bleeding_edge/dart_html/StyleSheet.html
  // http://api.dartlang.org/docs/bleeding_edge/dart_html/CSSStyleSheet.html
  CssStyleSheet styleSheet = document.styleSheets[0]; // geometry.css
  print('styleSheet.title: ${styleSheet.title}');

  List<CssRule> cssRules = styleSheet.cssRules;
  print('cssRules.length: ${cssRules.length}');

  // http://api.dartlang.org/docs/bleeding_edge/dart_html/CSSRule.html
  // http://api.dartlang.org/docs/bleeding_edge/dart_html/CSSStyleRule.html
  CssStyleRule circleCssRule = cssRules[0];
  print('circleCssRule.cssText: ${circleCssRule.cssText}');
  print('circleCssRule.selectorText: ${circleCssRule.selectorText}');
  print('circleCssRule.type: ${circleCssRule.type}'); // 1 is normal style
  print("");

  print('circleCssRule.style.cssText: ${circleCssRule.style.cssText}');
  print("");

  print("circle style");
  print("------------");
  // http://api.dartlang.org/docs/bleeding_edge/dart_html/CSSStyleDeclaration.html
  CssStyleDeclaration circleStyle = circleCssRule.style;
  circleStyle.setProperty('background','yellow','');
  circleStyle.setProperty('font-weight','bold','important');
  var j, s = '';
  for( var i = 0; i < circleStyle.length; i++ ) {
    j = circleStyle.item(i);
    print('j: ${j}');
    s = '${s}${j} = ${circleStyle.getPropertyValue(j)} ${circleStyle.getPropertyPriority(j)} \n';
  }
  print(s);
  //geometryStyle.removeProperty('font-weight');
  print('circle new style: ${circleStyle.cssText}');
  print("");

  print("geometry rules");
  print("--------------");
  for (CssRule cssRule in cssRules) {
    print(cssRule.cssText);
  }

  // all style sheets
  CssStyleSheet geometryCss;
  print('document.styleSheets.length: ${document.styleSheets.length}');
  for (var ssi = 0; ssi <document.styleSheets.length; ssi++) {
    print('document.styleSheets[${ssi}].title: ${document.styleSheets[ssi].title}' );
    if (document.styleSheets[ssi].title == "geometry") {
      geometryCss = document.styleSheets[ssi];
      //break;
    }
  }
}

CssStyleSheet findStyleSheet(String title) {
  for (var ssi = 0; ssi <document.styleSheets.length; ssi++) {
    if (document.styleSheets[ssi].title == title) {
      return document.styleSheets[ssi];
    }
  }
}

CssStyleRule findCssRule(CssStyleSheet styleSheet, String selector) {
  List<CssRule> styleRules = styleSheet.cssRules;
  for (var sr = 0; sr <styleRules.length; sr++) {
    CssStyleRule styleRule = styleRules[sr];
    if (styleRule.selectorText == selector) {
      return styleRule;
    }
  }
}

changeBallColor(String color) {
  circleStyleDeclaration.background = color;
}

changeBallPosition(int x, int y) {
  circleStyleDeclaration.left = '${x.toString()}px';
  circleStyleDeclaration.top = '${y.toString()}px';
}

main() {
  document.query('#description').innerHtml = description();
  document.query('#links').setInnerHtml(
    links(),
    validator: new NodeValidatorBuilder()
      ..allowHtml5()
      ..allowElement('a', attributes: ['href'])
  );
  geometryStyleSheet = findStyleSheet('geometry');
  circleStyleRule = findCssRule(geometryStyleSheet, '#circle');
  circleStyleDeclaration = circleStyleRule.style;

  document.onKeyDown.listen(onKeyDown);
  // Redraw every INTERVAL ms.
  new Timer.periodic(const Duration(milliseconds: INTERVAL), (t) => moveBall());

  examineCss();
}
