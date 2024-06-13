// католог с модулем для синхр. работы с MySQL, который должен быть усталовлен командой: sync-mysql
// const dir_nms = 'C:\\nodejs\\node_modules\\sync-mysql';

// работа с базой данных.
// const Mysql = require(dir_nms)
var MySql = require('sync-mysql');
const connection = new MySql({
	host: 'localhost',
	user: 'root',
	password: '12345',
	database: 'space'
})

// обработка параметров из формы.
var qs = require('querystring');
function reqPost(request, response) {
	if (request.method == 'POST') {
		var body = '';

		request.on('data', function (data) {
			body += data;
		});

		request.on('end', function () {
			var post = qs.parse(body);
			var sInsert = "INSERT INTO Object (id_object,type, accuracy, quantity, time, date, notes)  VALUES (\"" + post['col1'] + "\",\"" + post['col2'] + "\",\"" + post['col3'] + post['col4'] + "\",\"" + post['col5'] + "\",\"" + post['col6'] + "\",\"" + post['col7'] + "\",\"" + post['col8'] + "\")";
			var results = connection.query(sInsert);
			console.log('Done. Hint: ' + sInsert);
		});
	}
}

// выгрузка массива данных.
function ViewSelect(res) {
	var results = connection.query('SHOW COLUMNS FROM Object');
	res.write('<tr>');
	for (let i = 0; i < results.length; i++)
		res.write('<td>' + results[i].Field + '</td>');
	res.write('</tr>');

	var results = connection.query('CALL JoinObjectsAndNaturalObjects()');
	res.write('<tr>');
	results[0].forEach(result => {
		res.write(`<tr><td>${result.id_object}</td><td>${result.type}</td><td>${result.accuracy}</td><td>${result.quantity}</td><td>${result.time}</td><td>${result.date}</td><td>${result.notes}</td><td>${result.date}</td></tr>`);
	});
	res.write('</tr>');
}
function ViewVer(res) {
	var results = connection.query('SELECT VERSION() AS ver');
	res.write(results[0].ver);
}

// создание ответа в браузер, на случай подключения.
const http = require('http');
const server = http.createServer((req, res) => {
	reqPost(req, res);
	console.log('Loading...');

	res.statusCode = 200;
	//	res.setHeader('Content-Type', 'text/plain');

	// чтение шаблока в каталоге со скриптом.
	var fs = require('fs');
	var array = fs.readFileSync(__dirname + '/select.html').toString().split("\n");
	console.log(__dirname + '/select.html');
	// var array = fs.readFileSync('/select.html').toString().split("\n");
	// console.log('/select.html');
	for (i in array) {
		// подстановка.
		if ((array[i].trim() != '@tr') && (array[i].trim() != '@ver')) res.write(array[i]);
		if (array[i].trim() == '@tr') ViewSelect(res);
		if (array[i].trim() == '@ver') ViewVer(res);
	}
	res.end();
	console.log('1 User Done.');
});

// запуск сервера, ожидание подключений из браузера.
const hostname = '127.0.0.1';
const port = 3000;
server.listen(port, hostname, () => {
	console.log(`Server running at http://${hostname}:${port}/`);
});
