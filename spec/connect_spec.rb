require 'spec_helper'

module Plaid
  class Connect
    describe 'get' do
      before do
        response = double('response', code: 200, body: { 'transactions' => [] })
        allow(Plaid::RestClient).to receive(:post).and_return(response)
      end

      it 'converts gte to ISO8601 format' do
        expect(Plaid::RestClient).to receive(:post).
          with('connect/get', hash_including(options: '{"gte":"2013-04-02"}'))
        Plaid::Connect.get('access-token', gte: DateTime.new(2013, 04, 02, 12, 1, 0))
      end

      it 'does not touch the options that is not date' do
        expect(Plaid::RestClient).to receive(:post).
          with('connect/get', hash_including(options: '{"pending":true}'))
        Plaid::Connect.get('access-token', pending: true)

      end
    end
  end
end
