import 'dart:html';
import 'dart:async';

const int interval = 10;
const int increment = 20; // move increment in pixels
const int speed = 4;

CssStyleSheet styleSheet;

var pingPong = {
  'ball': {
    'speed': speed,
    'x'    : 195,
    'y'    : 100,
    'dx'   : 1,
    'dy'   : 1
  },
  'key': {
    'w'    : 87,
    's'    : 83,
    'up'   : 38,
    'down' : 40
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

String rectangleARule(int top) {
  String rule = '''
    #rectangleA {
      background: #9cc3e8;
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
      background: #9cc3e8;
      position: absolute;
      width: 20px;
      height: 80px;
      left: 360px;
      top: ${top.toString()}px;
    }
  ''';
  return rule;
}

updateCircleRule(int left, int top) {
  styleSheet.removeRule(0);
  styleSheet.insertRule(circleRule(left, top), 0);
}

updateRectangleARule(int top) {
  styleSheet.removeRule(2);
  styleSheet.insertRule(rectangleARule(pingPong['paddleA']['top']), 2);
}

updateRectangleBRule(int top) {
  styleSheet.removeRule(3);
  styleSheet.insertRule(rectangleBRule(pingPong['paddleB']['top']), 3);
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
  // update the circle rule
  updateCircleRule(ball['x'], ball['y']);
}

onKeyDown(e) {
  var paddleA = pingPong['paddleA'];
  var paddleB = pingPong['paddleB'];
  var key = pingPong['key'];
  if (e.keyCode == key['w']) {
    paddleA['top'] = paddleA['top'] - increment;
    // update the left rectangle (A) rule
    updateRectangleARule(paddleA['top']);
  } else if (e.keyCode == key['s']) {
    paddleA['top'] = paddleA['top'] + increment;
    // update the left rectangle (A) rule
    updateRectangleARule(paddleA['top']);
  } else if (e.keyCode == key['up']) {
    paddleB['top'] = paddleB['top'] - increment;
    // update the right rectangle (B) rule
    updateRectangleBRule(paddleB['top']);
  } else if (e.keyCode == key['down']) {
    paddleB['top'] = paddleB['top'] + increment;
    // update the right rectangle (B) rule
    updateRectangleBRule(paddleB['top']);
  }
}

main() {
  document.query('#description').innerHtml = description();
  document.query('#links').innerHtml = links();
  styleSheet = document.styleSheets[0]; // geometry.css

  document.on.keyDown.add(onKeyDown);
  // Redraw every interval ms.
  new Timer.repeating(interval, (t) => moveBall());
}
