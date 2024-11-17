<!DOCTYPE html>
<html>
<head>
    <title>Ожидающие верификации</title>
    <style>
        .verification-list {
            max-width: 800px;
            margin: 30px auto;
            padding: 20px;
        }
        .verification-item {
            background: white;
            padding: 20px;
            margin-bottom: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .user-info {
            margin-bottom: 15px;
        }
        .actions {
            display: flex;
            gap: 10px;
            margin-top: 15px;
        }
        .btn {
            padding: 8px 16px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        .btn-approve {
            background: #4caf50;
            color: white;
        }
        .btn-reject {
            background: #f44336;
            color: white;
        }
    </style>
</head>
<body>
    <div class="verification-list">
        <h2>Ожидающие верификации пользователи</h2>
        <#if pendingUsers?has_content>
            <#list pendingUsers as user>
                <div class="verification-item">
                    <div class="user-info">
                        <h3>${user.name}</h3>
                        <p>Email: ${user.email}</p>
                        <p>Телефон: ${user.phoneNumber}</p>
                        <p>Адрес: ${user.address}</p>
                        <p>Номер паспорта: ${user.passportNumber}</p>
                    </div>
                    <div class="actions">
                        <form action="/admin/verify/${user.id}" method="post">
                            <input type="hidden" name="_csrf" value="${_csrf.token}">
                            <input type="hidden" name="approved" value="true">
                            <button type="submit" class="btn btn-approve">Подтвердить</button>
                        </form>
                        <form action="/admin/verify/${user.id}" method="post">
                            <input type="hidden" name="_csrf" value="${_csrf.token}">
                            <input type="hidden" name="approved" value="false">
                            <button type="submit" class="btn btn-reject">Отклонить</button>
                        </form>
                    </div>
                </div>
            </#list>
        <#else>
            <p>Нет ожидающих верификации пользователей</p>
        </#if>
    </div>
</body>
</html>