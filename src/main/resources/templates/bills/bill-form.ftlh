<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>ЕРИП 2.0 | Создание счета</title>
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

        .info-card {
            background: white;
            border-radius: 10px;
            padding: 25px;
            margin-bottom: 20px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 800px;
        }

        .info-card h3 {
            color: #2e7d32;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #81c784;
        }

        .info-row {
            margin-bottom: 15px;
        }

        .info-label {
            display: block;
            margin-bottom: 8px;
            color: #333;
            font-weight: 500;
        }

        .form-control {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
            transition: border-color 0.3s;
        }

        .form-control:focus {
            outline: none;
            border-color: #2e7d32;
        }

        .submit-button {
            background-color: #2e7d32;
            color: white;
            padding: 12px 24px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
            transition: background-color 0.3s;
        }

        .submit-button:hover {
            background-color: #1b5e20;
        }

        .cancel-button {
            background-color: #757575;
            color: white;
            padding: 12px 24px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
            text-decoration: none;
            margin-right: 10px;
            transition: background-color 0.3s;
        }

        .cancel-button:hover {
            background-color: #616161;
        }

        .breadcrumb {
            width: 100%;
            max-width: 800px;
            margin-bottom: 20px;
            color: #666;
        }

        .breadcrumb a {
            color: #2e7d32;
            text-decoration: none;
        }

        .button-group {
            display: flex;
            justify-content: flex-start;
            margin-top: 20px;
        }

        .content {
            flex: 1;
            padding: 30px;
            display: flex;
            flex-direction: column;
            align-items: center;
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
            <a href="/bills">Счета</a> / Создание нового счета
        </nav>

        <div class="info-card">
            <h3>Создание нового счета</h3>
            <form action="/bills/create" method="post">
                <input type="hidden" name="_csrf" value="${_csrf.token}">
                
                <div class="info-row">
                    <span class="info-label">Сумма</span>
                    <input type="number" step="0.01" name="amount" class="form-control" required>
                </div>
                
                <div class="info-row">
                    <span class="info-label">Тип валюты</span>
                    <select name="isNationalCurrency" class="form-control" required>
                        <option value="true">BYN (Национальная валюта)</option>
                        <option value="false">USD (Иностранная валюта)</option>
                    </select>
                </div>
                
                <div class="button-group">
                    <a href="/bills" class="cancel-button">Отмена</a>
                    <button type="submit" class="submit-button">Создать счет</button>
                </div>
            </form>
        </div>
    </div>
</body>
</html>