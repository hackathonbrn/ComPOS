$(document).ready(function() {
    var topmas = [];
    $.ajax({
        type: 'get',
        url: '/api/productInTransaction/all',
    })
        .done(function (data) {
            var tmpmas = [];
            console.log(data.length);
            for (var i = 0; i < data.length; i++) {
                tmpmas[i] = [];
                tmpmas[i][0] = parseInt(data[i].product_fk);
                tmpmas[i][1] = parseInt(data[i].quantity);
            }
            for (i = 0; i < tmpmas.length; i++) {
                var indexmas = [];
                var k = 0;
                for (var j = i + 1; j < tmpmas.length; j++) {
                    if (tmpmas[i][0] === tmpmas[j][0]) {
                        tmpmas[i][1] += tmpmas[j][1];
                        indexmas[k] = j;
                        k++
                    }
                }
                console.log(indexmas);
                for (var t = 0; t < k; t++) {
                    tmpmas.splice(indexmas[t] - t, 1);
                }
            }
            tmpmas.sort(function(a,b) {
                return b[1]-a[1]
            });

            $.ajax({
                type: 'get',
                url: '/api/product/all',
            })
                .done(function (products) {
                    var countProducts;
                    if (tmpmas.length < 10)
                        countProducts = tmpmas.length;
                    else
                        countProducts = 10;
                    for (var j = 0; j < countProducts; j++)
                        for (t = 0; t < products.length; t++)
                            if (tmpmas[j][0] === parseInt(products[t].id)) {
                                tmpmas[j][2] = products[t].name;
                                tmpmas[j][3] = products[t].retailPrice;
                            }
                    var div = document.getElementById("popularProducts");
                    var content = "";
                    for (var i = 0; i < countProducts; i++) {
                        content += "   <tr>\n" +
                            "       <td>" +  tmpmas[i][2] + "</td>\n" +
                            "       <td>" +  tmpmas[i][1] + "</td>\n" +
                            "       <td>" + tmpmas[i][3] +  "</td>\n" +
                            "    </tr>\n";
                    }
                    div.innerHTML +=
                        "      <table class=\"table table-borderred table-hover\" id=\"productsTable\">\n" +
                        "        <thread class=\"thread-light\">\n" +
                        "          <tr>\n" +
                        "            <th>Название</th>\n" +
                        "            <th>Количество</th>\n" +
                        "            <th>Розничная цена</th>\n" +
                        "          </tr>\n" +
                        "        </thread>\n" +
                        "        <tbody>\n" + content;
                });
        })
});
