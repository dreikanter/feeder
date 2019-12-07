require 'test_helper'

class ReworkTest < Minitest::Test
  def subject
    Pull.call(feed)
  end

  def feed
    create(:feed, **feed_config)
  end

  def feed_config
    {
      name: 'rework',
      processor: 'feedjira',
      normalizer: 'rework',
      url: 'https://rss.art19.com/rework'
    }
  end

  def setup
    Feed.delete_all
    stub_request(:get, 'https://rss.art19.com/rework')
      .to_return(
        body: file_fixture('feeds/rework.xml'),
        headers: { 'Content-Type' => 'text/xml' }
      )
  end

  def test_general_success
    assert(subject.success?)
  end

  # TODO: Move to a fixture
  # TODO: Consider using dry-struct for time coercion
  EXPECTED_ENTITY = {
    uid: 'https://share.transistor.fm/s/49d755a9',
    link: 'https://share.transistor.fm/s/49d755a9',
    published_at: DateTime.parse('2019-12-03 13:00:00 UTC'),
    text: "Venture Capital and Control with Dave Teare\nhttps://media.transistor.fm/178d7279.mp3 (3971)",
    attachments: [],
    comments: ["\"Open Source and Power with Matt Mullenweg,\" our episode featuring a phone call between DHH and Automattic's Matt Mullenweg - 00:34\n\nDHH's tweet about Automattic's funding round - 00:49\n\nDave Teare on Twitter | 1Password - 00:56\n\n1Password's blog post announcing the funding round - 1:02\n\nDHH's tweet about 1Password's funding announcement - 1:04\n\n\"A love letter to DHH and others concerned about our recent funding announcement\" - 1:30\n\n\"Bezos Expeditions invests in 37signals\" (Signal v. Noise) - 1:55\n\n1Password co-founder Roustem Karimov on Twitter - 3:10\n\nDHH's Ruby on Rails demo about building a blog engine in 15 minutes - 3:30\n\n\"Conceal, don't feel\" is a lyric from Frozen's Let It Go - 14:14\n\n\"Inside WeWork's week from hell: How the mass layoffs went down\" (CNN) - 19:16\n\n\"The day I became a millionaire\" (Signal v. Noise) - 21:22\n\n\"It Doesn't Have to Be Crazy at Work\" - 25:31\n\nApple's Differential Privacy policy (PDF) - 26:25\n\nOur Incredible Journey (Tumblr) - 31:42\n\n\"The Mess at Meetup\" (Gizmodo) - 32:08\n\n\"Meetup wants to charge users $2 just to RSVP for events — and some are furious\" (The Verge) - 32:18\n\n\"Patreon now offers creators 3 plans, with fees ranging from 5-12%\" (VentureBeat) - 32:45\n\nAn irate forum post about Dropbox's new storage plan - 33:12\n\n\"GitHub is trying to quell employee anger over its ICE contract. It's not going well\" (LA Times) - 34:55\n\n\"The deal Jeff Bezos got on Basecamp\" (Signal v. Noise) - 39:20\n\n\"How to Fly a Horse\" by Kevin Ashton... (continued)"],
    validation_errors: []
  }.freeze

  def test_each_entity_is_a_success
    subject.value!.all?(&:success?)
  end

  def test_entity_normalization
    assert_equal(EXPECTED_ENTITY, subject.value!.first.value!)
  end
end
