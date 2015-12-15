require 'spec_helper'

module Plaid
  class Connect
    describe 'get' do
      let(:response) { double('response', code: 200, body: {'access_token' => 'xxxx', 'accounts' => [], 'transactions' => []}) }
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
            with('connect', hash_including(type: '1234', options: '{"gte":"2013-04-02"}'))
        Plaid::Connect.base('1234', {username: 'username', password: 'password'}, gte: DateTime.new(2013, 04, 02, 12, 1, 0))
      end

      it 'converts gte from date to ISO8601 format' do
        expect(Plaid::RestClient).to receive(:post).
            with('connect', hash_including(options: '{"gte":"2013-04-02"}'))
        Plaid::Connect.base('1234', {username: 'username', password: 'password'}, gte: Date.new(2013, 04, 02))
      end

      it 'converts gte from time to ISO8601 format' do
        expect(Plaid::RestClient).to receive(:post).
            with('connect', hash_including(options: '{"gte":"2013-04-02"}'))
        Plaid::Connect.base('1234', {username: 'username', password: 'password'}, gte: Time.new(2013, 04, 02, 12, 1, 0))
      end


      it 'does not touch the options that is not date' do
        expect(Plaid::RestClient).to receive(:post).
            with('connect', hash_including(options: '{"pending":true}'))
        Plaid::Connect.base('1234', {username: 'username', password: 'password'}, pending: true)
      end

      it 'does not convert to ISO8601 format from something it can not do' do
        date = double('date')
        gte = double('some value', to_date: date, to_json: '"value"')
        expect(Plaid::RestClient).to receive(:post).
            with('connect', hash_including(options: '{"gte":"value"}'))
        Plaid::Connect.base('1234', {username: 'username', password: 'password'}, gte: gte)
      end
    end

    describe 'step' do
      before do
        keys = YAML::load(IO.read('./keys.yml'))

        Plaid.config do |p|
          p.client_id = keys.fetch("client_id")
          p.secret = keys.fetch("secret")
          p.base_url = keys.fetch("base_url")
        end
      end

      context 'when the first answer is given' do
        it 'responds with a status code of 201' do
          response = Plaid::Connect.step('test', 'again', nil, 'bofa')
          expect(response[:code]).to eq(201)
        end
      end
      context 'when the final answer is given' do
        it 'responds with a status code of 200' do
          response = Plaid::Connect.step('test', 'tomato', nil, 'bofa')
          expect(response[:code]).to eq(200)
        end
      end
    end

    describe 'delete' do
      it 'responds with a status code of 200' do
        response = Plaid::Connect.delete('test_wells')
        expect(response[:code]).to eq(200)
      end
    end
  end
end
