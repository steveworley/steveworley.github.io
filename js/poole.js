window.buttler = {
  elements: [],
  serve: function(response) {
    response = typeof response == 'text' ? $.parseJSON(response) : response;

    if (typeof response.sessions == 'undefined') {
      return;
    }

    response = response.sessions;

    var eventName = !!response[0].type ? 'poole:response:' + response[0].type : 'poole:response';

    response = response.filter(function(element) {
      return typeof element.path != 'undefined' && element.path == window.location.pathname;
    });

    for (var i = 0; i < this.elements.length; i++) {
      $(this.elements[i]).trigger(eventName, [response]);
    }
  }
};

(function($) {

  /**
   * $(form).pooleApi();
   */
  $.fn.pooleApi = function( options ) {
    options = $.extend({
      url: 'http://pooleapp.com/{type}/{secret}',
      secret: 'we-need-a-secret',
      dataElement: '.comments',
      template: '.comments-template',
      type: 'comments'
    }, options);

    var buildInput = function(name, value) {
      return $('<input />', {type: 'hidden', name: name, value: value});
    }

    // We need to tell the jsonp callback about the elements we need to emit
    // events to.
    window.buttler.elements.push(options.dataElement);

    // Ensure that there is additional metadata on the form so we can use this
    // to limit the API responses later.
    $(this)
      // Ensure that we redirect to _self- currently PoolAPI doesn't support
      // cross-origin-resource-sharing.
      .append(buildInput('redirect_to', window.location.href))
      // Add the current path to the stored data.
      .append(buildInput('path', window.location.pathname))
      .append(buildInput('type', options.type));

    // Bind a response event. This will be triggered when a request to the Poole
    // API has been made - we will then pass over the template.
    $(options.dataElement).bind('poole:response:' + options.type, function(e, response) {
      var template = twig({data: $(options.template).html() });
      $(options.dataElement).html(template.render({comments: response }));
      if (window.localStorage) {
        localStorage.setItem(window.location.pathname + ':comments', JSON.stringify(response));
      }
    });

    if (window.localStorage && (storage = localStorage.getItem(window.location.pathname + ':comments'))) {
      $(options.dataElement).trigger('poole:response:' + options.type, [$.parseJSON(storage)]);
    }

    // $.ajax({url: options.url.fmt({secret: options.secret, type: 'data'}) + '.json', dataType: 'jsonp'});

    return this;
  };

})(jQuery);

String.prototype.fmt = function (hash) {
  var string = this, key; for (key in hash) string = string.replace(new RegExp('\\{' + key + '\\}', 'gm'), hash[key]);
  return string;
}
