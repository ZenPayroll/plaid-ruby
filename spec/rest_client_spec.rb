require 'spec_helper.rb'

describe Plaid::RestClient do
  describe 'post_with_retry' do
    it 'retries to post when a timeout error was encountered' do
      expect(Plaid::RestClient).to receive(:post).and_raise(Net::ReadTimeout).ordered
      expect(Plaid::RestClient).to receive(:post).ordered
      Plaid::RestClient.post_with_retry(2, "path", {a: 1})
    end
  end
end
