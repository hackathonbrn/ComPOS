var profit = false;
var income = false;
var checks = false;
var seven = false;
var thirty;

$(document).ready(function() {

    Chart.defaults.global.defaultFontFamily = '-apple-system,system-ui,BlinkMacSystemFont,"Segoe UI",Roboto,"Helvetica Neue",Arial,sans-serif';
    Chart.defaults.global.defaultFontColor = '#292b2c';

    params7days();
    profit = true;
    seven = true;

    processData();
});

function params7days() {
    var sumProfit = 0;
    var sumIncome = 0;
    $.ajax({
        type: 'get',
        url: '/api/salesTransaction/last7days',
    })
        .done(function (data) {
            for(var i = 0; i < data.length; i++) {
                sumProfit += parseInt(data[i].retailPrice) - parseInt(data[i].wholesalePrice);
                sumIncome += parseInt(data[i].retailPrice);
            }
            document.getElementById("profith5").innerText = "Прибыль: " + sumProfit.toLocaleString() + " ₽";
            document.getElementById("incomeh5").innerText = "Доход: " + sumIncome.toLocaleString() + " ₽";
            document.getElementById("checksh5").innerText = "Чеки: " + data.length.toLocaleString();
        });
}

function params30days() {
    var sumProfit = 0;
    var sumIncome = 0;
    $.ajax({
        type: 'get',
        url: '/api/salesTransaction/last30days',
    })
        .done(function (data) {
            for(var i = 0; i < data.length; i++) {
                sumProfit += parseInt(data[i].retailPrice) - parseInt(data[i].wholesalePrice);
                sumIncome += parseInt(data[i].retailPrice);
            }
            document.getElementById("profith5").innerText = "Прибыль: " + sumProfit.toLocaleString() + " ₽";
            document.getElementById("incomeh5").innerText = "Доход: " + sumIncome.toLocaleString() + " ₽";
            document.getElementById("checksh5").innerText = "Чеки: " + data.length.toLocaleString();
        });
}

// 7days
function processData() {
    var month = [
        'Янв',
        'Фев',
        'Март',
        'Апр',
        'Май',
        'Июнь',
        'Июль',
        'Авг',
        'Сент',
        'Окт',
        'Ноя',
        'Дек'];

    if (seven) {
        $.ajax({
            type: 'get',
            url: '/api/salesTransaction/last7days',
        })
            .done(function (data) {
                var values = [];
                var labels = [];
                var name;
                var today = new Date();
                var i = 0;
                var j = 0;
                var day = new Date();
                document.getElementById("chartCanvas").innerHTML = "";
                document.getElementById("chartCanvas").innerHTML = "<canvas id=\"myAreaChart\" width=\"100%\" height=\"30\"></canvas>";
                if (profit) {
                    name = "Прибыль";
                    for (i = 0; i < 7; i++) {
                        day = new Date();
                        day.setDate(today.getDate() - 6 + i);
                        labels[i] = month[day.getMonth()] + " " + day.getDate();
                        values[i] = 0;
                        for (j = 0; j < data.length; j++) {
                            if (getStringDate(day) === data[j].dataTime.substring(0, 10)) {
                                values[i] += parseInt(data[j].retailPrice) - parseInt(data[j].wholesalePrice);
                            }
                        }
                    }
                }
                if (income) {
                    name = "Доход";
                    for (i = 0; i < 7; i++) {
                        day = new Date();
                        day.setDate(today.getDate() - 6 + i);
                        labels[i] = month[day.getMonth()] + " " + day.getDate();
                        values[i] = 0;
                        for (j = 0; j < data.length; j++) {
                            if (getStringDate(day) === data[j].dataTime.substring(0, 10)) {
                                values[i] += parseInt(data[j].retailPrice);
                            }
                        }
                    }
                }
                if (checks) {
                    name = "Чеки";
                    for (i = 0; i < 7; i++) {
                        day = new Date();
                        day.setDate(today.getDate() - 6 + i);
                        labels[i] = month[day.getMonth()] + " " + day.getDate();
                        values[i] = 0;
                        for (j = 0; j < data.length; j++) {
                            if (getStringDate(day) === data[j].dataTime.substring(0, 10)) {
                                values[i]++;
                            }
                        }
                    }
                }
                drawChartArea(labels, values, name)
            });
    }

    if (thirty) {
        $.ajax({
            type: 'get',
            url: '/api/salesTransaction/last30days',
        })
            .done(function (data) {
                var values = [];
                var labels = [];
                var name;
                var today = new Date();
                var i = 0;
                var j = 0;
                var day = new Date();
                document.getElementById("chartCanvas").innerHTML = "";
                document.getElementById("chartCanvas").innerHTML = "<canvas id=\"myAreaChart\" width=\"100%\" height=\"30\"></canvas>";
                if (profit) {
                    name = "Прибыль";
                    for (i = 0; i < 30; i++) {
                        day = new Date();
                        day.setDate(today.getDate() - 29 + i);
                        labels[i] = month[day.getMonth()] + " " + day.getDate();
                        values[i] = 0;
                        for (j = 0; j < data.length; j++) {
                            if (getStringDate(day) === data[j].dataTime.substring(0, 10)) {
                                values[i] += parseInt(data[j].retailPrice) - parseInt(data[j].wholesalePrice);
                            }
                        }
                    }
                }
                if (income) {
                    name = "Доход";
                    for (i = 0; i < 30; i++) {
                        day = new Date();
                        day.setDate(today.getDate() - 29 + i);
                        labels[i] = month[day.getMonth()] + " " + day.getDate();
                        values[i] = 0;
                        for (j = 0; j < data.length; j++) {
                            if (getStringDate(day) === data[j].dataTime.substring(0, 10)) {
                                values[i] += parseInt(data[j].retailPrice);
                            }
                        }
                    }
                }
                if (checks) {
                    name = "Чеки";
                    for (i = 0; i < 30; i++) {
                        day = new Date();
                        day.setDate(today.getDate() - 29 + i);
                        labels[i] = month[day.getMonth()] + " " + day.getDate();
                        values[i] = 0;
                        for (j = 0; j < data.length; j++) {
                            if (getStringDate(day) === data[j].dataTime.substring(0, 10)) {
                                values[i]++;
                            }
                        }
                    }
                }
                drawChartArea(labels, values, name)
            });
    }
}

$( "#7days" ).click(function () {
    params7days();
    seven = true;
    thirty = false;
    this.classList.add("active");
    document.getElementById("30days").classList.remove("active");
    processData();
});

$("#30days").click(function() {
    params30days();
    thirty = true;
    seven = false;
    this.classList.add("active");
    document.getElementById("7days").classList.remove("active");
    processData();
});

$("#profit").click(function() {
    checks = false;
    income = false;
    profit = true;
    this.classList.add("active");
    document.getElementById("income").classList.remove("active");
    document.getElementById("checks").classList.remove("active");
    processData();
});

$("#income").click(function() {
    profit = false;
    checks = false;
    income = true;
    this.classList.add("active");
    document.getElementById("profit").classList.remove("active");
    document.getElementById("checks").classList.remove("active");
    processData();
});

$("#checks").click(function() {
    profit = false;
    income = false;
    checks = true;
    this.classList.add("active");
    document.getElementById("profit").classList.remove("active");
    document.getElementById("income").classList.remove("active");
    processData();
});

function getStringDate(date) {
    var stringDate = date.getFullYear() + "-";
    var month = date.getMonth() + 1;
    if (month < 10)
        stringDate += "0" + month + "-";
    else
        stringDate += month + "-";
    var day = date.getDate();
    if (day < 10)
        stringDate += "0" + day;
    else
        stringDate += day;
    return stringDate;
}

function drawChartArea(labels, dataMas, name) {
    var ctx = document.getElementById("myAreaChart");
    var myLineChart = new Chart(ctx, {
        type: 'line',
        data: {
            labels: labels,
            datasets: [{
                label: name,
                lineTension: 0,
                backgroundColor: "rgba(2,117,216,0.2)",
                borderColor: "rgba(2,117,216,1)",
                pointRadius: 5,
                pointBackgroundColor: "rgba(2,117,216,1)",
                pointBorderColor: "rgba(255,255,255,0.8)",
                pointHoverRadius: 5,
                pointHoverBackgroundColor: "rgba(2,117,216,1)",
                pointHitRadius: 50,
                pointBorderWidth: 2,
                data: dataMas,
            }],
        },
        options: {
            maintainAspectRatio: false,
            scales: {
                xAxes: [{
                    time: {
                        unit: 'date'
                    },
                    gridLines: {
                        display: false
                    },
                    ticks: {
                        maxTicksLimit: 15
                    }
                }],
                yAxes: [{
                    ticks: {
                        min: 0,
                        max: Math.max.apply(Math, dataMas),
                        maxTicksLimit: 10
                    },
                    gridLines: {
                        color: "rgba(0, 0, 0, .125)",
                    }
                }],
            },
            legend: {
                display: false
            }
        }
    });
}
