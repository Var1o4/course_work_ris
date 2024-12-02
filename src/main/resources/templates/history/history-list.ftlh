<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>ЕРИП 2.0 | История</title>
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

        .dashboard {
            display: grid;
            grid-template-columns: 1fr;
            gap: 20px;
        }

        .bills-container {
            background: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }

        .payments-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            margin-top: 20px;
        }

        .payments-table th {
            background-color: #f8f9fa;
            color: #2e7d32;
            padding: 15px;
            text-align: left;
            border-bottom: 2px solid #e0e0e0;
        }

        .payments-table td {
            padding: 12px 15px;
            border-bottom: 1px solid #f0f0f0;
        }

        .value-container {
            display: flex;
            flex-wrap: wrap;
            gap: 6px;
        }

        .value-tag {
            background: #f5f5f5;
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 13px;
            color: #333;
        }

        .old-value .value-tag {
            border-left: 3px solid #f44336;
        }

        .new-value .value-tag {
            border-left: 3px solid #4caf50;
        }

        .action-type {
            display: inline-block;
            padding: 6px 12px;
            border-radius: 4px;
            color: white;
            font-size: 12px;
            font-weight: 500;
            text-transform: uppercase;
        }

        .action-type.INSERT {
            background-color: #4CAF50;
        }

        .action-type.UPDATE {
            background-color: #2196F3;
        }

        .action-type.DELETE {
            background-color: #F44336;
        }

        .table-name {
            color: #1976d2;
            font-weight: 500;
        }

        .action-type.BAN { background-color: #d32f2f; }
        .action-type.UNBAN { background-color: #388e3c; }
        .action-type.CREATE { background-color: #4CAF50; }
        .action-type.DELETE { background-color: #F44336; }
        .action-type.UPDATE { background-color: #2196F3; }
        .action-type.STATUS_CHANGE { background-color: #ff9800; }
        .action-type.TRANSFER { background-color: #9c27b0; }
        .action-type.VERIFICATION { background-color: #00bcd4; }
        .action-type.LOGIN { background-color: #3f51b5; }
        .action-type.LOGOUT { background-color: #607d8b; }
        .action-type.PASSWORD_CHANGE { background-color: #795548; }
        .action-type.EMAIL_CHANGE { background-color: #009688; }
        .action-type.FREEZE { background-color: #00bcd4; }
        .action-type.UNFREEZE { background-color: #ffc107; }
    </style>
</head>
<body>
   
   <#include "../common/navigation.ftlh">
    <div class="content">
        <div class="dashboard">
            <div class="bills-container">
                <div class="page-header">
                    <h2>История действий</h2>
                    <div class="filter-controls">
                        <form action="/history" method="GET" class="period-filter">
                            <select name="period" class="form-control" onchange="this.form.submit()">
                                <option value="all" <#if period == "all">selected</#if>>За все время</option>
                                <option value="day" <#if period == "day">selected</#if>>За день</option>
                                <option value="week" <#if period == "week">selected</#if>>За неделю</option>
                            </select>
                        </form>
                    </div>
                </div>

                <#if histories?? && histories?size gt 0>
                    <table class="payments-table">
                        <thead>
                            <tr>
                                <th>Действие</th>
                                <th>Таблица</th>
                                <th>Старое значение</th>
                                <th>Новое значение</th>
                            </tr>
                        </thead>
                        <tbody>
                            <#list histories as history>
                                <tr>
                                    <td>
                                        <span class="action-type ${history.actionType}">
                                            <#if history.actionType == 'BAN'>
                                                Блокировка
                                            <#elseif history.actionType == 'UNBAN'>
                                                Разблокировка
                                            <#elseif history.actionType == 'CREATE'>
                                                Создание
                                            <#elseif history.actionType == 'DELETE'>
                                                Удаление
                                            <#elseif history.actionType == 'UPDATE'>
                                                Изменение
                                            <#elseif history.actionType == 'STATUS_CHANGE'>
                                                Смена статуса
                                            <#elseif history.actionType == 'TRANSFER'>
                                                Перевод
                                            <#elseif history.actionType == 'VERIFICATION'>
                                                Верификация
                                            <#elseif history.actionType == 'LOGIN'>
                                                Вход
                                            <#elseif history.actionType == 'LOGOUT'>
                                                Выход
                                            <#elseif history.actionType == 'PASSWORD_CHANGE'>
                                                Смена пароля
                                            <#elseif history.actionType == 'EMAIL_CHANGE'>
                                                Смена email
                                            <#elseif history.actionType == 'FREEZE'>
                                                Заморозка счета
                                            <#elseif history.actionType == 'UNFREEZE'>
                                                Разморозка счета
                                            <#else>
                                                ${history.actionType}
                                            </#if>
                                        </span>
                                    </td>
                                    <td>
                                        <span class="table-name">
                                            <#if history.tableName == 'users'>
                                                Пользователи
                                            <#elseif history.tableName == 'invoices'>
                                                Счета
                                            <#elseif history.tableName == 'payments'>
                                                Платежи
                                            <#else>
                                                ${history.tableName}
                                            </#if>
                                        </span>
                                    </td>
                                    <td>
                                        <div class="value-container old-value">
                                            <#if history.oldValues??>
                                                <#list history.oldValues?split(",") as value>
                                                    <span class="value-tag">${value}</span>
                                                </#list>
                                            <#else>
                                                -
                                            </#if>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="value-container new-value">
                                            <#if history.newValues??>
                                                <#list history.newValues?split(",") as value>
                                                    <span class="value-tag">${value}</span>
                                                </#list>
                                            <#else>
                                                -
                                            </#if>
                                        </div>
                                    </td>
                                </tr>
                            </#list>
                        </tbody>
                    </table>
                <#else>
                    <div class="empty-state">
                        <i class="fas fa-history"></i>
                        <p>История действий пуста</p>
                    </div>
                </#if>
            </div>
        </div>
    </div>
</body>
</html> 