// const { request } = require("express");
const axios = require('axios');
const cheerio = require('cheerio');

const scrapCamsUrls = async function (url) {
    return new Promise(resolve => {
        axios(url)
            .then(response => {
                const html = response.data;
                const $ = cheerio.load(html);

                const cams = $('#room_list > li');
                const hrefs = [];
                cams.each(function () {
                    const href = $(this).find('.details > .title > a').attr("href")
                    hrefs.push(href)
                })
                resolve(hrefs)
            })
    })
}

const decodeLink = function (link) {
    link = link.replace("/external_link/?url=", "");
    return unescape(link);
}

const progressBar = function (i, max) {
    process.stdout.write((i + 1) % 10 ? "." : ". ");
    process.stdout.write(i == max ? "\n" : "");
}

const scrapExternalUrls = async function (url) {
    return new Promise(resolve => {
        axios(url)
            .then(response => {
                const html = response.data;
                const $ = cheerio.load(html, { xmlMode: true });
                const urls = []

                $('a').each(function () {
                    const href = $(this).attr("href");
                    if (href && href.indexOf("external_link") !== -1)
                        urls.push(decodeLink(href));
                })

                resolve(urls)
            })
    })
}

const main = async function () {
    const female_url = "https://www.chaturbate.com/female-cams/?page=";
    const paths = [];
    const externalUrls = [];

    console.log(`Getting list of streamers:`)
    const maxPage = 1
    for (let i = 0; i < maxPage; i++) {
        const chunk = await scrapCamsUrls(female_url + i + 1);
        let a = 15 // DEV
        chunk.forEach(path => {
            if (0 < a--) // DEV
                paths.push(path)
        })
        progressBar(i, maxPage - 1);
    }

    console.log(`Scrapping urls:`)
    for (let i = 0; i < paths.length; i++) {
        const streamer = `https://chaturbate.com${paths[i]}`;
        const url = await scrapExternalUrls(streamer)
        externalUrls.push(url);
        progressBar(i, paths.length - 1);
    }

    // console.log(paths);
    console.log(externalUrls);
    // console.log(arr1);
    // console.log(arr2);
}

main();