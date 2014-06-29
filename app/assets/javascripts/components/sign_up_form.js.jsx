/** @jsx React.DOM */

var SignUpForm = React.createClass({
  getInitialState: function(){
    return JSON.parse(this.props.presenter);
  },

  render: function () {
    return (
      <div>
        {/* TODO: locale is missing */}
        <h1>Welcome to Helpful</h1>

        <form ref="form" className="new_account" action={ this.state.form.action }
              accept-charset="UTF-8" method="post">

          <div style={{"display": "none"}}>
            <input type="hidden" name={ this.state.form.csrf_param }
                   value={ this.state.form.csrf_token }/>
            <input name="utf8" type="hidden" value="✓"/>
          </div>

          {/* TODO: locale is missing */}
          <h2>Sign Up for a Free Account</h2>

          {/* TODO: locale is missing */}
          <p>We'll get your company and personal information setup so you can be ready to answer those support requests and make some customers happy.</p>

          <fieldset>
            <div className="row">
              <div className="col-md-12">
                <div className="form-group">
                  <label className='control-label' htmlFor='account_name'>
                     { this.state.translations.company_name }
                  </label>
                  <input autofocus="autofocus" className="form-control"
                         name="account[name]" id="account_name"
                         required="required" type="text"
                  />
                </div>
              </div>
            </div>
          </fieldset>

          {/* TODO: (vanstee) Add support for linking social accounts, prefilling info, and uploading avatars here

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

          */}

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

          <fieldset>
            {/*  TODO: locale is missing */}
            <h2>Clearly this isn't your first rodeo</h2>

            {/* TODO: locale is missing */}
            <p>Your support experience is about to change for the better</p>

            <div className="form-group">
              {/* TODO: locale is missing */}
              <input className="btn btn-primary"
                     name="commit" type="submit"
                     value="Sign up and start inviting your team!"/>
            </div>

          </fieldset>
        </form>
      </div>
    )
  }
});
