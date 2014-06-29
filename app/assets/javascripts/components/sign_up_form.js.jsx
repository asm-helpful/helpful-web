/** @jsx React.DOM */

var SignUpForm = React.createClass({
  getInitialState: function(){
    return JSON.parse(this.props.presenter);
  },

  isInvalid: function(){
    return !this.state.accountName || 
      !this.state.email ||
      this.isEmailInvalid() ||
      this.isAccountNameInvalid();
  },

  handleSubmit: function(event){
    // TODO: implement me
    event.preventDefault();
    return false;
  },

  handleAccountNameChange: function(event){
    this.setState({accountName: event.target.value});
  },

  handleEmailChange: function(event){
    this.setState({email: event.target.value});
  },

  checkEmail: function(event){
    var email = this.state.email;
    if (email.length > 0){
      if (/@/.test(email)) {
        $.ajax({
          type: 'GET',
          url: this.state.validation_url.email,
          data: {email: email},
          dataType: 'json',
          contentType: 'application/json',
          accepts: { json: 'application/json' },
          success: function(response) {
            this.setState({isEmailValid: true});
          }.bind(this),
          error: function(response) {
            this.setState({isEmailValid: false});
          }.bind(this)
        });
      } else {
        this.setState({isEmailValid: false});
      }
    }
  },

  checkAccountName: function(){
    var accountName = this.state.accountName;
    if (accountName.length > 0){
      $.ajax({
        type: 'GET',
        url: this.state.validation_url.company,
        data: {name: accountName},
        dataType: 'json',
        contentType: 'application/json',
        accepts: { json: 'application/json' },
        success: function(response) {
          this.setState({isAccountNameValid: true});
        }.bind(this),
        error: function(response) {
          this.setState({isAccountNameValid: false});
        }.bind(this)
      });
    }
  },

  isAccountNameInvalid: function(){
    return this.state.isAccountNameValid == false;
  },

  isEmailInvalid: function(){
    return this.state.isEmailValid == false;
  },

  renderTitle: function(){
    // TODO: locale is missing 
    return (
        <h1 className="page-title">Welcome to Helpful</h1>
    )
  },

  renderCSRF: function(){
    return (
      <div style={{"display": "none"}}>
        <input type="hidden" name={ this.state.form.csrf_param }
               value={ this.state.form.csrf_token }/>
        <input name="utf8" type="hidden" value="✓"/>
      </div>
    )
  },

  renderCompanyValidationMessage: function(){
    if (!(this.state.accountName && this.state.accountName.length > 0))
      return

    var validationMessage;
    if (this.isAccountNameInvalid()){
      validationMessage = <span className="help-block"> That company name has already been taken.  Please choose a unique name so we can give you a Helpful.io URL. </span>
    } else {
      validationMessage = <span className="help-block"> Your sweet profile URL will be <b>http://helpful.io/{ this.state.accountName }</b></span>
    }
    
    return validationMessage;
  },

  renderCompanyValidationIcon: function(){
    var classNames = React.addons.classSet({
      'glyphicon': true,
      'glyphicon glyphicon-ok form-control-feedback': this.state.isAccountNameValid,
      'glyphicon glyphicon-remove form-control-feedback': this.isAccountNameInvalid()
    });
    return <span className={ classNames }></span>
  },

  renderCompanyValidation: function(){
    return (
      <div>
        { this.renderCompanyValidationMessage() }
        { this.renderCompanyValidationIcon() }
      </div>
    )
  },

  renderCompanyName: function(){
    var classNames = React.addons.classSet({
      'form-group': true,
      'form-group has-feedback has-success': this.state.isAccountNameValid,
      'form-group has-feedback has-error': this.isAccountNameInvalid()
    });

    return (
      <fieldset>
          {/* TODO: locale is missing */}
          <h2>Sign Up for a Free Account</h2>

          {/* TODO: locale is missing */}
          <p>We'll get your company and personal information setup so you can be ready to answer those support requests and make some customers happy.</p>

          <div className="row">
            <div className="col-md-12">
              <div className={ classNames }>
                <label className='control-label' htmlFor='account_name'>
                   { this.state.translations.company_name }
                </label>

                <input autofocus="autofocus" className="form-control"
                       name="account[name]" id="account_name"
                       required="required" type="text" onBlur={ this.checkAccountName }
                       onChange={ this.handleAccountNameChange }
                />

                { this.renderCompanyValidation() }
              </div>
            </div>
          </div>
      </fieldset>
    )
  },

  renderSocialButtons: function(){
    // TODO: (vanstee) Add support for linking social accounts, prefilling info, and uploading avatars here 
    return (
            <fieldset>

              <h2>Be a real person to your customers</h2>

              <p>Add a face to the name so your customers can relate to a fellow human</p>

              <div class="form-group">

                <button class="btn btn-secondary">
                  <span class="glyphicon glyphicon-user"></span>
                  Upload a Picture
                </button>

                <button class="btn btn-default">
                  <span class="glyphicon fa fa-twitter"></span>
                  Twitter
                </button>

                <button class="btn btn-default">
                  <span class="glyphicon fa fa-facebook"></span>
                  Facebook
                </button>

                <button class="btn btn-default">
                  <span class="glyphicon fa fa-google-plus"></span>
                  Google+
                </button>

              </div>

            </fieldset>
           )
  },

  renderFullName: function(){
    return (
      <div className="row">
        <div className="col-md-12">
          <div className="form-group">
            {/* TODO: locale is missing  */}
            <label className="control-label" htmlFor="person_name">Full name</label>
            <input className="form-control" id="person_name" name="person[name]" required="required"
                   type="text" autoComplete="off"/>
          </div>
        </div>
      </div>
    )
  },

  renderEmailValidationIcon: function(){
    var classNames = React.addons.classSet({
      'glyphicon': true,
      'glyphicon glyphicon-ok form-control-feedback': this.state.isEmailValid,
      'glyphicon glyphicon-remove form-control-feedback': this.isEmailInvalid()
    });
    return <span className={ classNames }></span>
  },

  renderEmail: function(){
    var classNames = React.addons.classSet({
      'form-group': true,
      'form-group has-feedback has-success': this.state.isEmailValid,
      'form-group has-feedback has-error': this.isEmailInvalid()
    });
    return (
              <div className="row">
                <div className="col-md-12">
                  <div className={ classNames }>
                    {/* TODO: locale is missing  */}
                    <label className="control-label" htmlFor="user_email">Email address</label>
                    <input className="form-control" id="user_email" name="user[email]" required="required"
                           autoComplete="off" onBlur={ this.checkEmail } onChange={ this.handleEmailChange }/>

                    { this.renderEmailValidationIcon() }
                  </div>
                </div>
              </div>
    )
  },

  renderPassword: function(){
    return (
              <div className="row">
                <div className="col-md-12">
                  <div className="form-group">
                    {/* TODO: locale is missing  */}
                    <label className="control-label" htmlFor="user_password">Password</label>
                    <input className="form-control" id="user_password"
                           name="user[password]" pattern=".{8,}" 
                           placeholder="Pretend you're a spy. Make it a good one"
                           required="required" title="Make sure you use at least 8 characters"
                           type="password" autoComplete="off"/>

                    <span className="help-block">
                      Your password must be at least 8 characters.
                    </span>
                  </div>
                </div>
              </div>
    )
  },

  renderPersonalInfo: function(){
    return (
            <fieldset>
              {/* TODO: locale is missing  */}
              <h2>Personal Information</h2>

              { this.renderFullName() }
              { this.renderEmail() }
              { this.renderPassword() }
            </fieldset>
           )
  },

  renderSubmitArea: function(){
    var classNames = React.addons.classSet({
      'btn': true,
      'btn-disabled': this.isInvalid(),
      'btn-primary': !this.isInvalid()
    });
    return (
            <fieldset>
              {/*  TODO: locale is missing */}
              <h2>Clearly this isn't your first rodeo</h2>

              {/* TODO: locale is missing */}
              <p>Your support experience is about to change for the better</p>

              <div className="form-group">
                {/* TODO: locale is missing */}
                <input className={ classNames }
                       name="commit" type="submit"
                       value="Sign up and start inviting your team!"
                       disabled= { this.isInvalid() }
                       />
              </div>

            </fieldset>
          )
  },

  renderForm: function(){
    return (
            <form ref="form" className="new_account" action={ this.state.form.action }
                  accept-charset="UTF-8" method="post" onSubmit={ this.handleSubmit }>

              { this.renderCSRF() }
              { this.renderCompanyName() }
              {/* this.renderSocialButtons() */}
              { this.renderPersonalInfo() }
              { this.renderSubmitArea() }

            </form>
           )
  },

  render: function () {
    return (
      <div>
        { this.renderTitle() }
        { this.renderForm()  }
      </div>
    )
  }
});
