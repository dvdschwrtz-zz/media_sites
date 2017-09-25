(function() {
  const site = document.getElementsByTagName('body')[0].dataset.site;
  const head = document.getElementsByTagName('head')[0];
  const link = document.createElement('link');
  const rel = document.createAttribute('rel');
  const href = document.createAttribute('href');

  rel.value = 'stylesheet';
  href.value = site;

  link.setAttributeNode(rel);
  link.setAttributeNode(href);

  head.appendChild(link);
})()

// side navbar responsiveness
window.toggleNav = function () {
  var originalClass = 'nav__category-links'
  var x = document.getElementsByClassName(originalClass)[0];
  if(x.className === originalClass) {
    x.className += ' responsive';
  } else {
    x.className = originalClass;
  }
}
