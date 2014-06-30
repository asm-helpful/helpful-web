/** @jsx React.DOM */

var SignUpForm = React.createClass({
  // TODO: duplication: validation
  getInitialState: function(){
    return JSON.parse(this.props.presenter);
  },

  isInvalid: function(){
    return !this.state.accountName || 
      !this.state.email ||
      !this.state.personName ||
      !this.state.password ||
      this.isEmailInvalid() ||
      this.isAccountNameInvalid() ||
      this.isPersonNameInvalid() ||
      this.isPasswordInvalid();
  },

  handleSubmit: function(event){
    // TODO: implement me
    event.preventDefault();
    return false;
  },

  handleAccountNameChange: function(event){
    this.setState({accountName: event.target.value});
  },

  handlePersonNameChange: function(event){
    this.setState({personName: event.target.value});
  },

  handleEmailChange: function(event){
    this.setState({email: event.target.value});
  },

  handlePasswordChange: function(event){
    this.setState({password: event.target.value});
  },

  checkEmail: function(event){
    var email = this.state.email;
    if (email && email.length > 0){
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
            this.setState({isEmailValid: false, emailError: 'taken'});
          }.bind(this)
        });
      } else {
        this.setState({isEmailValid: false, emailError: 'format'});
      }
    } else {
      this.setState({isEmailValid: false, emailError: 'blank'});
    }
  },

  checkAccountName: function(){
    var accountName = this.state.accountName;
    if (accountName && accountName.length > 0){
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
          this.setState({isAccountNameValid: false, accountNameError: 'taken'});
        }.bind(this)
      });
    } else {
      this.setState({isAccountNameValid: false, accountNameError: 'blank'});
    }
  },

  checkPersonName: function(){
    var personName = this.state.personName;
    if (personName && personName.length > 0){
      this.setState({isPersonNameValid: true});
    } else {
      this.setState({isPersonNameValid: false});
    }
  },

  checkPassword: function(){
    var password = this.state.password;
    if (password && password.length > 0){
      if (password.length >= 8){
        this.setState({isPasswordValid: true});
      } else {
        this.setState({isPasswordValid: false, passwordError: 'format'});
      }
    } else {
      this.setState({isPasswordValid: false, passwordError: 'blank'});
    }
  },

  isAccountNameInvalid: function(){
    return this.state.isAccountNameValid == false;
  },

  isPersonNameInvalid: function(){
    return this.state.isPersonNameValid == false;
  },

  isEmailInvalid: function(){
    return this.state.isEmailValid == false;
  },

  isPasswordInvalid: function(){
    return this.state.isPasswordValid == false;
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

  renderCompanyValidationText: function(){
    if (!this.isAccountNameInvalid() && this.state.accountName)
      return (<span className="help-block"> Your sweet profile URL will be <b>http://helpful.io/{ this.state.accountName }</b></span>)

    var reason = this.state.accountNameError;
    if (reason == 'taken'){
      return (<span className="help-block"> That company name has already been taken.  Please choose a unique name so we can give you a Helpful.io URL. </span>)
    } else if (reason == 'blank') {
      return (<span className="help-block"> Company name can't be blank.</span>)
    }
  },

  renderCompanyValidationIcon: function(){
    var classNames = React.addons.classSet({
      'glyphicon': true,
      'glyphicon-ok form-control-feedback': this.state.isAccountNameValid,
      'glyphicon-remove form-control-feedback': this.isAccountNameInvalid()
    });
    return <span className={ classNames }></span>
  },

  renderCompanyValidation: function(){
    return (
      <div>
        { this.renderCompanyValidationText() }
        { this.renderCompanyValidationIcon() }
      </div>
    )
  },

  renderCompanyName: function(){
    var classNames = React.addons.classSet({
      'form-group': true,
      'has-feedback has-success': this.state.isAccountNameValid,
      'has-feedback has-error': this.isAccountNameInvalid()
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

  renderPersonNameValidationIcon: function(){
    var classNames = React.addons.classSet({
      'glyphicon': true,
      'glyphicon-ok form-control-feedback': this.state.isPersonNameValid,
      'glyphicon-remove form-control-feedback': this.isPersonNameInvalid()
    });
    return <span className={ classNames }></span>
  },

  renderPersonNameValidationText: function(){
    if (!(this.isPersonNameInvalid()))
      return

    return (<span className='help-block'> Full name can't be blank. </span>)
  },

  renderPersonNameValidation: function(){
    return (
      <div>
        { this.renderPersonNameValidationText() }
        { this.renderPersonNameValidationIcon() }
      </div>
    )
  },

  renderPersonName: function(){
    var classNames = React.addons.classSet({
      'form-group': true,
      'has-feedback has-success': this.state.isPersonNameValid,
      'has-feedback has-error': this.isPersonNameInvalid()
    });
    return (
      <div className="row">
        <div className="col-md-12">
          <div className={ classNames }>
            {/* TODO: locale is missing  */}
            <label className="control-label" htmlFor="person_name">Full name</label>
            <input className="form-control" id="person_name" name="person[name]" required="required"
              type="text" autoComplete="off" onChange={ this.handlePersonNameChange }
              onBlur={ this.checkPersonName }/>

            { this.renderPersonNameValidation() }
          </div>
        </div>
      </div>
    )
  },

  renderEmailValidationIcon: function(){
    var classNames = React.addons.classSet({
      'glyphicon': true,
      'glyphicon-ok form-control-feedback': this.state.isEmailValid,
      'glyphicon-remove form-control-feedback': this.isEmailInvalid()
    });
    return <span className={ classNames }></span>
  },

  renderEmailValidationText: function(){
    if (!(this.isEmailInvalid()))
      return

    if (this.state.emailError == 'format'){
      return (<span className='help-block'> Email is in incorrect format, it doesn't contain '@'. </span>)
    } else if (this.state.emailError == 'taken') {
      return (<span className='help-block'> Email is already taken. </span>)
    } else {
      return (<span className='help-block'> Email can't be blank. </span>)
    }
  },

  renderEmailValidation: function(){
    return (
      <div>
        { this.renderEmailValidationText() }
        { this.renderEmailValidationIcon() }
      </div>
    )
  },

  renderEmail: function(){
    var classNames = React.addons.classSet({
      'form-group': true,
      'has-feedback has-success': this.state.isEmailValid,
      'has-feedback has-error': this.isEmailInvalid()
    });
    return (
              <div className="row">
                <div className="col-md-12">
                  <div className={ classNames }>
                    {/* TODO: locale is missing  */}
                    <label className="control-label" htmlFor="user_email">Email address</label>
                    <input className="form-control" id="user_email" name="user[email]" required="required"
                           autoComplete="off" onBlur={ this.checkEmail } onChange={ this.handleEmailChange }/>

                    { this.renderEmailValidation() }
                  </div>
                </div>
              </div>
    )
  },

  renderPasswordValidationIcon: function(){
    var classNames = React.addons.classSet({
      'glyphicon': true,
      'glyphicon-ok form-control-feedback': this.state.isPasswordValid,
      'glyphicon-remove form-control-feedback': this.isPasswordInvalid()
    });
    return <span className={ classNames }></span>
  },

  renderPasswordValidationText: function(){
    if (this.state.isPasswordValid == true)
      return

    if (this.state.passwordError == 'blank'){
      return (<span className='help-block'> Password can't be blank. </span>)
    } else {
      return (<span className='help-block'> Your password must be at least 8 characters.</span>)
    }
  },

  renderPasswordValidation: function(){
    return (
      <div>
        { this.renderPasswordValidationText() }
        { this.renderPasswordValidationIcon() }
      </div>
    )
  },


  renderPassword: function(){
    var classNames = React.addons.classSet({
      'form-group': true,
      'has-feedback has-success': this.state.isPasswordValid,
      'has-feedback has-error': this.isPasswordInvalid()
    });
    return (
              <div className="row">
                <div className="col-md-12">
                  <div className={ classNames }>
                    {/* TODO: locale is missing  */}
                    <label className="control-label" htmlFor="user_password">Password</label>
                    <input className="form-control" id="user_password"
                           name="user[password]" pattern=".{8,}" 
                           placeholder="Pretend you're a spy. Make it a good one"
                           required="required" title="Make sure you use at least 8 characters"
                           type="password" autoComplete="off" onChange={ this.handlePasswordChange } 
                           onBlur={ this.checkPassword }/>

                    { this.renderPasswordValidation() }
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

              { this.renderPersonName() }
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
              accept-charset="UTF-8" method="post" onSubmit={ this.handleSubmit }
              autocomplete="off">

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
