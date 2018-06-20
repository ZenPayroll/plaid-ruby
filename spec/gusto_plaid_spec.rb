require 'spec_helper.rb'

describe GustoPlaid do
  before(:all) do |_|
    keys = YAML::load(IO.read('./keys.yml'))

    GustoPlaid.config do |p|
      p.client_id = keys.fetch("client_id")
      p.secret = keys.fetch("secret")
      p.base_url = keys.fetch("base_url")
    end
  end

  describe GustoPlaid::Auth do
    describe '.add' do
      context 'when the bank does not require MFA' do
        it 'responds with a status code of 200' do
          response = GustoPlaid::Auth.add('wells', username: 'plaid_test', password: 'plaid_good')
          expect(response[:code]).to eq(200)
        end
      end

      context 'when the bank requires MFA' do
        it 'responds with a status code of 201' do
          response = GustoPlaid::Auth.add('chase', username: 'plaid_test', password: 'plaid_good')
          expect(response[:code]).to eq(201)
        end
      end
    end

    describe '.get' do
      it 'responds with a status code of 200' do
        response = GustoPlaid::Auth.get('test_chase')
        expect(response[:code]).to equal(200)
      end
    end

    describe '.step' do
      context 'when the first answer is given' do
        it 'responds with a status code of 201' do
          response = GustoPlaid::Auth.step('test', 'again', nil, 'bofa')
          expect(response[:code]).to eq(201)
        end
      end
      context 'when the final answer is given' do
        it 'responds with a status code of 200' do
          response = GustoPlaid::Auth.step('test', 'tomato', nil, 'bofa')
          expect(response[:code]).to eq(200)
        end
      end
    end

    describe '.delete' do
      it 'responds with a status code of 200 for a valid access token' do
        response = GustoPlaid::Auth.delete('test_wells')
        expect(response[:code]).to eq(200)
      end

      it 'responds with a status code of 401 for an invalid access token' do
        response = GustoPlaid::Auth.delete('not_a_real_access_token')
        expect(response[:code]).to eq(401)
      end
    end
  end

  describe GustoPlaid::Institution do
    describe '.all' do
      it 'responds with a status code of 200' do
        response = GustoPlaid::Institution.all
        expect(response[:code]).to equal(200)
      end
    end
  end

  describe GustoPlaid::Upgrade do
    let(:account_id) { 'QPO8Jo8vdDHMepg41PBwckXm4KdK1yUdmXOwK' }
    let(:from) { '2013-06-11' }

    describe '.upgrade' do
      before do
        auth_response = GustoPlaid::Auth.add('wells', username: 'plaid_test', password: 'plaid_good')
        expect(auth_response[:code]).to eq(200)
        @upgrade_response = GustoPlaid::Upgrade.upgrade(auth_response.fetch(:access_token), 'connect')
      end

      it 'can upgrade the service' do
        expect(@upgrade_response[:code]).to eq(200)
      end

      it 'can retrieve the transactions after upgrading' do
        response = GustoPlaid::Connect.get(@upgrade_response[:access_token], account: account_id, gte: from)
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

  describe GustoPlaid::Balance do
    describe '.balance' do
      it 'can get account balance information' do
        response = GustoPlaid::Balance.balance('test_wells')
        expect(response.fetch(:code)).to eq(200)
        expect(response.fetch(:accounts)).to_not be_nil
      end
    end
  end

  describe GustoPlaid::Info do
    describe '.get' do
      it 'can get account info' do
        response = GustoPlaid::Info.get('test_wells')
        expect(response.fetch(:code)).to eq(200)
        expect(response.fetch(:info)).to_not be_nil
      end
    end
  end
end
