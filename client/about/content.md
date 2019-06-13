# Freefeed Feeder

Feeder is an automated content sharing service built for [Freefeed](https://freefeed.net), an open source social network. Feeder can monitor RSS, ATOM, Reddit, Twitter, YouTube, Tumblr, or potentially any other web feed updates, normalize the content and share clean and readable excerpts on Freefeed.

Feeder was inspired by "Imaginary friends" feature from [Friendfeed](https://en.wikipedia.org/wiki/FriendFeed). There was ability to receive updates from a person, even if he or she don't have an account on Friendfeed. Feeder introduce the similar capability to Freefeed.

## References

- New feed announcements: [freefeed.net/feeder](https://freefeed.net/feeder)
- If you like to see a new blog imported to Freefeed, please post a message to [freefeed.net/feeder-inbox](https://freefeed.net/feeder-inbox), or [open an issue](https://github.com/dreikanter/feeder/issues/new) on GitHub.
- GitHub project: [github.com/dreikanter/feeder](https://github.com/dreikanter/feeder)
- Project wiki: [github.com/dreikanter/feeder/wiki](https://github.com/dreikanter/feeder/wiki)

## FAQ

**Q:** Ok, where am I?

**A:** [Feeder](https://frf.im) is a service to import blogs, YouTube-channels and other kinds of content to Freefeed.

---

**Q:** Why import external feeds to Freefeed?

**A:** Для того, чтобы их можно было обсудить во Freefeed, конечно. И быть уверенным, что ваши комментарии и лайки не потеряются, даже если пост на сайте-первоисточнике будет удалён.

---

**Q:** Why adding new feeds is not automated?

**A:** For technical reasons.

Для того, чтобы импортированные посты хорошо выглядели в фидике, приходится подстраивать трансляцию под каждый новый источник. Не каждый раз, но довольно часто. Кроме того, есть открытые вопросы про безопасность.

После того, как во Freefeed API появится поддержка тоукенов, я планирую сделать, как минимум, частичную автоматизацию добавления фидов (freefeed.net/dsumin/f0288f16-5df7-47db-a358-…).

---

**Q:** What kind of content can be imported?

**A:** Блоги, новостные сайты или другие регулярно обновляемые ресурсы, если для них доступна RSS или Atom-трансляция. Ещё есть поддержка сабреддитов и Telegram-каналов через [tele.ga](https://tele.ga).

---

**Q:** What can not be imported?

**A:** Контент, который не предполагается публиковать на сторонних сайтах. Например, приватные нотификации. А так же всё то, что может вызвать противоречия с [Freefeed TOS](https://freefeed.net/about/terms). Потому что никому не нужна лишняя ответственность.

---

**Q:** How content import works?

**A:** There is a dedicated public group on Freefeed for each feed. Each new post appears in this group soon after being published on the original site.

Feeder groups are usually remain in "read-only" mode. Anyone can read and comment posts, but only @feeder – a bot account – can create new posts.

---

**Q:** Is it possible to import full history from a blog or another source?

**A:** @feeder is designed to share new content in more or less real time. Archive content import is not supported.

---

**Q:** Is it possible to import a feed to a private group, or to a groupthat is already exists?

**A:** Yes. [@feeder](https://freefeed.net/feeder) user should be able to post to this group. This is the only constraint.

---

**Q:** I'd like to become an admin in one of the Feeder groups. Is this possible?

**A:** Yes. Please send a direct message to [@dreikanter](https://feeder.net) or open an issue on GitHub.

---

**Q:** Can I import posts to My Feed?

**A:** Not yet.

This feature would require Feeder to have access a personal Freefeed account. I'd like to avoid this for security resons till Freefeed API will support personalized API tokens, [OAuth](https://en.wikipedia.org/wiki/OAuth), or something similar access delegation technology.

---

**Q:** I want to add a new feed. Can I do this myself?

**A:** Yes. Check out contribution recommendations [at GitHub](https://github.com/dreikanter/feeder) and send a pull request.

---

**Q:** How much time it takes to add a new feed?

**A:** Зависит от моей занятости и сложности извлечения контента из конкретного источника. Проще всего добавлять каналы из YouTube и блоги с Tumblr. Там более-менее предсказуемая структура контента. Более трудоёмкая задача – импортировать новости из какого-нибудь неортодоксального источника, типа [@best-of-hacker-news](https://freefeed.net/best-of-hacker-news).

---

**Q:** Can I see a list of existing feeds?

**A:** New feed announcements are published [on Freefeed](https://freefeed.net/feeder). You may subscribe to [@feeder](https://freefeed.net/feeder) to see the updates. Additionally, there is a status page with an index of active feeds here: [frf.im](https://frf.im).
