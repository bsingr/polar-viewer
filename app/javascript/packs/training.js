import {CategoryScale, Chart, LinearScale, LineController, LineElement, PointElement} from 'chart.js';
import moment from 'moment';

Chart.register(LinearScale, LineController, CategoryScale, LineElement, PointElement);

window.drawChart = function(id, labels, data) {
    const context = document.getElementById(id).getContext('2d');
    const chart = new Chart(context, {
        type: 'line',
        data: {
            labels: labels,
            datasets: [{
                label: 'Heart Rate',
                data: data,
            }]
        },
        options: {
            responsive: false,
            scales: {
                y: {
                    beginAtZero: true
                }
            }
        }
    });
}

