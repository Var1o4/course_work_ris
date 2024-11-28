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
            border-collapse: collapse;
            margin-top: 20px;
        }

        .payments-table th,
        .payments-table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #eee;
        }

        .payments-table th {
            background-color: #f5f5f5;
            font-weight: 600;
        }

        .empty-state {
            text-align: center;
            padding: 40px;
            color: #666;
        }

        .empty-state i {
            font-size: 48px;
            margin-bottom: 20px;
            color: #ccc;
        }

        .action-type {
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 0.9em;
            color: white;
        }

        .action-type.CREATE { background-color: #4CAF50; }
        .action-type.UPDATE { background-color: #2196F3; }
        .action-type.DELETE { background-color: #f44336; }
        .action-type.LOGIN { background-color: #9C27B0; }
        .action-type.PAYMENT { background-color: #FF9800; }
        .action-type.TRANSFER { background-color: #795548; }

        .filter-controls {
            margin-bottom: 20px;
        }

        .period-filter {
            display: flex;
            align-items: center;
        }

        .period-filter select {
            padding: 8px;
            border-radius: 4px;
            border: 1px solid #ddd;
            background-color: white;
            margin-left: 10px;
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
                                <th style="width: 20%">Дата и время</th>
                                <th style="width: 15%">Действие</th>
                                <th style="width: 15%">Таблица</th>
                                <th style="width: 35%">Измененные поля</th>
                                <th style="width: 15%">IP адрес</th>
                            </tr>
                        </thead>
                        <tbody>
                            <#list histories as history>
                                <tr>
                                    <td></td>
                                    <td>
                                        <span class="action-type ${history.actionType}">
                                            ${history.actionType}
                                        </span>
                                    </td>
                                    <td>${history.tableName}</td>
                                    <td>${history.changedFields}</td>
                                    <td>${history.ipAddress!''}</td>
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