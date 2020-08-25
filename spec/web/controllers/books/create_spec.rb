RSpec.describe Web::Controllers::Books::Create, type: :action do
  let(:action) { described_class.new }
  let(:params) { Hash[book: {title: 'Confident Ruby', author: 'Avdi Grimm'}] }
  let(:repository) { BookRepository.new }

  after do
    repository.clear
  end

  it 'creates a new book' do
    action.call(params)
    book = repository.last
    expect(book.id).to_not be_nil
  end

  it 'redirects the user to the books listing' do
    response = action.call(params)
    expect(response[0]).to eq(302)
    expect(response[1]['Location']).to eq('/books')
  end

  context 'with invalid params' do
    let(:params) { Hash[book: {author: ''}] }

    it 'returns HTTP client error' do
      response = action.call(params)
      expect(response[0]).to eq(422)
    end

    it 'dumps errors in params' do
      response = action.call(params)
      expect(response[0]).to eq(422)
      errors = action.params.errors
      expect(errors.dig(:book, :title)).to eq(['is missing'])
      expect(errors.dig(:book, :author)).to eq(['must be filled'])
    end
  end
end
