<div class="navbar">
    <div class="logo">
        <a href="/">ЕРИП 2.0</a>
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