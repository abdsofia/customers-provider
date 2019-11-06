require 'rails_helper'

RSpec.describe "imports/show", type: :view do
  before(:each) do
    @import = assign(:import, Import.create!(
      :title => "Title",
      :csv_file => "Csv File"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/Csv File/)
  end
end
