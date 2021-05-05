require "spec_helper"

describe SilencerShop::Inventory do

  let(:options) { { username: '123', password: 'abc' } }
  let(:get_headers) { {
    'Accept'=>'*/*',
    'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
    'Authorization'=>'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6Im5PbzNaRHJPRFhFSzFqS1doWHNsSFJfS1hFZyIsImtpZCI6Im5PbzNaRHJPRFhFSzFqS1doWHNsSFJfS1hFZyJ9.eyJhdWQiOiJodHRwczovL3NpbGVuY2Vyc2hvcHN0YWdpbmcub25taWNyb3NvZnQuY29tL1NpbGVuY2VyU2hvcC5Qb3J0YWwiLCJpc3MiOiJodHRwczovL3N0cy53aW5kb3dzLm5ldC82YzAzZWE4ZC0zMzczLTQ2OTMtYmYyYy0yNWM4NGFiM2VlYmQvIiwiaWF0IjoxNjIwMjM2NzIzLCJuYmYiOjE2MjAyMzY3MjMsImV4cCI6MTYyMDI0MDYyMywiYWlvIjoiRTJaZ1lOak44OVhvTHNOdmI0YjVUK2JuZEYwNUFBQT0iLCJhcHBpZCI6IjgzYTM0NzRhLWZkNjQtNDg1OS05NGYxLWIzMWVhY2MyMDYxMSIsImFwcGlkYWNyIjoiMSIsImlkcCI6Imh0dHBzOi8vc3RzLndpbmRvd3MubmV0LzZjMDNlYThkLTMzNzMtNDY5My1iZjJjLTI1Yzg0YWIzZWViZC8iLCJvaWQiOiIxMGM5Yjk1MS05ODRhLTRhNGItOTMxMi04MDg3MjQxOGU4MDAiLCJyaCI6IjAuQVJVQWplb0RiSE16azBhX0xDWElTclB1dlVwSG80TmtfVmxJbFBHekhxekNCaEVXQUFBLiIsInN1YiI6IjEwYzliOTUxLTk4NGEtNGE0Yi05MzEyLTgwODcyNDE4ZTgwMCIsInRpZCI6IjZjMDNlYThkLTMzNzMtNDY5My1iZjJjLTI1Yzg0YWIzZWViZCIsInV0aSI6ImJrQXVGU3VfWjAtcXJyRkR0ZUp3QlEiLCJ2ZXIiOiIxLjAifQ.oOe-zFHGK78mGex0tbBGp_iOJXzXRSoSuIaXsJlqK6cAw3UUGP8NxfjJRg64KFAOv1L7WyOsosYCgbcpHkP25jLifXdi0lVplPmzFWad_PYojrHraCc5zbPffPaJOdzG_cxYPkFY-csa1zXWp88BjUO0m2yzg96MTkqb1U_mnasHsGPcPMzH9RyoL5Vl2zU5zzxnE8W2K6oEUz9juqLaXtkEDfC3QAThzkAMvH_s-7AP897TRYz3CfKajSRA3jlNSS8xcrfaB_gdFlmXbiV127FpQe8UGZOCV7x36ftNThX8am8pikUc5udNUeu6kj3QJLv2W0G_nwap6jqO42Txhw',
    'User-Agent'=>'SilencerShopRubyGem/1.0.0'
  } }

  before do
    stub_request(:post, "https://login.microsoftonline.com/silencershopstaging.onmicrosoft.com/oauth2/token").
      with(
        body: {"client_id"=>"123", "client_secret"=>"abc", "grant_type"=>"client_credentials", "resource"=>"https://silencershopstaging.onmicrosoft.com/SilencerShop.Portal"},
        headers: {
          'Content-Type'=>'application/x-www-form-urlencoded',
          'User-Agent'=>'SilencerShopRubyGem/1.0.0'
        }
      ).to_return(status: 200, body: FixtureHelper.get_fixture_file('silencer-shop-auth.json').read)

    stub_request(:get, "https://silencershopportaldebug.azurewebsites.net/api/productfeed/availability").
      with(headers: get_headers).to_return(status: 200, body: FixtureHelper.get_fixture_file('silencer-shop-inventory.json').read)
  end

  describe '.all' do
    it 'returns an array of items' do
      items = SilencerShop::Inventory.all(options)

      items.each_with_index do |item, index|
        case index
        when 0
          expect(item[:item_identifier]).to eq('SCO AC87')
          expect(item[:price]).to eq(9.0)
          expect(item[:quantity]).to eq(10)
        when 1
          expect(item[:item_identifier]).to eq('Griffin TMTP')
          expect(item[:price]).to eq(11.0)
          expect(item[:quantity]).to eq(8)
        end
      end

      expect(items.count).to eq(8)
    end
  end

end
