<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>Платежная система | <#if payment.id??>Редактирование<#else>Создание</#if> платежа</title>
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
        }

        .info-label {
            display: block;
            color: #666;
            font-size: 14px;
            margin-bottom: 5px;
        }

        .form-control {
            width: 100%;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
            margin-bottom: 10px;
            font-size: 14px;
        }

        .form-control:focus {
            border-color: #2e7d32;
            outline: none;
            box-shadow: 0 0 0 2px rgba(46, 125, 50, 0.2);
        }

        textarea.form-control {
            min-height: 100px;
            resize: vertical;
        }

        .form-check {
            margin: 15px 0;
        }

        .form-check-input {
            margin-right: 8px;
        }

        .form-check-label {
            color: #666;
            font-size: 14px;
        }

        .button-group {
            display: flex;
            gap: 10px;
            margin-top: 20px;
        }

        .submit-button {
            background-color: #2e7d32;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
            transition: background-color 0.3s;
        }

        .submit-button:hover {
            background-color: #1b5e20;
        }

        .cancel-button {
            background-color: #757575;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
            text-decoration: none;
            transition: background-color 0.3s;
        }

        .cancel-button:hover {
            background-color: #616161;
        }

        .hidden {
            display: none;
        }
    </style>
</head>
<body>
   <#include "../common/navigation.ftlh">

    <div class="content">
        <form action="/payments/<#if payment.id??>edit/${payment.id}<#else>create</#if>" method="POST">
            <input type="hidden" name="_csrf" value="${_csrf.token}">
            
            <div class="info-card">
                <h3>Основная информация</h3>
                <div class="info-row">
                    <span class="info-label">Название платежа</span>
                    <input type="text" class="form-control" id="name" name="name" 
                           value="${(payment.name)!''}" required>
                </div>

                <div class="info-row">
                    <span class="info-label">Описание</span>
                    <textarea class="form-control" id="description" name="description">${(payment.description)!''}</textarea>
                </div>

                <div class="form-check">
                    <input class="form-check-input" type="checkbox" id="group" name="group" 
                           <#if payment.group>checked</#if> onchange="toggleAmountField()">
                    <label class="form-check-label" for="group">
                        Это группа платежей
                    </label>
                </div>
            </div>

            <div class="info-card" id="paymentDetails">
                <h3>Параметры оплаты</h3>
                <div class="info-row" id="amountGroup">
                    <span class="info-label">Сумма платежа</span>
                    <input type="number" class="form-control" id="amount" name="amount" 
                           value="${(payment.amount)!''}" step="0.01">
                </div>

                <div class="form-check">
                    <input class="form-check-input" type="checkbox" id="fixedPrice" 
                           name="fixedPrice" <#if payment.fixedPrice>checked</#if>>
                    <label class="form-check-label" for="fixedPrice">
                        Фиксированная цена
                    </label>
                </div>

                <div class="info-row">
                    <span class="info-label">Родительская группа</span>
                    <select class="form-control" id="parentPayment" name="parentPayment">
                        <option value="">Без группы</option>
                        <#if groupPaths??>
                            <#list groupPaths as path>
                                <#assign parts = path?split("|")>
                                <option value="${parts[1]}" 
                                    <#if payment.parentPayment?? && payment.parentPayment.id?string == parts[1]>selected</#if>>
                                    ${parts[0]}
                                </option>
                            </#list>
                        </#if>
                    </select>
                </div>
            </div>

            <div class="button-group">
                <button type="submit" class="submit-button">Сохранить</button>
                <a href="/payments/groups" class="cancel-button">Отмена</a>
            </div>
        </form>
    </div>

    <script>
        function toggleAmountField() {
            const isGroup = document.getElementById('group').checked;
            const amountGroup = document.getElementById('amountGroup');
            
            if (isGroup) {
                amountGroup.classList.add('hidden');
                document.getElementById('amount').value = '';
            } else {
                amountGroup.classList.remove('hidden');
            }
        }

        // Вызываем функцию при загрузке страницы для установки начального состояния
        document.addEventListener('DOMContentLoaded', toggleAmountField);
    </script>
</body>
</html> 