/** @jsx React.DOM */

var SignUpForm = React.createClass({
  getInitialState: function(){
    return JSON.parse(this.props.presenter);
  },

  handleSubmit: function(event){
    // TODO: implement me
    event.preventDefault();
    return false;
  },

  handleAccountNameChange: function(event){
    this.setState({accountName: event.target.value});
  },

  checkAccountName: function(){
    var accountName = this.state.accountName;
    if (accountName.length > 0){
      $.ajax({
        type: 'GET',
        url: '/accounts/validate_name',
        data: {name: accountName},
        dataType: 'json',
        contentType: 'application/json',
        accepts: { json: 'application/json' },
        success: function(response) {
          this.setState({accountNameIsValid: true});
        }.bind(this),
        error: function(response) {
          this.setState({accountNameIsValid: false});
        }.bind(this)
      });
    }
  },

  accountNameIsInvalid: function(){
    return this.state.accountNameIsValid == false;
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
    if (this.accountNameIsInvalid()){
      validationMessage = <span className="help-block"> That company name has already been taken.  Please choose a unique name so we can give you a Helpful.io URL. </span>
    } else {
      validationMessage = <span className="help-block"> Your sweet profile URL will be <b>http://helpful.io/{ this.state.accountName }</b></span>
    }
    
    return validationMessage;
  },

  renderCompanyValidationIcon: function(){
    var classNames = React.addons.classSet({
      'glyphicon': true,
      'glyphicon glyphicon-ok form-control-feedback': this.state.accountNameIsValid,
      'glyphicon glyphicon-remove form-control-feedback': this.state.accountNameIsValid == false
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
      'form-group has-feedback has-success': this.state.accountNameIsValid,
      'form-group has-feedback has-error': this.state.accountNameIsValid == false
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

  renderPersonalInfo: function(){
    // TODO: make me DRY
    return (
            <fieldset>
            {/* TODO: locale is missing  */}
            <h2>Personal Information</h2>
              <div className="row">
                <div className="col-md-12">
                  <div className="form-group">
                    {/* TODO: locale is missing  */}
                    <label className="control-label" htmlFor="person_name">Full name</label>
                    <input className="form-control" id="person_name" name="person[name]" required="required" type="text" autoComplete="off"/>
                  </div>
                </div>
              </div>

              <div className="row">
                <div className="col-md-12">
                  <div className="form-group">
                    {/* TODO: locale is missing  */}
                    <label className="control-label" htmlFor="user_email">Email address</label>
                    <input className="form-control" id="user_email" name="user[email]" required="required" type="email" autoComplete="off"/>
                  </div>
                </div>
              </div>

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
          </fieldset>
        )
  },

  renderSubmitArea: function(){
    return (
            <fieldset>
              {/*  TODO: locale is missing */}
              <h2>Clearly this isn't your first rodeo</h2>

              {/* TODO: locale is missing */}
              <p>Your support experience is about to change for the better</p>

              <div className="form-group">
                {/* TODO: locale is missing */}
                <input className="btn btn-primary"
                       name="commit" type="submit"
                       value="Sign up and start inviting your team!"
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
