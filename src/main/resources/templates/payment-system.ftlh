<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>ЕРИП 2.0 | Главная</title>
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

        .content {
            flex: 1;
            padding: 30px;
        }

        .breadcrumbs {
            background: white;
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 20px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        .breadcrumbs a {
            color: #2e7d32;
            text-decoration: none;
        }

        .services-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
        }

        .service-card {
            background: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            cursor: pointer;
            transition: transform 0.3s;
        }

        .service-card:hover {
            transform: translateY(-5px);
        }

        .service-title {
            font-size: 18px;
            font-weight: bold;
            color: #2e7d32;
            margin-bottom: 10px;
        }

        .service-description {
            color: #666;
            font-size: 14px;
        }

        .logout-btn {
            background: none;
            border: none;
            color: white;
            padding: 10px;
            cursor: pointer;
            width: 100%;
            text-align: left;
            font-size: 14px;
        }

        .logout-btn:hover {
            background-color: rgba(255, 255, 255, 0.1);
        }

        .dashboard {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 20px;
        }

        .news-section {
            background: white;
            border-radius: 10px;
            padding: 25px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        .news-header {
            color: #2e7d32;
            font-size: 24px;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #81c784;
        }

        .news-item {
            margin-bottom: 25px;
            padding-bottom: 20px;
            border-bottom: 1px solid #eee;
        }

        .news-item:last-child {
            border-bottom: none;
        }

        .news-date {
            color: #666;
            font-size: 14px;
            margin-bottom: 5px;
        }

        .news-title {
            color: #2e7d32;
            font-size: 18px;
            font-weight: bold;
            margin-bottom: 10px;
        }

        .news-content {
            color: #444;
            line-height: 1.5;
        }

        .side-section {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        .info-card {
            background: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        .info-card h3 {
            color: #2e7d32;
            margin-bottom: 15px;
            padding-bottom: 8px;
            border-bottom: 2px solid #81c784;
        }

        .quick-stats {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 15px;
            margin-bottom: 20px;
        }

        .stat-card {
            background: #f5f5f5;
            padding: 15px;
            border-radius: 8px;
            text-align: center;
        }

        .stat-value {
            font-size: 24px;
            font-weight: bold;
            color: #2e7d32;
        }

        .stat-label {
            font-size: 14px;
            color: #666;
        }

        .useful-links {
            list-style: none;
            padding: 0;
            margin: 0;
        }

        .useful-links li {
            margin-bottom: 10px;
        }

        .useful-links a {
            color: #2e7d32;
            text-decoration: none;
            display: block;
            padding: 8px;
            border-radius: 5px;
            transition: background-color 0.3s;
        }

        .useful-links a:hover {
            background-color: #f5f5f5;
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
        <#if breadcrumbs??>
            <div class="breadcrumbs">
                <a href="/payment">Главная</a>
                <#list breadcrumbs as folder>
                    <span>/</span>
                    <#if folder_has_next>
                        <a href="/payment/${folder.id}">${folder.title}</a>
                    <#else>
                        <span>${folder.title}</span>
                    </#if>
                </#list>
            </div>
        </#if>

        <div class="dashboard">
            <div class="news-section">
                <h2 class="news-header">Новости и обновления</h2>
                
                <div class="news-item">
                    <div class="news-date">15 ноября 2024</div>
                    <div class="news-title">Запуск новой версии платежной системы</div>
                    <div class="news-content">
                        Мы рады представить обновленную версию нашей платежной системы с улучшенным интерфейсом 
                        и новыми возможностями. Теперь оплата услуг стала еще удобнее и быстрее.
                    </div>
                </div>

                <div class="news-item">
                    <div class="news-date">10 ноября 2024</div>
                    <div class="news-title">Добавлены новые способы оплаты</div>
                    <div class="news-content">
                        Расширен список доступных способов оплаты. Теперь вы можете использовать 
                        электронные кошельки и криптовалюту для оплаты услуг.
                    </div>
                </div>

                <div class="news-item">
                    <div class="news-date">5 ноября 2024</div>
                    <div class="news-title">Обновление системы безопасности</div>
                    <div class="news-content">
                        Внедрена двухфакторная аутентификация и улучшена система защиты персональных данных. 
                        Ваши платежи стали еще безопаснее.
                    </div>
                </div>
            </div>

            <div class="side-section">
                <div class="info-card">
                    <h3>Статистика</h3>
                    <div class="quick-stats">
                        <div class="stat-card">
                            <div class="stat-value">1,234</div>
                            <div class="stat-label">Платежей сегодня</div>
                        </div>
                        <div class="stat-card">
                            <div class="stat-value">50+</div>
                            <div class="stat-label">Сервисов</div>
                        </div>
                        <div class="stat-card">
                            <div class="stat-value">99.9%</div>
                            <div class="stat-label">Успешных операций</div>
                        </div>
                        <div class="stat-card">
                            <div class="stat-value">24/7</div>
                            <div class="stat-label">Поддержка</div>
                        </div>
                    </div>
                </div>

                <div class="info-card">
                    <h3>Полезные ссылки</h3>
                    <ul class="useful-links">
                        <li><a href="#">Как совершить платеж</a></li>
                        <li><a href="#">Часто задаваемые вопросы</a></li>
                        <li><a href="#">Правила безопасности</a></li>
                        <li><a href="#">Контакты поддержки</a></li>
                    </ul>
                </div>

                <div class="info-card">
                    <h3>График работы</h3>
                    <p>Пн-Пт: 9:00 - 20:00</p>
                    <p>Сб-Вс: 10:00 - 18:00</p>
                    <p>Технические работы: каждый последний четверг месяца с 02:00 до 05:00</p>
                </div>
            </div>
        </div>
    </div>
</body>
</html> 