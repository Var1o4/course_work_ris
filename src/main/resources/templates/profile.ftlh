<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ЕРИП 2.0 | Профиль</title>
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
        }

        .dashboard {
            background: white;
            border-radius: 10px;
            padding: 25px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .profile-header {
            display: flex;
            align-items: center;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 1px solid #e0e0e0;
        }

        .profile-icon {
            width: 60px;
            height: 60px;
            background-color: #e8f5e9;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 20px;
            color: #2e7d32;
            font-size: 24px;
        }

        .info-row {
            display: flex;
            margin-bottom: 15px;
            padding: 10px;
            border-bottom: 1px solid #f5f5f5;
        }

        .info-label {
            width: 200px;
            color: #757575;
            font-weight: bold;
        }

        .info-value {
            flex: 1;
            color: #424242;
        }

        .verification-status {
            display: inline-flex;
            align-items: center;
            padding: 5px 10px;
            border-radius: 15px;
            font-size: 14px;
            gap: 5px;
        }

        .status-verified {
            background-color: #e8f5e9;
            color: #2e7d32;
        }

        .status-unverified {
            background-color: #ffebee;
            color: #d32f2f;
        }
    </style>
</head>
<body>
    <#include "common/navigation.ftlh">
    
    <div class="content">
        <div class="dashboard">
            <div class="profile-header">
                <div class="profile-icon">
                    <i class="fas fa-user"></i>
                </div>
                <h2>Профиль пользователя</h2>
            </div>

            <div class="info-row">
                <span class="info-label">Email:</span>
                <span class="info-value">${user.email!''}</span>
            </div>

            <div class="info-row">
                <span class="info-label">Статус верификации:</span>
                <span class="verification-status ${user.verified?then('status-verified','status-unverified')}">
                    <i class="fas ${user.verified?then('fa-check-circle','fa-times-circle')}"></i>
                    ${user.verified?then('Верифицирован','Не верифицирован')}
                </span>
            </div>

            <div class="info-row">
                <span class="info-label">Тип пользователя:</span>
                <span class="info-value">
                    <#list user.roles as role>
                        <#if role == "ROLE_USER">Физическое лицо
                        <#elseif role == "ROLE_URFACE">Юридическое лицо
                        <#elseif role == "ROLE_ADMIN">Администратор
                        </#if><#sep>, 
                    </#list>
                </span>
            </div>

            <div class="info-row">
                <span class="info-label">Дата регистрации:</span>
                <span class="info-value">
                    <#if user.dateOfCreated??>
                        ${user.dateOfCreated}
                    <#else>
                        Не указана
                    </#if>
                </span>
            </div>

            <div class="info-row">
                <span class="info-label">Количество счетов:</span>
                <span class="info-value">${userInvoices?size}</span>
            </div>

            <#if mainInvoice??>
            <div class="info-row">
                <span class="info-label">Основной счёт:</span>
                <span class="info-value">${mainInvoice.invoiceId}</span>
            </div>
            </#if>

            <#if contract??>
            <div class="info-row">
                <span class="info-label">Номер договора:</span>
                <span class="info-value">${contract.contractNumber}</span>
            </div>
            </#if>
        </div>
    </div>
</body>
</html>