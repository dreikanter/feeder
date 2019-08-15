#!/usr/bin/env node

const puppeteer = require('puppeteer-core');
const program = require('commander');

function instagramFeedUrl (user) {
  return `https://www.instagram.com/${user}/`;
}

async function download ({ user, executablePath }) {
  const browser = await puppeteer.launch({ executablePath });
  const page = await browser.newPage();

  await page.goto(instagramFeedUrl(user), {
    waitUntil: 'load'
  });

  // eslint-disable-next-line no-underscore-dangle
  const data = await page.evaluate(() => window._sharedData);
  process.stdout.write(`${JSON.stringify(data)}\n`);
  await browser.close();
}

program
  .version('0.0.1')
  .description('Instagram feed downloader')
  .option(
    '--exec-path <path>',
    'Chrome browser executable path',
    '/usr/bin/google-chrome-stable'
  );

program
  .command('download <user>')
  .description('download Instagram feed for specified user')
  .action(user => download({ user, executablePath: program.execPath }));

program.parse(process.argv);
