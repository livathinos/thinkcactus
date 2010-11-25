require "test_helper"

class ActiveRecordTest < ActiveSupport::TestCase

  context "model_fields" do

    should "be an ActiveSupport::OrderedHash" do
      assert TypusUser.model_fields.instance_of?(ActiveSupport::OrderedHash)
    end

    should "verify TypusUser model_fields" do
      expected_fields = [[:id, :integer],
                         [:first_name, :string],
                         [:last_name, :string],
                         [:role, :string],
                         [:email, :string],
                         [:status, :boolean],
                         [:token, :string],
                         [:salt, :string],
                         [:crypted_password, :string],
                         [:preferences, :string],
                         [:created_at, :datetime],
                         [:updated_at, :datetime]]
      assert_equal expected_fields.map { |i| i.first }, TypusUser.model_fields.keys
      assert_equal expected_fields.map { |i| i.last }, TypusUser.model_fields.values
    end

    should "verify Post model_fields" do
      expected_fields = [[:id, :integer],
                         [:title, :string],
                         [:body, :text],
                         [:status, :string],
                         [:favorite_comment_id, :integer],
                         [:created_at, :datetime],
                         [:updated_at, :datetime],
                         [:published_at, :datetime],
                         [:typus_user_id, :integer]]
      assert_equal expected_fields.map { |i| i.first }, Post.model_fields.keys
      assert_equal expected_fields.map { |i| i.last }, Post.model_fields.values
    end

  end

  context "model_relationships" do

    should "be an ActiveSupport::OrderedHash" do
      assert TypusUser.model_relationships.instance_of?(ActiveSupport::OrderedHash)
    end

    should "verify Post model_relationships" do
      expected = [[:comments, :has_many],
                  [:categories, :has_and_belongs_to_many],
                  [:user, nil],
                  [:assets, :has_many]]
      expected.each do |i|
        assert_equal i.last, Post.model_relationships[i.first]
      end
    end

  end

  context "typus_description" do

    should "return the description of a model" do
      assert_equal "System Users Administration", TypusUser.typus_description
    end

  end

  context "typus_fields_for" do

    should "accept strings" do
      assert_equal %w(email role status), TypusUser.typus_fields_for("list").keys
    end

    should "accept symbols" do
      assert_equal %w(email role status), TypusUser.typus_fields_for(:list).keys
    end

    should "return list fields for TypusUser" do
      expected_fields = [["email", :string],
                         ["role", :selector],
                         ["status", :boolean]]
      assert_equal expected_fields.map { |i| i.first }, TypusUser.typus_fields_for(:list).keys
      assert_equal expected_fields.map { |i| i.last }, TypusUser.typus_fields_for(:list).values
    end

    should "return form fields for TypusUser" do
      expected_fields = [["first_name", :string],
                         ["last_name", :string],
                         ["role", :selector],
                         ["email", :string],
                         ["password", :password],
                         ["password_confirmation", :password],
                         ["language", :selector]]
      assert_equal expected_fields.map { |i| i.first }, TypusUser.typus_fields_for(:form).keys
      assert_equal expected_fields.map { |i| i.last }, TypusUser.typus_fields_for(:form).values
    end

    should "return form fields for Picture" do
      expected_fields = [["title", :string], ["picture", :file]]
      assert_equal expected_fields.map { |i| i.first }, Picture.typus_fields_for(:form).keys
      assert_equal expected_fields.map { |i| i.last }, Picture.typus_fields_for(:form).values
    end

    should "return form fields for a Model without configuration" do
      assert Class.new(ActiveRecord::Base).typus_fields_for(:form).empty?
    end

    should "return relationship fields for TypusUser" do
      assert_equal %w(first_name last_name role email language), TypusUser.typus_fields_for(:relationship).keys
    end

    should "return undefined fields for TypusUser" do
      assert_equal %w(first_name last_name role email language), TypusUser.typus_fields_for(:undefined).keys
    end

  end

  context "typus_filters" do

    should "return filters for TypusUser" do
      expected = [["status", :boolean], ["role", :string]]
      assert_equal expected.map { |i| i.first }.join(", "), Typus::Configuration.config["TypusUser"]["filters"]
      assert_equal expected.map { |i| i.first }, TypusUser.typus_filters.keys
      assert_equal expected.map { |i| i.last }, TypusUser.typus_filters.values
    end

    should "return filters for Post" do
      expected = [["status", :string], ["created_at", :datetime]]
      assert_equal expected.map { |i| i.first }.join(", "), Typus::Configuration.config["Post"]["filters"]
      assert_equal expected.map { |i| i.first }, Post.typus_filters.keys
      assert_equal expected.map { |i| i.last }, Post.typus_filters.values
    end

  end

  context "typus_actions_on" do

    should "accept strings" do
      assert_equal %w(cleanup), Post.typus_actions_on("index")
    end

    should "accept symbols" do
      assert_equal %w(cleanup), Post.typus_actions_on(:index)
    end

    should "return actions on list for TypusUser" do
      assert TypusUser.typus_actions_on(:list).empty?
    end

    should "return actions on edit for Post" do
      assert_equal %w(send_as_newsletter preview), Post.typus_actions_on(:edit)
    end

  end

  context "typus_options_for" do

    should "accept strings" do
      assert_equal 15, Post.typus_options_for("form_rows")
    end

    should "accept symbols" do
      assert_equal 15, Post.typus_options_for(:form_rows)
    end

    should "return nil when options do not exist" do
      assert_nil TypusUser.typus_options_for(:unexisting)
    end

    should "return options for Post" do
      assert_equal 15, Post.typus_options_for(:form_rows)
    end

    should "return options for Page" do
      assert_equal 25, Page.typus_options_for(:form_rows)
    end

    should "return sortable options as a boolean" do
      assert Post.typus_options_for(:sortable)
      assert !Page.typus_options_for(:sortable)
    end

  end

  context "typus_application" do

    should "return application for Post" do
      assert_equal "Blog", Post.typus_application
    end

    should "return application for View" do
      assert_equal "Unknown", View.typus_application
    end

  end

  context "typus_field_options_for" do

    should "verify on models" do
      assert_equal [:status], Post.typus_field_options_for(:selectors)
      assert_equal [:permalink], Post.typus_field_options_for(:read_only)
      assert_equal [:created_at], Post.typus_field_options_for(:auto_generated)
      assert_equal [], Post.typus_field_options_for(:unexisting)
    end

  end

  context "typus_boolean" do

    should "accept strings" do
      expected = {"Inactive"=>"false", "Active"=>"true"}
      assert_equal expected, TypusUser.typus_boolean("status")
    end

    should "accept symbols" do
      expected = {"Inactive"=>"false", "Active"=>"true"}
      assert_equal expected, TypusUser.typus_boolean(:status)
    end

    should "return booleans for Post" do
      expected = {"True" => "true", "False" => "false"}
      assert_equal expected, Post.typus_boolean(:status)
    end

    should "return booleans for Comment" do
      expected = {"No, its not spam" => "false", "Yes, its spam" => "true"}
      assert_equal expected, Comment.typus_boolean(:spam)
    end

  end

  context "typus_date_format" do

    should "accept strings" do
      assert_equal :default, Post.typus_date_format("unknown")
    end

    should "accept symbols" do
      assert_equal :default, Post.typus_date_format(:unknown)
    end

    should "return date_format for Post" do
      assert_equal :default, Post.typus_date_format
      assert_equal :short, Post.typus_date_format(:created_at)
    end

  end

  context "typus_template" do

    should "accept strings" do
      assert_equal "datepicker", Post.typus_template("published_at")
    end

    should "accept symbols" do
      assert_equal "datepicker", Post.typus_template(:published_at)
    end

    should "return nil if template does not exist" do
      assert_nil Post.typus_template(:created_at)
    end

  end

  context "typus_defaults_for" do

    should "accept strings" do
      assert_equal %w(title), Post.typus_defaults_for("search")
    end

    should "accepts symbols" do
      assert_equal %w(title), Post.typus_defaults_for(:search)
    end

    should "return default_for relationships on Post" do
      assert_equal %w(assets categories comments views), Post.typus_defaults_for(:relationships)
    end

  end

  context "typus_search_fields" do

    should "return a hash with the search modifiers" do
      search = ["=id", "^title", "body"]
      Post.stubs(:typus_defaults_for).with(:search).returns(search)
      expected = {"body"=>"@", "title"=>"^", "id"=>"="}
      assert_equal expected, Post.typus_search_fields
    end

    should "return and empty hash" do
      search = []
      Post.stubs(:typus_defaults_for).with(:search).returns(search)
      expected = {}
      assert_equal expected, Post.typus_search_fields
    end

  end

  context "typus_export_formats" do

    should "return post formats" do
      assert_equal ["csv", "xml"], Post.typus_export_formats
    end

    should "return picture formats" do
      assert_equal [], Picture.typus_export_formats
    end

  end

  context "typus_order_by" do

    should "return defaults_for order_by on Post" do
      assert_equal "posts.title ASC, posts.created_at DESC", Post.typus_order_by
      assert_equal %w(title -created_at), Post.typus_defaults_for(:order_by)
    end

  end

  context "build_conditions" do

    should "generate conditions for id" do
      Post.stubs(:typus_defaults_for).with(:search).returns(["id"])

      params = { :search => '1' }
      expected = "(`posts`.id LIKE '%1%')"

      assert_equal expected, Post.build_conditions(params).first
    end

    should "generate conditions for fields starting with equal" do
      Post.stubs(:typus_defaults_for).with(:search).returns(["=id"])

      params = { :search => '1' }
      expected = "(`posts`.id LIKE '1')"

      assert_equal expected, Post.build_conditions(params).first
    end

    should "generate conditions for fields starting with ^" do
      Post.stubs(:typus_defaults_for).with(:search).returns(["^id"])

      params = { :search => '1' }
      expected = "(`posts`.id LIKE '1%')"

      assert_equal expected, Post.build_conditions(params).first
    end

    should "return_sql_conditions_on_search_for_typus_user" do
      expected = case ENV["DB"]
                 when /postgresql/
                   "(TEXT(role) LIKE '%francesc%' OR TEXT(last_name) LIKE '%francesc%' OR TEXT(email) LIKE '%francesc%' OR TEXT(first_name) LIKE '%francesc%')"
                 else
                   "(`typus_users`.role LIKE '%francesc%' OR `typus_users`.last_name LIKE '%francesc%' OR `typus_users`.email LIKE '%francesc%' OR `typus_users`.first_name LIKE '%francesc%')"
                end

      params = { :search => "francesc" }
      assert_equal expected, TypusUser.build_conditions(params).first
      params = { :search => "Francesc" }
      assert_equal expected, TypusUser.build_conditions(params).first
    end

    should "return_sql_conditions_on_search_and_filter_for_typus_user" do
      case ENV["DB"]
      when /mysql/
        boolean_true = "(`typus_users`.`status` = 1)"
        boolean_false = "(`typus_users`.`status` = 0)"
      else
        boolean_true = "(\"typus_users\".\"status\" = 't')"
        boolean_false = "(\"typus_users\".\"status\" = 'f')"
      end

      expected = "((`typus_users`.role LIKE '%francesc%' OR `typus_users`.last_name LIKE '%francesc%' OR `typus_users`.email LIKE '%francesc%' OR `typus_users`.first_name LIKE '%francesc%')) AND #{boolean_true}"

      params = { :search => "francesc", :status => "true" }
      assert_equal expected, TypusUser.build_conditions(params).first
      params = { :search => "francesc", :status => "false" }
      assert_match /#{boolean_false}/, TypusUser.build_conditions(params).first
    end

    should "return_sql_conditions_on_filtering_typus_users_by_status" do
      case ENV["DB"]
      when /mysql/
        boolean_true = "(`typus_users`.`status` = 1)"
        boolean_false = "(`typus_users`.`status` = 0)"
      else
        boolean_true = "(\"typus_users\".\"status\" = 't')"
        boolean_false = "(\"typus_users\".\"status\" = 'f')"
      end

      params = { :status => "true" }
      assert_equal boolean_true, TypusUser.build_conditions(params).first
      params = { :status => "false" }
      assert_equal boolean_false, TypusUser.build_conditions(params).first
    end

    should "return_sql_conditions_on_filtering_typus_users_by_created_at today" do
      expected = "(`typus_users`.created_at BETWEEN '#{Time.zone.now.beginning_of_day.to_s(:db)}' AND '#{Time.zone.now.beginning_of_day.tomorrow.to_s(:db)}')"
      params = { :created_at => "today" }
      assert_equal expected, TypusUser.build_conditions(params).first
    end

    should "return_sql_conditions_on_filtering_typus_users_by_created_at last_few_days" do
      expected = "(`typus_users`.created_at BETWEEN '#{3.days.ago.beginning_of_day.to_s(:db)}' AND '#{Time.zone.now.beginning_of_day.tomorrow.to_s(:db)}')"
      params = { :created_at => "last_few_days" }
      assert_equal expected, TypusUser.build_conditions(params).first
    end

    should "return_sql_conditions_on_filtering_typus_users_by_created_at last_7_days" do
      expected = "(`typus_users`.created_at BETWEEN '#{6.days.ago.beginning_of_day.to_s(:db)}' AND '#{Time.zone.now.beginning_of_day.tomorrow.to_s(:db)}')"
      params = { :created_at => "last_7_days" }
      assert_equal expected, TypusUser.build_conditions(params).first
    end

    should "return_sql_conditions_on_filtering_typus_users_by_created_at last_30_days" do
      expected = "(`typus_users`.created_at BETWEEN '#{Time.zone.now.beginning_of_day.prev_month.to_s(:db)}' AND '#{Time.zone.now.beginning_of_day.tomorrow.to_s(:db)}')"
      params = { :created_at => "last_30_days" }
      assert_equal expected, TypusUser.build_conditions(params).first
    end

    should "return_sql_conditions_on_filtering_posts_by_published_at today" do
      expected = "(`posts`.published_at BETWEEN '#{Time.zone.now.beginning_of_day.to_s(:db)}' AND '#{Time.zone.now.beginning_of_day.tomorrow.to_s(:db)}')"
      params = { :published_at => "today" }
      assert_equal expected, Post.build_conditions(params).first
    end

    should "return_sql_conditions_on_filtering_posts_by_string" do
      expected = case ENV["DB"]
                 when /mysql/
                   "(`typus_users`.`role` = 'admin')"
                 else
                   "(\"typus_users\".\"role\" = 'admin')"
                 end

      params = { :role => "admin" }
      assert_equal expected, TypusUser.build_conditions(params).first
    end

  end

  context "typus_user_id?" do

    should "exist on Post" do
      assert Post.typus_user_id?
    end

    should "not exist on TypusUser" do
      assert !TypusUser.typus_user_id?
    end

  end

  context "read_model_config" do

    should "return data for existing model" do
      expected = {"application"=>"Site", "fields"=>{"default"=>"caption"}}
      assert_equal expected, Asset.read_model_config
    end

    should "raise error when model does not exist on configuration" do
      assert_raises RuntimeError do
        Article.read_model_config
      end
    end

  end

end
