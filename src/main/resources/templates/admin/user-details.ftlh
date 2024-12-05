<!DOCTYPE html>
<html>
<head>
    <title>ЕРИП 2.0 | Информация о пользователе</title>
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

        .profile-section {
            background: white;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .section-title {
            color: #333;
            border-bottom: 2px solid #2e7d32;
            padding-bottom: 10px;
            margin-bottom: 20px;
        }

        .info-grid {
            display: grid;
            grid-template-columns: auto 1fr;
            gap: 15px;
            align-items: center;
        }

        .info-label {
            font-weight: bold;
            color: #555;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        th {
            background-color: #2e7d32;
            color: white;
            padding: 12px;
            text-align: left;
        }

        td {
            padding: 12px;
            border-bottom: 1px solid #eee;
        }

        .view-btn {
            padding: 6px 12px;
            background-color: #2e7d32;
            color: white;
            text-decoration: none;
            border-radius: 4px;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }

        .ban-btn {
            padding: 8px 16px;
            border: none;
            border-radius: 4px;
            color: white;
            cursor: pointer;
            margin-top: 20px;
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 14px;
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
        <div class="profile-section">
            <h2 class="section-title">Информация о пользователе</h2>
            <div class="info-grid">
                <span class="info-label">Email:</span>
                <span>${user.email!''}</span>
                
                <span class="info-label">ФИО:</span>
                <span>${user.name!''}</span>
                
                <span class="info-label">Статус:</span>
                <span class="status-badge ${user.active?string('status-active', 'status-banned')}">
                    ${user.active?string('Активен', 'Заблокирован')}
                </span>
                
                <#if user.passportNumber??>
                    <span class="info-label">Паспортные данные:</span>
                    <span>${user.passportNumber}</span>
                </#if>
            </div>

            <form action="/admin/users/${user.id}/toggle-ban" method="post">
                <input type="hidden" name="_csrf" value="${_csrf.token}">
                <button type="submit" class="ban-btn" 
                        style="background-color: ${user.active?string('#f44336', '#4CAF50')}">
                    <i class="fas fa-${user.active?string('ban', 'unlock')}"></i>
                    ${user.active?string('Заблокировать', 'Разблокировать')}
                </button>
            </form>
        </div>
        
        <#if userInvoices?has_content>
            <div class="profile-section">
                <h2 class="section-title">Счета пользователя</h2>
                <table>
                    <thead>
                        <tr>
                            <th>Номер счета</th>
                            <th>Сумма</th>
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
        </#if>

        <#if payments?? && user.roles?seq_contains(roleUrface)>
            <div class="profile-section">
                <h2 class="section-title">Платежи пользователя</h2>
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
            </div>
        </#if>
    </div>
</body>
</html> 