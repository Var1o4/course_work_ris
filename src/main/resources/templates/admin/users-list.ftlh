<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>ЕРИП 2.0 | Управление пользователями</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f5f5f5;
            display: flex;
        }

        .menu {
            width: 250px;
            background: white;
            min-height: 100vh;
            box-shadow: 2px 0 5px rgba(0,0,0,0.1);
        }

        .content {
            flex: 1;
            padding: 30px;
            margin-left: 20px;
        }

        .page-title {
            color: #333;
            border-bottom: 2px solid #2e7d32;
            padding-bottom: 10px;
            margin-bottom: 30px;
        }

        .filter-buttons {
            margin-bottom: 20px;
            display: flex;
            gap: 10px;
        }
        
        .filter-btn {
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            background-color: #2e7d32;
            color: white;
            text-decoration: none;
            transition: background-color 0.3s;
        }
        
        .filter-btn:hover {
            background-color: #1b5e20;
        }
        
        .filter-btn.active {
            background-color: #1b5e20;
        }
        
        .users-table {
            width: 100%;
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        
        .users-table th {
            background-color: #2e7d32;
            color: white;
            padding: 15px;
            text-align: left;
        }
        
        .users-table td {
            padding: 15px;
            border-bottom: 1px solid #eee;
        }
        
        .user-row {
            cursor: pointer;
            transition: background-color 0.3s;
        }
        
        .user-row:hover {
            background-color: #f8f8f8;
        }
        
        .ban-btn {
            padding: 8px 16px;
            border: none;
            border-radius: 4px;
            color: white;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 8px;
            transition: opacity 0.3s;
        }
        
        .ban-btn:hover {
            opacity: 0.9;
        }
        
        .status-badge {
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 14px;
            font-weight: 500;
        }
        
        .status-active {
            background-color: #4caf50;
            color: white;
        }
        
        .status-banned {
            background-color: #f44336;
            color: white;
        }
    </style>
</head>
<body>

        <#include "../common/navigation.ftlh">
    
    <div class="content">
        <h1 class="page-title">Управление пользователями</h1>
        
        <div class="filter-buttons">
            <a href="/admin/users" class="filter-btn ${(selectedRole == '')?string('active', '')}">
                <i class="fas fa-users"></i> Все пользователи
            </a>
            <a href="/admin/users?role=ROLE_USER" class="filter-btn ${(selectedRole == 'ROLE_USER')?string('active', '')}">
                <i class="fas fa-user"></i> Физические лица
            </a>
            <a href="/admin/users?role=ROLE_URFACE" class="filter-btn ${(selectedRole == 'ROLE_URFACE')?string('active', '')}">
                <i class="fas fa-building"></i> Юридические лица
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
                        <td>
                            <span class="status-badge ${user.active?string('status-active', 'status-banned')}">
                                ${user.active?string('Активен', 'Заблокирован')}
                            </span>
                        </td>
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