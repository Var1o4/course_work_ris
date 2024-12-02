<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ЕРИП 2.0 | Мои платежи</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            display: flex;
            background-color: #f5f5f5;
        }

        .content {
            flex: 1;
            padding: 30px;
        }

        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }

        .page-header h2 {
            font-size: 24px;
            color: #2e7d32;
            margin: 0;
        }

        .header-actions {
            display: flex;
            gap: 15px;
            align-items: center;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 8px 16px;
            border-radius: 4px;
            border: none;
            cursor: pointer;
            font-size: 14px;
            text-decoration: none;
            background-color: #2e7d32;
            color: white;
            transition: background-color 0.3s;
        }

        .btn:hover {
            background-color: #1b5e20;
        }

        .payment-link {
            color: inherit;
            text-decoration: none;
        }

        .payment-link:hover {
            color: #2e7d32;
        }

        .form-text {
            display: none;
        }

        .upload-form {
            display: inline-block;
        }

        .payments-container {
            background: white;
            border-radius: 10px;
            padding: 25px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        .payments-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
        }

        .payments-table th {
            text-align: left;
            padding: 15px;
            border-bottom: 2px solid #e0e0e0;
            color: #2e7d32;
        }

        .payments-table td {
            padding: 15px;
            border-bottom: 1px solid #e0e0e0;
        }

        .action-buttons {
            display: flex;
            gap: 10px;
            justify-content: flex-end;
        }

        .action-btn {
            min-width: 40px;
            height: 40px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            color: white;
            transition: all 0.2s;
        }

        .action-btn-edit {
            background-color: #fb8c00;
        }

        .action-btn-delete {
            background-color: #e53935;
        }

        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #757575;
        }

        .empty-state i {
            font-size: 48px;
            color: #bdbdbd;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <#include "../common/navigation.ftlh">

    <div class="content">
        <div class="page-header">
            <h2>Мои платежи</h2>
            <div class="header-actions">
                <#if user.hasRole('ROLE_ADMIN') || user.hasRole('ROLE_URFACE')>
                    <form action="/payments/upload" method="POST" enctype="multipart/form-data" class="upload-form">
                        <input type="hidden" name="_csrf" value="${_csrf.token}">
                        <input type="file" name="xmlFile" id="xmlFile" accept=".xml" style="display: none;">
                        <button type="button" class="btn" onclick="document.getElementById('xmlFile').click();">
                            <i class="fas fa-upload"></i> Импорт платежей
                        </button>
                    </form>
                </#if>
                <a href="/payments/create" class="btn">
                    <i class="fas fa-plus"></i> Новый платёж
                </a>
            </div>
        </div>

        <div class="payments-container">
            <#if payments?? && payments?size gt 0>
                <table class="payments-table">
                    <thead>
                        <tr>
                            <th style="width: 30%">Название</th>
                            <th style="width: 20%">Сумма</th>
                            <th style="width: 15%">Статус</th>
                            <th style="width: 15%">
                                <#if user.hasRole('ROLE_ADMIN')>
                                    Адресат
                                </#if>
                            </th>
                            <th style="width: 20%">Действия</th>
                        </tr>
                    </thead>
                    <tbody>
                        <#list payments as payment>
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
                                <td>
                                    <#if !payment.group>
                                        <strong>${(payment.amount)!'0.00'} BYN</strong>
                                    </#if>
                                </td>
                                <td>
                                    <#if !payment.group>
                                        <span class="status-badge status-${(payment.status == 'PAID')?string('paid', 'pending')}">
                                            ${payment.status}
                                        </span>
                                    </#if>
                                </td>
                                <td>
                                    <#if user.hasRole('ROLE_ADMIN') && payment.recipient??>
                                        ${payment.recipient.email}
                                    </#if>
                                </td>
                                <td class="actions-cell">
                                    <div class="action-buttons">
                                        <#if user?? && (user.hasRole('ROLE_ADMIN') || (user.hasRole('ROLE_URFACE') && payment.user?? && payment.user.id == user.id))>
                                            <a href="/payments/edit/${payment.id}" class="action-btn action-btn-edit" title="Редактировать">
                                                <i class="fas fa-edit"></i>
                                            </a>
                                            <form action="/payments/delete/${payment.id}" method="POST" style="display: inline;">
                                                <input type="hidden" name="_csrf" value="${_csrf.token}">
                                                <button type="submit" class="action-btn action-btn-delete" title="Удалить" onclick="return confirm('Вы уверены?');">
                                                    <i class="fas fa-trash"></i>
                                                </button>
                                            </form>
                                        </#if>
                                    </div>
                                </td>
                            </tr>
                        </#list>
                    </tbody>
                </table>
            <#else>
                <div class="empty-state">
                    <i class="fas fa-inbox fa-3x"></i>
                    <p>У вас пока нет платежей</p>
                    <a href="/payments/create" class="btn">Создать первый платёж</a>
                </div>
            </#if>
        </div>
    </div>

    <script>
    document.getElementById('xmlFile').addEventListener('change', function() {
        if (this.files.length > 0) {
            document.querySelector('.upload-form').submit();
        }
    });
    </script>
</body>
</html> 