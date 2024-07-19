// Set new default font family and font color to mimic Bootstrap's default styling

// Area Chart Example
$(document).ready(function() {
	
    $.ajax({
        url: '/admin/chart/daily',
        method: 'GET',
        dataType: 'json',
        success: function(data) {
            const labels = data.map(item => item.date);
            const values = data.map(item => item.total_sales);

            const ctx = document.getElementById('dailyChart').getContext('2d');
            new Chart(ctx, {
                type: 'line',
                data: {
                    labels: labels,
                    datasets: [{
                        label: 'Daily Sales',
                        lineTension: 0.3,
                        backgroundColor: "rgba(2,117,216,0.2)",
                        borderColor: "rgba(2,117,216,1)",
                        pointRadius: 5,
                        pointBackgroundColor: "rgba(2,117,216,1)",
                        pointBorderColor: "rgba(255,255,255,0.8)",
                        pointHoverRadius: 5,
                        pointHoverBackgroundColor: "rgba(2,117,216,1)",
                        pointHitRadius: 50,
                        pointBorderWidth: 2,
                        data: values,
                        fill: true
                    }]
                },
                options: {
                    scales: {
                      xAxes: [{
                        time: {
                          unit: 'date'
                        },
                        gridLines: {
                          display: false
                        },
                        ticks: {
                          maxTicksLimit: 7
                        }
                      }],
                      yAxes: [{
                        ticks: {
                          min: 0,
                          max: 5000,
                          maxTicksLimit: 5
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
    });
});
