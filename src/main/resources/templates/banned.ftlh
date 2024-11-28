<!DOCTYPE html>
<html>
<head>
    <title>Аккаунт заблокирован</title>
    <link rel="stylesheet" href="/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
</head>
<body>
    <div class="banned-container">
        <div class="banned-content">
            <i class="fas fa-ban banned-icon"></i>
            <h1>Аккаунт заблокирован</h1>
            <p>Ваш аккаунт был заблокирован администратором.</p>
            <p>Если вы считаете, что это ошибка, пожалуйста, свяжитесь с поддержкой.</p>
            
            <div class="banned-actions">
                <form action="/logout" method="post">
                    <input type="hidden" name="_csrf" value="${_csrf.token}">
                    <button type="submit" class="btn btn-primary">Выйти</button>
                </form>
                <a href="mailto:support@example.com" class="btn btn-secondary">
                    <i class="fas fa-envelope"></i> Связаться с поддержкой
                </a>
            </div>
        </div>
    </div>
</body>
</html>