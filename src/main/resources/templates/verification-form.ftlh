<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>ЕРИП 2.0 | Верификация аккаунта</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f5f5f5;
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .verification-form {
            background: white;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            width: 100%;
            max-width: 500px;
            margin: 20px;
        }

        h1 {
            color: #333;
            text-align: center;
            margin-bottom: 30px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        label {
            display: block;
            margin-bottom: 8px;
            color: #555;
            font-weight: 500;
        }

        input[type="text"],
        input[type="file"],
        select {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
        }

        select {
            background-color: white;
        }

        .btn-submit {
            background: #2e7d32;
            color: white;
            border: none;
            padding: 12px 24px;
            border-radius: 5px;
            cursor: pointer;
            width: 100%;
            font-size: 16px;
            margin-top: 20px;
        }

        .btn-submit:hover {
            background: #1b5e20;
        }

        .file-input-wrapper {
            position: relative;
            overflow: hidden;
            display: inline-block;
            width: 100%;
        }

        .file-input-wrapper input[type="file"] {
            font-size: 100px;
            position: absolute;
            left: 0;
            top: 0;
            opacity: 0;
            cursor: pointer;
        }

        .file-input-button {
            background: #f5f5f5;
            border: 1px solid #ddd;
            padding: 10px;
            border-radius: 5px;
            display: block;
            text-align: center;
            color: #555;
        }
    </style>
</head>
<body>
    <div class="verification-form">
        <h1>Верификация аккаунта</h1>
        <form action="/verify" method="post" enctype="multipart/form-data">
            <input type="hidden" name="_csrf" value="${_csrf.token}">
            
            <div class="form-group">
                <label for="address">Адрес</label>
                <input type="text" id="address" name="address" required>
            </div>

            <div class="form-group">
                <label for="passportNumber">Номер паспорта</label>
                <input type="text" id="passportNumber" name="passportNumber" required>
            </div>

            <div class="form-group">
                <label for="userType">Тип пользователя</label>
                <select id="userType" name="userType" required>
                    <option value="ROLE_USER">Физическое лицо</option>
                    <option value="ROLE_URFACE">Юридическое лицо</option>
                </select>
            </div>

            <div class="form-group">
                <label for="contractDuration">Срок действия договора (месяцев)</label>
                <select id="contractDuration" name="contractDuration" required>
                    <option value="12">12 месяцев</option>
                    <option value="24">24 месяца</option>
                    <option value="36">36 месяцев</option>
                </select>
            </div>

            <div class="form-group">
                <label>Фото паспорта</label>
                <div class="file-input-wrapper">
                    <div class="file-input-button">
                        <i class="fas fa-upload"></i> Выберите файл
                    </div>
                    <input type="file" name="passportPhoto" required>
                </div>
            </div>

            <div class="form-group">
                <label>Личное фото</label>
                <div class="file-input-wrapper">
                    <div class="file-input-button">
                        <i class="fas fa-upload"></i> Выберите файл
                    </div>
                    <input type="file" name="personalPhoto" required>
                </div>
            </div>

            <button type="submit" class="btn-submit">Отправить на проверку</button>
        </form>
    </div>
</body>
</html>