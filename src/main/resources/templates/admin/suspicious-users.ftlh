<!DOCTYPE html>
<html>
<head>
    <title>Подозрительные пользователи</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <style>
        .suspicious-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        
        .suspicious-table th,
        .suspicious-table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        
        .suspicious-table th {
            background-color: #f5f5f5;
        }
        
        .suspicious-row:hover {
            background-color: #f9f9f9;
        }
        
        .warning-icon {
            color: #ff9800;
            margin-right: 5px;
        }
    </style>
</head>
<body>
    <div class="menu">
        <#include "../parts/navbar.ftlh">
    </div>
    
    <div class="content">
        <h2><i class="fas fa-exclamation-triangle warning-icon"></i>Подозрительные пользователи</h2>
        
        <table class="suspicious-table">
            <thead>
                <tr>
                    <th>Пользователь</th>
                    <th>Email</th>
                    <th>Номер счета</th>
                    <th>Количество уникальных отправителей</th>
                    <th>Действия</th>
                </tr>
            </thead>
            <tbody>
                <#list suspiciousUsers as suspicious>
                    <tr class="suspicious-row">
                        <td>${suspicious.user.name}</td>
                        <td>${suspicious.user.email}</td>
                        <td>#${suspicious.invoice.invoiceId}</td>
                        <td>${suspicious.sendersCount}</td>
                        <td>
                            <a href="/admin/users/${suspicious.user.id}" class="btn">
                                <i class="fas fa-eye"></i> Просмотр
                            </a>
                        </td>
                    </tr>
                <#else>
                    <tr>
                        <td colspan="5">Подозрительных пользователей не найдено</td>
                    </tr>
                </#list>
            </tbody>
        </table>
    </div>
</body>
</html> 