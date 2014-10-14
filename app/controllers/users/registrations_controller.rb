class Users::RegistrationsController < Devise::RegistrationsController
  def destroy
      resource.destroy
      Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
      set_flash_message :notice, :destroyed if is_flashing_format?
      yield resource if block_given?
      redirect_to after_sign_out_path_for(resource_name)
    end
end
