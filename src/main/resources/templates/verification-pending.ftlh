<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>ЕРИП 2.0 | Ожидание верификации</title>
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
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }

        .pending-card {
            background: white;
            border-radius: 10px;
            padding: 40px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            text-align: center;
            max-width: 500px;
            width: 100%;
        }

        .pending-icon {
            font-size: 48px;
            color: #2e7d32;
            margin-bottom: 20px;
        }

        h1 {
            color: #333;
            margin-bottom: 20px;
        }

        p {
            color: #666;
            line-height: 1.6;
            margin-bottom: 20px;
        }

        .logout-btn {
            background: #2e7d32;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
        }

        .logout-btn:hover {
            background: #1b5e20;
        }
    </style>
</head>
<body>
    <div class="content">
        <div class="pending-card">
            <i class="fas fa-clock pending-icon"></i>
            <h1>Ожидание верификации</h1>
            <p>Ваша заявка на верификацию находится на рассмотрении. Пожалуйста, дождитесь подтверждения от администратора.</p>
            <p>После подтверждения вы получите доступ ко всем функциям системы.</p>
            <form action="/logout" method="post">
                <input type="hidden" name="_csrf" value="${_csrf.token}">
                <button type="submit" class="logout-btn">Выйти</button>
            </form>
        </div>
    </div>
</body>
</html>