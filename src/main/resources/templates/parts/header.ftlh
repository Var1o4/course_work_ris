<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>ЕРИП</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="/static/css/style.css">
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container">
        <a class="navbar-brand" href="/">ЕРИП</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav me-auto">
                <li class="nav-item">
                    <a class="nav-link" href="/payments/groups">Платежи</a>
                </li>
                <#if user?? && user.hasRole('ROLE_ADMIN')>
                    <li class="nav-item">
                        <a class="nav-link" href="/admin">Админ панель</a>
                    </li>
                </#if>
            </ul>
            <ul class="navbar-nav">
                <#if user??>
                    <li class="nav-item">
                        <a class="nav-link" href="/payments/my">Мои платежи</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="/profile">${user.name}</a>
                    </li>
                    <li class="nav-item">
                        <form action="/logout" method="POST" class="d-inline">
                            <button type="submit" class="btn btn-link nav-link">Выйти</button>
                        </form>
                    </li>
                <#else>
                    <li class="nav-item">
                        <a class="nav-link" href="/login">Войти</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="/registration">Регистрация</a>
                    </li>
                </#if>
            </ul>
        </div>
    </div>
</nav>
</body>
</html> 