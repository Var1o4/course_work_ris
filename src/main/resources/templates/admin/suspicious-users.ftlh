<!DOCTYPE html>
<html>
<head>
    <title>ЕРИП 2.0 | Подозрительные пользователи</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f5f5f5;
            display: flex;
        }

        .content {
            flex: 1;
            padding: 30px;
            margin-left: 20px;
        }

        .page-title {
            color: #333;
            margin-bottom: 30px;
            padding-bottom: 10px;
            border-bottom: 2px solid #2e7d32;
        }

        .users-grid {
            display: grid;
            gap: 20px;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
        }

        .user-card {
            background: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .user-info {
            margin-bottom: 15px;
        }

        .info-label {
            font-weight: bold;
            color: #666;
            display: block;
            margin-bottom: 5px;
        }

        .info-value {
            color: #333;
        }

        .suspicious-reason {
            background: #fff3e0;
            padding: 10px;
            border-radius: 5px;
            margin-top: 10px;
            border-left: 4px solid #ff9800;
        }

        .actions {
            display: flex;
            gap: 10px;
            margin-top: 15px;
        }

        .action-btn {
            padding: 8px 16px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }

        .btn-view {
            background: #2196f3;
            color: white;
        }

        .btn-block {
            background: #f44336;
            color: white;
        }

        .empty-message {
            text-align: center;
            padding: 40px;
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            color: #666;
        }
    </style>
</head>
<body>
    <#include "../common/navigation.ftlh">
    
    <div class="content">
        <h1 class="page-title">
            <i class="fas fa-exclamation-triangle" style="color: #ff9800; margin-right: 10px;"></i>
            Подозрительные пользователи
        </h1>
        
        <#if suspiciousUsers?? && suspiciousUsers?size gt 0>
            <div class="users-grid">
                <#list suspiciousUsers as suspicious>
                    <div class="user-card">
                        <div class="user-info">
                            <span class="info-label">ФИО:</span>
                            <span class="info-value">${suspicious.user.name!''}</span>
                        </div>
                        
                        <div class="user-info">
                            <span class="info-label">Email:</span>
                            <span class="info-value">${suspicious.user.email!''}</span>
                        </div>
                        
                        <div class="user-info">
                            <span class="info-label">Номер счета:</span>
                            <span class="info-value">#${suspicious.invoice.invoiceId!''}</span>
                        </div>
                        
                        <div class="suspicious-reason">
                            <i class="fas fa-exclamation-triangle"></i>
                            Количество уникальных отправителей: ${suspicious.sendersCount!'0'}
                        </div>
                        
                        <div class="actions">
                            <a href="/admin/users/${suspicious.user.id!''}" class="action-btn btn-view">
                                <i class="fas fa-eye"></i> Просмотр
                            </a>
                            <form action="/admin/users/${suspicious.user.id!''}/toggle-ban" method="POST" style="display: inline;">
                                <input type="hidden" name="_csrf" value="${_csrf.token}">
                                <button type="submit" class="action-btn btn-block">
                                    <i class="fas fa-ban"></i> Заблокировать
                                </button>
                            </form>
                        </div>
                    </div>
                </#list>
            </div>
        <#else>
            <div class="empty-message">
                <i class="fas fa-check-circle" style="font-size: 48px; color: #4caf50; margin-bottom: 20px;"></i>
                <h3>Подозрительных пользователей не обнаружено</h3>
                <p>В данный момент в системе нет пользователей, требующих особого внимания.</p>
            </div>
        </#if>
    </div>
</body>
</html> 