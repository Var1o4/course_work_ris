<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>ЕРИП 2.0 | Счета</title>
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

        .page-header h2 {
            margin: 0;
            color: #2e7d32;
        }

        .payments-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            margin-top: 0;
        }

        .payments-table th {
            background-color: #f5f5f5;
            color: #2e7d32;
            text-align: left;
            padding: 15px;
            font-weight: 600;
            border-bottom: 2px solid #e0e0e0;
        }

        .payments-table td {
            padding: 12px 15px;
            border-bottom: 1px solid #f0f0f0;
            vertical-align: middle;
        }

        .payment-name {
            display: flex;
            align-items: center;
            gap: 8px;
            color: #2e7d32;
        }

        .status-badge {
            display: inline-block;
            padding: 5px 10px;
            border-radius: 15px;
            font-size: 12px;
            font-weight: bold;
        }

        .status-active { background-color: #c8e6c9; color: #2e7d32; }
        .status-frozen { background-color: #bbdefb; color: #1976d2; }
        .status-arrested { background-color: #ffcdd2; color: #c62828; }

        .btn {
            padding: 8px 16px;
            border-radius: 5px;
            border: none;
            cursor: pointer;
            font-size: 14px;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            text-decoration: none;
            transition: all 0.2s;
        }

        .btn-create {
            background-color: #2e7d32;
            color: white;
        }

        .btn-freeze {
            background-color: #1976d2;
            color: white;
        }

        .empty-state {
            text-align: center;
            padding: 40px;
            color: #757575;
        }

        .empty-state i {
            font-size: 48px;
            margin-bottom: 20px;
            color: #bdbdbd;
        }

        .empty-state h3 {
            color: #2e7d32;
            margin-bottom: 10px;
        }

        .empty-state p {
            margin: 10px 0;
        }

        .empty-state a {
            color: #1976d2;
            text-decoration: none;
        }

        .empty-state a:hover {
            text-decoration: underline;
        }

        .app-title {
            font-size: 24px;
            font-weight: bold;
            color: white;
            margin-bottom: 30px;
            padding-bottom: 15px;
            border-bottom: 2px solid rgba(255, 255, 255, 0.2);
        }

        .menu-items {
            display: flex;
            flex-direction: column;
            gap: 10px;
        }

        .menu-item {
            position: relative;
            color: white;
            text-decoration: none;
            padding: 10px;
            border-radius: 5px;
            transition: background-color 0.3s;
        }

        .menu-item:hover {
            background-color: rgba(255, 255, 255, 0.1);
        }

        .menu-item.has-submenu:hover .submenu {
            display: block;
        }

        .submenu {
            display: none;
            position: absolute;
            left: 100%;
            top: 0;
            background-color: #388e3c;
            border-radius: 5px;
            padding: 10px;
            min-width: 200px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
        }

        .submenu a {
            color: white;
            text-decoration: none;
            display: block;
            padding: 8px 15px;
            border-radius: 3px;
            transition: background-color 0.3s;
        }

        .submenu a:hover {
            background-color: rgba(255, 255, 255, 0.1);
        }

        .logout-btn {
            background: none;
            border: none;
            color: white;
            cursor: pointer;
            width: 100%;
            text-align: left;
            padding: 10px;
            font-size: 14px;
        }

        .logout-btn:hover {
            background-color: rgba(255, 255, 255, 0.1);
        }

        .main-account {
            background-color: rgba(46, 125, 50, 0.1);
        }
        
        .btn-set-main {
            background-color: #fb8c00;
            color: white;
        }
        
        .main-account-badge {
            background-color: #2e7d32;
            color: white;
            padding: 2px 8px;
            border-radius: 12px;
            font-size: 12px;
            margin-left: 8px;
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
                    <h2>Счета</h2>
                    <div class="page-actions">
                        <#if contract?? && contract.status == 'ACTIVE'>
                            <a href="/bills/create" class="btn btn-create">
                                <i class="fas fa-plus"></i> Создать новый счёт
                            </a>
                        </#if>
                    </div>
                </div>

                <#if contract?? && contract.status == 'ACTIVE'>
                    <#if bills?? && bills?size gt 0>
                        <table class="payments-table">
                            <thead>
                                <tr>
                                    <th style="width: 25%">Номер счёта</th>
                                    <th style="width: 20%">Дата создания</th>
                                    <th style="width: 15%">Валюта</th>
                                    <th style="width: 15%">Остаток</th>
                                    <th style="width: 10%">Статус</th>
                                    <th style="width: 15%">Действия</th>
                                </tr>
                            </thead>
                            <tbody>
                                <#list bills as bill>
                                    <tr class="${bill.mainAccount?then('main-account', '')}">
                                        <td>
                                            <div class="payment-name">
                                                <i class="fas fa-wallet"></i>
                                                <a href="/bills/${bill.invoiceId}/details" style="color: inherit; text-decoration: none;">
                                                    #${bill.invoiceId}
                                                </a>
                                                <#if bill.mainAccount>
                                                    <span class="main-account-badge">Основной счёт</span>
                                                </#if>
                                            </div>
                                        </td>
                                        <td></td>
                                        <td>${bill.nationalCurrency?string('BYN', 'USD')}</td>
                                        <td>${bill.amount}</td>
                                        <td>
                                            <span class="status-badge status-${bill.status?lower_case}">
                                                ${bill.status}
                                            </span>
                                        </td>
                                        <td>
                                            <div class="action-buttons">
                                                <#if !bill.mainAccount>
                                                    <form action="/bills/${bill.invoiceId}/set-main" method="POST" style="display: inline;">
                                                        <input type="hidden" name="_csrf" value="${_csrf.token}">
                                                        <button type="submit" class="btn btn-set-main" title="Сделать основным">
                                                            <i class="fas fa-star"></i>
                                                        </button>
                                                    </form>
                                                </#if>
                                                <#if bill.status == 'ACTIVE'>
                                                    <form action="/bills/${bill.invoiceId}/freeze" method="post" style="display: inline;">
                                                        <input type="hidden" name="_csrf" value="${_csrf.token}">
                                                        <button type="submit" class="btn btn-freeze">
                                                            <i class="fas fa-snowflake"></i> Заморозить
                                                        </button>
                                                    </form>
                                                </#if>
                                            </div>
                                        </td>
                                    </tr>
                                </#list>
                            </tbody>
                        </table>
                    <#else>
                        <div class="empty-state">
                            <i class="fas fa-wallet"></i>
                            <p>У вас пока нет счетов</p>
                        </div>
                    </#if>
                <#else>
                    <div class="empty-state">
                        <i class="fas fa-exclamation-circle"></i>
                        <h3>Для создания счетов необходим активный договор</h3>
                        <p>Пожалуйста, убедитесь что у вас есть активный договор с нашим сервисом.</p>
                        <#if !user.verified>
                            <p>Для получения договора необходимо пройти <a href="/verify">верификацию</a>.</p>
                        </#if>
                    </div>
                </#if>
            </div>
        </div>
    </div>
</body>
</html>