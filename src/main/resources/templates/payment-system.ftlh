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

        .exchange-rates-container {
            padding: 20px;
            margin: 20px 0;
            background: #f8f9fa;
            border-radius: 8px;
        }

        .rates-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-top: 15px;
        }

        .rate-card {
            padding: 15px;
            background: white;
            border-radius: 6px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            text-align: center;
        }

        .period-selector {
            margin: 20px 0;
            text-align: center;
        }

        .period-selector .btn {
            margin: 0 5px;
            padding: 8px 16px;
            border: 1px solid #ddd;
            border-radius: 4px;
            text-decoration: none;
        }

        .period-selector .btn.active {
            background: #007bff;
            color: white;
        }

        /* Стили для курсов валют и ставки рефинансирования */
        .rate-cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-top: 15px;
        }

        .rate-card {
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .rate-card h4 {
            margin: 0 0 15px 0;
            color: #2e7d32;
            font-size: 18px;
        }

        .currency-rate {
            display: flex;
            justify-content: space-between;
            padding: 8px 0;
            border-bottom: 1px solid #eee;
        }

        .currency-rate:last-child {
            border-bottom: none;
        }

        .rate-value {
            font-weight: bold;
            color: #1976d2;
        }

        /* Стили для новостей и обновлений */
        .news-updates {
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }

        .news-item {
            padding: 15px;
            border-bottom: 1px solid #eee;
            transition: background-color 0.3s;
        }

        .news-item:last-child {
            border-bottom: none;
        }

        .news-item:hover {
            background-color: #f5f5f5;
        }

        .news-date {
            font-size: 12px;
            color: #666;
            margin-bottom: 5px;
        }

        .news-title {
            font-weight: bold;
            color: #2e7d32;
            margin-bottom: 8px;
        }

        .news-content {
            color: #333;
            line-height: 1.5;
        }

        .news-tag {
            display: inline-block;
            padding: 3px 8px;
            border-radius: 12px;
            font-size: 12px;
            margin-right: 5px;
        }

        .tag-update {
            background-color: #e3f2fd;
            color: #1976d2;
        }

        .tag-news {
            background-color: #e8f5e9;
            color: #2e7d32;
        }

        .tag-maintenance {
            background-color: #fff3e0;
            color: #f57c00;
        }
    </style>
</head>
<body>
  
        <#include "common/navigation.ftlh">

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
            <div class="news-updates">
                <h3>Новости и обновления</h3>
                <div class="news-item">
                    <div class="news-date">01.12.2024</div>
                    <span class="news-tag tag-update">Обновление</span>
                    <div class="news-title">Обновление системы до версии 2.5</div>
                    <div class="news-content">
                        Добавлен новый функционал графиков курсов валют, улучшена производительность системы, 
                        оптимизирована работа с платежами.
                    </div>
                </div>
                
                <div class="news-item">
                    <div class="news-date">30.11.2024</div>
                    <span class="news-tag tag-maintenance">Тех. работы</span>
                    <div class="news-title">Плановые технические работы</div>
                    <div class="news-content">
                        В ночь с 30.11 на 01.12 будут проводиться плановые технические работы. 
                        Возможны кратковременные перерывы в работе сервиса.
                    </div>
                </div>
                
                <div class="news-item">
                    <div class="news-date">28.11.2024</div>
                    <span class="news-tag tag-news">Новость</span>
                    <div class="news-title">Запуск программы лояльности</div>
                    <div class="news-content">
                        Теперь за каждый платеж вы получаете бонусные баллы, которые можно использовать 
                        для оплаты следующих платежей. Подробности в разделе "Программа лояльности".
                    </div>
                </div>
            </div>

            <div class="side-section">
             <div class="info-card">
  
                    <div class="rate-cards">
                        <div class="rate-card">
                            <h3>Курсы валют</h3>
                            <div id="exchangeRates">
                                <div class="currency-rate" id="usdRate">
                                    <a href="/exchange-rates/chart"><span>USD:</span></a>
                                    <span class="rate-value">Загрузка...</span>
                                </div>
                                <div class="currency-rate" id="eurRate">
                                     <a href="/exchange-rates/chart?currency=EUR"><span>EUR:</span></a>
                                    <span class="rate-value">Загрузка...</span>
                                </div>
                            </div>
                        </div>
                        <div class="rate-card">
                            <h3>Ставка рефинансирования</h3>
                            <div id="refinancingRate">
                                <span class="rate-value">Загрузка...</span>
                            </div>
                        </div>
                    </div>
                </div>
                
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

    <#noparse>
    <script>
    const API_BASE = 'https://api.nbrb.by/';

    async function loadRates() {
        try {
            const usdResponse = await fetch(`${API_BASE}exrates/rates/USD?parammode=2`);
            const usdData = await usdResponse.json();
            document.querySelector('#usdRate .rate-value').textContent = 
                `${usdData.Cur_OfficialRate} BYN`;

            const eurResponse = await fetch(`${API_BASE}exrates/rates/EUR?parammode=2`);
            const eurData = await eurResponse.json();
            document.querySelector('#eurRate .rate-value').textContent = 
                `${eurData.Cur_OfficialRate} BYN`;

            const refinResponse = await fetch(`${API_BASE}refinancingrate`);
            const refinData = await refinResponse.json();
            document.querySelector('#refinancingRate .rate-value').textContent = 
                `${refinData[0].Value}%`;
        } catch (error) {
            console.error('Ошибка загрузки данных:', error);
            document.querySelector('#exchangeRates').innerHTML = 
                '<div class="error">Сервис временно недоступен</div>';
        }
    }

    document.addEventListener('DOMContentLoaded', loadRates);
    </script>
    </#noparse>
</body>
</html> 