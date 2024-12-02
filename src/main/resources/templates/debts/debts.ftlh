<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>ЕРИП 2.0 | Задолженности</title>
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

        .dashboard {
            display: grid;
            grid-template-columns: 1fr;
            gap: 20px;
        }

        .debts-container {
            background: white;
            border-radius: 10px;
            padding: 25px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            border-bottom: 2px solid #81c784;
            padding-bottom: 15px;
        }

        .page-header h2 {
            color: #2e7d32;
            margin: 0;
        }

        .debts-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            margin-top: 20px;
        }

        .debts-table th {
            background-color: #f8f9fa;
            color: #2e7d32;
            padding: 15px;
            text-align: left;
            border-bottom: 2px solid #e0e0e0;
        }

        .debts-table td {
            padding: 12px 15px;
            border-bottom: 1px solid #f0f0f0;
        }

        .btn {
            height: 36px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 0 16px;
            border-radius: 4px;
            border: none;
            cursor: pointer;
            font-size: 14px;
            text-decoration: none;
            transition: all 0.3s;
        }

        .btn-pay {
            background-color: #2e7d32;
            color: white;
        }

        .btn-pay:hover {
            background-color: #1b5e20;
        }

        .btn-view {
            background-color: #1976d2;
            color: white;
        }

        .btn-view:hover {
            background-color: #1565c0;
        }

        .empty-state {
            text-align: center;
            padding: 40px;
            color: #757575;
            background: white;
            border-radius: 10px;
            margin-top: 20px;
        }

        .empty-state i {
            font-size: 48px;
            color: #81c784;
            margin-bottom: 20px;
        }

        .empty-state h3 {
            color: #2e7d32;
            margin-bottom: 10px;
        }
    </style>
</head>
<body>
    <#include "../common/navigation.ftlh">
    
    <div class="content">
        <div class="dashboard">
            <div class="debts-container">
                <div class="page-header">
                    <h2>Задолженности</h2>
                </div>

                <#if debts?? && debts?size gt 0>
                    <table class="debts-table">
                        <thead>
                            <tr>
                                <th>Название</th>
                                <th>Сумма</th>
                                <th>Срок оплаты</th>
                                <th>Действия</th>
                            </tr>
                        </thead>
                        <tbody>
                            <#list debts as debt>
                                <tr>
                                    <td>${debt.name}</td>
                                    <td>${debt.amount} BYN</td>
                                    <td>${debt.dueDate}</td>
                                    <td>
                                        <a href="/debts/${debt.id}/pay" class="btn btn-pay">
                                            <i class="fas fa-credit-card"></i> Оплатить
                                        </a>
                                        <a href="/debts/${debt.id}" class="btn btn-view">
                                            <i class="fas fa-eye"></i> Просмотр
                                        </a>
                                    </td>
                                </tr>
                            </#list>
                        </tbody>
                    </table>
                <#else>
                    <div class="empty-state">
                        <i class="fas fa-check-circle"></i>
                        <h3>У вас нет задолженностей</h3>
                        <p>Все платежи выполнены вовремя</p>
                    </div>
                </#if>
            </div>
        </div>
    </div>
</body>
</html> 