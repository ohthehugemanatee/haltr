require File.dirname(__FILE__) + '/../test_helper'
require 'invoices_controller'

# Re-raise errors caught by the controller.
class InvoicesController; def rescue_action(e) raise e end; end

class InvoicesControllerTest < ActionController::TestCase
  fixtures :projects, :enabled_modules, :users, :roles, :members, :invoices

  def setup
    Setting.plugin_haltr = { 'trace_url' => 'loclhost:3000',
                             'export_channels_path' => '/tmp' }

    # user 2 (jsmith) is member of project 2 (onlinesotre)
    # with role 2 (developer)
    Project.find(2).enabled_modules << EnabledModule.new(:name => 'haltr')
    dev = Role.find(2)
    dev.permissions += [:free_use]
    assert dev.save

    @controller = InvoicesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    User.current = nil
 end

  def test_must_redirect_if_not_configured
    @request.session[:user_id] = 2
    get :index, :id => 'onlinestore'
    assert_redirected_to :controller => 'companies', :action => 'index', :id => 'onlinestore'
  end

end