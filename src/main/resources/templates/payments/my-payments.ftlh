<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Мои платежи</title>
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

        .payments-card {
            background: white;
            border-radius: 10px;
            padding: 25px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        .card-header {
            color: #2e7d32;
            font-size: 24px;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #81c784;
        }

        .payments-table {
            width: 100%;
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            border-collapse: collapse;
            margin-top: 20px;
        }

        .payments-table th {
            background-color: #f5f5f5;
            color: #2e7d32;
            text-align: left;
            padding: 15px;
            font-weight: bold;
            border-bottom: 2px solid #81c784;
        }

        .payments-table td {
            padding: 12px 15px;
            border-bottom: 1px solid #eee;
        }

        .payments-table tr:hover {
            background-color: #f9f9f9;
        }

        .payment-link {
            color: inherit;
            text-decoration: none;
        }

        .payment-link:hover {
            color: #2e7d32;
        }

        .status-badge {
            display: inline-block;
            padding: 5px 10px;
            border-radius: 15px;
            font-size: 12px;
            font-weight: bold;
        }

        .status-paid {
            background-color: #c8e6c9;
            color: #2e7d32;
        }

        .status-pending {
            background-color: #fff3e0;
            color: #ef6c00;
        }

        .btn {
            padding: 5px 10px;
            border-radius: 5px;
            border: none;
            cursor: pointer;
            margin-right: 5px;
        }

        .btn-edit {
            background-color: #2196f3;
            color: white;
        }

        .btn-delete {
            background-color: #f44336;
            color: white;
        }

        .back-button {
            display: inline-block;
            background-color: #2e7d32;
            color: white;
            padding: 10px 20px;
            border-radius: 5px;
            text-decoration: none;
            margin-top: 20px;
            transition: background-color 0.3s;
        }

        .back-button:hover {
            background-color: #1b5e20;
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

        .payments-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
            margin-top: 20px;
        }

        .payment-card {
            background: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        .payment-info {
            margin: 15px 0;
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

        .payments-container {
            background: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
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
        }

        .type-badge {
            display: inline-block;
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 500;
        }

        .type-group {
            background-color: #fff3e0;
            color: #ef6c00;
        }

        .type-payment {
            background-color: #e8f5e9;
            color: #2e7d32;
        }

        .action-buttons {
            display: flex;
            gap: 8px;
            justify-content: flex-end;
        }

        .btn {
            padding: 6px 12px;
            border-radius: 5px;
            border: none;
            cursor: pointer;
            font-size: 14px;
            transition: all 0.2s;
        }

        .btn-create {
            background-color: #2e7d32;
            color: white;
        }

        .btn-pay {
            background-color: #1976d2;
            color: white;
        }

        .btn-edit {
            background-color: #fb8c00;
            color: white;
        }

        .btn-delete {
            background-color: #e53935;
            color: white;
        }

        .empty-state {
            text-align: center;
            padding: 40px;
            color: #757575;
        }

        .empty-state i {
            margin-bottom: 20px;
            color: #bdbdbd;
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
                Пл
                <div class="submenu">
                    <#if user?? && (user.hasRole('ROLE_ADMIN') || user.hasRole('ROLE_URFACE'))>
                        <a href="/payments/create">Создать платёж</a>
                        <a href="/payments/my">Мои платежи</a>
                    </#if>
                    <a href="/payments/groups">се платежи</a>
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
        <div class="page-header">
            <h2>Мои платежи</h2>
            <div class="header-actions">
                <#if user.hasRole('ROLE_ADMIN') || user.hasRole('ROLE_URFACE')>
                    <form action="/payments/upload" method="POST" enctype="multipart/form-data" class="upload-form" accept-charset="UTF-8">
                        <input type="hidden" name="_csrf" value="${_csrf.token}">
                        <input type="file" name="xmlFile" id="xmlFile" accept=".xml" style="display: none;">
                        <button type="button" class="btn btn-upload" onclick="document.getElementById('xmlFile').click();">
                            <i class="fas fa-upload"></i> Загрузить платежи (UTF-8)
                        </button>
                        <small class="form-text text-muted">Файл должен быть в кодировке UTF-8</small>
                    </form>
                </#if>
                <a href="/payments/create" class="btn btn-create">
                    <i class="fas fa-plus"></i> Создать платёж
                </a>
            </div>
        </div>

        <div class="payments-container">
            <#if payments?? && payments?size gt 0>
                <table class="payments-table">
                    <thead>
                        <tr>
                            <th style="width: 30%">Название</th>
                            <th style="width: 20%">Сумма</th>
                            <th style="width: 15%">Статус</th>
                            <th style="width: 15%">
                                <#if user.hasRole('ROLE_ADMIN')>
                                    Адресат
                                </#if>
                            </th>
                            <th style="width: 20%">Действия</th>
                        </tr>
                    </thead>
                    <tbody>
                        <#list payments as payment>
                            <tr>
                                <td>
                                    <div class="payment-name">
                                        <#if payment.group>
                                            <i class="fas fa-folder" style="color: #ffd54f; margin-right: 8px;"></i>
                                            <a href="/payments/groups/${payment.id}" class="payment-link">${payment.name}</a>
                                        <#else>
                                            <i class="fas fa-file-invoice" style="color: #81c784; margin-right: 8px;"></i>
                                            <a href="/payments/view/${payment.id}" class="payment-link">${payment.name}</a>
                                        </#if>
                                    </div>
                                </td>
                                <td>
                                    <#if !payment.group>
                                        <strong>${(payment.amount)!'0.00'} BYN</strong>
                                    </#if>
                                </td>
                                <td>
                                    <#if !payment.group>
                                        <span class="status-badge status-${(payment.status == 'PAID')?string('paid', 'pending')}">
                                            ${payment.status}
                                        </span>
                                    </#if>
                                </td>
                                <td>
                                    <#if user.hasRole('ROLE_ADMIN') && payment.recipient??>
                                        ${payment.recipient.email}
                                    </#if>
                                </td>
                                <td class="actions-cell">
                                    <div class="action-buttons">
                                        <#if !payment.group>
                                            <button class="btn btn-pay" onclick="window.location.href='/payments/${payment.id}/pay'">
                                                <i class="fas fa-credit-card"></i> Оплатить
                                            </button>
                                        </#if>
                                        <#if user?? && (user.hasRole('ROLE_ADMIN') || (user.hasRole('ROLE_URFACE') && payment.user?? && payment.user.id == user.id))>
                                            <a href="/payments/edit/${payment.id}" class="btn btn-edit">
                                                <i class="fas fa-edit"></i>
                                            </a>
                                            <form action="/payments/delete/${payment.id}" method="POST" style="display: inline;">
                                                <input type="hidden" name="_csrf" value="${_csrf.token}">
                                                <button type="submit" class="btn btn-delete" onclick="return confirm('Вы уверены?');">
                                                    <i class="fas fa-trash"></i>
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
                    <i class="fas fa-inbox fa-3x"></i>
                    <p>У вас пока нет платежей</p>
                    <a href="/payments/create" class="btn btn-create">Создать первый платёж</a>
                </div>
            </#if>
        </div>
    </div>

    <script>
    document.getElementById('xmlFile').addEventListener('change', function() {
        if (this.files.length > 0) {
            document.querySelector('.upload-form').submit();
        }
    });
    </script>
</body>
</html> 