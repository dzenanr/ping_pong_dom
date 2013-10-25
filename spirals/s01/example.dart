import 'dart:html';

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

main() {
  document.querySelector('#description').innerHtml = description();
  //document.querySelector('#links').innerHtml = links();
  document.querySelector('#links').setInnerHtml(
    links(),
    validator: new NodeValidatorBuilder()
      ..allowHtml5()
      ..allowElement('a', attributes: ['href'])
  );
}
