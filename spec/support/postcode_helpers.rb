module PostcodeHelpers
  def stub_hackney_postcode_search!
    stub_request(:get, 'https://api.postcodes.io/postcodes/E33NN')
      .to_return(
        status: 200,
        body: IO.read(Rails.root.join('spec/fixtures/postcode_search.json'))
      )
  end

  def stub_ops_postcode_search!
    stub_request(:get, 'https://api.postcodes.io/postcodes/MK429AB')
      .to_return(
        status: 200,
        body: IO.read(Rails.root.join('spec/fixtures/ops_postcode_search.json'))
      )
  end
end
