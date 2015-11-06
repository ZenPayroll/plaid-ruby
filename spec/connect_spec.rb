require 'spec_helper'

module Plaid
  class Connect
    describe 'get' do
      let(:response) { double('response', code: 200, body: {'transactions' => []}) }
      before do
        allow(Plaid::RestClient).to receive(:post).and_return(response)
      end

      it 'converts gte to ISO8601 format' do
        expect(Plaid::RestClient).to receive(:post).
            with('connect/get', hash_including(options: '{"gte":"2013-04-02"}'))
        Plaid::Connect.get('access-token', gte: DateTime.new(2013, 04, 02, 12, 1, 0))
      end

      it 'converts gte from date to ISO8601 format' do
        expect(Plaid::RestClient).to receive(:post).
            with('connect/get', hash_including(options: '{"gte":"2013-04-02"}'))
        Plaid::Connect.get('access-token', gte: Date.new(2013, 04, 02))
      end

      it 'converts gte from time to ISO8601 format' do
        expect(Plaid::RestClient).to receive(:post).
            with('connect/get', hash_including(options: '{"gte":"2013-04-02"}'))
        Plaid::Connect.get('access-token', gte: Time.new(2013, 04, 02, 12, 1, 0))
      end


      it 'does not touch the options that is not date' do
        expect(Plaid::RestClient).to receive(:post).
            with('connect/get', hash_including(options: '{"pending":true}'))
        Plaid::Connect.get('access-token', pending: true)
      end

      it 'does not convert to ISO8601 format from something it can not do' do
        date = double('date')
        gte = double('some value', to_date: date, to_json: '"value"')
        expect(Plaid::RestClient).to receive(:post).
            with('connect/get', hash_including(options: '{"gte":"value"}'))
        Plaid::Connect.get('access-token', gte: gte)
      end
    end

    describe 'base' do
      let(:response) { double('response', code: 200, body: {'access_token' => 'xxxx', 'accounts' => [], 'transactions' => []}) }
      before do
        allow(Plaid::RestClient).to receive(:post).and_return(response)
      end

      it 'converts gte to ISO8601 format' do
        expect(Plaid::RestClient).to receive(:post).
            with('connect', hash_including(options: '{"gte":"2013-04-02"}'))
        Plaid::Connect.base('username', 'password', '1234', gte: DateTime.new(2013, 04, 02, 12, 1, 0))
      end

      it 'converts gte from date to ISO8601 format' do
        expect(Plaid::RestClient).to receive(:post).
            with('connect', hash_including(options: '{"gte":"2013-04-02"}'))
        Plaid::Connect.base('username', 'password', '1234', gte: Date.new(2013, 04, 02))
      end

      it 'converts gte from time to ISO8601 format' do
        expect(Plaid::RestClient).to receive(:post).
            with('connect', hash_including(options: '{"gte":"2013-04-02"}'))
        Plaid::Connect.base('username', 'password', '1234', gte: Time.new(2013, 04, 02, 12, 1, 0))
      end


      it 'does not touch the options that is not date' do
        expect(Plaid::RestClient).to receive(:post).
            with('connect', hash_including(options: '{"pending":true}'))
        Plaid::Connect.base('username', 'password', '1234', pending: true)
      end

      it 'does not convert to ISO8601 format from something it can not do' do
        date = double('date')
        gte = double('some value', to_date: date, to_json: '"value"')
        expect(Plaid::RestClient).to receive(:post).
            with('connect', hash_including(options: '{"gte":"value"}'))
        Plaid::Connect.base('username', 'password', '1234', gte: gte)
      end
    end
  end
end
