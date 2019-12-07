require 'test_helper'
require_relative '../support/normalizer_test_helper'

class RedakciyaNormalizerTest < Minitest::Test
  include NormalizerTestHelper

  def subject
    RedakciyaNormalizer
  end

  def processor
    YoutubeProcessor
  end

  def sample_data_file
    'feed_redakciya.xml'
  end

  def test_normalization
    assert(normalized.any?)
    assert(normalized.all?(&:success?))
  end

  # rubocop:disable Metrics/LineLength
  FIRST_SAMPLE = {
    uid: 'https://www.youtube.com/watch?v=lFEMneG3jfM',
    link: 'https://www.youtube.com/watch?v=lFEMneG3jfM',
    published_at: DateTime.parse('2019-09-12 09:53:10 UTC'),
    text: 'Взгляд на Россию с высоты Эльбруса - https://www.youtube.com/watch?v=lFEMneG3jfM',
    attachments: [],
    comments: ["Подписывайтесь на канал и смотрите самое крутое шоу про бизнес – «Теперь я Босс»: http://bit.ly/2lPNtnC\n\nУзнать больше о ЖК «Пресня Сити»: https://clck.ru/J2ukF\n\nВ этот раз мы забрались на самое высокое место России — гору Эльбрус! Но выпуск все равно получился про людей: тех, кто там живет, тех, кто туда едет испытать себя, и тех, кто не может не возвращаться туда снова и снова, потому что Эльбрус — как война, затягивает и не отпускает.\n\nИнстаграм Александра Байдаева: https://www.instagram.com/alexander_baydaev/\n\nПодписывайтесь на наши социальные сети:\n\nТелеграм-канал «Редакции»:\nhttps://t.me/redakciya_channel\n\nРедакция в «ВК»:\nhttps://vk.com/redakciya_pivovarova\n\nРедакция в фейсбуке:\nhttps://www.facebook.com/pivovarov.red\n\nИнстаграм Пивоварова:\n\nhttps://www.instagram.com/pivo_varov\n\nТвиттер Пивоварова:\n\nhttps://twitter.com/pivo_varov\n\nОдноклассники:\nhttps://ok.ru/redakciya\n\nНаш блог в «Дзене»:\nhttps://zen.yandex.ru/redakciya\n\nСотрудничество и идеи:\ninfo@redakciya.com\n\nПо вопросам рекламы:\n\nnewsroom@carrot.moscow\n\n#эльбрус"],
    validation_errors: []
  }.freeze
  # rubocop:enable Metrics/LineLength

  def test_normalized_sample
    assert_equal(FIRST_SAMPLE, normalized.first.value!)
  end
end
