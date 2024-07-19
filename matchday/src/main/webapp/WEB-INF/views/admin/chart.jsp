<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="adheader.jsp"%>
<div class="container-fluid px-4">
	<h1 class="mt-4">매출현황</h1>

	<div class="card mb-4">
		<div class="card-body"></div>
	</div>
	<div class="card mb-4">
		<div class="card-header">
			<i class="fas fa-chart-area me-1"></i> 일별 총 매출
		</div>
		<div class="card-body">
			<canvas id="dailyChart" width="100%" height="30"></canvas>
		</div>
		<%
		// 서버 사이드에서 현재 시간을 가져와서 렌더링
		java.util.Date now = new java.util.Date();
		String lastUpdated = String.format("Updated on %tF at %tT", now, now);
		%>
		<div class="card-footer small text-muted" id="lastUpdated"><%=lastUpdated%></div>
	</div>
	<div class="row">
		<div class="col-lg-6">
			<div class="card mb-4">
				<div class="card-header">
					<i class="fas fa-chart-bar me-1"></i>월별 티켓 판매수
				</div>
				<div class="card-body">
					<canvas id="BarChart" width="100%" height="50"></canvas>
				</div>
				<div class="card-footer small text-muted" id="lastUpdatedTickets"><%=lastUpdated%></div>
			</div>
		</div>
		<div class="col-lg-6">
			<div class="card mb-4">
				<div class="card-header">
					<i class="fas fa-chart-pie me-1"></i>항목별 매출
				</div>
				<div class="card-body">
					<canvas id="PieChart" width="100%" height="50"></canvas>
				</div>
				<div class="card-footer small text-muted" id="lastUpdatedItems"><%=lastUpdated%></div>
			</div>
		</div>
	</div>
</div>
<script>
// 일별 매출 데이터를 가져와서 차트를 그립니다.
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
                          max: 300000,
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
//비율차트
$(document).ready(function() {
    $.ajax({
        url: '/admin/chart/itemSales',
        method: 'GET',
        success: function(data) {
            var ctx = document.getElementById('PieChart').getContext('2d');
            var PieChart = new Chart(ctx, {
                type: 'pie',
                data: {
                    labels: ['굿즈', '티켓', '멤버쉽'],
                    datasets: [{
                        data: [
                            data.total_order_amount,
                            data.total_ticket_amount,
                            data.total_membership_amount
                        ],
                        backgroundColor: ['#FF6384', '#36A2EB', '#FFCE56'],
                    }]
                },
                options: {
                    plugins: {
                        datalabels: {
                            formatter: (value, ctx) => {
                                let datasets = ctx.chart.data.datasets;
                                if (datasets.indexOf(ctx.dataset) === datasets.length - 1) {
                                    let sum = datasets[0].data.reduce((a, b) => a + b, 0);
                                    let percentage = Math.round((value / sum) * 100) + '%';
                                    return percentage;
                                } else {
                                    return percentage;
                                }
                            },
                            color: '#fff',
                        }
                    }
                },
                plugins: [ChartDataLabels]
            });
        },
        error: function(err) {
            console.error('Error fetching item sales data:', err);
        }
    });
});

//막대그래프
$(document).ready(function() {
    $.ajax({
        url: '/admin/chart/monthly-ticket-sales',
        method: 'GET',
        success: function(data) {
            var labels = data.map(function(item) {
                return item.month;
            });

            var ticketSales = data.map(function(item) {
                return item.ticket_sales;
            });

            var ctx = document.getElementById("BarChart").getContext('2d');

            var myLineChart = new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: labels,
                    datasets: [{
                        label: '티켓 판매수',
                        data: ticketSales,
                        backgroundColor: 'rgba(54, 162, 235, 0.2)',
                        borderColor: 'rgba(54, 162, 235, 1)',
                        borderWidth: 1
                    }]
                },
                options: {
                	scales: {
                	      xAxes: [{
                	        time: {
                	          unit: 'month'
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
                	          max: 15000,
                	          maxTicksLimit: 5
                	        },
                	        gridLines: {
                	          display: true
                	        }
                	      }],
                	    },
                    plugins: {
                        legend: {
                            display: false
                        },
                        tooltip: {
                            callbacks: {
                                label: function(context) {
                                    var value = context.raw;
                                    return value + ' 매출';
                                }
                            }
                        }
                    }
                }
            });
        }
    });
});

</script>
<%@ include file="adfooter.jsp"%>

