<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Профиль пользователя</title>

    <style>
        html {
            background: #e8f5e9;
        }

        body {
            font-family: Roboto, sans-serif;
            font-size: 14px;
            color: #2e7d32;
            letter-spacing: 0.2px;
            display: flex;
            height: 100vh;
            margin: 0 5% 0 5%;
            box-shadow: -10px -10px 20px 30px rgba(0, 0, 0, 0.1);
            background-color: #ffffff;
        }

        .menu {
            width: 15%;
            background-color: #2e7d32;
            padding: 20px;
            height: 100vh;
            display: flex;
            flex-direction: column;
        }

        .menu ul {
            list-style-type: none;
            padding: 0;
            margin: 0;
        }

        .menu li {
            margin-bottom: 15px;
        }

        .menu a {
            text-decoration: none;
            color: #ffffff;
            display: block;
            padding: 10px;
            border-radius: 5px;
            transition: 0.3s;
        }

        .menu a:hover {
            background-color: #1b5e20;
        }

        .menu a.active {
            background-color: #1b5e20;
            border-left: 4px solid #81c784;
        }

        .profile-container {
            flex: 1;
            padding: 30px;
            background-color: #ffffff;
        }

        .profile-header {
            display: flex;
            align-items: center;
            margin-bottom: 30px;
            padding: 20px;
            background-color: #f1f8e9;
            border-radius: 10px;
        }

        .profile-avatar {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            background-color: #2e7d32;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 36px;
            margin-right: 20px;
        }

        .profile-info {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 20px;
        }

        .info-card {
            background-color: #f1f8e9;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        .info-card h3 {
            color: #2e7d32;
            margin-bottom: 15px;
            border-bottom: 2px solid #81c784;
            padding-bottom: 5px;
        }

        .info-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
            padding: 5px 0;
        }

        .info-label {
            color: #666;
            font-weight: 500;
        }

        .info-value {
            color: #2e7d32;
            font-weight: 600;
        }

        .edit-button {
            background-color: #2e7d32;
            color: white;
            padding: 8px 15px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: 0.3s;
            margin-top: 10px;
        }

        .edit-button:hover {
            background-color: #1b5e20;
        }

        .account-status {
            padding: 5px 10px;
            border-radius: 15px;
            font-size: 12px;
            font-weight: bold;
        }

        .status-active {
            background-color: #c8e6c9;
            color: #2e7d32;
        }

        .status-inactive {
            background-color: #ffcdd2;
            color: #c62828;
        }

        .submit-button {
            background-color: #2e7d32;
            color: white;
            padding: 12px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: 0.3s;
        }

        .submit-button:hover {
            background-color: #1b5e20;
        }
    </style>
</head>
<body>
    <div class="menu">
        <ul>
            <li><a href="/payments">Платежи</a></li>
            <li><a href="/history">История</a></li>
            <li><a href="/favorites">Избранное</a></li>
            <li><a href="/settings">Настройки</a></li>
        </ul>
        
        <div style="margin-top: auto;">
            <form action="/logout" method="post">
                <input type="hidden" name="_csrf" value="${_csrf.token}">
                <input type="submit" value="Выйти" class="submit-button">
            </form>
        </div>
    </div>

    <div class="profile-container">
        <div class="profile-header">
            <div class="profile-avatar">
                <#if user.name??>
                    ${user.name?substring(0,1)}
                </#if>
            </div>
            <div>
                <h2>${user.name!''}</h2>
                <p>ID: ${user.id!''}</p>
                <span class="account-status ${user.active?string('status-active', 'status-inactive')}">
                    ${user.active?string('Активный аккаунт', 'Неактивный аккаунт')}
                </span>
            </div>
        </div>

        <div class="profile-info">
            <div class="info-card">
                <h3>Основная информация</h3>
                <div class="info-row">
                    <span class="info-label">Email:</span>
                    <span class="info-value">${user.email!''}</span>
                </div>
                <div class="info-row">
                    <span class="info-label">Телефон:</span>
                    <span class="info-value">${user.phoneNumber!''}</span>
                </div>
                <div class="info-row">
                    <span class="info-label">Специальность:</span>
                    <span class="info-value">${user.speciality!''}</span>
                </div>
                <div class="info-row">
                    <span class="info-label">Опыт:</span>
                    <span class="info-value">${user.expirience!''}</span>
                </div>
                <a href="/profile/edit">
                    <button class="edit-button">Редактировать</button>
                </a>
            </div>

            <div class="info-card">
                <h3>Роли и права доступа</h3>
                <div class="info-row">
                    <span class="info-label">Роли:</span>
                    <span class="info-value">
                        <#list user.roles as role>
                            ${role}<#sep>, 
                        </#list>
                    </span>
                </div>
                <div class="info-row">
                    <span class="info-label">Дата регистрации:</span>
                    <span class="info-value">${user.dateOfCreated!''}</span>
                </div>
            </div>
        </div>
    </div>
</body>
</html>