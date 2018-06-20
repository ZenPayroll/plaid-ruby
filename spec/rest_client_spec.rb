require 'spec_helper.rb'

describe GustoPlaid::RestClient do
  describe 'post_with_retry' do
    it 'retries to post when a timeout error was encountered' do
      expect(GustoPlaid::RestClient).to receive(:post).and_raise(Net::ReadTimeout).ordered
      expect(GustoPlaid::RestClient).to receive(:post).ordered
      GustoPlaid::RestClient.post_with_retry(2, "path", {a: 1})
    end
  end
end
