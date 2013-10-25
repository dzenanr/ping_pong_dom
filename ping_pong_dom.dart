import 'dart:html';
import 'dart:async';

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

String ballRule(int x, int y) {
  String rule = '''
    #ball {
      background: #fbbfbb;
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

String paddleARule(int top) {
  String rule = '''
    #paddleA {
      background: #bbbbff;
      position: absolute;
      width: 20px;
      height: 80px;
      left: 20px;
      top: ${top.toString()}px;
    }
  ''';
  return rule;
}

String paddleBRule(int top) {
  String rule = '''
    #paddleB {
      background: #bbbbff;
      position: absolute;
      width: 20px;
      height: 80px;
      left: 360px;
      top: ${top.toString()}px;
    }
  ''';
  return rule;
}

updateBallRule(int left, int top) {
  styleSheet.removeRule(1);
  styleSheet.insertRule(ballRule(left, top), 1);
}

updatePaddleARule(int top) {
  styleSheet.removeRule(2);
  styleSheet.insertRule(paddleARule(pingPong['paddleA']['top']), 2);
}

updatePaddleBRule(int top) {
  styleSheet.removeRule(3);
  styleSheet.insertRule(paddleBRule(pingPong['paddleB']['top']), 3);
}

onKeyDown(e) {
  var paddleA = pingPong['paddleA'];
  var paddleB = pingPong['paddleB'];
  var key = pingPong['key'];
  if (e.keyCode == key['w']) {
    paddleA['top'] = paddleA['top'] - INCREMENT;
    // update the paddle A rule
    updatePaddleARule(paddleA['top']);
  } else if (e.keyCode == key['s']) {
    paddleA['top'] = paddleA['top'] + INCREMENT;
    // update the paddle A rule
    updatePaddleARule(paddleA['top']);
  } else if (e.keyCode == key['up']) {
    paddleB['top'] = paddleB['top'] - INCREMENT;
    // update the paddle B rule
    updatePaddleBRule(paddleB['top']);
  } else if (e.keyCode == key['down']) {
    paddleB['top'] = paddleB['top'] + INCREMENT;
    // update the paddle B rule
    updatePaddleBRule(paddleB['top']);
  }
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
    document.querySelector('#scoreA').innerHtml = paddleA['score'].toString();
    // reset the ball;
    ball['x'] = 250;
    ball['y'] = 100;
    ball['dx'] = -1;
  }
  // check the left edge
  if (ball['x'] + ball['speed'] * ball['dx'] < 0) {
    // player A lost
    paddleB['score']++;
    document.querySelector('#scoreB').innerHtml = paddleB['score'].toString();
    // reset the ball;
    ball['x'] = 150;
    ball['y'] = 100;
    ball['dx'] = 1;
  }

  ball['x'] += ball['speed'] * ball['dx'];
  ball['y'] += ball['speed'] * ball['dy'];

  // check the moving paddles
  // check the left paddle
  if (ball['x'] + ball['speed'] * ball['dx'] <
      paddleA['left'] + paddleA['width']) {
    if (ball['y'] + ball['speed'] * ball['dy'] <=
        paddleA['top'] + paddleA['height'] &&
        ball['y'] + ball['speed'] * ball['dy'] >= paddleA['top']) {
      ball['dx'] = 1;
    }
  }
  // check the right paddle
  if (ball['x'] + ball['speed'] * ball['dx'] >= paddleB['left']) {
    if (ball['y'] + ball['speed'] * ball['dy'] <=
        paddleB['top'] + paddleB['height'] &&
        ball['y'] + ball['speed'] * ball['dy'] >= paddleB['top']) {
      ball['dx'] = -1;
    }
  }
  // update the ball rule
  updateBallRule(ball['x'], ball['y']);
}

gameLoop(num delta) {
  moveBall();
  window.animationFrame.then(gameLoop);
}

main() {
  styleSheet = document.styleSheets[0];
  document.onKeyDown.listen(onKeyDown);
  // redraw
  window.animationFrame.then(gameLoop);
}


