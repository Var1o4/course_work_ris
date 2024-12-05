<!DOCTYPE html>
<html>
<head>
    <title>ЕРИП 2.0 | Ожидающие верификации</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f5f5f5;
            display: flex;
        }
        
        .menu {
            width: 250px;
            background: white;
            min-height: 100vh;
            box-shadow: 2px 0 5px rgba(0,0,0,0.1);
        }
        
        .content {
            flex: 1;
            padding: 20px;
            margin-left: 20px;
        }
        
        .page-title {
            color: #333;
            border-bottom: 2px solid #2e7d32;
            padding-bottom: 10px;
            margin-bottom: 30px;
        }
        
        .verification-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(500px, 1fr));
            gap: 20px;
        }
        
        .verification-card {
            background: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        
        .user-info {
            display: grid;
            grid-template-columns: auto 1fr;
            gap: 10px;
            margin-bottom: 20px;
        }
        
        .info-label {
            font-weight: bold;
            color: #555;
        }
        
        .photos-container {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
            margin: 20px 0;
        }
        
        .photo-box {
            border: 1px solid #ddd;
            padding: 10px;
            border-radius: 5px;
        }
        
        .photo-box img {
            width: 100%;
            height: 200px;
            object-fit: cover;
            border-radius: 5px;
        }
        
        .photo-label {
            text-align: center;
            margin-top: 10px;
            color: #666;
        }
        
        .actions {
            display: flex;
            gap: 10px;
            margin-top: 15px;
        }
        
        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-weight: 500;
            flex: 1;
        }
        
        .btn-approve {
            background: #2e7d32;
            color: white;
        }
        
        .btn-reject {
            background: #d32f2f;
            color: white;
        }
        
        .empty-message {
            text-align: center;
            color: #666;
            padding: 40px;
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
    </style>
</head>
<body>
        <#include "../common/navigation.ftlh">

    
    <div class="content">
        <h1 class="page-title">Ожидающие верификации пользователи</h1>
        
        <#if pendingUsers?? && pendingUsers?size gt 0>
            <div class="verification-grid">
                <#list pendingUsers as user>
                    <div class="verification-card">
                        <div class="user-info">
                            <span class="info-label">ФИО:</span>
                            <span>${user.name}</span>
                            
                            <span class="info-label">Email:</span>
                            <span>${user.email}</span>
                            
                            <span class="info-label">Телефон:</span>
                            <span>${user.phoneNumber!''}</span>
                            
                            <span class="info-label">Адрес:</span>
                            <span>${user.address!''}</span>
                            
                            <span class="info-label">Паспорт:</span>
                            <span>${user.passportNumber!''}</span>
                        </div>
                        
                        <div class="photos-container">
                            <div class="photo-box">
                                <img src="/user/photo/${user.id}/personal" alt="Личное фото">
                                <div class="photo-label">Личное фото</div>
                            </div>
                            <div class="photo-box">
                                <img src="/user/photo/${user.id}/passport" alt="Фото паспорта">
                                <div class="photo-label">Фото паспорта</div>
                            </div>
                        </div>
                        
                        <div class="actions">
                            <form action="/admin/verify/${user.id}" method="post" style="flex: 1;">
                                <input type="hidden" name="_csrf" value="${_csrf.token}">
                                <input type="hidden" name="approved" value="true">
                                <button type="submit" class="btn btn-approve">
                                    <i class="fas fa-check"></i> Подтвердить
                                </button>
                            </form>
                            <form action="/admin/verify/${user.id}" method="post" style="flex: 1;">
                                <input type="hidden" name="_csrf" value="${_csrf.token}">
                                <input type="hidden" name="approved" value="false">
                                <button type="submit" class="btn btn-reject">
                                    <i class="fas fa-times"></i> Отклонить
                                </button>
                            </form>
                        </div>
                    </div>
                </#list>
            </div>
        <#else>
            <div class="empty-message">
                <i class="fas fa-user-check"></i>
                <p>Нет ожидающих верификации пользователей</p>
            </div>
        </#if>
    </div>
</body>
</html>