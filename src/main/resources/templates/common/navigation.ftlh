<style>
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
        background-color: #1b5e20;
    }

    .menu-item.has-submenu {
        cursor: pointer;
    }

    .submenu {
        display: none;
        position: absolute;
        left: 100%;
        top: 0;
        background-color: #2e7d32;
        padding: 10px;
        border-radius: 5px;
        box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
        min-width: 200px;
        z-index: 1000;
    }

    .menu-item.has-submenu:hover .submenu {
        display: flex;
        flex-direction: column;
        gap: 8px;
    }

    .submenu a {
        color: white;
        text-decoration: none;
        padding: 8px 12px;
        border-radius: 4px;
        transition: background-color 0.2s;
    }

    .submenu a:hover {
        background-color: #1b5e20;
    }

    .logout-btn {
        background: none;
        border: none;
        color: white;
        cursor: pointer;
        width: 100%;
        text-align: left;
        padding: 10px;
        border-radius: 5px;
        transition: background-color 0.3s;
    }

    .logout-btn:hover {
        background-color: #1b5e20;
    }
</style>

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
          <a href="/profile" class="menu-item">
            Профиль
        </a>

        <#if user?? && user.hasRole('ROLE_ADMIN')>
            <div class="menu-item has-submenu">
                Админ панель
                <div class="submenu">
                    <a href="/admin/users">Управление пользователями</a>
                    <a href="/admin/verifications">Одобрение верификаций</a>
                    <a href="/admin/suspicious-users">Подозрительные пользователи</a>
                </div>
            </div>
        </#if>

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