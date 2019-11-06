require 'rails_helper'

RSpec.describe "imports/index", type: :view do
  before(:each) do
    assign(:imports, [
      Import.create!(
        :title => "Title",
        :csv_file => "Csv File"
      ),
      Import.create!(
        :title => "Title",
        :csv_file => "Csv File"
      )
    ])
  end

  it "renders a list of imports" do
    render
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => "Csv File".to_s, :count => 2
  end
end
