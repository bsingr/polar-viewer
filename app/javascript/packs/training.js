import {CategoryScale, Chart, LinearScale, LineController, LineElement, PointElement} from 'chart.js';
import moment from 'moment';

Chart.register(LinearScale, LineController, CategoryScale, LineElement, PointElement);

window.drawChart = function (id, label, labels, data, color) {
    const context = document.getElementById(id).getContext('2d');
    const chart = new Chart(context, {
        type: 'line',
        data: {
            labels: labels,
            datasets: [{
                label: label,
                data: data,
                borderColor: color
            }]
        },
        options: {
            responsive: false,
            scales: {
                y: {
                    beginAtZero: true
                }
            },
            elements: {
                point: {
                    radius: 0
                }
            },
        }
    });
}
