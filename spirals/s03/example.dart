import 'dart:html';
import 'dart:async';

const int INTERVAL = 10;
const int INCREMENT = 20; // move increment in pixels

CssStyleSheet styleSheet;

var pingPong = {
  'ball': {
    'speed': 3,
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
    'top'    : 60
  },
  'paddleB' : {
    'width'  : 20,
    'height' : 80,
    'left'   : 360,
    'top'    : 80
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
        <a href="http://www.packtpub.com/html5-games-development-using-css-javascript-beginners-guide/book">
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

moveBall() {
  var ball = pingPong['ball'];

  // check table boundary
  // check bottom edge
  if (ball['y'] + ball['speed'] * ball['dy'] > pingPong['table']['height']) {
    ball['dy'] = -1;
  }
  // check top edge
  if (ball['y'] + ball['speed'] * ball['dy'] < 0) {
    ball['dy'] = 1;
  }
  // check right edge
  if (ball['x'] + ball['speed'] * ball['dx'] > pingPong['table']['width']) {
    // reset the ball;
    ball['x'] = 250;
    ball['y'] = 100;
    ball['dx'] = -1;
  }
  // check left edge
  if (ball['x'] + ball['speed'] * ball['dx'] < 0) {
    // reset the ball;
    ball['x'] = 150;
    ball['y'] = 100;
    ball['dx'] = 1;
  }

  ball['x'] += ball['speed'] * ball['dx'];
  ball['y'] += ball['speed'] * ball['dy'];

  // update the circle rule: actually move the ball with speed and direction
  styleSheet.removeRule(0);
  styleSheet.insertRule(circleRule(ball['x'], ball['y']), 0);
}

onKeyDown(e) {
  if (e.keyCode == pingPong['key']['w']) {
    pingPong['paddleA']['top'] = pingPong['paddleA']['top'] - INCREMENT;
    // update the rectangleA rule
    styleSheet.removeRule(2);
    styleSheet.insertRule(rectangleARule(pingPong['paddleA']['top']), 2);
  } else if (e.keyCode == pingPong['key']['s']) {
    pingPong['paddleA']['top'] = pingPong['paddleA']['top'] + INCREMENT;
    // update the rectangleA rule
    styleSheet.removeRule(2);
    styleSheet.insertRule(rectangleARule(pingPong['paddleA']['top']), 2);
  } else if (e.keyCode == pingPong['key']['up']) {
    pingPong['paddleB']['top'] = pingPong['paddleB']['top'] - INCREMENT;
    // update the rectangleB rule
    styleSheet.removeRule(3);
    styleSheet.insertRule(rectangleBRule(pingPong['paddleB']['top']), 3);
  } else if (e.keyCode == pingPong['key']['down']) {
    pingPong['paddleB']['top'] = pingPong['paddleB']['top'] + INCREMENT;
    // update the rectangleB rule
    styleSheet.removeRule(3);
    styleSheet.insertRule(rectangleBRule(pingPong['paddleB']['top']), 3);
  }
}

main() {
  document.query('#description').innerHtml = description();
  document.query('#links').setInnerHtml(
    links(),
    validator: new NodeValidatorBuilder()
      ..allowHtml5()
      ..allowElement('a', attributes: ['href'])
  );
  styleSheet = document.styleSheets[0]; // geometry.css

  document.onKeyDown.listen(onKeyDown);
  // Redraw every INTERVAL ms.
  new Timer.periodic(const Duration(milliseconds: INTERVAL), (t) => moveBall());
}
