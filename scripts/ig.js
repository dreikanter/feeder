#!/usr/bin/env node

const puppeteer = require('puppeteer-core');
const program = require('commander');

const imagesSelector = 'article img[srcset]'
const timeout = 10000
const instagramBaseUrl = 'https://www.instagram.com'

function instagramFeedUrl (user) {
  return `${instagramBaseUrl}/${user}/`;
}

function instagramPostUrl (shortCode) {
  return `${instagramBaseUrl}/p/${shortCode}/`;
}

async function fetchUser ({ name, executablePath }) {
  const browser = await puppeteer.launch({ executablePath });
  const page = await browser.newPage();

  await page.goto(instagramFeedUrl(name), {
    waitUntil: 'load'
  });

  // eslint-disable-next-line no-underscore-dangle
  const data = await page.evaluate(() => window._sharedData);
  process.stdout.write(`${JSON.stringify(data)}\n`);
  await browser.close();
}

async function fetchPost ({ shortCode, executablePath }) {
  const browser = await puppeteer.launch({ executablePath });
  const page = await browser.newPage();
  await page.goto(instagramPostUrl(shortCode));
  await page.waitForSelector(imagesSelector, { timeout });

  const data = await page.evaluate(() => (
    Array
      .from(document.querySelectorAll(imagesSelector))
      .map(item => item.src)
  ));

  process.stdout.write(`${JSON.stringify(data)}\n`);
  await browser.close();
}

program
  .version('0.0.1')
  .description('Instagram content downloader')
  .option(
    '--exec-path <path>',
    'Chrome executable path',
    '/usr/bin/google-chrome-stable'
  );

program
  .command('user <name>')
  .description('download Instagram feed for specified user')
  .action(name => fetchUser({
    name,
    executablePath: program.execPath
  }));

program
  .command('post <shortCode>')
  .description('fetch Instagram post contents')
  .action(shortCode => fetchPost({
    shortCode,
    executablePath: program.execPath
  }));

program.parse(process.argv);
