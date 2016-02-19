require 'rails_helper'
require 'typographic_cleaner'

describe TypographicCleaner do
  before { I18n.locale = :en }

  describe '.clean' do
    it 'applies the rules using the specified locale' do
      TypographicCleaner.config :en do |cleaner|
        cleaner.rule /\|\|/, 'foo'
      end
      TypographicCleaner.config :fr do |cleaner|
        cleaner.rule /\|\|/, 'bar'
      end

      expect(TypographicCleaner.clean('||', locale: :en)).to eq('foo')
      expect(TypographicCleaner.clean('||', locale: :fr)).to eq('bar')
      expect(TypographicCleaner.clean('||', locale: :de)).to eq('||')
    end

    context 'for french locale' do
      before { I18n.locale = :fr }

      it 'replaces consecutives spaces with a single one' do
        expect(TypographicCleaner.clean('Un   jour')).to eq('Un&nbsp;jour')
      end

      it 'replaces non-breaking spaces with the corresponding html entity' do
        expect(TypographicCleaner.clean('17 %')).to eq('17&nbsp;%')
      end

      it 'replaces spaces before high ponctuations with a non-breaking space' do
        expect(TypographicCleaner.clean('Foo !')).to eq('Foo&#8239;!')
        expect(TypographicCleaner.clean('Foo ?')).to eq('Foo&#8239;?')
        expect(TypographicCleaner.clean('Foo ;')).to eq('Foo&#8239;;')
        expect(TypographicCleaner.clean('Foo :')).to eq('Foo&#8239;:')
        expect(TypographicCleaner.clean('Foo %')).to eq('Foo&nbsp;%')
        expect(TypographicCleaner.clean('10%')).to eq('10&nbsp;%')
        expect(TypographicCleaner.clean('http://bigard-recrute-staging.s3.amazonaws.com/uploads%2Ff497e4e9-8aef-45d4-9406-1b39df7a2094%2Fequipe-production.jpg')).to eq('http://bigard-recrute-staging.s3.amazonaws.com/uploads%2Ff497e4e9-8aef-45d4-9406-1b39df7a2094%2Fequipe-production.jpg')
      end

      it 'replaces multiple instances of a punctuation with a single version' do
        expect(TypographicCleaner.clean('!!!')).to eq('!')
        expect(TypographicCleaner.clean('???')).to eq('?')
      end

      it 'replaces Etc... or etc… by etc.' do
        expect(TypographicCleaner.clean('Etc...')).to eq('Etc.')
        expect(TypographicCleaner.clean('etc…')).to eq('etc.')
      end

      it 'replaces triple dots with an ellipsis' do
        expect(TypographicCleaner.clean("Foo...")).to eq('Foo&hellip;')
      end

      it 'replaces Mr. with M.' do
        expect(TypographicCleaner.clean("Mr.")).to eq('M.')
      end

      it 'replaces N° with the proper numeral exponent' do
        expect(TypographicCleaner.clean("N°")).to eq('N&#186;')
      end

      it 'replaces ordinal numbers with their proper form' do
        expect(TypographicCleaner.clean('1ere')).to eq('1<sup>re</sup>')
        expect(TypographicCleaner.clean('1ère')).to eq('1<sup>re</sup>')
        expect(TypographicCleaner.clean('2eme')).to eq('2<sup>e</sup>')
        expect(TypographicCleaner.clean('2ème')).to eq('2<sup>e</sup>')
        expect(TypographicCleaner.clean('3eme')).to eq('3<sup>e</sup>')
        expect(TypographicCleaner.clean('3ème')).to eq('3<sup>e</sup>')
        expect(TypographicCleaner.clean('10ème')).to eq('10<sup>e</sup>')

        expect(TypographicCleaner.clean('1ers')).to eq('1<sup>ers</sup>')
        expect(TypographicCleaner.clean('1ères')).to eq('1<sup>res</sup>')
        expect(TypographicCleaner.clean('1eres')).to eq('1<sup>res</sup>')

        expect(TypographicCleaner.clean('2emes')).to eq('2<sup>es</sup>')
        expect(TypographicCleaner.clean('2èmes')).to eq('2<sup>es</sup>')

        expect(TypographicCleaner.clean('10emes')).to eq('10<sup>èmes</sup>')
        expect(TypographicCleaner.clean('10èmes')).to eq('10<sup>èmes</sup>')
      end

      it 'replaces oe with œ' do
        expect(TypographicCleaner.clean('Oeuf')).to eq('&#338;uf')
        expect(TypographicCleaner.clean('oeuf')).to eq('&#339;uf')
      end

      it 'replaces single quotes with typographic ones' do
        expect(TypographicCleaner.clean("L’arbre")).to eq('L&rsquo;arbre')

        expect(TypographicCleaner.clean("L'arbre")).to eq('L&rsquo;arbre')

        expect(TypographicCleaner.clean('![an image](http://foo.com/bar.jpg "image\'s title")')).to eq('![an&nbsp;image](http://foo.com/bar.jpg "image\'s title")')
      end

      it 'replaces the double quotes around a sentence by typographic quotes' do
        expect(TypographicCleaner.clean('Le "Chat Botté".')).to eq('Le&nbsp;&ldquo;&#8239;Chat Botté&#8239;&rdquo;.')
        expect(TypographicCleaner.clean('Le " Chat Botté ".')).to eq('Le&nbsp;&ldquo;&#8239;Chat Botté&#8239;&rdquo;.')
        expect(TypographicCleaner.clean('\n\nLe " Chat Botté ".\n![foo](bar.png "")')).to eq('\n\nLe&nbsp;&ldquo;&#8239;Chat Botté&#8239;&rdquo;.\n![foo](bar.png "")')

        expect(TypographicCleaner.clean('![an image](http://foo.com/bar.jpg "a title")')).to eq('![an&nbsp;image](http://foo.com/bar.jpg "a title")')
      end

      it 'replaces commercial symbol with their html equivalent' do
        expect(TypographicCleaner.clean('©')).to eq('&copy;')
        expect(TypographicCleaner.clean('(c)')).to eq('&copy;')
        expect(TypographicCleaner.clean('(C)')).to eq('&copy;')
        expect(TypographicCleaner.clean('™')).to eq('&trade;')
        expect(TypographicCleaner.clean('TM')).to eq('&trade;')
        expect(TypographicCleaner.clean('ATM')).to eq('ATM')
      end

      it 'replaces days and months names with their lower case equivalent' do
        %w(Lundi Mardi Mercredi Jeudi Vendredi Samedi Dimanche Janvier Février Mars Avril Mai Juin Juillet Aout Septembre Octobre Novembre Décembre).each do |s|
          expect(TypographicCleaner.clean(s)).to eq(s.downcase)
        end
      end

      it 'formats times properly' do
        expect(TypographicCleaner.clean('13h37')).to eq('13 h 37')
      end

      it 'replaces spaces before a currency with a non-breaking space' do
        expect(TypographicCleaner.clean('12€')).to eq('12&nbsp;&euro;')
        expect(TypographicCleaner.clean('12$')).to eq('12&nbsp;$')
        expect(TypographicCleaner.clean('12£')).to eq('12&nbsp;&#163;')
        expect(TypographicCleaner.clean('12¥')).to eq('12&nbsp;&#165;')
      end

      it 'adds a non-breaking space after a short word' do
        expect(TypographicCleaner.clean('à dos de cheval')).to eq('à&nbsp;dos&nbsp;de&nbsp;cheval')
      end

      it 'adds a non-breaking space before the last word of a paragraph' do
        expect(TypographicCleaner.clean('Ceci est la fin. Enfin la toute fin.')).to eq('Ceci est&nbsp;la&nbsp;fin. Enfin la&nbsp;toute&nbsp;fin.')
      end
    end
  end
end
