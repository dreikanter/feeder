require 'test_helper'

class TelegaNormalizerTest < ActiveSupport::TestCase
  SAMPLE_DATA_FILE = 'feed_agavr_today.xml'

  SAMPLE_DATA_PATH =
    File.join(File.expand_path('../../data', __FILE__), SAMPLE_DATA_FILE)

  def test_sample_data_file_exists
    assert File.exist?(open(SAMPLE_DATA_PATH))
  end

  def process_sample_data
    source = open(SAMPLE_DATA_PATH).read
    FeedProcessors::RssProcessor.process(source)
  end

  def processed
    @processed ||= process_sample_data
  end

  def test_have_sample_data
    assert processed.present?
    assert processed.length > 0
  end

  def normalize_sample_data
    processed.map do |entity|
      EntityNormalizers::TelegaNormalizer.process(entity[1])
    end
  end

  def normalized
    @normalized ||= normalize_sample_data
  end

  def test_normalization
    assert normalized.present?
    assert processed.length == normalized.length
  end

  FIRST_SAMPLE = {
    'link' => 'http://tele.ga/agavr_today/126.html',
    'published_at' => DateTime.parse('2017-09-07 14:51:45 +0000'),
    'text' => 'Находясь в настоящий момент в двух поразительных тяжбах в Израиле, я всё думаю: ведь не напрасно Кафка был еврей. Но умереть планирую позже, чем завершу. Это и есть еврейский оптимизм - http://tele.ga/agavr_today/126.html',
    'attachments' => [],
    'comments' =>
    [
      "Forwarded from Белый шум (https://t.me/Polyarinov/95):Еще о сиквелах, ремейках и ребутах. Я вот что вспомнил: «Превращение» Кафки заканчивается совершенно гениально — там же настоящий задел на сиквел. После смерти Грегора вся семья идет гулять:\n" +
      "\n" +
      "«Затем они покинули квартиру все вместе, чего уже много месяцев не делали, и поехали на трамвае за город Господину и госпоже Замза при виде их все более оживлявшейся дочери почти одновременно подумалось, что, несмотря на все горести, покрывшие бледностью ее щеки, она за последнее время расцвела и стала пышной красавицей. Приумолкнув и почти безотчетно перейдя на язык взглядов, они думали о том, что вот и пришло время подыскать ей хорошего мужа. И как бы в утверждение их новых мечтаний и прекрасных намерений, дочь первая поднялась в конце их поездки и выпрямила свое молодое тело».\n" +
      "\n" +
      "Так вот, я все придумал: сиквел назовем «Синекдоха, Превращение».\n" +
      "\n" +
      "Сюжет такой: Грета Замза встречает мужчину своей мечты, они влюблены, у них роман, мужчина делает ей предложение, и они идут в ЗАГС. Но в ЗАГСе чиновник говорит им, что в этом году лимит свадеб исчерпан, но вы, конечно, можете записаться на следующий год. Встать в очередь. И Грета Замза и ее возлюбленный записываются в очередь на свадьбу. Проходит год, Грета уже беременна, она каждый день зачеркивает даты в календаре — считает дни до свадьбы. Затем они с возлюбленным снова идут в ЗАГС, но там им сообщают, что их место в очереди потерялось. Возлюбленный Греты спрашивает, что же... (continued)"
    ]
  }

  def test_normalized_sample
    # binding.pry
    assert normalized.first == FIRST_SAMPLE
  end
end
