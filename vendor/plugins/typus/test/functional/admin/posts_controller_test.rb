require "test_helper"

class Admin::PostsControllerTest < ActionController::TestCase

  setup do
    @typus_user = Factory(:typus_user)
    @request.session[:typus_user_id] = @typus_user.id
    @post = Factory(:post)
  end

  teardown do
    Post.delete_all
    TypusUser.delete_all
  end

  ##############################################################################
  #
  ##############################################################################

  context "CRUD" do

    should "render index" do
      get :index
      assert_response :success
      assert_template 'index'
    end

    should "render new" do
      get :new
      assert_response :success
      assert_template 'new'
    end

    should "create" do
      assert_difference('Post.count') do
        post :create, { :post => { :title => 'This is another title', :body => 'Body' } }
        assert_response :redirect
        assert_redirected_to :controller => '/admin/posts', :action => 'edit', :id => Post.last
      end
    end

    should "render show" do
      get :show, { :id => @post.id }
      assert_response :success
      assert_template 'show'
    end

    should "render edit" do
      get :edit, { :id => @post.id }
      assert_response :success
      assert_template 'edit'
    end

    should "update" do
      post :update, { :id => @post.id, :title => 'Updated' }
      assert_response :redirect
      assert_redirected_to :controller => '/admin/posts', :action => 'edit', :id => @post.id
    end

  end

  context "Forms" do

    setup do
      get :new
    end

    should "verify forms" do
      assert_select "form"
    end

    # We have 3 inputs: 1 hidden which is the UTF8 stuff, one which is the 
    # Post#title and finally the submit button.
    should "have 3 inputs" do
      assert_select "form input", 3

      # Post#title: Input
      assert_select 'label[for="post_title"]'
      assert_select 'input#post_title[type="text"]'
    end

    should "have 1 textarea" do
      assert_select "form textarea", 1

      # Post#body: Text Area
      assert_select 'label[for="post_body"]'
      assert_select 'textarea#post_body'
    end

    should "have 6 selectors" do
      assert_select "form select", 6

      # Post#created_at: Datetime
      assert_select 'label[for="post_created_at"]'
      assert_select 'select#post_created_at_1i'
      assert_select 'select#post_created_at_2i'
      assert_select 'select#post_created_at_3i'
      assert_select 'select#post_created_at_4i'
      assert_select 'select#post_created_at_5i'

      # Post#status: Selector
      assert_select 'label[for="post_status"]'
      assert_select 'select#post_status'
    end

    should "have 1 template" do
      assert_match "templates#datepicker_template_published_at", @response.body
    end

  end

  context "Overwrite action_after_save" do

    setup do
      Typus::Resources.expects(:action_after_save).returns("index")
    end

    should "create an item and redirect to index" do
      assert_difference('Post.count') do
        post :create, { :post => { :title => 'This is another title', :body => 'Body' } }
        assert_response :redirect
        assert_redirected_to :action => 'index'
      end
    end

    should "update an item and redirect to index" do
      post :update, { :id => Factory(:post).id, :title => 'Updated' }
      assert_response :redirect
      assert_redirected_to :action => 'index'
    end

  end

  context "Formats" do

    should "render index and return xml" do
      expected = <<-RAW
<?xml version="1.0" encoding="UTF-8"?>
<posts type="array">
  <post>
    <title>#{@post.title}</title>
    <status>#{@post.status}</status>
  </post>
</posts>
      RAW

      get :index, :format => "xml"

      assert_response :success
      assert_equal expected, @response.body
    end

    should "render index and return csv" do
      expected = <<-RAW
title;status
#{@post.title};#{@post.status}
       RAW

      get :index, :format => "csv"

      assert_response :success
      assert_equal expected, @response.body
    end

  end

  context "Permissions" do

    context "Root" do

      setup do
        editor = Factory(:typus_user, :email => "editor@example.com", :role => "editor")
        @post = Factory(:post, :typus_user => editor)
      end

      should "verify_root_can_edit_any_record" do
        Post.all.each do |post|
          get :edit, { :id => post.id }
          assert_response :success
          assert_template 'edit'
        end
      end

      should "verify_admin_updating_an_item_does_not_change_typus_user_id_if_not_defined" do
        post :update, { :id => @post.id, :post => { :title => 'Updated by admin' } }
        post_updated = Post.find(@post.id)
        assert_equal @post.typus_user_id, post_updated.typus_user_id
      end

      should "verify_admin_updating_an_item_does_change_typus_user_id_to_whatever_admin_wants" do
        post :update, { :id => @post.id, :post => { :title => 'Updated', :typus_user_id => 108 } }
        post_updated = Post.find(@post.id)
        assert_equal 108, post_updated.typus_user_id
      end

    end

    context "No root" do

      setup do
        @typus_user = Factory(:typus_user, :email => "editor@example.com", :role => "editor")
        @request.session[:typus_user_id] = @typus_user.id
        @request.env['HTTP_REFERER'] = '/admin/posts'
      end

      should "not be root" do
        assert @typus_user.is_not_root?
      end

      should "verify_editor_can_show_any_record" do
        Post.all.each do |post|
          get :show, { :id => post.id }
          assert_response :success
          assert_template 'show'
        end
      end

      should "verify_editor_tried_to_edit_a_post_owned_by_himself" do
        post_ = Factory(:post, :typus_user => @typus_user)
        get :edit, { :id => post_.id }
        assert_response :success
      end

      should "verify_editor_tries_to_edit_a_post_owned_by_the_admin" do
        get :edit, { :id => Factory(:post).id }

        assert_response :redirect
        assert_redirected_to @request.env['HTTP_REFERER']
        assert_equal "You don't have permission to access this item.", flash[:alert]
      end

      should "verify_editor_tries_to_show_a_post_owned_by_the_admin" do
        get :show, { :id => Factory(:post).id }
        assert_response :success
      end

      should "verify_editor_tries_to_show_a_post_owned_by_the_admin whe only user items" do
        Typus::Resources.expects(:only_user_items).returns(true)
        post = Factory(:post)
        get :show, { :id => post.id }

        assert_response :redirect
        assert_redirected_to @request.env['HTTP_REFERER']
        assert_equal "You don't have permission to access this item.", flash[:alert]
      end

      should "verify_typus_user_id_of_item_when_creating_record" do
        post :create, { :post => { :title => "Chunky Bacon", :body => "Lorem ipsum ..." } }
        post_ = Post.find_by_title("Chunky Bacon")

        assert_equal @request.session[:typus_user_id], post_.typus_user_id
      end

      should "verify_editor_updating_an_item_does_not_change_typus_user_id" do
        [ 108, nil ].each do |typus_user_id|
          post_ = Factory(:post, :typus_user => @typus_user)
          post :update, { :id => post_.id, :post => { :title => 'Updated', :typus_user_id => @typus_user.id } }
          post_updated = Post.find(post_.id)
          assert_equal  @request.session[:typus_user_id], post_updated.typus_user_id
        end
      end

    end

  end

  context "Roles" do

    setup do
      @request.env['HTTP_REFERER'] = '/admin/posts'
    end

    context "Admin" do

      should "be able to add posts" do
        assert @typus_user.can?("create", "Post")
      end

      should "be able to destroy posts" do
        get :destroy, { :id => Factory(:post).id, :method => :delete }

        assert_response :redirect
        assert_equal "Post successfully removed.", flash[:notice]
        assert_redirected_to :action => :index
      end

    end

    context "Designer" do

      setup do
        Typus.user_class.delete_all
        @designer = Factory(:typus_user, :role => "designer")
        @request.session[:typus_user_id] = @designer.id
        @post = Factory(:post)
      end

      should "not be able to add posts" do
        get :new

        assert_response :redirect
        assert_equal "Designer is not able to perform this action. (new)", flash[:notice]
        assert_redirected_to :action => :index
      end

      should "not_be_able_to_destroy_posts" do
        assert_no_difference('Post.count') do
          get :destroy, { :id => @post.id, :method => :delete }
        end
        assert_response :redirect
        assert_equal "You don't have permission to access this item.", flash[:alert]
        assert_redirected_to :action => :index
      end

    end

  end

  context "Relationships" do

    ##
    # Post => has_many :comments
    ##

    should "relate_comment_with_post_and_then_unrelate" do

      comment = Factory(:comment, :post => nil)
      post_ = Factory(:post)
      @request.env['HTTP_REFERER'] = "/admin/posts/edit/#{post_.id}#comments"

      assert_difference('post_.comments.count') do
        post :relate, { :id => post_.id,
                        :related => { :model => 'Comment', :id => comment.id } }
      end

      assert_response :redirect
      assert_redirected_to @request.env['HTTP_REFERER']
      assert_equal "Comment related to Post", flash[:notice]

      assert_difference('post_.comments.count', -1) do
        post :unrelate, { :id => post_.id,
                          :resource => 'Comment', :resource_id => comment.id }
      end

      assert_response :redirect
      assert_redirected_to @request.env['HTTP_REFERER']
      assert_equal "Comment unrelated from Post", flash[:notice]

    end

    ##
    # Post => has_and_belongs_to_many :categories
    ##

    should "relate_category_with_post_and_then_unrelate" do
      category = Factory(:category)
      post_ = Factory(:post)
      @request.env['HTTP_REFERER'] = "/admin/posts/edit/#{post_.id}#categories"

      ##
      # First Step: Relate
      #

      assert_difference('category.posts.count') do
        post :relate, { :id => post_.id, :related => { :model => 'Category', :id => category.id } }
      end

      assert_response :redirect
      assert_redirected_to @request.env['HTTP_REFERER']
      assert_equal "Category related to Post", flash[:notice]

      ##
      # Second Step: Unrelate
      #

      assert_difference('category.posts.count', -1) do
        post :unrelate, { :id => post_.id, :resource => 'Category', :resource_id => category.id }
      end

      assert_response :redirect
      assert_redirected_to @request.env['HTTP_REFERER']
      assert_equal "Category unrelated from Post", flash[:notice]
    end

    ##
    # Post => has_many :assets, :as => resource (Polimorphic)
    ##

    should "relate_asset_with_post_and_then_unrelate" do
      post_ = Factory(:post)
      asset = Factory(:asset)
      post_.assets << asset

      @request.env['HTTP_REFERER'] = "/admin/posts/edit/#{post_.id}#assets"

      assert_difference('post_.assets.count', -1) do
        get :unrelate, { :id => post_.id, :resource => 'Asset', :resource_id => asset.id }
      end
      assert_response :redirect
      assert_redirected_to @request.env['HTTP_REFERER']
      assert_equal "Asset unrelated from Post", flash[:notice]
    end

  end

  context "Views" do

    context "Index" do

      setup do
        get :index
      end

      should "render index and validates_presence_of_custom_partials" do
        assert_match "posts#_index.html.erb", @response.body
      end

      should "render_index_and_verify_page_title" do
        assert_select "title", "Posts"
      end

      should "render index_and_show_add_entry_link" do
        assert_select "#sidebar ul" do
          assert_select "li", "Add new"
        end
      end

      should "render_index_and_show_trash_item_image" do
        assert_response :success
        assert_select '.trash', 'Trash'
      end

    end

    context "New" do

      setup do
        get :new
      end

      should "render new and partials_on_new" do
        assert_match "posts#_new.html.erb", @response.body
      end

      should "render new and verify page title" do
        assert_select "title", "New Post"
      end

    end

    context "Edit" do

      setup do
        get :edit, { :id => Factory(:post).id }
      end

      should "render_edit_and_verify_presence_of_custom_partials" do
        assert_match "posts#_edit.html.erb", @response.body
      end

      should "render_edit_and_verify_page_title" do
        assert_select "title", "Edit Post"
      end

    end

    context "Show" do

      setup do
        get :show, { :id => Factory(:post).id }
      end

      should "render_show_and_verify_presence_of_custom_partials" do
        assert_match "posts#_show.html.erb", @response.body
      end

      should "render_show_and_verify_page_title" do
        assert_select "title", "Show Post"
      end

    end

    should "get_index_and_render_edit_or_show_links" do
      %w(edit show).each do |action|
        Typus::Resources.expects(:default_action_on_item).at_least_once.returns(action)
        get :index
        Post.all.each do |post|
          assert_match "/posts/#{action}/#{post.id}", @response.body
        end
      end
    end

    context "Designer" do

      setup do
        @typus_user = Factory(:typus_user, :email => "designer@example.com", :role => "designer")
        @request.session[:typus_user_id] = @typus_user.id
      end

      should "render_index_and_not_show_add_entry_link" do
        get :index
        assert_response :success
        assert_no_match /Add Post/, @response.body
      end

      should "render_index_and_not_show_trash_image" do
        get :index
        assert_response :success
        assert_select ".trash", false
      end

    end

    context "Editor" do

      setup do
        @typus_user = Factory(:typus_user, :email => "editor@example.com", :role => "editor")
        @request.session[:typus_user_id] = @typus_user.id
      end

      should "get_index_and_render_edit_or_show_links_on_owned_records" do
        get :index
        Post.all.each do |post|
          action = post.owned_by?(@typus_user) ? "edit" : "show"
          assert_match "/posts/#{action}/#{post.id}", @response.body
        end
      end

      should "get_index_and_render_edit_or_show_on_only_user_items" do
        %w(edit show).each do |action|
          Typus::Resources.stubs(:only_user_items).returns(true)
          Typus::Resources.stubs(:default_action_on_item).returns(action)
          get :index
          Post.all.each do |post|
            if post.owned_by?(@typus_user)
              assert_match "/posts/#{action}/#{post.id}", @response.body
            else
              assert_no_match /\/posts\/#{action}\/#{post.id}/, @response.body
            end
          end
        end
      end

    end

  end

end
