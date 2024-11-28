<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Задолженности</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <style>
        .notifications-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
            padding: 20px;
        }

        .notification-card {
            background: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            transition: transform 0.2s;
        }

        .notification-card:hover {
            transform: translateY(-5px);
        }

        .notification-header {
            display: flex;
            align-items: center;
            margin-bottom: 15px;
        }

        .notification-icon {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 12px;
        }

        .notification-icon.warning {
            background-color: #fff3e0;
            color: #f57c00;
        }

        .notification-icon.danger {
            background-color: #ffebee;
            color: #d32f2f;
        }

        .notification-icon.info {
            background-color: #e3f2fd;
            color: #1976d2;
        }

        .notification-title {
            font-size: 18px;
            font-weight: 600;
            color: #333;
            margin: 0;
        }

        .notification-content {
            color: #666;
            margin-bottom: 15px;
        }

        .notification-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-top: 15px;
            border-top: 1px solid #eee;
        }

        .notification-date {
            color: #999;
            font-size: 14px;
        }

        .notification-actions {
            display: flex;
            gap: 10px;
        }

        .btn {
            height: 36px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 0 16px;
            border-radius: 4px;
            border: none;
            cursor: pointer;
            font-size: 14px;
            text-decoration: none;
            transition: background-color 0.2s;
        }

        .btn-pay {
            background-color: #1976d2;
            color: white;
        }

        .btn-view {
            background-color: #757575;
            color: white;
        }

        .empty-state {
            text-align: center;
            padding: 40px;
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
    <div class="menu">
        <#include "../blocks/menu.ftlh">
    </div>

    <div class="content">
        <div class="page-header">
            <h2>Задолженности</h2>
        </div>

        <div class="notifications-grid">
    <#if notifications?? && notifications?size gt 0>
        <#list notifications as notification>
            <div class="notification-card">
                <div class="notification-header">
                    <div class="notification-icon ${(notification.type?? && notification.type?lower_case == 'WARNING')?then('warning', 
                         (notification.type?? && notification.type?lower_case == 'DANGER')?then('danger', 'info'))}">
                        <#if notification.type?? && notification.type == 'WARNING'>
                            <i class="fas fa-exclamation-triangle"></i>
                        <#elseif notification.type?? && notification.type == 'DANGER'>
                            <i class="fas fa-exclamation-circle"></i>
                        <#else>
                            <i class="fas fa-info-circle"></i>
                        </#if>
                    </div>
                    <h3 class="notification-title">${notification.title!'Уведомление'}</h3>
                </div>
                <div class="notification-content">
                    ${notification.message!''}
                </div>
                <div class="notification-footer">
                    <span class="notification-date">
                        <#if notification.createdDate??>
                            ${notification.createdDate?string("dd.MM.yyyy HH:mm")}
                        <#else>
                            Дата не указана
                        </#if>
                    </span>
                    <div class="notification-actions">
                        <#if notification.paymentId??>
                            <a href="/payments/${notification.paymentId}/pay" class="btn btn-pay">
                                <i class="fas fa-credit-card"></i> Оплатить
                            </a>
                        </#if>
                        <#if notification.link??>
                            <a href="${notification.link}" class="btn btn-view">
                                <i class="fas fa-eye"></i> Просмотр
                            </a>
                        </#if>
                    </div>
                </div>
            </div>
        </#list>
    <#else>
        <div class="empty-state">
            <i class="fas fa-check-circle"></i>
            <p>У вас нет уведомлений о задолженностях</p>
        </div>
    </#if>
</div>
    </div>
</body>
</html> 