require 'spec_helper.rb'

describe Plaid do
  before(:all) do |_|
    keys = YAML::load(IO.read('./keys.yml'))

    Plaid.config do |p|
      p.client_id = keys.fetch("client_id")
      p.secret = keys.fetch("secret")
      p.base_url = keys.fetch("base_url")
    end
  end

  describe Plaid::Auth do
    describe '.add' do
      context 'when the bank does not require MFA' do
        it 'responds with a status code of 200' do
          response = Plaid::Auth.add('wells', username: 'plaid_test', password: 'plaid_good')
          expect(response[:code]).to eq(200)
        end
      end

      context 'when the bank requires MFA' do
        it 'responds with a status code of 201' do
          response = Plaid::Auth.add('chase', username: 'plaid_test', password: 'plaid_good')
          expect(response[:code]).to eq(201)
        end
      end
    end

    describe '.get' do
      it 'responds with a status code of 200' do
        response = Plaid::Auth.get('test_chase')
        expect(response[:code]).to equal(200)
      end
    end

    describe '.step' do
      context 'when the first answer is given' do
        it 'responds with a status code of 201' do
          response = Plaid::Auth.step('test', 'again', nil, 'bofa')
          expect(response[:code]).to eq(201)
        end
      end
      context 'when the final answer is given' do
        it 'responds with a status code of 200' do
          response = Plaid::Auth.step('test', 'tomato', nil, 'bofa')
          expect(response[:code]).to eq(200)
        end
      end
    end

    describe '.delete' do
      it 'responds with a status code of 200' do
        response = Plaid::Auth.delete('test_wells')
        expect(response[:code]).to eq(200)
      end
    end
  end

  describe Plaid::Institution do
    describe '.all' do
      it 'responds with a status code of 200' do
        response = Plaid::Institution.all
        expect(response[:code]).to equal(200)
      end
    end
  end

  # Disabling this test because Plaid turned off sandbox access to this API
  # describe Plaid::LongtailInstitution do
  #   describe '.get 5 longtail institutions' do
  #     it 'responds with 5 institutions and a status code of 200' do
  #       response = Plaid::LongtailInstitution.get(5, 0)
  #       expect(response[:code]).to eq(200)
  #       expect(response[:institutions].count).to eq(5)
  #     end
  #   end
  # end

  describe Plaid::Upgrade do
    let(:account_id) { 'QPO8Jo8vdDHMepg41PBwckXm4KdK1yUdmXOwK' }
    let(:from) { '2013-06-11' }

    describe '.upgrade' do
      before do
        auth_response = Plaid::Auth.add('wells', username: 'plaid_test', password: 'plaid_good')
        expect(auth_response[:code]).to eq(200)
        @upgrade_response = Plaid::Upgrade.upgrade(auth_response.fetch(:access_token), 'connect')
      end

      it 'can upgrade the service' do
        expect(@upgrade_response[:code]).to eq(200)
      end

      it 'can retrieve the transactions after upgrading' do
        response = Plaid::Connect.get(@upgrade_response[:access_token], account: account_id, gte: from)
        expect(response.fetch(:code)).to eq(200)
        expect(response.fetch(:transactions).size).to be >= 1
        first_transaction = response.fetch(:transactions).first
        expect(first_transaction.fetch('amount')).to be
        expect(first_transaction.fetch('date')).to be
        expect(first_transaction.fetch('pending')).to_not be_nil
        expect(first_transaction.fetch('_account')).to eq account_id
        expect(first_transaction.fetch('_id')).to be
      end

    end
  end

  describe Plaid::Balance do
    describe '.balance' do
      it 'can get account balance information' do
        response = Plaid::Balance.balance('test_wells')
        expect(response.fetch(:code)).to eq(200)
        expect(response.fetch(:accounts)).to_not be_nil
      end
    end
  end
end
