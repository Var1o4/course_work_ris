<!DOCTYPE html>
<html>
<head>
    <title>Верификация аккаунта</title>
    <style>
        .verification-form {
            max-width: 600px;
            margin: 30px auto;
            padding: 20px;
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-label {
            display: block;
            margin-bottom: 5px;
            color: #333;
        }
        
        .form-control {
            width: 100%;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        
        .photo-upload {
            border: 2px dashed #ddd;
            padding: 20px;
            text-align: center;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <div class="verification-form">
        <h2>Верификация аккаунта</h2>
        <form action="/verify" method="post" enctype="multipart/form-data">
            <input type="hidden" name="_csrf" value="${_csrf.token}">
            
            <div class="form-group">
                <label class="form-label">Адрес проживания</label>
                <input type="text" name="address" class="form-control" required>
            </div>
            
            <div class="form-group">
                <label class="form-label">Номер паспорта</label>
                <input type="text" name="passportNumber" class="form-control" required>
            </div>
            
            <div class="photo-upload">
                <label class="form-label">Ваше фото</label>
                <input type="file" name="personalPhoto" accept="image/*" required>
            </div>
            
            <div class="photo-upload">
                <label class="form-label">Фото паспорта</label>
                <input type="file" name="passportPhoto" accept="image/*" required>
            </div>
            
            <div class="form-group">
                <label class="form-label">Тип пользователя</label>
                <select name="userType" class="form-control" required>
                    <option value="ROLE_USER">Физическое лицо</option>
                    <option value="ROLE_URFACE">Юридическое лицо</option>
                </select>
            </div>
            
            <div class="form-group">
                <label class="form-label">Срок договора (лет)</label>
                <select name="contractDuration" class="form-control" required>
                    <option value="1">1 год</option>
                    <option value="2">2 года</option>
                    <option value="3">3 года</option>
                    <option value="4">4 года</option>
                    <option value="5">5 лет</option>
                </select>
            </div>
            
            <button type="submit" class="btn btn-primary">Отправить на проверку</button>
        </form>
    </div>
</body>
</html>