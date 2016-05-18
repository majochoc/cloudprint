var request = require('request');
var pdfUtil = require('pdf-to-text');


pdfUtil.pdfToText(process.argv[2], function(err, data) {
    if (err) throw(err);
    request.post(
        'http://connect.reveal.digital/api/v1/printjobs',
        { form: { bucket: process.argv[4], key: process.argv[3], pdf_info: data } },
        function (error, response, body) {
            if (!error && response.statusCode == 200) {
                console.log(body)
            }
        }
    );
});
