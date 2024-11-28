<!DOCTYPE html>
<html>
<head>
    <title>Профиль пользователя</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <style>
        .content {
            padding: 20px;
        }
        
        .profile-section {
            margin-bottom: 30px;
        }
        
        .section-title {
            border-bottom: 2px solid #2e7d32;
            padding-bottom: 10px;
            margin-bottom: 20px;
        }
        
        .info-grid {
            display: grid;
            grid-template-columns: auto 1fr;
            gap: 10px;
            margin-bottom: 20px;
        }
        
        .info-label {
            font-weight: bold;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        
        th, td {
            padding: 10px;
            border: 1px solid #ddd;
            text-align: left;
        }
        
        th {
            background-color: #2e7d32;
            color: white;
        }
        
        .view-btn {
            padding: 6px 12px;
            background-color: #2e7d32;
            color: white;
            text-decoration: none;
            border-radius: 4px;
        }
    </style>
</head>
<body>
    <div class="menu">
        <#include "../parts/navbar.ftlh">
    </div>
    
    <div class="content">
        <div class="profile-section">
            <h2 class="section-title">Информация о пользователе</h2>
            <div class="info-grid">
                <span class="info-label">Email:</span>
                <span>${user.email}</span>
                
                <span class="info-label">ФИО:</span>
                <span>${user.name}</span>
                
                <span class="info-label">Статус:</span>
                <span>${user.active?string('Активен', 'Заблокирован')}</span>
                
                <#if user.passportNumber??>
                    <span class="info-label">Паспортные данные:</span>
                    <span>${user.passportNumber}</span>
                </#if>
            </div>
        </div>
        
        <#if userInvoices?has_content>
            <div class="profile-section">
                <h2 class="section-title">Счета пользователя</h2>
                <table>
                    <thead>
                        <tr>
                            <th>Номер счёта</th>
                            <th>Баланс</th>
                            <th>Статус</th>
                            <th>Действия</th>
                        </tr>
                    </thead>
                    <tbody>
                        <#list userInvoices as invoice>
                            <tr>
                                <td>${invoice.invoiceId!''}</td>
                                <td>${invoice.amount!0} BYN</td>
                                <td>${invoice.status!''}</td>
                                <td>
                                    <a href="/bills/${invoice.invoiceId!''}/details" class="view-btn">
                                        <i class="fas fa-eye"></i> Просмотр
                                    </a>
                                </td>
                            </tr>
                        </#list>
                    </tbody>
                </table>
            </div>
        <#else>
            <div class="profile-section">
                <h2 class="section-title">Счета пользователя</h2>
                <p>У пользователя нет активных счетов</p>
            </div>
        </#if>
        
        <#if user.roles?seq_contains(roleUrface) && payments??>
            <div class="profile-section">
                <h2 class="section-title">Созданные платежи</h2>
                <#if payments?has_content>
                    <table>
                        <thead>
                            <tr>
                                <th>Название</th>
                                <th>Сумма</th>
                                <th>Статус</th>
                                <th>Действия</th>
                            </tr>
                        </thead>
                        <tbody>
                            <#list payments as payment>
                                <tr>
                                    <td>${payment.name!''}</td>
                                    <td>${payment.amount!0} BYN</td>
                                    <td>${payment.status!''}</td>
                                    <td>
                                        <a href="/payments/view/${payment.id!''}" class="view-btn">
                                            <i class="fas fa-eye"></i> Просмотр
                                        </a>
                                    </td>
                                </tr>
                            </#list>
                        </tbody>
                    </table>
                <#else>
                    <p>У пользователя нет созданных платежей</p>
                </#if>
            </div>
        </#if>
    </div>
</body>
</html> 