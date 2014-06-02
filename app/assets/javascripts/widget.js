// Helpful Embed JS

// When somebody with an Account includes a script tag to this file on their own
// website, it'll embed a simple web embed that posts to Helpful.
//
// It's attached to the DOM with the use of the `data-helpful` attribute:
//
//    <a href="#" data-helpful="my-account-slug">Click me to show embed</a>
//
// The value of `data-helpful` should be the account slug of the Helpful account
// where the new message should be created.
//
// 
// No need for jQuery! Plain old Javascript!
//
(function() {
  // HelpfulEmbed Class
  var HelpfulEmbed = function () {
  }

  HelpfulEmbed.prototype.load = function () {
    var load_js = function () {
      var js_el = document.createElement('script');
      js_el.type = 'text/javascript';
      // js_el.src = 'http://localhost:5000/assets/widget-content.js' // DEV
      js_el.src = '//assets.helpful.io/assets/widget-content.js' // PROD
      document.body.appendChild(js_el);
    }

    var css_el = document.createElement('link');
    css_el.rel = 'stylesheet';
    css_el.type = 'text/css';
    css_el.addEventListener('load', load_js);
    // css_el.href = 'http://localhost:5000/assets/widget.css'; // DEV
    css_el.href = '//assets.helpful.io/assets/widget.css'; // PROD
    css_el.media = 'all';
    document.head.appendChild(css_el);
  }

  HelpfulEmbed.prototype.showWidget = function () {
    // remove old style
    this.widget.className = this.widget.className.replace('helpful-shown-below', '');

    // check overlay
    if (!this.options.overlay) {
      if (this.overlay.className.indexOf('transparent') == -1)
        this.overlay.className += ' transparent';
    } else
    {
      this.overlay.className.replace('transparent', '');
    }

    // calculate widget location, width = 300px, height = 325px, minimum viewport margin = 25px
    var el_pos = this.source.getBoundingClientRect();

    var document_h = Math.max(
        document.body.scrollHeight, document.documentElement.scrollHeight,
        document.body.offsetHeight, document.documentElement.offsetHeight,
        document.body.clientHeight, document.documentElement.clientHeight
    );

    var document_w = Math.max(
        document.body.scrollWidth, document.documentElement.scrollWidth,
        document.body.offsetWidth, document.documentElement.offsetWidth,
        document.body.clientWidth, document.documentElement.clientWidth
    );
    
    var widget_top = 0;
    var widget_left = 0;

    // check if enough space on screen above source AND if enough space below in document UNLESS not enough above in document
    if ((el_pos.top < 355) && ((this.source.offsetTop + this.source.offsetHeight + 355) < document_h || this.source.offsetTop < 355)) {
      // show below
      widget_top = this.source.offsetTop + this.source.offsetHeight + 15;
      this.widget.className += ' helpful-shown-below';
    } else
    {
      // show above
      widget_top = this.source.offsetTop - 355;
    }
    
    widget_left = this.source.offsetLeft + (this.source.offsetWidth / 2) - 175; // center relative to source
    document.querySelector('.helpful-pointer').style.left = '50%';

    if (widget_left < 0) {
      widget_left = Math.min(this.source.offsetLeft, 25); // compensate when centering would cause offscreen pos

      // position arrow
      var arrow_left = this.source.offsetLeft + this.source.offsetWidth / 2 - widget_left;
      document.querySelector('.helpful-pointer').style.left = arrow_left + 'px';
    }

    if (widget_left + 350 > document_w) {
      widget_left = Math.min(this.source.offsetLeft + this.source.offsetWidth - 300, document_w - 25); // compensate when centering would cause offscreen pos

      // position arrow
      var arrow_left = this.source.offsetLeft + this.source.offsetWidth / 2 - widget_left;
      document.querySelector('.helpful-pointer').style.left = arrow_left + 'px';
    }

    this.widget.style.top = widget_top + 'px';
    this.widget.style.left = widget_left + 'px';

    // fill out predefined values
    document.querySelector('#helpful-name').value = this.options.name;
    document.querySelector('#helpful-email').value = this.options.email;

    this.overlay.style.display = 'block';
    this.container.style.display = 'block';
  }

  HelpfulEmbed.prototype.checkTextarea = function () {
    var textarea = document.querySelector('.helpful-embed textarea');

    if (textarea.value.length > 0) {
      if (this.widget.className.indexOf('helpful-textarea-filled') == -1)
        this.widget.className += ' helpful-textarea-filled';
    } else
    {
      this.widget.className = this.widget.className.replace('helpful-textarea-filled', '');
    }
  }

  HelpfulEmbed.prototype.setupEvents = function () {
    var that = this;

    // event listener for closing on overlay click
    document.querySelector('.helpful-overlay').addEventListener('click', function (e) {
      e.stopPropagation();
      helpful_embed.close();
    });

    // event listener to change styles for textarea input
    document.querySelector('.helpful-embed textarea').addEventListener('keyup', function () {
      that.checkTextarea();
    });

    // event listener to continue to next screen
    document.querySelector('.helpful-question-container button').addEventListener('click', function () {
      document.querySelector('.helpful-question-container').style.display = 'none';
      document.querySelector('.helpful-details-container').style.display = 'block';
      that.widget.className = that.widget.className.replace('helpful-textarea-filled', '');
    });

    // event listener to go back to first screen
    document.querySelector('.helpful-back-button').addEventListener('click', function () {
      document.querySelector('.helpful-details-container').style.display = 'none';
      document.querySelector('.helpful-question-container').style.display = 'block';
      that.checkTextarea();
    });

    // event listener to close the screen
    [].forEach.call(document.querySelectorAll('.helpful-close-button'), function (el) {
      el.addEventListener('click', function () {
        helpful_embed.close();
      });
    });

    // event listener to ask another question
    document.querySelector('.helpful-btn-return').addEventListener('click', function () {
      document.querySelector('.helpful-embed textarea').value = '';
      document.querySelector('.helpful-thanks-container').style.display = 'none';
      document.querySelector('.helpful-question-container').style.display = 'block';
      that.checkTextarea();
    });

    // event listener for submiting data
    document.querySelector('.helpful-embed input[type=submit]').addEventListener('click', function (e) {
      var params = 'content='+encodeURIComponent(document.querySelector('#helpful-question').value);
          params += '&email='+encodeURIComponent(document.querySelector('#helpful-name').value + ' <' + document.querySelector('#helpful-email').value + '>')
          params += '&account='+encodeURIComponent(that.options.company)
          params += '&callback=helpful_embed.gotResponse';

      var js_el = document.createElement('script');
      js_el.type = 'text/javascript';
      // js_el.src = 'http://localhost:5000/incoming_message?' + params; // DEV
      js_el.src = '//helpful.io/incoming_message?' + params; // PROD

      document.body.appendChild(js_el);
    });
  }

  HelpfulEmbed.prototype.gotResponse = function (data) {
    document.querySelector('.helpful-details-container').style.display = 'none';
    document.querySelector('.helpful-thanks-container').style.display = 'block';
  }

  HelpfulEmbed.prototype.createContainer = function () {
    this.container = document.createElement('div');
    this.container.style.display = 'none';
    this.container.className = 'helpful-container';

    this.overlay = document.createElement('div');
    this.overlay.style.display = 'none';
    this.overlay.className = 'helpful-overlay';

    document.body.appendChild(this.overlay);
    document.body.appendChild(this.container);
  }

  // Opens the embed on top of an element
  HelpfulEmbed.prototype.open = function (source) {
    // set source of the click
    this.source = source;

    this.options = {
      company: source.getAttribute('data-helpful'),
      overlay: source.getAttribute('data-helpful-overlay') != 'off',
      name: source.getAttribute('data-helpful-name') || '',
      email: source.getAttribute('data-helpful-email') || ''
    };

    if (this.loaded)
      return this.showWidget();

    // create container element
    this.createContainer();

    // load css & js
    this.load();
  }

  HelpfulEmbed.prototype.htmlLoaded = function (data) {
    // put loaded html into container
    this.container.innerHTML = data.html;

    // set widget element
    this.widget = document.querySelector('.helpful-embed');

    // show widget
    this.showWidget();

    // setup event handlers
    this.setupEvents();

    this.loaded = true;
  }

  // Closes the embed popup at the target
  HelpfulEmbed.prototype.close = function () {
    this.container.style.display = 'none';
    this.overlay.style.display = 'none';
  }

  // TODO This should be store in the DOM on the target element. That will allow
  // multiple popups to exist on the page. At the moment there's only a singular
  // popup.
  window.helpful_embed = new HelpfulEmbed();

  [].forEach.call(document.querySelectorAll('[data-helpful]'), function (el) {
    el.addEventListener('click', function(e) {
      e.preventDefault();
      e.stopPropagation();
      helpful_embed.open(this);
    });
  });

})();
