// const { request } = require("express");
const axios = require('axios');
const cheerio = require('cheerio');


const url = "https://www.chaturbate.com";

axios(url)
    .then(response => {
        const html = response.data;
        const $ = cheerio.load(html);

        const cams = $('#room_list > li');
        const nicknames = [];

        cams.each(function () {
            const nickname = $(this).find('.details > .title > a').attr("href")

            nicknames.push(nickname)
        })

        console.log(nicknames);
    })
    .catch(console.error)