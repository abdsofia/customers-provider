require 'rails_helper'

RSpec.describe "imports/new", type: :view do
  before(:each) do
    assign(:import, Import.new(
      :title => "MyString",
      :csv_file => "MyString"
    ))
  end

  it "renders new import form" do
    render

    assert_select "form[action=?][method=?]", imports_path, "post" do

      assert_select "input[name=?]", "import[title]"

      assert_select "input[name=?]", "import[csv_file]"
    end
  end
end
