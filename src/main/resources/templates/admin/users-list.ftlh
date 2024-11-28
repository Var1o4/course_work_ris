<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>ЕРИП 2.0 | Управление пользователями</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <style>
        .filter-buttons {
            margin-bottom: 20px;
        }
        
        .filter-btn {
            padding: 8px 16px;
            margin-right: 10px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            background-color: #2e7d32;
            color: white;
        }
        
        .filter-btn.active {
            background-color: #1b5e20;
        }
        
        .users-table {
            width: 100%;
            border-collapse: collapse;
        }
        
        .users-table th,
        .users-table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        
        .user-row {
            cursor: pointer;
            transition: background-color 0.3s;
        }
        
        .user-row:hover {
            background-color: #f5f5f5;
        }
        
        .ban-btn {
            padding: 6px 12px;
            border: none;
            border-radius: 4px;
            background-color: #f44336;
            color: white;
            cursor: pointer;
        }
    </style>
</head>
<body>
    <div class="menu">
        <#include "../parts/navbar.ftlh">
    </div>
    
    <div class="content">
        <h2>Управление пользователями</h2>
        
        <div class="filter-buttons">
            <a href="/admin/users" class="filter-btn ${(selectedRole == '')?string('active', '')}">
                Все пользователи
            </a>
            <a href="/admin/users?role=ROLE_USER" class="filter-btn ${(selectedRole == 'ROLE_USER')?string('active', '')}">
                Пользователи
            </a>
            <a href="/admin/users?role=ROLE_URFACE" class="filter-btn ${(selectedRole == 'ROLE_URFACE')?string('active', '')}">
                Юр. лица
            </a>
        </div>
        
        <table class="users-table">
            <thead>
                <tr>
                    <th>Email</th>
                    <th>ФИО</th>
                    <th>Паспортные данные</th>
                    <th>Статус</th>
                    <th>Действия</th>
                </tr>
            </thead>
            <tbody>
                <#list users as user>
                    <tr class="user-row" onclick="window.location='/admin/users/${user.id}'">
                        <td>${user.email}</td>
                        <td>${user.name}</td>
                        <td>${user.passportNumber!''}</td>
                        <td>${user.active?then('Активен', 'Заблокирован')}</td>
                        <td onclick="event.stopPropagation()">
                            <form action="/admin/users/${user.id}/toggle-ban" method="post" style="display: inline;">
                                <input type="hidden" name="_csrf" value="${_csrf.token}">
                                <button type="submit" class="ban-btn" style="background-color: ${user.active?string('#f44336', '#4CAF50')}">
                                    <i class="fas fa-${user.active?string('ban', 'unlock')}"></i> 
                                    ${user.active?string('Заблокировать', 'Разблокировать')}
                                </button>
                            </form>
                        </td>
                    </tr>
                </#list>
            </tbody>
        </table>
    </div>
</body>
</html> 