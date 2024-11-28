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

        .menu {
            width: 250px;
            background-color: #2e7d32;
            color: white;
            padding: 20px;
            min-height: 100vh;
        }

        .content {
            flex: 1;
            padding: 30px;
        }

        .account-card {
            background: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }

        .account-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            border-bottom: 1px solid #eee;
            padding-bottom: 15px;
        }

        .account-balance {
            font-size: 24px;
            font-weight: bold;
            color: #2e7d32;
        }

        .status-badge {
            padding: 5px 10px;
            border-radius: 12px;
            font-size: 12px;
            color: white;
        }

        .status-active { background-color: #4caf50; }
        .status-frozen { background-color: #2196f3; }

        .btn {
            padding: 8px 16px;
            border-radius: 4px;
            border: none;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            color: white;
            text-decoration: none;
            font-size: 14px;
        }

        .btn-primary { background-color: #2e7d32; }
        .btn-secondary { background-color: #757575; }
        .btn-warning { background-color: #f57c00; }

        .transactions-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        .transactions-table th,
        .transactions-table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #e0e0e0;
        }

        .transactions-table th {
            background-color: #f5f5f5;
            font-weight: 600;
        }

        .amount {
            font-weight: 600;
        }

        .amount.positive {
            color: #2e7d32;
        }

        .amount.negative {
            color: #d32f2f;
        }

        .breadcrumb {
            margin-bottom: 20px;
            color: #666;
        }

        .breadcrumb a {
            color: #2e7d32;
            text-decoration: none;
        }

        .transfer-form {
            margin-top: 20px;
        }

        .form-group {
            margin-bottom: 15px;
        }

        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: 500;
        }

        .form-control {
            width: 100%;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
            box-sizing: border-box;
        }

        .card {
            background: white;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }
        
        #expensesChart {
            width: 100%;
            height: 400px !important;
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <div class="menu">
        <div class="app-title">
            ЕРИП 2.0
        </div>
        <div class="menu-items">
            <a href="/" class="menu-item">Главная</a>
            <div class="menu-item has-submenu">
                Платежи
                <div class="submenu">
                    <#if user?? && (user.hasRole('ROLE_ADMIN') || user.hasRole('ROLE_URFACE'))>
                        <a href="/payments/create">Создать платёж</a>
                        <a href="/payments/my">Мои платежи</a>
                    </#if>
                    <a href="/payments/groups">Все платежи</a>
                </div>
            </div>
            <a href="/bills" class="menu-item">Счета</a>
            <a href="/history" class="menu-item">История</a>
            <a href="/debts" class="menu-item">Задолженности</a>

            <#if user??>
                <form action="/logout" method="post">
                    <input type="hidden" name="_csrf" value="${_csrf.token}">
                    <button type="submit" class="logout-btn">Выйти</button>
                </form>
            <#else>
                <a href="/login" class="menu-item">Войти</a>
                <a href="/registration" class="menu-item">Регистрация</a>
            </#if>
        </div>
    </div>

    <div class="content">
        <nav class="breadcrumb">
            <a href="/bills">Счета</a> / Счет #${bill.invoiceId}
        </nav>

        <div class="account-card">
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
                <p>
                    <strong>Статус:</strong>
                    <span class="status-badge status-${bill.status?lower_case}">${bill.status}</span>
                </p>
                <p><strong>Тип валюты:</strong> ${bill.nationalCurrency?string('BYN (Национальная)', 'USD (Иностранная)')}</p>
                <p><strong>Основной счет:</strong> ${bill.mainAccount?string('Да', 'Нет')}</p>
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
        <div class="account-card">
            <h3>Перевод средств</h3>
            <form action="/bills/${bill.invoiceId}/transfer" method="POST" class="transfer-form">
                <input type="hidden" name="_csrf" value="${_csrf.token}">
                <div class="form-group">
                    <label for="targetInvoiceId">Счет получателя:</label>
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
                    <label for="amount">Сумма перевода:</label>
                    <input type="number" name="amount" id="amount" class="form-control" 
                           step="0.01" min="0.01" required>
                </div>
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-exchange-alt"></i> Выполнить перевод
                </button>
            </form>
        </div>
        </#if>

        <div class="account-card">
            <h3>История операций</h3>
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
                                <td>
                                    
                                </td>
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
                                    <#if transaction.type == 'DEPOSIT' || transaction.type == 'TRANSFER_IN'>
                                        +${transaction.amount?string(",##0.00")} BYN
                                    <#else>
                                        -${transaction.amount?string(",##0.00")} BYN
                                    </#if>
                                </td>
                                <td>
                                    ${(transaction.balanceAfter?string(",##0.00"))!''} BYN
                                </td>
                                <td>${transaction.description!''}</td>
                            </tr>
                        </#list>
                    </tbody>
                </table>
            <#else>
                <div class="empty-state">
                    <i class="fas fa-history"></i>
                    <p>История операций пуста</p>
                </div>
            </#if>
        </div>

        <div class="card">
            <h3>Статистика расходов за последние 5 месяцев</h3>
            <canvas id="expensesChart"></canvas>
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
            
            console.log('Monthly expenses data:', monthlyExpenses);
            
            const ctx = document.getElementById('expensesChart').getContext('2d');
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
                            suggestedMin: 0,
                            suggestedMax: 10000,
                            ticks: {
                                stepSize: 1000,
                                callback: function(value) {
                                    return value + ' BYN';
                                }
                            }
                        }
                    },
                    layout: {
                        padding: {
                            top: 20,
                            bottom: 20
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