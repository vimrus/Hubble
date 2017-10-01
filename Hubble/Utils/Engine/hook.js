var console = {
	log: function(message) {
        consoleLog(message);
	}
}

var articles = {
	append: function(article) {
        if (typeof article.id == 'number') {
            article.id = article.id.toString()
        }
		articleAppend(article);
	},
	get: function(field, value, callback) {
        if (field === 'id' && typeof value === 'number') {
            value = value.toString()
        }
        articleGet(field, value, function(article) {
            callback(article);
        })
	}
};

var hubble = {
    get: function (url, callback) {
        request(url, function(error, response, body) {
            callback(error, response, body);
        })
    },
    getHtml: function (url, callback) {
        request(url, function(error, response, body){
            callback(error, response, cheerio.load(body));
        })
    },
    getXML: function (url, callback) {
        request(url, function(error, response, body){
            callback(error, response, cheerio.load(body, { xmlMode: true }));
        })
    },
    getJSON: function (url, callback) {
        request(url, function(error, response, body){
            callback(error, response, JSON.parse(body));
        })
    }
}
