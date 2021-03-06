# frozen_string_literal: true

require 'pry'
require_relative '../paragraph_parser'

RSpec.describe ParagraphParser do
  let(:paragraph) do
    <<~PGH
      Cupcake ipsum dolor sit amet. Soufflé liquorice pastry pie croissant soufflé jelly. Halvah croissant gummi bears. Jelly beans cake liquorice apple pie. Lemon drops fruitcake pudding tootsie roll sesame snaps sweet. Chocolate cake jujubes gummi bears dragée jelly cupcake jelly cookie. Ice cream cupcake donut jelly.
    PGH
  end

  let(:parser) { ParagraphParser.new(paragraph) }

  describe '#sentences' do
    it 'should return an array' do
      expect(parser.sentences).to be_an_instance_of(Array)
    end

    it 'when joined, should equal the original paragraph' do
      expect(parser.sentences.join(' ')).to eq paragraph.strip
    end

    context 'when there is a sentence with an email address in it' do
      let(:paragraph) do
        <<~PGH
          Cupcake ipsum dolor sit amet. Soufflé liquorice pastry pie croissant soufflé info@example.com jelly. Halvah croissant gummi bears. Jelly beans cake liquorice apple pie. Lemon drops fruitcake pudding tootsie roll sesame snaps sweet. Chocolate cake jujubes gummi bears dragée jelly cupcake jelly cookie. Ice cream cupcake donut jelly.
        PGH
      end

      it 'finds the correct sentence including the email address' do
        expect(parser.sentences[1]).to eq 'Soufflé liquorice pastry pie croissant soufflé info@example.com jelly.'
      end
    end

    context 'when there is a sentence with an elipsis at the end of it' do
      let(:paragraph) do
        <<~PGH
          Cupcake ipsum dolor sit amet. Soufflé liquorice pastry pie croissant soufflé jelly... Halvah croissant gummi bears. Jelly beans cake liquorice apple pie. Lemon drops fruitcake pudding tootsie roll sesame snaps sweet. Chocolate cake jujubes gummi bears dragée jelly cupcake jelly cookie. Ice cream cupcake donut jelly.
        PGH
      end

      it 'finds the correct sentence including the elipsis' do
        expect(parser.sentences[1]).to eq 'Soufflé liquorice pastry pie croissant soufflé jelly...'
      end
    end

    context 'when a sentence ends in a question mark' do
      let(:paragraph) do
        <<~PGH
          Cupcake ipsum dolor sit amet. Soufflé liquorice pastry pie croissant soufflé jelly? Halvah croissant gummi bears. Jelly beans cake liquorice apple pie. Lemon drops fruitcake pudding tootsie roll sesame snaps sweet. Chocolate cake jujubes gummi bears dragée jelly cupcake jelly cookie. Ice cream cupcake donut jelly.
        PGH
      end

      it 'finds the correct sentence including the question mark' do
        expect(parser.sentences[1]).to eq 'Soufflé liquorice pastry pie croissant soufflé jelly?'
      end
    end

    context 'when a sentence ends in an exclamation point' do
      let(:paragraph) do
        <<~PGH
          Cupcake ipsum dolor sit amet. Soufflé liquorice pastry pie croissant soufflé jelly! Halvah croissant gummi bears. Jelly beans cake liquorice apple pie. Lemon drops fruitcake pudding tootsie roll sesame snaps sweet. Chocolate cake jujubes gummi bears dragée jelly cupcake jelly cookie. Ice cream cupcake donut jelly.
        PGH
      end

      it 'finds the correct sentence including the exclamation mark' do
        expect(parser.sentences[1]).to eq 'Soufflé liquorice pastry pie croissant soufflé jelly!'
      end
    end

    context 'when there is dialogue in the paragraph and a sentence ends in quotes' do
      let(:paragraph) do
        <<~PGH
          Cupcake ipsum dolor sit amet. "Soufflé liquorice pastry pie croissant soufflé jelly." Halvah croissant gummi bears. Jelly beans cake liquorice apple pie. Lemon drops fruitcake pudding tootsie roll sesame snaps sweet. Chocolate cake jujubes gummi bears dragée jelly cupcake jelly cookie. Ice cream cupcake donut jelly.
        PGH
      end

      it 'finds the correct sentence including the quotes' do
        expect(parser.sentences[1]).to eq '"Soufflé liquorice pastry pie croissant soufflé jelly."'
      end
    end

    context 'when the paragraph has sentences with many of the above in it' do
      let(:paragraph) do
        <<~PGH
          Cupcake ipsum dolor sit amet! "Soufflé liquorice pastry pie croissant soufflé jelly.", she said. Halvah croissant gummi bears... Jelly beans cake liquorice apple pie? Lemon drops fruitcake pudding@example.com tootsie roll sesame snaps sweet. Chocolate cake jujubes gummi bears dragée jelly cupcake jelly cookie?? Ice cream cupcake donut jelly!! "Yay!"
        PGH
      end

      it 'finds the correct sentences' do
        expect(parser.sentences[0]).to eq 'Cupcake ipsum dolor sit amet!'
        expect(parser.sentences[1]).to eq '"Soufflé liquorice pastry pie croissant soufflé jelly.", she said.'
        expect(parser.sentences[2]).to eq 'Halvah croissant gummi bears...'
        expect(parser.sentences[3]).to eq 'Jelly beans cake liquorice apple pie?'
        expect(parser.sentences[4]).to eq 'Lemon drops fruitcake pudding@example.com tootsie roll sesame snaps sweet.'
        expect(parser.sentences[5]).to eq 'Chocolate cake jujubes gummi bears dragée jelly cupcake jelly cookie??'
        expect(parser.sentences[6]).to eq 'Ice cream cupcake donut jelly!!'
        expect(parser.sentences[7]).to eq '"Yay!"'
      end
    end
  end
end
