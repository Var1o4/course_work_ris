<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>ЕРИП 2.0 | График курсов валют</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            display: flex;
            background-color: #f5f5f5;
        }

        .content {
            flex: 1;
            padding: 30px;
        }

        .chart-container {
            background: white;
            border-radius: 10px;
            padding: 25px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }

        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
            padding-bottom: 15px;
            border-bottom: 2px solid #81c784;
        }

        .page-header h2 {
            color: #2e7d32;
            margin: 0;
        }

        .period-selector {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
        }

        .btn {
            padding: 8px 16px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
            transition: all 0.3s;
            background-color: #e8f5e9;
            color: #2e7d32;
        }

        .btn:hover {
            background-color: #c8e6c9;
        }

        .btn.active {
            background-color: #2e7d32;
            color: white;
        }

        .breadcrumb {
            margin-bottom: 20px;
            color: #666;
        }

        .breadcrumb a {
            color: #2e7d32;
            text-decoration: none;
        }

        #rateChart {
            width: 100% !important;
            height: 400px !important;
        }
    </style>
</head>
<body>
    <#include "../common/navigation.ftlh">
    
    <div class="content">
        <nav class="breadcrumb">
            <a href="/">Главная</a> / График курсов валют
        </nav>

        <div class="chart-container">
            <div class="page-header">
                <h2>График курса валют</h2>
            </div>

            <div class="period-selector">
                <button onclick="changePeriod('day')" class="btn active">День</button>
                <button onclick="changePeriod('10days')" class="btn">10 дней</button>
                <button onclick="changePeriod('month')" class="btn">Месяц</button>
                <button onclick="changePeriod('year')" class="btn">Год</button>
            </div>
            
            <canvas id="rateChart"></canvas>
        </div>
    </div>

<#noparse>
<script>
const API_BASE = 'https://api.nbrb.by/';
let chart;
const USD_ID = 431;
const EUR_ID = 451;

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
        const currencyResponse = await fetch(`${API_BASE}ExRates/Currencies/${currencyId}`);
        if (!currencyResponse.ok) throw new Error(`HTTP error! status: ${currencyResponse.status}`);
        const currencyInfo = await currencyResponse.json();

        const ratesResponse = await fetch(
            `${API_BASE}ExRates/Rates/Dynamics/${currencyId}?startDate=${formatDate(startDate)}&endDate=${formatDate(endDate)}`
        );
        if (!ratesResponse.ok) throw new Error(`HTTP error! status: ${ratesResponse.status}`);
        const data = await ratesResponse.json();
        
        if (!Array.isArray(data)) throw new Error('Данные не являются массивом');
        updateChart(data, currencyInfo);
    } catch (error) {
        console.error('Ошибка загрузки данных:', error);
        const ctx = document.getElementById('rateChart').getContext('2d');
        if (chart) chart.destroy();
        ctx.font = '14px Arial';
        ctx.fillStyle = '#d32f2f';
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
            borderColor: '#2e7d32',
            backgroundColor: '#e8f5e9',
            tension: 0.3,
            fill: true
        }]
    };

    if (chart) chart.destroy();

    chart = new Chart(ctx, {
        type: 'line',
        data: chartData,
        options: {
            responsive: true,
            maintainAspectRatio: false,
            interaction: {
                intersect: false,
                mode: 'index'
            },
            scales: {
                y: {
                    beginAtZero: false,
                    grid: {
                        color: '#e0e0e0'
                    },
                    ticks: {
                        callback: function(value) {
                            return value + ' BYN';
                        }
                    }
                },
                x: {
                    grid: {
                        color: '#e0e0e0'
                    }
                }
            },
            plugins: {
                tooltip: {
                    backgroundColor: '#2e7d32',
                    callbacks: {
                        label: function(context) {
                            return `${context.dataset.label}: ${context.parsed.y} BYN`;
                        }
                    }
                },
                legend: {
                    labels: {
                        font: {
                            size: 14
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