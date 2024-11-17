<div class="menu-items">
    <a href="/" class="menu-item">Главная</a>
    <a href="/payment" class="menu-item">Оплата услуг</a>
    <#if user?? && (user.authorities?seq_contains("ROLE_ADMIN") || user.authorities?seq_contains("ROLE_URFACE"))>
        <a href="/services/my" class="menu-item">Мои услуги</a>
    </#if>
    <#if user??>
        <form action="/logout" method="post" class="menu-item">
            <input type="hidden" name="_csrf" value="${_csrf.token}">
            <button type="submit" class="logout-btn">Выйти</button>
        </form>
    </#if>
</div>

<style>
.menu-items {
    display: flex;
    flex-direction: column;
    gap: 15px;
}

.menu-item {
    color: white;
    text-decoration: none;
    padding: 10px;
    border-radius: 5px;
    transition: background-color 0.3s;
}

.menu-item:hover {
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
}

.logout-btn:hover {
    background-color: #1b5e20;
}
</style> 