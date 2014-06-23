module AccountsHelper
  def web_form_code
    %{<form action="#{incoming_message_url}" method="post">
  <input type="hidden" name="account" value="#{@account.slug}">
  <p>
    <label for="email">Email</label><br>
    <input id="email" name="email" type="text">
  </p>
  <p>
    <label for="content">Message</label><br>
    <textarea id="content" name="content" type="text"></textarea>
  </p>

  <input type="submit" value="Submit">
</form>}
  end
end
