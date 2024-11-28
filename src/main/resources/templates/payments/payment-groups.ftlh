<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>ЕРИП 2.0 | Группы платежей</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            display: flex;
            background-color: #f5f5f5;
        }

        .menu {
            width: 250px;
            background-color: #2e7d32;
            color: white;
            padding: 20px;
            min-height: 100vh;
        }

        .content {
            flex: 1;
            padding: 30px;
        }

        .breadcrumb {
            background: white;
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 20px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        .breadcrumb a {
            color: #2e7d32;
            text-decoration: none;
        }

        .payments-container {
            background: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        .payments-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            margin-top: 0;
        }

        .payments-table th {
            background-color: #f5f5f5;
            color: #2e7d32;
            text-align: left;
            padding: 15px;
            font-weight: 600;
            border-bottom: 2px solid #e0e0e0;
        }

        .payments-table td {
            padding: 12px 15px;
            border-bottom: 1px solid #f0f0f0;
            vertical-align: middle;
        }

        .payment-name {
            display: flex;
            align-items: center;
        }

        .payment-link {
            color: inherit;
            text-decoration: none;
        }

        .payment-link:hover {
            color: #2e7d32;
        }

        .btn {
            padding: 8px 16px;
            border-radius: 5px;
            border: none;
            cursor: pointer;
            font-size: 14px;
            transition: all 0.2s;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .btn i {
            font-size: 16px;
        }

        .btn-pay {
            background-color: #1976d2;
            color: white;
        }

        .btn-edit {
            background-color: #2e7d32;
            color: white;
        }

        .btn-delete {
            background-color: #757575;
            color: white;
        }

        .action-buttons {
            display: flex;
            gap: 8px;
            justify-content: flex-end;
        }

        .create-button {
            display: inline-block;
            background-color: #2e7d32;
            color: white;
            padding: 10px 20px;
            border-radius: 5px;
            text-decoration: none;
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <div class="menu">
        <#include "../blocks/menu.ftlh">
    </div>

    <div class="content">
        <nav class="breadcrumb">
            <a href="/payments/groups">Главная</a>
            <#if currentGroup??>
                / ${currentGroup.name}
            </#if>
        </nav>

        <h2>
            <#if currentGroup??>
                ${currentGroup.name}
            <#else>
                Группы платежей
            </#if>
        </h2>

        <div class="payments-container">
            <#if payments?? && payments?size gt 0>
                <table class="payments-table">
                    <thead>
                        <tr>
                            <th style="width: 40%">Название</th>
                            <th style="width: 15%">Тип</th>
                            <th style="width: 15%">Сумма</th>
                            <th style="width: 30%">Действия</th>
                        </tr>
                    </thead>
                    <tbody>
                        <#list payments as payment>
                            <#if !currentGroup?? && !payment.group>
                                <#continue>
                            </#if>
                            <tr>
                                <td>
                                    <div class="payment-name">
                                        <#if payment.group>
                                            <i class="fas fa-folder" style="color: #ffd54f; margin-right: 8px;"></i>
                                            <a href="/payments/groups/${payment.id}" class="payment-link">${payment.name}</a>
                                        <#else>
                                            <i class="fas fa-file-invoice" style="color: #81c784; margin-right: 8px;"></i>
                                            <a href="/payments/view/${payment.id}" class="payment-link">${payment.name}</a>
                                        </#if>
                                    </div>
                                </td>
                                <td>${payment.group?string('Группа', 'Платёж')}</td>
                                <td>
                                    <#if !payment.group>
                                        ${(payment.amount)!'0.00'} BYN
                                    </#if>
                                </td>
                                <td>
                                    <div class="action-buttons">
                                        <#if user??>
                                            <#if user.hasRole('ROLE_ADMIN') || (user.hasRole('ROLE_URFACE') && payment.user?? && payment.user.id == user.id)>
                                                <a href="/payments/edit/${payment.id}" class="btn btn-edit">
                                                    <i class="fas fa-edit"></i>
                                                    Изменить
                                                </a>
                                                <form action="/payments/delete/${payment.id}" method="POST" style="display: inline;" 
                                                      onsubmit="return confirm('Вы уверены?');">
                                                    <input type="hidden" name="_csrf" value="${_csrf.token}">
                                                    <button type="submit" class="btn btn-delete">
                                                        <i class="fas fa-trash"></i>
                                                        Удалить
                                                    </button>
                                                </form>
                                            </#if>
                                        </#if>
                                    </div>
                                </td>
                            </tr>
                        </#list>
                    </tbody>
                </table>
            <#else>
                <p style="text-align: center;">Платежи не найдены</p>
            </#if>
        </div>

        <#if user?? && user.hasRole('ROLE_ADMIN')>
            <a href="/payments/create" class="create-button">
                <i class="fas fa-plus"></i>
                Создать новый платеж
            </a>
        </#if>
    </div>
</body>
</html> 