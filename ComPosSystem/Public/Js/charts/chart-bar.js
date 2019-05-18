$(document).ready(function() {

    Chart.defaults.global.defaultFontFamily = '-apple-system,system-ui,BlinkMacSystemFont,"Segoe UI",Roboto,"Helvetica Neue",Arial,sans-serif';
    Chart.defaults.global.defaultFontColor = '#292b2c';

    var dataList = [0, 0, 0, 0, 0, 0, 0];
    var sumList = [0, 0, 0, 0, 0, 0, 0];
    var amountList = [0, 0, 0, 0, 0, 0, 0];
    $.ajax({
        type: 'get',
        url: '/api/salesTransaction/all',
    })
        .done(function (data) {
            for (var i = 0; i < data.length; i++) {
                var year = parseInt(data[i].dataTime.substring(0, 4));
                var month = parseInt(data[i].dataTime.substring(5, 7)) - 1;
                var day = parseInt(data[i].dataTime.substring(8, 10));
                var dayOfWeek = new Date(year, month, day);
                if (dayOfWeek.getDay() === 1) {
                    dataList[0]++;
                    sumList[0] += parseInt(data[i].retailPrice);
                }
                if (dayOfWeek.getDay() === 2) {
                    dataList[1]++;
                    sumList[1] += parseInt(data[i].retailPrice);
                }
                if (dayOfWeek.getDay() === 3) {
                    dataList[2]++;
                    sumList[2] += parseInt(data[i].retailPrice);
                }
                if (dayOfWeek.getDay() === 4) {
                    dataList[3]++;
                    sumList[3] += parseInt(data[i].retailPrice);
                }
                if (dayOfWeek.getDay() === 5) {
                    dataList[4]++;
                    sumList[4] += parseInt(data[i].retailPrice);
                }
                if (dayOfWeek.getDay() === 6) {
                    dataList[5]++;
                    sumList[5] += parseInt(data[i].retailPrice);
                }
                if (dayOfWeek.getDay() === 0) {
                    dataList[6]++;
                    sumList[6] += parseInt(data[i].retailPrice);
                }
            }
        for (i = 0; i < 7; i++) {
            amountList[i] = sumList[i] / dataList[i];
        }

        drawAmount(dataList);
        drawAverage(amountList);
    });
});

function drawAmount(dataList) {

   var ctx = document.getElementById("checkAmountByDay");
   var myLineChart = new Chart(ctx, {
       type: 'bar',
       data: {
           labels: ["Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"],
           datasets: [{
               label: "Количество",
               backgroundColor: "rgba(142, 94, 162, 0.8)",
               data: dataList,
           }],
       },
       options: {
           scales: {
               xAxes: [{
                   time: {
                       unit: 'day'
                   },
                   gridLines: {
                       display: false
                   },
                   ticks: {
                       maxTicksLimit: 6
                   }
               }],
               yAxes: [{
                   ticks: {
                       min: 0,
                       max: Math.max.apply(Math, dataList) * 1.5,
                       maxTicksLimit: 5
                   },
                   gridLines: {
                       display: true
                   }
               }],
           },
           legend: {
               display: false
           }
       }
   });
}

function drawAverage(amountList) {
    // Bar Chart Example
    ctx = document.getElementById("averageCheckByDay");
    myLineChart = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: ["Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"],
            datasets: [{
                label: "Среднее значение",
                backgroundColor: "rgba(60, 186, 159, 0.8)",
                data: amountList,
            }],
        },
        options: {
            scales: {
                xAxes: [{
                    time: {
                        unit: 'day'
                    },
                    gridLines: {
                        display: false
                    },
                    ticks: {
                        maxTicksLimit: 6
                    }
                }],
                yAxes: [{
                    ticks: {
                        min: 0,
                        max: Math.max.apply(Math, amountList) * 1.5,
                        maxTicksLimit: 5
                    },
                    gridLines: {
                        display: true
                    }
                }],
            },
            legend: {
                display: false
            }
        }
    });
}
