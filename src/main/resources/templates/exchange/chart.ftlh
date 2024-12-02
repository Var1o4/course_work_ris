<!DOCTYPE html>
<html>
<head>
    <title>График курса валют</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
    <div class="period-selector">
        <button onclick="changePeriod('day')" class="btn active">День</button>
        <button onclick="changePeriod('10days')" class="btn">10 дней</button>
        <button onclick="changePeriod('month')" class="btn">Месяц</button>
        <button onclick="changePeriod('year')" class="btn">Год</button>
    </div>
    
    <canvas id="rateChart"></canvas>

<#noparse>
<script>
const API_BASE = 'https://api.nbrb.by/';
let chart;
const USD_ID = 431; // ID доллара США
const EUR_ID = 451; // ID евро

function formatDate(date) {
    const day = date.getDate().toString().padStart(2, '0');
    const month = (date.getMonth() + 1).toString().padStart(2, '0');
    const year = date.getFullYear();
    return `${year}-${month}-${day}`;
}

async function loadChartData(currencyId = USD_ID, period = 'day') {
    const endDate = new Date();
    let startDate = new Date();
    
    switch(period) {
        case 'day':
            startDate.setDate(endDate.getDate() - 1);
            break;
        case '10days':
            startDate.setDate(endDate.getDate() - 10);
            break;
        case 'month':
            startDate.setMonth(endDate.getMonth() - 1);
            break;
        case 'year':
            startDate.setFullYear(endDate.getFullYear() - 1);
            break;
    }

    try {
        // Сначала получим информацию о валюте для отображения
        const currencyResponse = await fetch(`${API_BASE}ExRates/Currencies/${currencyId}`);
        if (!currencyResponse.ok) {
            throw new Error(`HTTP error! status: ${currencyResponse.status}`);
        }
        const currencyInfo = await currencyResponse.json();

        // Затем получим динамику курса
        const ratesResponse = await fetch(
            `${API_BASE}ExRates/Rates/Dynamics/${currencyId}?startDate=${formatDate(startDate)}&endDate=${formatDate(endDate)}`
        );
        if (!ratesResponse.ok) {
            throw new Error(`HTTP error! status: ${ratesResponse.status}`);
        }
        const data = await ratesResponse.json();
        if (!Array.isArray(data)) {
            throw new Error('Данные не являются массивом');
        }
        updateChart(data, currencyInfo);
    } catch (error) {
        console.error('Ошибка загрузки данных:', error);
        const ctx = document.getElementById('rateChart').getContext('2d');
        if (chart) {
            chart.destroy();
        }
        ctx.font = '14px Arial';
        ctx.fillText('Ошибка загрузки данных', 10, 50);
    }
}

function updateChart(data, currencyInfo) {
    const ctx = document.getElementById('rateChart').getContext('2d');
    
    const chartData = {
        labels: data.map(item => new Date(item.Date).toLocaleDateString('ru-RU')),
        datasets: [{
            label: `${currencyInfo.Cur_Name} (${currencyInfo.Cur_Scale} ${currencyInfo.Cur_Abbreviation})/BYN`,
            data: data.map(item => item.Cur_OfficialRate),
            borderColor: 'rgb(75, 192, 192)',
            tension: 0.1,
            fill: false
        }]
    };

    if (chart) {
        chart.destroy();
    }

    chart = new Chart(ctx, {
        type: 'line',
        data: chartData,
        options: {
            responsive: true,
            scales: {
                y: {
                    beginAtZero: false,
                    ticks: {
                        callback: function(value) {
                            return value + ' BYN';
                        }
                    }
                }
            },
            plugins: {
                tooltip: {
                    callbacks: {
                        label: function(context) {
                            return `${context.dataset.label}: ${context.parsed.y} BYN`;
                        }
                    }
                }
            }
        }
    });
}

const urlParams = new URLSearchParams(window.location.search);
const defaultCurrency = urlParams.get('currency') === 'EUR' ? EUR_ID : USD_ID;

document.addEventListener('DOMContentLoaded', () => loadChartData(defaultCurrency, 'day'));

function changePeriod(period) {
    loadChartData(defaultCurrency, period);
    document.querySelectorAll('.btn').forEach(btn => btn.classList.remove('active'));
    event.target.classList.add('active');
}
</script>
</#noparse>
</body>
</html> 