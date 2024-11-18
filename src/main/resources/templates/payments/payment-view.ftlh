<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>ЕРИП 2.0 | Просмотр платежа</title>
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

        .info-card {
            background: white;
            border-radius: 10px;
            padding: 25px;
            margin-bottom: 20px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        .info-card h3 {
            color: #2e7d32;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #81c784;
        }

        .info-row {
            margin-bottom: 15px;
            display: flex;
            gap: 10px;
        }

        .info-label {
            font-weight: bold;
            color: #666;
            width: 200px;
        }

        .info-value {
            color: #333;
            flex: 1;
        }

        .status-badge {
            display: inline-block;
            padding: 5px 10px;
            border-radius: 15px;
            font-size: 14px;
            font-weight: bold;
        }

        .status-paid {
            background-color: #c8e6c9;
            color: #2e7d32;
        }

        .status-pending {
            background-color: #fff3e0;
            color: #ef6c00;
        }

        .action-buttons {
            display: flex;
            gap: 10px;
            margin-top: 20px;
        }

        .btn {
            padding: 10px 20px;
            border-radius: 5px;
            border: none;
            cursor: pointer;
            font-size: 14px;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            text-decoration: none;
            transition: all 0.2s;
        }

        .btn-pay {
            background-color: #1976d2;
            color: white;
        }

        .btn-back {
            background-color: #757575;
            color: white;
        }

        .breadcrumb {
            margin-bottom: 20px;
            color: #666;
        }

        .breadcrumb a {
            color: #2e7d32;
            text-decoration: none;
        }
    </style>
</head>
<body>
    <div class="menu">
        <#include "../blocks/menu.ftlh">
    </div>

    <div class="content">
        <nav class="breadcrumb">
            <a href="/payments/my">Мои платежи</a> / ${payment.name}
        </nav>

        <div class="info-card">
            <h3>Информация о платеже</h3>
            
            <div class="info-row">
                <span class="info-label">Название:</span>
                <span class="info-value">${payment.name}</span>
            </div>

            <#if payment.description??>
                <div class="info-row">
                    <span class="info-label">Описание:</span>
                    <span class="info-value">${payment.description}</span>
                </div>
            </#if>

            <div class="info-row">
                <span class="info-label">Сумма:</span>
                <span class="info-value">${(payment.amount)!'0.00'} BYN</span>
            </div>

            <div class="info-row">
                <span class="info-label">Тип цены:</span>
                <span class="info-value">${payment.fixedPrice?string('Фиксированная', 'Переменна��')}</span>
            </div>

            <div class="info-row">
                <span class="info-label">Статус:</span>
                <span class="status-badge status-${(payment.status == 'PAID')?string('paid', 'pending')}">
                    ${payment.status}
                </span>
            </div>

            <div class="action-buttons">
                <#if user??>
                    <#if !payment.group && (user.hasRole('ROLE_ADMIN') || user.hasRole('ROLE_USER'))>
                        <a href="/payments/${payment.id}/pay" class="btn btn-pay">
                            <i class="fas fa-credit-card"></i>
                            Оплатить
                        </a>
                    </#if>
                </#if>
                
                <a href="/payments/my" class="btn btn-back">
                    <i class="fas fa-arrow-left"></i>
                    Назад
                </a>
            </div>
        </div>
    </div>
</body>
</html>
