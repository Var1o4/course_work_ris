<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>ЕРИП 2.0 | Детали счета</title>
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

        .info-card {
            background: white;
            border-radius: 10px;
            padding: 25px;
            margin-bottom: 20px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .account-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
            padding-bottom: 15px;
            border-bottom: 2px solid #81c784;
        }

        .account-header h2 {
            color: #2e7d32;
            margin: 0;
        }

        .account-balance {
            font-size: 24px;
            font-weight: bold;
            color: #2e7d32;
        }

        .account-info {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 20px;
        }

        .info-item {
            padding: 15px;
            background: #f8f9fa;
            border-radius: 8px;
            border-left: 4px solid #2e7d32;
        }

        .transfer-section {
            background: #fff;
            border-radius: 10px;
            padding: 25px;
            margin-bottom: 20px;
        }

        .transfer-form {
            display: grid;
            grid-template-columns: 1fr 1fr auto;
            gap: 20px;
            align-items: end;
        }

        .form-group {
            margin-bottom: 0;
        }

        .form-control {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            transition: all 0.3s;
        }

        .btn-primary {
            background-color: #2e7d32;
            color: white;
        }

        .btn-warning {
            background-color: #ffc107;
            color: #000;
        }

        .btn-success {
            background-color: #28a745;
            color: white;
        }

        .transactions-section {
            margin-top: 30px;
        }

        .transactions-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        .transactions-table th,
        .transactions-table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #eee;
        }

        .transactions-table th {
            background-color: #f8f9fa;
            color: #2e7d32;
        }

        .amount.positive {
            color: #28a745;
        }

        .amount.negative {
            color: #dc3545;
        }

        #expensesChart {
            width: 100% !important;
            height: 400px !important;
            margin: 20px 0;
        }

        .chart-container {
            position: relative;
            margin: auto;
        }

        .breadcrumb {
            margin-bottom: 20px;
            color: #666;
        }

        .breadcrumb a {
            color: #2e7d32;
            text-decoration: none;
        }
    </style>
</head>
<body>
    <#include "../common/navigation.ftlh">
    <div class="content">
        <nav class="breadcrumb">
            <a href="/bills">Счета</a> / Счет #${bill.invoiceId}
        </nav>

        <div class="info-card">
            <div class="account-header">
                <div>
                    <h2>Счет #${bill.invoiceId}</h2>
                    <p>Создан: ${bill.createdDate}</p>
                </div>
                <div class="account-balance">
                    ${bill.amount} BYN
                </div>
            </div>

            <div class="account-info">
                <div class="info-item">
                    <strong>Статус:</strong>
                    <span class="status-badge status-${bill.status?lower_case}">${bill.status}</span>
                </div>
                <div class="info-item">
                    <strong>Тип валюты:</strong>
                    ${bill.nationalCurrency?string('BYN (Национальная)', 'USD (Иностранная)')}
                </div>
                <div class="info-item">
                    <strong>Основной счет:</strong>
                    ${bill.mainAccount?string('Да', 'Нет')}
                </div>
            </div>

            <div class="account-actions">
                <#if !bill.mainAccount>
                    <form action="/bills/${bill.invoiceId}/set-main" method="POST" style="display: inline;">
                        <input type="hidden" name="_csrf" value="${_csrf.token}">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-star"></i> Сделать основным
                        </button>
                    </form>
                </#if>
                
                <#if bill.status == 'ACTIVE'>
                    <form action="/bills/${bill.invoiceId}/freeze" method="POST" style="display: inline;">
                        <input type="hidden" name="_csrf" value="${_csrf.token}">
                        <button type="submit" class="btn btn-warning">
                            <i class="fas fa-snowflake"></i> Заморозить
                        </button>
                    </form>
                <#elseif bill.status == 'FROZEN'>
                    <form action="/bills/${bill.invoiceId}/unfreeze" method="POST" style="display: inline;">
                        <input type="hidden" name="_csrf" value="${_csrf.token}">
                        <button type="submit" class="btn btn-success">
                            <i class="fas fa-sun"></i> Разморозить
                        </button>
                    </form>
                </#if>
            </div>
        </div>

        <#if isOwner>
        <div class="info-card">
            <div class="account-header">
                <h2>Перевод средств</h2>
            </div>
            <form action="/bills/${bill.invoiceId}/transfer" method="POST" class="transfer-form">
                <input type="hidden" name="_csrf" value="${_csrf.token}">
                <div class="form-group">
                    <label for="targetInvoiceId">Счет получателя</label>
                    <select name="targetInvoiceId" id="targetInvoiceId" class="form-control" required>
                        <option value="">Выберите счет</option>
                        <#list userInvoices as targetBill>
                            <#if targetBill.invoiceId != bill.invoiceId>
                                <option value="${targetBill.invoiceId}">#${targetBill.invoiceId}</option>
                            </#if>
                        </#list>
                    </select>
                </div>
                <div class="form-group">
                    <label for="amount">Сумма перевода</label>
                    <input type="number" name="amount" id="amount" class="form-control" 
                           step="0.01" min="0.01" required>
                </div>
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-exchange-alt"></i> Перевести
                </button>
            </form>
        </div>
        </#if>

        <div class="info-card">
            <div class="account-header">
                <h2>Статистика расходов</h2>
            </div>
            <canvas id="expensesChart"></canvas>
        </div>

        <div class="info-card">
            <div class="account-header">
                <h2>История операций</h2>
            </div>
            <#if transactions?? && transactions?size gt 0>
                <table class="transactions-table">
                    <thead>
                        <tr>
                            <th>Дата</th>
                            <th>Тип операции</th>
                            <th>Сумма</th>
                            <th>Баланс после</th>
                            <th>Примечание</th>
                        </tr>
                    </thead>
                    <tbody>
                        <#list transactions as transaction>
                            <tr>
                                <td>${transaction.date!''}</td>
                                <td>
                                    <#if transaction.type == 'TRANSFER_OUT'>
                                        Исходящий перевод
                                    <#elseif transaction.type == 'TRANSFER_IN'>
                                        Входящий перевод
                                    <#elseif transaction.type == 'DEPOSIT'>
                                        Пополнение
                                    <#elseif transaction.type == 'WITHDRAWAL'>
                                        Снятие
                                    <#else>
                                        ${transaction.type!''}
                                    </#if>
                                </td>
                                <td class="amount ${(transaction.type == 'DEPOSIT' || transaction.type == 'TRANSFER_IN')?then('positive','negative')}">
                                    ${transaction.amount!''} BYN
                                </td>
                                <td>${transaction.balanceAfter!''} BYN</td>
                                <td>${transaction.description!''}</td>
                            </tr>
                        </#list>
                    </tbody>
                </table>
            <#else>
                <p>История операций пуста</p>
            </#if>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const monthlyExpenses = [
                <#if monthlyExpenses?? && monthlyExpenses?size gt 0>
                    <#list monthlyExpenses as expense>
                    {
                        month: '${expense.formattedMonth}',
                        amount: ${expense.amount?string["0.##"]}
                    }<#if expense_has_next>,</#if>
                    </#list>
                </#if>
            ];
            
            const canvas = document.getElementById('expensesChart');
            const ctx = canvas.getContext('2d');
            
            new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: monthlyExpenses.map(e => e.month),
                    datasets: [{
                        label: 'Расходы (BYN)',
                        data: monthlyExpenses.map(e => e.amount),
                        backgroundColor: '#2e7d32',
                        borderColor: '#1b5e20',
                        borderWidth: 1
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    scales: {
                        y: {
                            beginAtZero: true,
                            ticks: {
                                callback: function(value) {
                                    return value + ' BYN';
                                }
                            }
                        }
                    },
                    plugins: {
                        legend: {
                            display: true,
                            position: 'top'
                        },
                        tooltip: {
                            callbacks: {
                                label: function(context) {
                                    return context.parsed.y.toFixed(2) + ' BYN';
                                }
                            }
                        }
                    }
                }
            });
        });
    </script>
</body>
</html> 